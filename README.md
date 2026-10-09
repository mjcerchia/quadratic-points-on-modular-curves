# Quadratic points on modular curves of prime-power level

This repository contains the computational material accompanying the manuscript **“Modular Curves of Prime-Power Level with Infinitely Many Quadratic Points”** by Michael Cerchia and Rakvi.

## Tested software and external dependencies

The computations in the manuscript were carried out with **Magma V2.29-5**.

Run the scripts from the repository root. Several scripts also require the following external data/code:

- David Zywina's `Modular` package (attach its `Modular.spec` before running scripts that use `CreateModularCurveRec` or `FindModelOfXG`).
- David Zywina's `OpenImage` repository; scripts that call `FindOpenImage` require `main/FindOpenImage.m`.
- The Cummins--Pauli congruence-subgroup data and Magma routines (`pre.m`, `csg.m`, and `csg24.dat`). The scripts containing the level-bound calculations indicate where these files are loaded.

Because the external packages are not vendored here, their paths must be adjusted to the local installation when indicated in a script.

## Frozen LMFDB input data

The directory `LMFDB Data` contains the LMFDB data used in the computations rather than relying on live database queries.

- `Genus 0 data_LMFDB.m`: downloaded 13 December 2025; the recorded query returned 265 curves.
- `Genus 1 data_LMFDB.m`: downloaded 13 December 2025; the recorded query returned 342 curves.
- `LMFDB data on genus 2-11.m`: downloaded 14 December 2025; the recorded query returned 2199 curves.

Each of these files records the LMFDB search link, the query, and the format of the stored records. In particular, the genus-one data are stored in `data1`, while the genus 2--11 data are stored in `data211`.

## Main verification files

- `Genus 0`: genus-zero level bounds and the genus-zero classification.
- `Genus1`: genus-one level bounds and the seven exceptional genus-one cases.
- `Hyperelliptic prime power level upper bound on GL2 level`, `Hyperellipticcandidates`, and `Remaining cases-hyperelliptic`: the hyperelliptic classification.
- `Bielliptic prime power level upper bound on GL2 level`, `biellipticlabels twist`, `Magma Code/`, and `Not positive rank/`: the positive-rank bielliptic classification.
- `Table6.m`: verifies the index-two subgroup relationships and positive-rank genus-one quotients used in Table 6 of the manuscript.
- `Section 7.1.m`: computations used in Section 7.1.

The scripts `Table6.m` and `Section 7.1.m` explicitly load both the genus-one and genus 2--11 LMFDB snapshots and are intended to be runnable in a fresh Magma session after the external Zywina package has been attached.

## Expected classification counts

The final manuscript classification contains, up to conjugacy:

- 265 genus-zero groups;
- 336 genus-one groups;
- 306 hyperelliptic groups of genus at least two;
- 178 non-hyperelliptic positive-rank bielliptic groups of genus at least two.

Thus the final total is **1085**.

The five genus-one curves
`9.81.1.a.1`, `16.96.1.t.1`, `16.64.1.a.1`, `16.64.1.b.1`, and `16.96.1.k.1`
are among the seven exceptional genus-one cases but are *not* in the final genus-one table; the computations in `Genus1` rule out quadratic points on them. The curve `8.48.1.bi.1` is also excluded, while `16.48.1.l.1` is included.

## Reproducibility notes

Where a script's mathematical conclusion is a Boolean or numerical condition, the verification files use Magma `assert` statements rather than requiring the reader to compare printed output with a comment. The static audit covers all 137 verification files (9 top-level scripts, 30 files in `Magma Code/`, and 98 files in `Not positive rank/`). The LMFDB input snapshots are kept separate from the derived computations so that the provenance of hard-coded curve data is visible and can be compared with future LMFDB releases.

Some individual files in `Magma Code/` and `Not positive rank/` use models copied from the frozen LMFDB snapshot; comments in those files explain the relevant argument. Optional model-comparison code may additionally require Zywina's packages and the `data211` dataset.

## One-command referee verification

The branch contains `verify_all.sh`, a referee-facing master verification script. After Magma and the documented external dependencies are installed, the command

```bash
bash verify_all.sh
```

runs the **complete computational verification suite represented in this repository**:

- every top-level classification/level-bound script named above;
- every `.m` file in `Magma Code/`;
- every `.m` file in `Not positive rank/`.

Before launching Magma, the runner also executes `audit_expected_outputs.py`. This static audit rejects the old manual-check style (for example `Rank(E); // 1`, `#l; // 3`, or a bare local-solubility/conjugacy computation whose expected answer appears only in a comment). Thus a successful run cannot silently rely on a referee comparing printed output by eye.

Each verification file is then launched in a **fresh Magma process**, so a computation cannot accidentally inherit variables from a previous interactive session. The script records a separate log for every computation and a `summary.tsv` file, and it exits nonzero if the static audit fails, if any Magma process fails, or if an assertion, syntax error, runtime error, user error, or internal error is detected.

The conventional dependency layout is

```text
external/Modular-main/Modular.spec
external/OpenImage/main/FindOpenImage.m
external/cummins-pauli/pre.m
external/cummins-pauli/csg.m
external/cummins-pauli/csg24.dat
```

If those packages live elsewhere, set `MODULAR_SPEC`, `OPENIMAGE_FIND`, and `CP_DIR` (or the individual Cummins--Pauli variables) before running the script. Set `MAGMA_BIN` if Magma is not available as `magma` on the shell path.

For diagnostics, `bash verify_all.sh top` runs only the top-level classification scripts, `bash verify_all.sh files` runs only the individual curve files, and `bash verify_all.sh list` prints the complete verification manifest.

A successful run certifies that all **computational checks encoded by the repository** complete and that every encoded assertion passes. It does not machine-check the purely theoretical arguments in the manuscript.

The expected Magma version for the manuscript is V2.29-5.

