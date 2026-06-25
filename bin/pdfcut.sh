#!/usr/bin/env bash

# Breaks up a single book PDF into smaller files (i.e. chapters) based on 
# page ranges config. Working directory name and the book PDF is expected 
# to have the same name. Config file .cuts is expected in the working 
# directory with the following format <page-ranges>:<pdf-suffix>.
#
# Example: `10-15,17,20-25:_ch01` creates a PDF with suffix `<file>_ch01.pdf`
# that contains physical pages 10 thru 15, 17, and 20 thru 25 of the original
# book PDF file.
# 
# Requires `qpdf` installed. Page range could be in any format it supports.

CONFIG="$PWD/.cuts"
STEM="$(basename "$PWD")"

echo "File: $STEM.pdf"

while IFS=: read -r PAGES SUFFIX; do
  echo "Pages: $PAGES => [$SUFFIX]"
  qpdf "$PWD/$STEM.pdf" --pages . $PAGES -- "$PWD/$STEM$SUFFIX.pdf"
done < "$CONFIG"
