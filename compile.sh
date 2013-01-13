#!/usr/bin/env bash
OPTIONS="--highlight-style=zenburn  --standalone -t html -f markdown"
`pandoc $OPTIONS -o html/tp1/0-introduction.html src/0-introduction.markdown`
`pandoc $OPTIONS -o html/tp1/1-discover-php.html src/1-discover-php.markdown`
`pandoc $OPTIONS -o html/tp2/2-implement-PSR-0.html src/2-implement-PSR-0.markdown`
