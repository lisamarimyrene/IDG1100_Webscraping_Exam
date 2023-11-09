#!/bin/bash
cd /home/pi/idg1100-559688

./scrapingScript.sh

./pagesScript.sh

./overviewScript.sh
 
rm indexTemp.txt

git pull
git add . 
git commit -m "autocommit"
git push 