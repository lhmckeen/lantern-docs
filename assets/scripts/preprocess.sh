#!/usr/bin/bash

docx_files=`ls -1 source/preprocess/*.docx 2>/dev/null | wc -l`
odt_files=`ls -1 source/preprocess/*.odt 2>/dev/null | wc -l`
latex_files=`ls -1 source/preprocess/*.tex 2>/dev/null | wc -l`

if [ $docx_files != 0 ] ; then 
for f in source/preprocess/*.docx
    do 
        pandoc "$f" -t markdown --wrap=none --extract-media=assets/images -s -o "${f%.*}.md"
        mv "${f%.docx}.md" source/chapters/
    done
fi

if [ $odt_files != 0 ] ; then 
for f in source/preprocess/*.odt
    do 
        pandoc "$f" -t markdown --wrap=none --extract-media=assets/images -s -o "${f%.*}.md"
        mv "${f%.odt}.md" source/chapters/
    done
fi

if [ $latex_files != 0 ] ; then 
for f in source/preprocess/*.tex
    do 
        pandoc "$f" -t latex --wrap=none -s -o "${f%.*}.md"
        mv "${f%.odt}.md" source/chapters/
    done
fi