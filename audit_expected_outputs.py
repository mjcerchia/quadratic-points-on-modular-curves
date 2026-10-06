#!/usr/bin/env python3
"""Fail if a verification file still contains a manual expected-output check.

The repository historically contained lines such as

    #l;                                    // 3
    Rank(E);                               // 1
    IsConjugate(GL2,G,Gt);                 // false
    Jacobian(GenusOneModel(H));            // isomorphic to ...

Those require a reader to compare printed output by eye.  A referee-facing
verification suite should encode such expectations as assertions instead.

This audit is intentionally conservative: it targets the output forms that
occurred in this repository and also flags bare expression statements followed
by comments that look like expected values/results.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent

TOP_LEVEL = [
    "Genus 0",
    "Genus1",
    "Hyperelliptic prime power level upper bound on GL2 level",
    "Hyperellipticcandidates",
    "Remaining cases-hyperelliptic",
    "Bielliptic prime power level upper bound on GL2 level",
    "biellipticlabels twist",
    "Table6.m",
    "Section 7.1.m",
]

FILES = [ROOT / name for name in TOP_LEVEL]
FILES += sorted((ROOT / "Magma Code").glob("*.m"))
FILES += sorted((ROOT / "Not positive rank").glob("*.m"))

# Bare Magma expression statements that were previously used as manual checks.
DANGEROUS_CODE = [
    re.compile(r"^#l;\s*$"),
    re.compile(r"^#EllipticCurve\s*\("),
    re.compile(r"^#Points\s*\("),
    re.compile(r"^#G;\s*$"),
    re.compile(r"^#(?:remaining|SetHypCand|ptlessgenus0quo|genus0);\s*$"),
    re.compile(r"^Rank\s*\([^;]+\)\s*;\s*$"),
    re.compile(r"^Genus\s*\(\s*CG\s*\)\s*;\s*$"),
    re.compile(r"^IsConjugate\s*\(\s*GL2\s*,\s*G\s*,\s*Gt\s*\)\s*;\s*$"),
    re.compile(r"^IsLocallySolv(?:able|uble)\s*\("),
    re.compile(r"^HasPointsEverywhereLocally\s*\("),
    re.compile(r"^Jacobian\s*\(\s*GenusOneModel\s*\(\s*H\s*\)\s*\)\s*;\s*$"),
    re.compile(r"^SimplifiedModel\s*\(\s*H\s*\)\s*;\s*$"),
]

EXPECTED_COMMENT = re.compile(
    r"(?:^|\b)"
    r"(?:true|false|empty|pointless|expected|"
    r"rank\s*[-=]?\s*\d+|"
    r"isomorphic\s+to|isogenous\s+to|"
    r"(?:has\s+)?no\s+Q(?:_|\b)|"
    r"\d+\s*(?:points?|quotients?|candidates?|curves?|groups?)?\b)",
    re.IGNORECASE,
)

# A comment after an assignment is usually explanatory (e.g. a database label)
# rather than a manual expected-output check.
ASSIGNMENT_OR_ASSERT = re.compile(
    r"(^|\s)(?:assert\b|print\b|return\b)|:=|(?<![<>!])=(?!=)"
)


def active_lines(text: str):
    """Yield (line_no, line) outside /* ... */ block comments."""
    in_block = False
    for n, raw in enumerate(text.splitlines(), 1):
        line = raw
        out = []
        i = 0
        while i < len(line):
            if in_block:
                j = line.find("*/", i)
                if j < 0:
                    i = len(line)
                    continue
                in_block = False
                i = j + 2
                continue
            j = line.find("/*", i)
            if j < 0:
                out.append(line[i:])
                i = len(line)
            else:
                out.append(line[i:j])
                in_block = True
                i = j + 2
        active = "".join(out)
        if active.strip():
            yield n, active


def suspicious(line: str) -> str | None:
    code, sep, comment = line.partition("//")
    code = code.strip()
    comment = comment.strip() if sep else ""

    if not code:
        return None

    for pat in DANGEROUS_CODE:
        if pat.search(code):
            # If it is already part of an assertion/assignment, it is encoded.
            if code.startswith("assert ") or ":=" in code:
                return None
            return "bare verification expression"

    if sep and code.endswith(";") and not ASSIGNMENT_OR_ASSERT.search(code):
        if EXPECTED_COMMENT.search(comment):
            return "expected result left in inline comment"

    return None


problems: list[tuple[Path, int, str, str]] = []

for path in FILES:
    if not path.exists():
        problems.append((path, 0, "missing verification file", ""))
        continue
    text = path.read_text(encoding="utf-8", errors="replace")
    for line_no, line in active_lines(text):
        reason = suspicious(line)
        if reason:
            problems.append((path, line_no, reason, line.strip()))

if problems:
    print("Unchecked/manual expected-output statements remain:", file=sys.stderr)
    for path, line_no, reason, line in problems:
        try:
            rel = path.relative_to(ROOT)
        except ValueError:
            rel = path
        loc = f"{rel}:{line_no}" if line_no else str(rel)
        print(f"  {loc}: {reason}", file=sys.stderr)
        if line:
            print(f"      {line}", file=sys.stderr)
    print(
        "\nConvert these expectations to Magma assertions (or remove a purely "
        "diagnostic output if it is not part of the verification).",
        file=sys.stderr,
    )
    sys.exit(1)

print(f"Static expected-output audit passed for {len(FILES)} verification files.")
