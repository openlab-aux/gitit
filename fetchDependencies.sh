#!/bin/sh

cd "$(dirname "$0")" || { echo "Can't cd. Exiting"; exit 1; }

MATHJAX_PATH=data/static/js/mathjax
FONTAWESOME_PATH=data/static/font-awesome

rm -r "$MATHJAX_PATH" && \
  echo "Removed old MathJax"

rm -r "$FONTAWESOME_PATH" && \
  echo "Removed old Font Awesome"

TMPDIR=$(mktemp -d)

haveOrDie() {
  command -v curl "$1" >/dev/null 2>&1 || { echo >&2 "$1 not found but is required. Exiting."; exit 1; }
}

downloadLatest() {
  curl -L -o "$3" "$(curl -s "https://api.github.com/repos/$1/$2/releases/latest" | grep 'zipball_url' | cut -d\" -f4)"
}

haveOrDie "curl"

echo "Download latest versions"

downloadLatest "mathjax" "MathJax" "$TMPDIR/mathjax.zip" || \
  { echo "Could not download MathJax. Exiting"; exit 1; }

# no latest release for font-awesome via the API
curl -L "https://github.com/FortAwesome/Font-Awesome/archive/master.zip" -o "$TMPDIR/font-awesome.zip" || \
  { echo "Could not download FontAwesome. Exiting"; exit 1; }

echo "Downloaded latest versions of MathJax and Font Awesome"

unzip -n -q "$TMPDIR/mathjax.zip" -d "$TMPDIR" && \
  mv "$TMPDIR"/mathjax-MathJax-* "$MATHJAX_PATH" && \
  echo "Extracted MathJax"

unzip -n -q "$TMPDIR/font-awesome.zip" -d "$TMPDIR" && \
  mv "$TMPDIR/Font-Awesome-master" "$FONTAWESOME_PATH" && \
  echo "Extracted Font Awesome"


curl  "https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.css" -o data/static/css/simplemde.min.css && \
  curl "https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.js" -o data/static/js/simplemde.min.js && \
  echo "Downloaded simplemde files"

rm -r "$TMPDIR" && echo "Removed tmpdir $TMPDIR"
