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

Where a script's mathematical conclusion is a Boolean or numerical condition, the verification files use (or should use) Magma `assert` statements rather than requiring the reader to compare printed output with a comment. The LMFDB input snapshots are kept separate from the derived computations so that the provenance of hard-coded curve data is visible and can be compared with future LMFDB releases.

Some individual files in `Magma Code/` and `Not positive rank/` use models copied from the frozen LMFDB snapshot; comments in those files explain the relevant argument. Optional model-comparison code may additionally require Zywina's packages and the `data211` dataset.


## One-command fresh-session verification

The branch also contains `verify_all.sh`. It launches each verification in a **separate Magma process**, so one computation cannot accidentally inherit variables from another session.

Before running the core checks, set the external dependency paths, for example:

```bash
export MODULAR_SPEC="/full/path/to/Modular.spec"
export CP_DIR="/full/path/to/cummins-pauli"
export MAGMA_BIN="/full/path/to/magma"   # omit this line if `magma` is already on PATH
```

Then run:

```bash
bash verify_all.sh
```

This runs the four core scripts and every individual computation file modified in the pre-submission cleanup. Logs are written to a timestamped directory under `verification-logs/`, and the script exits nonzero if any Magma process fails or an assertion/runtime/syntax error appears.

For a shorter first pass:

```bash
bash verify_all.sh core
```

To run only the individual files whose printed expected outputs were converted to assertions:

```bash
bash verify_all.sh assertions
```

The expected Magma version for the manuscript is V2.29-5.
