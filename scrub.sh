#!/usr/bin/env bash

set -eu
set -o pipefail

readonly ARGS="$@"
readonly RELLONGPROGNAME="$(type $0 | awk '{print $3}')"
readonly LONGPROGNAME=$(perl -m'Cwd' -e 'print Cwd::abs_path(@ARGV[0])' "$RELLONGPROGNAME")
readonly PROGDIR="${LONGPROGNAME%/*}"     # get directory component (remove short match)
readonly PROGNAME="${LONGPROGNAME##*/}"   # get basename component (remove long match)

set -x

# Example:
#   scrub.sh data /share/Data /share/homes/mark/scrubs

prefix="$1"
scan_dir="$2"
scrubs_dir="$3"

mkdir -p "$scrubs_dir"

scrubfile="$scrubs_dir"/"$prefix"--$(date '+%Y-%m-%d--%H-%M-%S--%N').scrubfile

find "$scan_dir"/ -type f -not -path '*/.rsync_shadow/*' -print0 | xargs -0 "$PROGDIR"/scrub.rb | tee "$scrubfile"
