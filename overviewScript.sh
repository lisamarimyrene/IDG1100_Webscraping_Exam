#!/bin/bash

#Loop that goes into alle the newsfolders and news.html files to grep everything I need.
for data in news-*/news*.html                                                                                       
do
    title=$(cat ${data} | grep 'h1' | sed 's/<h1>//g' | sed 's/<\/h1>//g')
    urlarticle=$(cat ${data} |  grep 'a href=w' | sed 's/>Orignal article at Tv2 Nyheter.<\/a>//g')
    link=$(echo "<li><a href="./$data">${title}</a></li>")
    echo ${link} >> indexTemp.txt
done
    
#Making a variable that sort the lines in reverse. 
reverse=$(cat indexTemp.txt | sort -r)

fileOverview="index.html"

echo "<html><head><title>Overwiev Script</title><meta charset=\"UTF-8\"></head><body>\
      <h1>Overview of all News Articles</h1><ol>"\
      > ${fileOverview}
echo "${reverse}" >> ${fileOverview}
echo "</ol></body></html>" >> ${fileOverview}
