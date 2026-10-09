#!/usr/bin/env bash
#
# Referee-facing verification runner for
# "Modular Curves of Prime-Power Level with Infinitely Many Quadratic Points".
#
# After Magma and the documented external dependencies are installed, the
# default invocation
#
#     bash verify_all.sh
#
# runs the COMPLETE computational verification suite represented in this
# repository:
#
#   * every top-level classification/level-bound script named in README.md;
#   * every .m file in "Magma Code/";
#   * every .m file in "Not positive rank/".
#
# Each file is run in a separate fresh Magma process.  A successful exit from
# this script therefore means that every assertion in every verification file
# passed and that no Magma syntax/runtime/user error was detected.
#
# IMPORTANT: this script verifies computational claims encoded by the repository.
# Purely theoretical arguments in the paper are, of course, not machine-checked.
#
# Dependency convention
# ---------------------
# The runner first looks in these conventional locations:
#
#   external/Modular-main/Modular.spec
#   external/OpenImage/main/FindOpenImage.m
#   external/cummins-pauli/pre.m
#   external/cummins-pauli/csg.m
#   external/cummins-pauli/csg24.dat
#
# You may instead point to local installations with:
#
#   MODULAR_SPEC=/path/to/Modular.spec
#   OPENIMAGE_FIND=/path/to/FindOpenImage.m
#   CP_DIR=/path/to/cummins-pauli
#
# or set CP_PRE, CP_CSG, and CP_CSG24 separately.
#
# If Magma is not available as "magma" on PATH, set:
#
#   MAGMA_BIN=/path/to/magma
#
# Usage:
#   bash verify_all.sh          # full referee-facing verification
#   bash verify_all.sh top      # top-level classification scripts only
#   bash verify_all.sh files    # individual curve files only
#   bash verify_all.sh list     # print the complete verification manifest
#
set -u
set -o pipefail

MODE="${1:-all}"
case "$MODE" in
  all|top|files|list) ;;
  *) echo "Usage: $0 [all|top|files|list]" >&2; exit 2 ;;
esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

MAGMA_BIN="${MAGMA_BIN:-magma}"

MODULAR_SPEC="${MODULAR_SPEC:-$ROOT_DIR/external/Modular-main/Modular.spec}"
OPENIMAGE_FIND="${OPENIMAGE_FIND:-$ROOT_DIR/external/OpenImage/main/FindOpenImage.m}"

CP_DIR="${CP_DIR:-$ROOT_DIR/external/cummins-pauli}"
CP_PRE="${CP_PRE:-$CP_DIR/pre.m}"
CP_CSG="${CP_CSG:-$CP_DIR/csg.m}"
CP_CSG24="${CP_CSG24:-$CP_DIR/csg24.dat}"

LMFDB_FINE="$ROOT_DIR/LMFDB Data/lmfdb_gps_gl2zhat_fine_1213_1923 (1).m"
LMFDB_GENUS0="$ROOT_DIR/LMFDB Data/Genus 0 data_LMFDB.m"
LMFDB_GENUS1="$ROOT_DIR/LMFDB Data/Genus 1 data_LMFDB.m"
LMFDB_GENUS2_11="$ROOT_DIR/LMFDB Data/LMFDB data on genus 2-11.m"

TOP_LEVEL_FILES=(
  "Genus 0"
  "Genus1"
  "Hyperelliptic prime power level upper bound on GL2 level"
  "Hyperellipticcandidates"
  "Remaining cases-hyperelliptic"
  "Bielliptic prime power level upper bound on GL2 level"
  "biellipticlabels twist"
  "Table6.m"
  "Section 7.1.m"
)

list_individual_files() {
  {
    find "$ROOT_DIR/Magma Code" -type f -name '*.m' -print
    find "$ROOT_DIR/Not positive rank" -type f -name '*.m' -print
  } | LC_ALL=C sort
}

print_manifest() {
  echo "Top-level verification scripts:"
  for f in "${TOP_LEVEL_FILES[@]}"; do
    echo "  $f"
  done
  echo
  echo "Individual verification files:"
  list_individual_files | sed "s#^$ROOT_DIR/#  #"
}

if [[ "$MODE" == "list" ]]; then
  print_manifest
  exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 is required for the static expected-output audit." >&2
  exit 2
fi

echo "=== Static expected-output audit ==="
if ! python3 "$ROOT_DIR/audit_expected_outputs.py"; then
  echo "ERROR: unchecked/manual expected-output statements remain." >&2
  exit 1
fi
echo

if [[ "$MAGMA_BIN" == */* ]]; then
  [[ -x "$MAGMA_BIN" ]] || {
    echo "ERROR: MAGMA_BIN is not executable: $MAGMA_BIN" >&2
    exit 2
  }
else
  command -v "$MAGMA_BIN" >/dev/null 2>&1 || {
    echo "ERROR: cannot find Magma executable '$MAGMA_BIN'." >&2
    echo "Set MAGMA_BIN to the full path to Magma." >&2
    exit 2
  }
fi

required_repo_files=(
  "$LMFDB_FINE"
  "$LMFDB_GENUS0"
  "$LMFDB_GENUS1"
  "$LMFDB_GENUS2_11"
)
for path in "${required_repo_files[@]}"; do
  [[ -f "$path" ]] || {
    echo "ERROR: repository input file is missing: $path" >&2
    exit 2
  }
done

if [[ "$MODE" == "all" || "$MODE" == "top" ]]; then
  for item in     "MODULAR_SPEC:$MODULAR_SPEC"     "OPENIMAGE_FIND:$OPENIMAGE_FIND"     "CP_PRE:$CP_PRE"     "CP_CSG:$CP_CSG"     "CP_CSG24:$CP_CSG24"
  do
    name="${item%%:*}"
    path="${item#*:}"
    [[ -f "$path" ]] || {
      echo "ERROR: $name does not point to an existing file:" >&2
      echo "       $path" >&2
      echo >&2
      echo "See README.md for the expected external dependency layout." >&2
      exit 2
    }
  done
fi

for path in "$MODULAR_SPEC" "$OPENIMAGE_FIND" "$CP_PRE" "$CP_CSG" "$CP_CSG24"; do
  [[ "$path" != *'"'* ]] || {
    echo "ERROR: dependency path contains a double quote: $path" >&2
    exit 2
  }
done

STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_DIR="${VERIFY_LOG_DIR:-$ROOT_DIR/verification-logs/$STAMP}"
mkdir -p "$LOG_DIR"

TMP_RUN_DIR="$(mktemp -d "${TMPDIR:-/tmp}/qpmc-verify.XXXXXX")"
trap 'rm -rf "$TMP_RUN_DIR"' EXIT INT TERM

SUMMARY_FILE="$LOG_DIR/summary.tsv"
printf 'status\tfile\tlog\n' > "$SUMMARY_FILE"

PASS_COUNT=0
FAIL_COUNT=0
FAILED_FILES=""

safe_name() {
  printf '%s' "$1" | tr '/ ' '__'
}

run_magma_file() {
  label="$1"
  runfile="$2"
  log="$LOG_DIR/$(safe_name "$label").log"

  printf '%-72s' "[RUN] $label"

  "$MAGMA_BIN" -b "$runfile" >"$log" 2>&1
  status=$?

  # Magma normally exits nonzero after a fatal error.  The textual scan gives
  # an additional guard against errors that nevertheless leave exit status 0.
  if [[ $status -eq 0 ]] && ! grep -Eiq     'Assertion failed|Runtime error|User error|Syntax error|Internal error' "$log"
  then
    echo " PASS"
    PASS_COUNT=$((PASS_COUNT + 1))
    printf 'PASS\t%s\t%s\n' "$label" "$log" >> "$SUMMARY_FILE"
  else
    echo " FAIL"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAILED_FILES="${FAILED_FILES}
$label"
    printf 'FAIL\t%s\t%s\n' "$label" "$log" >> "$SUMMARY_FILE"
    echo "      log: $log"
    echo "------ tail of log ------"
    tail -n 30 "$log" | sed 's/^/      /'
    echo "-------------------------"
  fi
}

# Rewrite only path/setup lines.  The mathematical code is otherwise identical
# to the committed verification script.
prepare_top_level() {
  source_file="$1"
  output_file="$2"
  cpdata="$TMP_RUN_DIR/$(safe_name "$source_file")_CPdata.dat"

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Several legacy top-level files use bare rows of asterisks as visual separators.
    # They are not Magma statements, so comment them in the temporary runnable copy.
    if [[ "$line" =~ ^\\*+$ ]]; then
      printf '//%s\\n' "$line"
      continue
    fi
    case "$line" in
      'load ".../pre.m";'*)
        printf 'load "%s";\n' "$CP_PRE"
        ;;
      'load ".../csg.m";'*)
        printf 'load "%s";\n' "$CP_CSG"
        ;;
      'load "csg24.dat";'*)
        printf 'load "%s";\n' "$CP_CSG24"
        ;;
      'filename:="CPdata.dat";'*)
        printf 'filename:="%s";\n' "$cpdata"
        ;;
      'load "lmfdb_gps_gl2zhat_fine_1213_1923 (1).m";'*)
        printf 'load "%s";\n' "$LMFDB_FINE"
        ;;
      'load "Genus 0 data.m";'*)
        printf 'load "%s";\n' "$LMFDB_GENUS0"
        ;;
      'load "Genus 0 data_LMFDB.m";'*)
        printf 'load "%s";\n' "$LMFDB_GENUS0"
        ;;
      'load "Genus 1 data_LMFDB.m";'*)
        printf 'load "%s";\n' "$LMFDB_GENUS1"
        ;;
      'load "LMFDB Data/Genus 0 data_LMFDB.m";'*)
        printf 'load "%s";\n' "$LMFDB_GENUS0"
        ;;
      'load "LMFDB Data/Genus 1 data_LMFDB.m";'*)
        printf 'load "%s";\n' "$LMFDB_GENUS1"
        ;;
      'load "LMFDB data on genus 2-11.m";'*)
        printf 'load "%s";\n' "$LMFDB_GENUS2_11"
        ;;
      'load "LMFDB Data/LMFDB data on genus 2-11.m";'*)
        printf 'load "%s";\n' "$LMFDB_GENUS2_11"
        ;;
      'load "OpenImage-master/main/FindOpenImage.m";'*)
        printf 'load "%s";\n' "$OPENIMAGE_FIND"
        ;;
      'AttachSpec('*'Modular.spec'*)
        printf 'AttachSpec("%s");\n' "$MODULAR_SPEC"
        ;;
      *)
        printf '%s\n' "$line"
        ;;
    esac
  done < "$ROOT_DIR/$source_file" > "$output_file"
}

# Some top-level scripts call functions from the Modular package without
# containing their own AttachSpec line.  Prefix a prepared copy in those cases.
needs_modular_prefix() {
  case "$1" in
    "Table6.m"|"Section 7.1.m") return 0 ;;
    *) return 1 ;;
  esac
}

run_top_level_suite() {
  echo
  echo "=== Top-level classification and level-bound verification ==="

  for source_file in "${TOP_LEVEL_FILES[@]}"; do
    [[ -f "$ROOT_DIR/$source_file" ]] || {
      echo "[MISS] $source_file"
      FAIL_COUNT=$((FAIL_COUNT + 1))
      FAILED_FILES="${FAILED_FILES}
$source_file (missing)"
      continue
    }

    prepared="$TMP_RUN_DIR/$(safe_name "$source_file").m"
    body="$TMP_RUN_DIR/$(safe_name "$source_file").body.m"
    prepare_top_level "$source_file" "$body"

    if needs_modular_prefix "$source_file"; then
      {
        printf 'AttachSpec("%s");\n' "$MODULAR_SPEC"
        cat "$body"
      } > "$prepared"
    else
      cp "$body" "$prepared"
    fi

    run_magma_file "$source_file" "$prepared"
  done
}

run_individual_suite() {
  echo
  echo "=== Individual modular-curve verification files ==="

  count=0
  while IFS= read -r file; do
    count=$((count + 1))
    rel="${file#$ROOT_DIR/}"
    run_magma_file "$rel" "$file"
  done < <(list_individual_files)

  if [[ $count -eq 0 ]]; then
    echo "ERROR: no individual .m verification files were found." >&2
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

echo "Quadratic-points-on-modular-curves computational verification"
echo "Repository: $ROOT_DIR"
echo "Mode:       $MODE"
echo "Magma:      $MAGMA_BIN"
echo "Logs:       $LOG_DIR"
echo
echo "Manuscript computation version: Magma V2.29-5"

if [[ "$MODE" == "all" || "$MODE" == "top" ]]; then
  run_top_level_suite
fi

if [[ "$MODE" == "all" || "$MODE" == "files" ]]; then
  run_individual_suite
fi

echo
echo "================ Verification summary ================"
echo "PASS: $PASS_COUNT"
echo "FAIL: $FAIL_COUNT"
echo "Summary: $SUMMARY_FILE"
echo "Logs:    $LOG_DIR"

if [[ $FAIL_COUNT -ne 0 ]]; then
  echo
  echo "Failed checks:"
  printf '%s\n' "$FAILED_FILES"
  exit 1
fi

echo
echo "ALL COMPUTATIONAL VERIFICATION FILES COMPLETED SUCCESSFULLY."
echo "Every assertion encountered by Magma passed."
exit 0
