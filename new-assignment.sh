#!/usr/bin/env bash
# Scaffold a new assignment-XX/ folder from templates/assignment-template.tex.
set -euo pipefail

usage() {
    echo "Usage: $0 <number-or-name>" >&2
    echo "  e.g. $0 07              -> creates assignment-07/" >&2
    echo "       $0 assignment-07   -> creates assignment-07/" >&2
    exit 1
}

[ $# -eq 1 ] || usage

raw="$1"
if [[ "$raw" =~ ^[0-9]+$ ]]; then
    name="assignment-$(printf "%02d" "$raw")"
else
    name="$raw"
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$root/$name"

if [ -e "$target" ]; then
    echo "Error: $target already exists" >&2
    exit 1
fi

mkdir -p "$target" "$target/.build"
cp "$root/templates/.latexmkrc" "$target/.latexmkrc"

tex_file="$target/$name.tex"
cp "$root/templates/assignment-template.tex" "$tex_file"

if [[ "$name" =~ ^assignment-0*([0-9]+)$ ]]; then
    asgnnum="${BASH_REMATCH[1]}"
    sed -i \
        -e "s/asgntitle{X}/asgntitle{$asgnnum}/" \
        -e "s/{AUTHOR}/{6733172621 Patthadon Phengpinij}/" \
        -e "s/{Claude}/{Claude (for\\\\,\\\\LaTeX\\\\,styling and grammar checking)}/" \
        "$tex_file"
fi

echo "Created $target/$name.tex"
echo "Next steps:"
echo "  1. Fill in the Week number and section title in $tex_file"
echo "  2. Build with: make build DIR=$name"

