#!/bin/bash

#Making project directory
mkdir -p idg1100-559688

#Change directory to Project Directory
cd ~/idg1100-559688

#Stating the date, then making a varianle with the date
date=$(date "+%d-%m-%Y %H:%M")
dateFolder="news-$(date "+%d-%m-%Y_%H:%M")"

#Making a directory named the current date. All the scraping will take place here. 
mkdir $dateFolder

cd $dateFolder

#Downloading newsarticles using wget, only scraping TV2 Sporten on even days.
 currentDate=`date +"%d" | sed -E 's/^0//'`;
 if [ $((${currentDate}%2)) -eq 0 ]
 then
      wget -O tv2nyheter.html "https://www.tv2.no/nyheter/"
     wget -O tv2sport.html "https://www.tv2.no/sport/"
 else 
      wget -O tv2nyheter.html "https://www.tv2.no/nyheter/"
 fi


#Starting to scrape the news website, retrieving only what I want:

#Removing everything, except everything inside the <body></body> tag, and putting it in a temporary file.
sed -n -e '/<body/,/<\/body>/p' tv2nyheter.html > temp1.html 
sed -n -e '/<body/,/<\/body>/p' tv2sport.html >> temp1.html 

#Removing everything I don't need.
cat temp1.html | sed  '/^$/d' > temp2.html 

#Sorting out the article lines from the temp2.html file, and then putting it into articlesScraped.html. This file has now all the article's htmls. 
sed -n '/<article class.*article--nyheter/,/<\/article>/p' temp2.html > articlesScraped.html 
sed -n '/<article class.*article--nyheter/,/<\/article>/p' articlesScraped.html | head -n 42 > articlesTopThree.html 
sed -n '/<article class.*article--sport/,/<\/article>/p' temp2.html >> articlesScraped.html 
sed -n '/<article class.*article--sport/,/<\/article>/p' articlesScraped.html | head -n 42 >> articlesTopThree.html 

#Loop: Retrieving the URL, title, IMG-URL and date from the articlesTopThree.html file.
input="articlesTopThree.html" 
fileName=articlesInfo.txt #Defining the new filename.
rm -r $fileName 
date=$(date '+%Y-%m-%d_%H:%M:%S') #Defining the date and clock, ex.: "2021-11-09 18:34"

#Loop starts 

#Redefines it only for the "read" invocation.
#IFS=Input Field Seporator, only reading one line at a time.
while IFS= read -r line
do
   #If the line matches "article__link" in $line, grep the article's URL and sed out the unecessary. Then put it in a new file called articlesInfo.txt.
   if [[ $line =~ "article__link" ]]; then 
       echo $line | sed "s/<a class=\"article__link\" href=\"/www.tv2.no/g" | sed "s/\">//g" | sed "s/.$//g" >> $fileName #removing the last / from the url.
   fi
   
   #If the line matches "image__img" in $line, grep the article's IMG-url and sed out/change the unecessary. Then add it to articlesInfo.txt.
   if [[ $line =~ "image__img" ]]; then
       echo $line | sed -n 's/.*data-src="\(.*\)".*"/\1/p' >> $fileName
   fi
   
   #If the line matches "article__title" in $line, grep the article's title and sed out/change the unecessary. Then add it to articlesInfo.txt.
   if [[ $line =~ "article__title" ]]; then
       echo $line | sed -n 's:.*<h2 class.*>\(.*\)</h2>.*:\1:p' >> $fileName
       echo $(date '+%Y-%m-%d %H:%M') >> $fileName
   fi
done < "$input" 


#Reading up articlesInfo.txt and putting the differect articles-lines info their own news files. 

cat articlesInfo.txt | head -n '4' > news1.txt
cat articlesInfo.txt | sed -n '5,8p' > news2.txt
cat articlesInfo.txt | sed -n '9,12p' > news3.txt
cat articlesInfo.txt | sed -n '15,18p' > news4.txt
cat articlesInfo.txt | sed -n '19,22p' > news5.txt
cat articlesInfo.txt | sed -n '23,26p' > news6.txt

#Loop Retrieving the news-URL, catching the sub-text and placing it inside the news(1-6).txt files.
for number in {1..6}
do
    articleURL=$(cat news${number}.txt | head -n 1) 

    wget -O tv2nyheterP.html "$articleURL"

#Removing everything, except the <p itemprop></p> tag, and putting it in a temporary file.
    sed -n -e '/<p itemprop\="description" class\="articleheader__subtitle">/,/<\/p>/p' tv2nyheterP.html > temp3.html 

#Removing the outside tags, and only retrieve the text inside. Add it to the news(1-6).txt
    cat temp3.html | sed "s/<p itemprop\=\"description\" class\=\"articleheader__subtitle\">// ; s/<\/p>//" >> news${number}.txt 
done 
