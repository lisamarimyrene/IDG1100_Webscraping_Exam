#!/bin/bash
date=$(date "+%d-%m-%Y %H:%M")
dateFolder="news-$(date "+%d-%m-%Y_%H:%M")"
# [[ -d $dateFolder ]] && rm -r $dateFolder

cd $dateFolder

#Making a loop that makes a html news page with proper tags. 
for number in {1..6}
do
    #Defining variables with different properties from the website. 
    URL=$(cat news${number}.txt | head -n 1) 
    TITLE=$(cat news${number}.txt | sed -n '3p')
    IMG=$(cat news${number}.txt | sed -n '2p')
    SUBTITLE=$(cat news${number}.txt | sed -n '6p')
    DATE=$(date +"%Y-%m-%d %H:%M")

    #Making the html-site with proper html tags.
    echo "<html><head><title>$TITLE</title><meta charset=\"UTF-8\"></head><body>" > news${number}.html
    echo "<h1>$TITLE</h1>" >> news${number}.html
    echo "<img src="$IMG">" >> news${number}.html
    echo "<h2>$SUBTITLE</h2>" >> news${number}.html
    echo "<p>Fetched on $DATE</p>" >> news${number}.html
    echo "<a href="//$URL">Orignal article at Tv2 Nyheter.</a>" >> news${number}.html
    echo "<a href="../index.html">Link to Overview Site.</a>" >> news${number}.html
    echo "</body></html>" >> news${number}.html
done

#Removes the news.html and news.txt (4-6) from the folder on odd days, because they are empty. 
currentDate=`date +"%d" | sed -E 's/^0//'`;
if [ $((10${currentDate}%2)) -eq 1 ];
then
    for number in {4..6}
    do
        rm news${number}.html
        rm news${number}.txt
    done
fi



cd ..