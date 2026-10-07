#!/usr/bin/env bash
set -euo pipefail

# OpenNowcastLab - add_upstream_submodule.sh
#
# Usage:
#   bash scripts/add_upstream_submodule.sh
#   bash scripts/add_upstream_submodule.sh https://github.com/b-rbmp/FlowCast.git
#
# Purpose:
#   Add an official upstream GitHub repository as an OpenNowcastLab Git submodule.
#   The script:
#     1. asks for / accepts a Git repository URL;
#     2. infers the reproduction directory;
#     3. reuses an existing clean clone when possible;
#     4. registers it as a Git submodule;
#     5. records upstream provenance in UPSTREAM.md;
#     6. prints verification information.
#
# Expected OpenNowcastLab layout:
#   reproductions/<reproduction_key>/upstream/<RepoName>

die() {
    echo "[ERROR] $*" >&2
    exit 1
}

info() {
    echo "[INFO] $*"
}

warn() {
    echo "[WARN] $*" >&2
}

# ------------------------------------------------------------
# 1. Locate OpenNowcastLab root
# ------------------------------------------------------------

find_project_root() {
    local current="$PWD"

    while [[ "$current" != "/" ]]; do
        if [[ -d "$current/.git" || -f "$current/.git" ]]; then
            if [[ -d "$current/reproductions" && -d "$current/docs" ]]; then
                echo "$current"
                return 0
            fi
        fi
        current="$(dirname "$current")"
    done

    return 1
}

PROJECT_ROOT="$(find_project_root || true)"

if [[ -z "$PROJECT_ROOT" ]]; then
    die "Cannot find the OpenNowcastLab repository root. Run this script somewhere inside OpenNowcastLab."
fi

cd "$PROJECT_ROOT"

info "OpenNowcastLab root: $PROJECT_ROOT"

# ------------------------------------------------------------
# 2. Read repository URL
# ------------------------------------------------------------

REPO_URL="${1:-}"

if [[ -z "$REPO_URL" ]]; then
    read -r -p "GitHub repository URL: " REPO_URL
fi

[[ -n "$REPO_URL" ]] || die "Repository URL cannot be empty."

# Accept HTTPS or SSH GitHub URLs.
if [[ ! "$REPO_URL" =~ ^https://github\.com/.+/.+(\.git)?$ && \
      ! "$REPO_URL" =~ ^git@github\.com:.+/.+(\.git)?$ ]]; then
    warn "The URL does not look like a standard GitHub HTTPS/SSH URL."
    read -r -p "Continue anyway? [y/N]: " answer
    [[ "${answer,,}" == "y" ]] || exit 1
fi

# ------------------------------------------------------------
# 3. Infer repository name and reproduction key
# ------------------------------------------------------------

repo_basename="${REPO_URL##*/}"
repo_basename="${repo_basename%.git}"

[[ -n "$repo_basename" ]] || die "Cannot infer repository name from URL: $REPO_URL"

# Known OpenNowcastLab mappings.
case "${repo_basename,,}" in
    flowcast)
        reproduction_key="flowcast"
        ;;
    openstl)
        reproduction_key="simvp_openstl"
        ;;
    pysteps)
        reproduction_key="pysteps"
        ;;
    prediff)
        reproduction_key="prediff"
        ;;
    nowcastnet)
        reproduction_key="nowcastnet"
        ;;
    *)
        reproduction_key="$(echo "$repo_basename" \
            | tr '[:upper:]' '[:lower:]' \
            | sed -E 's/[^a-z0-9._-]+/_/g')"
        ;;
esac

REPRO_DIR="reproductions/${reproduction_key}"
UPSTREAM_DIR="${REPRO_DIR}/upstream"
SUBMODULE_PATH="${UPSTREAM_DIR}/${repo_basename}"
UPSTREAM_MD="${REPRO_DIR}/UPSTREAM.md"
STATUS_MD="${REPRO_DIR}/STATUS.md"

info "Repository name : $repo_basename"
info "Reproduction key: $reproduction_key"
info "Submodule path   : $SUBMODULE_PATH"

mkdir -p "$UPSTREAM_DIR"
mkdir -p "${REPRO_DIR}/patches" \
         "${REPRO_DIR}/adapters" \
         "${REPRO_DIR}/tests" \
         "${REPRO_DIR}/reference"

# ------------------------------------------------------------
# 4. Check whether this submodule is already registered
# ------------------------------------------------------------

if git config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null \
    | awk '{print $2}' \
    | grep -Fxq "$SUBMODULE_PATH"; then

    info "Submodule is already registered: $SUBMODULE_PATH"

    git submodule update --init --recursive "$SUBMODULE_PATH"

else
    # --------------------------------------------------------
    # 5. Reuse an existing clone or add a new submodule
    # --------------------------------------------------------

    if [[ -e "$SUBMODULE_PATH" ]]; then
        if ! git -C "$SUBMODULE_PATH" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            die "Path already exists but is not a Git repository: $SUBMODULE_PATH"
        fi

        existing_origin="$(git -C "$SUBMODULE_PATH" remote get-url origin 2>/dev/null || true)"

        if [[ -z "$existing_origin" ]]; then
            die "Existing repository has no 'origin' remote: $SUBMODULE_PATH"
        fi

        if [[ "$existing_origin" != "$REPO_URL" ]]; then
            warn "Existing clone origin differs from the entered URL."
            echo "  Existing: $existing_origin"
            echo "  Entered : $REPO_URL"
            read -r -p "Use the existing clone/origin anyway? [y/N]: " answer
            [[ "${answer,,}" == "y" ]] || exit 1
            REPO_URL="$existing_origin"
        fi

        if [[ -n "$(git -C "$SUBMODULE_PATH" status --porcelain)" ]]; then
            die "Existing upstream clone has local modifications. Commit/stash/revert them before registering it as a submodule."
        fi

        info "Existing clean clone found. Registering it as a submodule."

        git submodule add --force "$REPO_URL" "$SUBMODULE_PATH"
    else
        info "Cloning and registering submodule."
        git submodule add "$REPO_URL" "$SUBMODULE_PATH"
    fi
fi

# ------------------------------------------------------------
# 6. Collect exact upstream provenance
# ------------------------------------------------------------

git submodule update --init --recursive "$SUBMODULE_PATH"

REMOTE_URL="$(git -C "$SUBMODULE_PATH" remote get-url origin)"
COMMIT="$(git -C "$SUBMODULE_PATH" rev-parse HEAD)"
BRANCH="$(git -C "$SUBMODULE_PATH" branch --show-current || true)"
DESCRIBE="$(git -C "$SUBMODULE_PATH" describe --tags --always 2>/dev/null || true)"
RETRIEVED_DATE="$(date +%Y-%m-%d)"
WORKTREE_STATUS="$(git -C "$SUBMODULE_PATH" status --porcelain)"

if [[ -z "$BRANCH" ]]; then
    BRANCH="detached-HEAD"
fi

if [[ -z "$DESCRIBE" ]]; then
    DESCRIBE="$COMMIT"
fi

if [[ -n "$WORKTREE_STATUS" ]]; then
    LOCAL_MODIFICATION="Yes"
else
    LOCAL_MODIFICATION="None"
fi

# ------------------------------------------------------------
# 7. Create / update UPSTREAM.md
# ------------------------------------------------------------

cat > "$UPSTREAM_MD" <<EOF
# ${repo_basename} Upstream Record

## Repository

- Official repository: ${REMOTE_URL}
- Local path: \`${SUBMODULE_PATH}\`
- Git integration: submodule
- Branch at registration: \`${BRANCH}\`
- Commit: \`${COMMIT}\`
- Git describe: \`${DESCRIBE}\`
- Retrieved / registered: ${RETRIEVED_DATE}
- Local modification at registration: ${LOCAL_MODIFICATION}

## Reproduction status

The upstream repository is registered and pinned by the parent OpenNowcastLab repository.

The following items still require explicit verification before being treated as project facts:

- license;
- paper / official documentation;
- checkpoint source;
- checkpoint checksum;
- official environment;
- official preprocessing;
- official inference command;
- official training availability;
- evaluation protocol.

## Rules

- Keep \`${SUBMODULE_PATH}\` as close to official upstream as possible.
- Do not perform long-term OpenNowcastLab development directly inside the upstream repository.
- Compatibility changes should be documented under \`${REPRO_DIR}/patches/\`.
- Project adapters should be developed under \`${REPRO_DIR}/adapters/\`.
- Reference outputs should be stored under \`${REPRO_DIR}/reference/\`.
- Promote only verified reusable behavior into \`src/\`.
EOF

# ------------------------------------------------------------
# 8. Create STATUS.md only if missing
# ------------------------------------------------------------

if [[ ! -f "$STATUS_MD" ]]; then
cat > "$STATUS_MD" <<EOF
# ${repo_basename} Reproduction Status

## Provenance
- Official source: recorded
- Exact revision: recorded
- License: pending verification

## Capability
- Official preprocessing: pending audit
- Official inference: pending audit
- Released checkpoint: pending audit
- Official training: pending audit
- Evaluation code: pending audit

## Verification
- Environment creation: pending
- Model/checkpoint load: pending
- Single-sample inference: pending
- Tiny-set inference: pending
- Reference artifacts: pending

## Adaptation
- Upstream data flow understood: pending
- Canonical adapter: not started
- Local-data inference: not started
EOF
fi

# ------------------------------------------------------------
# 9. Verification summary
# ------------------------------------------------------------

echo
echo "============================================================"
echo " OpenNowcastLab upstream submodule registered successfully"
echo "============================================================"
echo "Repository : $REMOTE_URL"
echo "Path       : $SUBMODULE_PATH"
echo "Branch     : $BRANCH"
echo "Commit     : $COMMIT"
echo "Describe   : $DESCRIBE"
echo
echo "[git submodule status]"
git submodule status "$SUBMODULE_PATH"
echo
echo "[.gitmodules]"
cat .gitmodules
echo
echo "[parent repository status]"
git status --short
echo
echo "Generated / updated:"
echo "  $UPSTREAM_MD"
echo "  $STATUS_MD"
echo
echo "Recommended next step:"
echo "  git add .gitmodules \"$SUBMODULE_PATH\" \"$UPSTREAM_MD\" \"$STATUS_MD\""
echo "  git commit -m \"chore: add ${repo_basename} upstream submodule\""