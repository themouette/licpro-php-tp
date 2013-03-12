#!/usr/bin/env bash
OPTIONS="--highlight-style=tango --standalone -t html -f markdown"
pandoc $OPTIONS -o html/tp1/0-introduction.html src/0-introduction.markdown
pandoc $OPTIONS -o html/tp1/1-discover-php.html src/1-discover-php.markdown
pandoc $OPTIONS -o html/tp2/2-implement-PSR-0.html src/2-implement-PSR-0.markdown
pandoc $OPTIONS -o html/tp2/3-implement-a-front-controller.html src/3-implement-a-front-controller.markdown
pandoc $OPTIONS -o html/tp3/4-complete-the-application.html src/4-complete-the-application.markdown
pandoc $OPTIONS -o html/tp3/5-content-negotiation.html src/5-content-negotiation.markdown
pandoc $OPTIONS -o html/tp3/6-traits-examples.html src/6-traits-examples.markdown
pandoc $OPTIONS -o html/tp4/7-playing-with-a-database.html src/7-playing-with-a-database.markdown
pandoc $OPTIONS -o html/tp5/8-writing-tests.html src/8-writing-tests.markdown
pandoc $OPTIONS -o html/tp6/9-the-end.html src/9-the-end.markdown
pandoc $OPTIONS -o html/projet.html src/projet.markdown

pandoc $OPTIONS -o html/sf2/1-getting-started.html src/sf2/1-getting-started.md
pandoc $OPTIONS -o html/sf2/2-practical-2.html src/sf2/2-practical-2.md
