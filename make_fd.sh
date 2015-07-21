#!/bin/bash
# Make a Feynman diagram.

if [ $# -ne 2 ] ; then
    echo "Usage: input_tex output_pdf"
    exit
fi

INPUT_TEX="$1"
OUTPUT_PDF="$2"

if [ ! -f "$INPUT_TEX" ] ; then
    echo "ERROR: Input tex file '$INPUT_TEX' not found."
    exit
fi

INPUT_TEX_FILE_NAME="$(basename $INPUT_TEX)"
INPUT_TEX_NAME="$( echo $INPUT_TEX_FILE_NAME | sed 's/\.[^.]*$//' )"

TMP_DIR="tmp"
REF_TEX="tex/fd_ref.tex"

if [ ! -f "$REF_TEX" ] ; then
    echo "ERROR: Reference tex file '$REF_TEX' not found."
    exit
fi

REF_TEX_FILE_NAME="$(basename $REF_TEX)"
REF_TEX_NAME="$( echo $REF_TEX_FILE_NAME | sed 's/\.[^.]*$//' )"
OUTPUT_TMP_PS="${REF_TEX_NAME}-pics.ps"
OUTPUT_TMP_PDF="$TMP_DIR/${REF_TEX_NAME}-pics.pdf"

mkdir -p "$TMP_DIR"
rm -rf "$TMP_DIR"/*
cp "$INPUT_TEX" "$TMP_DIR/"
cat "$REF_TEX" | sed "s/INPUT/$INPUT_TEX_NAME/" > "$TMP_DIR/$REF_TEX_FILE_NAME"

cd "$TMP_DIR"
latex "$REF_TEX_NAME"
mpost "diagram.mp"
latex "$REF_TEX_NAME"
dvips -o "$OUTPUT_TMP_PS" "$REF_TEX_NAME"
ps2pdf "$OUTPUT_TMP_PS"
#pdflatex "$REF_TEX_NAME"
cd ..

if [ -f "$OUTPUT_TMP_PDF" ] ; then
    cp "$OUTPUT_TMP_PDF" "$OUTPUT_PDF"
fi
