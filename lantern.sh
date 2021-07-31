#!/bin/bash

# textbook content settings
OUTPUT_FILENAME=textbook
OUTPUT_DIRECTORY=public

# ignore lines 4-5 from original makefile
IMAGES=$(find source/images -type f)
CHAPTERS=$(find source/chapters -name '*.md')

# output configuration files
HOME='--defaults assets/defaults/home.yml'
HTML='--filter pandoc-crossref --defaults assets/defaults/html.yml'
DOCX='--defaults assets/defaults/docx.yml'
LATEX='--filter pandoc-crossref --defaults assets/defaults/latex.yml --no-highlight'
EPUB='--filter pandoc-crossref --defaults assets/defaults/epub.yml --mathml'

# utilities
PANDOC_COMMAND='pandoc --quiet'

# build commands
epub="$OUTPUT_DIRECTORY/$OUTPUT_FILENAME.epub"

html="$OUTPUT_DIRECTORY/$OUTPUT_FILENAME.html"

pdf="$OUTPUT_DIRECTORY/$OUTPUT_FILENAME.pdf"

docx="$OUTPUT_DIRECTORY/$OUTPUT_FILENAME.docx"

latex="$OUTPUT_DIRECTORY/$OUTPUT_FILENAME.tex"

# maybe use 'chmod +x [file]' command to all files in directory

preprocess() {
    ./assets/scripts/preprocess.sh;
    echo "📚 Your Markdown files are ready in the /chapters/ folder"
}

clean() {
    rm -r $OUTPUT_DIRECTORY;
    echo "🧹 Let's start over.";
}

epub() {
    awk 'FNR==1 && NR!=1 {print "\n\n"}{print}' $CHAPTERS >> chapters.md;
    mkdir -p $OUTPUT_DIRECTORY;
    $PANDOC_COMMAND chapters.md $EPUB -o $epub;
    rm chapters.md;
    echo "📚 The EPUB edition is now available in $epub";
}

html() {
    awk 'FNR==1 && NR!=1 {print "\n\n"}{print}' $CHAPTERS >> chapters.md;
    mkdir -p $OUTPUT_DIRECTORY;
    $PANDOC_COMMAND assets/empty.txt $HOME -o public/index.html;
    $PANDOC_COMMAND chapters.md $HTML -o public/textbook.html;
    cp $IMAGES $OUTPUT_DIRECTORY;
    cp assets/lib/* $OUTPUT_DIRECTORY;
    cp assets/styles/* $OUTPUT_DIRECTORY;
    rm chapters.md;
    echo "📚 The HTML edition is now available in public/index.html";
}

pdf() {
    awk 'FNR==1 && NR!=1 {print "\n\n"}{print}' $CHAPTERS >> chapters.md;
    mkdir -p $OUTPUT_DIRECTORY;
    $PANDOC_COMMAND chapters.md $LATEX -o $pdf;
    mv chapters.md $OUTPUT_DIRECTORY/$OUTPUT_FILENAME.md
    echo "📚 The PDF edition is now available in $pdf";
}

latex() {
    awk 'FNR==1 && NR!=1 {print "\n\n"}{print}' $CHAPTERS >> chapters.md;
    mkdir -p $OUTPUT_DIRECTORY;
    $PANDOC_COMMAND chapters.md $LATEX -o $latex;
    echo "📚 The LaTeX edition is now available in $latex";
}

docx() {
    $BASE_DEPENDENCIES;
    mkdir -p $OUTPUT_DIRECTORY;
    $CONTENT | $PANDOC_COMMAND $DOCX -o $docx;
    echo "📚 The DOCX edition is now available in $docx";
}

textbook() {
    markdown
    epub
    html
    pdf
    latex
    docx
}

markdown() {
    CHAPTERS=$(find source/chapters -name '*.md')
    awk 'FNR==1 && NR!=1 {print "\n\n"}{print}' $CHAPTERS >> chapters.md
}

# If no arguments are specified in the $ sh lantern.sh command,
# then run the textbook function (which builds all formats)
if [ -z "$1" ]
then
    textbook
fi

"$@"

