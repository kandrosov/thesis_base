#!/bin/bash

INPUT="main.tex"
TMP_DIR="tmp"
PDF_DIR="pdf"
OUTPUT_TMP="$TMP_DIR/main.pdf"
OUTPUT="$PDF_DIR/thesis.pdf"
TEX_DIR="tex"
IMG_DIR="img"
MY_THESIS_DIR="my_thesis"
MY_PDF_DIR="$MY_THESIS_DIR/pdf"
MY_OUTPUT="$MY_PDF_DIR/thesis.pdf"

mkdir -p "$TMP_DIR"
rm -rf "$TMP_DIR"/*
cp -r "$TEX_DIR"/* "$TMP_DIR"/
cp -r "$IMG_DIR" "$TMP_DIR"/

if [ -d "$MY_THESIS_DIR" ] ; then
    cp -r "$MY_THESIS_DIR"/"$TEX_DIR"/* "$TMP_DIR"/
    find "$MY_THESIS_DIR" -maxdepth 1 ! -name "$TEX_DIR" ! -name "$MY_THESIS_DIR" ! -name "$PDF_DIR" ! -name ".*" \
         -exec cp -r '{}' "$TMP_DIR"/ \;
fi

cd "$TMP_DIR"
rubber --pdf "$INPUT"
cd ..

if [ -f "$OUTPUT_TMP" ] ; then
    mkdir -p "$PDF_DIR"
    cp "$OUTPUT_TMP" "$OUTPUT"
    if [ -d "$MY_THESIS_DIR" ] ; then
        mkdir -p "$MY_PDF_DIR"
        cp "$OUTPUT_TMP" "$MY_OUTPUT"
    fi
fi
