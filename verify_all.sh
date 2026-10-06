#!/usr/bin/env bash
#
# Fresh-session verification runner for the Math Z pre-submission branch.
#
# Each verification is launched in a NEW Magma process. This catches scripts
# that accidentally rely on variables or packages left over from a previous
# interactive computation.
#
# Usage:
#   bash verify_all.sh              # core checks + every computation changed in the revision
#   bash verify_all.sh core         # just the four top-level/core checks
#   bash verify_all.sh assertions   # just the mechanically edited individual files
#
# Required for "core" and default "all":
#   export MODULAR_SPEC="/absolute/path/to/Modular.spec"
#
# Genus1 also needs Cummins--Pauli. Either:
#   export CP_DIR="/absolute/path/to/cummins-pauli"
# or set these separately:
#   export CP_PRE="/absolute/path/to/pre.m"
#   export CP_CSG="/absolute/path/to/csg.m"
#   export CP_CSG24="/absolute/path/to/csg24.dat"
#
# If Magma is not on PATH:
#   export MAGMA_BIN="/absolute/path/to/magma"
#
# Logs are written under verification-logs/<timestamp>/.
#
set -u
set -o pipefail

MODE="${1:-all}"
case "$MODE" in
  all|core|assertions) ;;
  *) echo "Usage: $0 [all|core|assertions]" >&2; exit 2 ;;
esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

MAGMA_BIN="${MAGMA_BIN:-magma}"
MODULAR_SPEC="${MODULAR_SPEC:-}"
CP_DIR="${CP_DIR:-}"
CP_PRE="${CP_PRE:-}"
CP_CSG="${CP_CSG:-}"
CP_CSG24="${CP_CSG24:-}"

if [[ -n "$CP_DIR" ]]; then
  [[ -n "$CP_PRE" ]]   || CP_PRE="$CP_DIR/pre.m"
  [[ -n "$CP_CSG" ]]   || CP_CSG="$CP_DIR/csg.m"
  [[ -n "$CP_CSG24" ]] || CP_CSG24="$CP_DIR/csg24.dat"
fi

if [[ "$MAGMA_BIN" == */* ]]; then
  [[ -x "$MAGMA_BIN" ]] || { echo "ERROR: MAGMA_BIN is not executable: $MAGMA_BIN" >&2; exit 2; }
else
  command -v "$MAGMA_BIN" >/dev/null 2>&1 || {
    echo "ERROR: cannot find Magma executable '$MAGMA_BIN'." >&2
    echo "Set MAGMA_BIN to the full path to Magma." >&2
    exit 2
  }
fi

if [[ "$MODE" == "all" || "$MODE" == "core" ]]; then
  [[ -n "$MODULAR_SPEC" && -f "$MODULAR_SPEC" ]] || {
    echo "ERROR: set MODULAR_SPEC to the full path to Zywina's Modular.spec." >&2
    exit 2
  }
  for item in "CP_PRE:$CP_PRE" "CP_CSG:$CP_CSG" "CP_CSG24:$CP_CSG24"; do
    name="${item%%:*}"
    path="${item#*:}"
    [[ -n "$path" && -f "$path" ]] || {
      echo "ERROR: $name is not set to an existing file." >&2
      echo "Set CP_DIR, or set CP_PRE, CP_CSG, and CP_CSG24 separately." >&2
      exit 2
    }
  done
fi

for path in "$MODULAR_SPEC" "$CP_PRE" "$CP_CSG" "$CP_CSG24"; do
  [[ "$path" != *'"'* ]] || { echo "ERROR: dependency path contains a double quote: $path" >&2; exit 2; }
done

STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_DIR="${VERIFY_LOG_DIR:-$ROOT_DIR/verification-logs/$STAMP}"
mkdir -p "$LOG_DIR"

TMP_RUN_DIR="$(mktemp -d "${TMPDIR:-/tmp}/qpmc-verify.XXXXXX")"
trap 'rm -rf "$TMP_RUN_DIR"' EXIT INT TERM

PASS_COUNT=0
FAIL_COUNT=0
FAILED_FILES=""

safe_log_name() {
  printf '%s' "$1" | tr '/ ' '__'
}

run_magma_file() {
  label="$1"
  runfile="$2"
  log="$LOG_DIR/$(safe_log_name "$label").log"

  printf '%-62s' "[RUN] $label"
  "$MAGMA_BIN" -b "$runfile" >"$log" 2>&1
  status=$?

  if [[ $status -eq 0 ]] && ! grep -Eiq 'Assertion failed|Runtime error|User error|Syntax error' "$log"; then
    echo " PASS"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo " FAIL"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAILED_FILES="${FAILED_FILES}
$label"
    echo "      log: $log"
    echo "------ tail of log ------"
    tail -n 25 "$log" | sed 's/^/      /'
    echo "-------------------------"
  fi
}

make_wrapper() {
  target="$1"
  output="$2"
  {
    printf 'AttachSpec("%s");\n' "$MODULAR_SPEC"
    printf 'load "%s";\n' "$target"
    printf 'quit;\n'
  } > "$output"
}

prepare_genus1() {
  output="$1"
  cpdata="$TMP_RUN_DIR/CPdata.dat"

  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      'load ".../pre.m";'*) printf 'load "%s";\n' "$CP_PRE" ;;
      'load ".../csg.m";'*) printf 'load "%s";\n' "$CP_CSG" ;;
      'load "csg24.dat";'*) printf 'load "%s";\n' "$CP_CSG24" ;;
      'filename:="CPdata.dat";'*) printf 'filename:="%s";\n' "$cpdata" ;;
      'AttachSpec("Modular-main (2)/Modular-main/Modular.spec");'*)
        printf 'AttachSpec("%s");\n' "$MODULAR_SPEC"
        ;;
      *) printf '%s\n' "$line" ;;
    esac
  done < "$ROOT_DIR/Genus1" > "$output"
}

prepare_hyperelliptic_candidates() {
  output="$1"

  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      'load "lmfdb_gps_gl2zhat_fine_1213_1923 (1).m";'*)
        printf 'load "LMFDB Data/lmfdb_gps_gl2zhat_fine_1213_1923 (1).m";\n'
        ;;
      'load "LMFDB data on genus 2-11.m";'*)
        printf 'load "LMFDB Data/LMFDB data on genus 2-11.m";\n'
        ;;
      'load "Genus 0 data.m";'*)
        printf 'load "LMFDB Data/Genus 0 data_LMFDB.m";\n'
        ;;
      'AttachSpec('*'Modular.spec'*)
        printf 'AttachSpec("%s");\n' "$MODULAR_SPEC"
        ;;
      *) printf '%s\n' "$line" ;;
    esac
  done < "$ROOT_DIR/Hyperellipticcandidates" > "$output"
}

run_core() {
  echo
  echo "=== Core fresh-session checks ==="

  genus1_tmp="$TMP_RUN_DIR/Genus1.m"
  hyp_tmp="$TMP_RUN_DIR/Hyperellipticcandidates.m"
  table6_wrapper="$TMP_RUN_DIR/Table6_wrapper.m"
  sec71_wrapper="$TMP_RUN_DIR/Section71_wrapper.m"

  prepare_genus1 "$genus1_tmp"
  prepare_hyperelliptic_candidates "$hyp_tmp"
  make_wrapper "Table6.m" "$table6_wrapper"
  make_wrapper "Section 7.1.m" "$sec71_wrapper"

  run_magma_file "Genus1" "$genus1_tmp"
  run_magma_file "Hyperellipticcandidates" "$hyp_tmp"
  run_magma_file "Table6.m" "$table6_wrapper"
  run_magma_file "Section 7.1.m" "$sec71_wrapper"
}

ASSERTION_FILES=(
  "Magma Code/16-96-3-dw-1.m"
  "Magma Code/16-96-5-s-1.m"
  "Magma Code/27-36-3-a-1.m"
  "Magma Code/32-48-3-b-1.m"
  "Magma Code/32-48-3-b-2.m"
  "Magma Code/32-96-5-a-1.m"
  "Magma Code/32-96-5-a-2.m"
  "Magma Code/32-96-5-be-2.m"
  "Magma Code/32-96-5-c-1.m"
  "Magma Code/32-96-5-f-2.m"
  "Magma Code/32-96-5-h-1.m"
  "Magma Code/32-96-5-i-1.m"
  "Magma Code/32-96-5-m-1.m"
  "Magma Code/32-96-5-n-2.m"
  "Magma Code/32-96-5-p-1.m"
  "Magma Code/32-96-5-p-2.m"
  "Magma Code/64-96-5-a-1.m"
  "Magma Code/64-96-5-a-2.m"
  "Magma Code/64-96-5-d-1.m"
  "Magma Code/81-108-7-a-1.m"
  "Not positive rank/16-192-5-bq-1.m"
  "Not positive rank/16-192-5-bs-1.m"
  "Not positive rank/16-192-5-cf-1.m"
  "Not positive rank/16-192-5-cl-1.m"
  "Not positive rank/16-96-5-be-1.m"
  "Not positive rank/16-96-5-bf-1.m"
  "Not positive rank/16-96-5-cb-1.m"
  "Not positive rank/16-96-5-cc-1.m"
  "Not positive rank/16-96-5-ck-1.m"
  "Not positive rank/16-96-5-cn-1.m"
  "Not positive rank/16-96-5-co-1.m"
  "Not positive rank/16-96-5-cv-1.m"
  "Not positive rank/16-96-5-cw-1.m"
  "Not positive rank/16-96-5-cx-1.m"
  "Not positive rank/16-96-5-cy-1.m"
  "Not positive rank/16-96-5-de-1.m"
  "Not positive rank/16-96-5-df-1.m"
  "Not positive rank/16-96-5-dl-1.m"
  "Not positive rank/16-96-5-do-1.m"
  "Not positive rank/16-96-5-dy-1.m"
  "Not positive rank/16-96-5-ea-1.m"
  "Not positive rank/16-96-5-ec-1.m"
  "Not positive rank/16-96-5-ed-1.m"
  "Not positive rank/16-96-5-ee-1.m"
  "Not positive rank/16-96-5-ef-1.m"
  "Not positive rank/16-96-5-eg-1.m"
  "Not positive rank/16-96-5-ei-1.m"
  "Not positive rank/16-96-5-ek-1.m"
  "Not positive rank/16-96-5-el-1.m"
  "Not positive rank/16-96-5-em-1.m"
  "Not positive rank/32-96-4-e-1.m"
  "Not positive rank/32-96-4-f-1.m"
  "Not positive rank/32-96-4-g-1.m"
  "Not positive rank/32-96-4-h-1.m"
  "Not positive rank/32-96-5-bf-1.m"
  "Not positive rank/32-96-5-bf-2.m"
  "Not positive rank/32-96-5-f-1.m"
  "Not positive rank/32-96-5-n-1.m"
  "Not positive rank/37-114-4-b-2.m"
)

run_assertion_files() {
  echo
  echo "=== Individually changed computation files ==="
  for file in "${ASSERTION_FILES[@]}"; do
    if [[ ! -f "$ROOT_DIR/$file" ]]; then
      echo "[MISS] $file"
      FAIL_COUNT=$((FAIL_COUNT + 1))
      FAILED_FILES="${FAILED_FILES}
$file (missing)"
      continue
    fi
    run_magma_file "$file" "$ROOT_DIR/$file"
  done
}

echo "Quadratic-points-on-modular-curves verification"
echo "Repository: $ROOT_DIR"
echo "Mode:       $MODE"
echo "Magma:      $MAGMA_BIN"
echo "Logs:       $LOG_DIR"
echo
echo "Expected software version for the paper: Magma V2.29-5."

if [[ "$MODE" == "all" || "$MODE" == "core" ]]; then
  run_core
fi

if [[ "$MODE" == "all" || "$MODE" == "assertions" ]]; then
  run_assertion_files
fi

echo
echo "================ Verification summary ================"
echo "PASS: $PASS_COUNT"
echo "FAIL: $FAIL_COUNT"
echo "Logs: $LOG_DIR"

if [[ $FAIL_COUNT -ne 0 ]]; then
  echo
  echo "Failed checks:"
  printf '%s\n' "$FAILED_FILES"
  exit 1
fi

echo
echo "All requested checks passed in fresh Magma processes."
exit 0
