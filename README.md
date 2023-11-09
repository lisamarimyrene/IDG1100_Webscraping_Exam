# README FILE
Candidatenumber: 10025

Studentid: 559688

This practical exam project in IDG1100 involves developing a series of small scripts and configuration files to fetch news articles from online newspapers and republish them on a Web server running on a Raspberry Pi. 

The project starts by installing Nginx to the Pi, then connecting it to the Project. I did this to make the `index.html`-file host on a server in the browser. The `mainScript.sh` scrapes every 6hrs by a Systemd Timer.

This project contains 4 scripts: 
  - Scraping Script
  - Pages Script
  - Overview Script
  - Main Script
  
All news articles scraped get added into new folders of today date, to get a clearer overview of all the new files. 

The project also includes config files, that shows how I set up Nginx and Systemd in a *config* folder:
  - nginx-default.txt
  - systemd.service
  - systemd.timer

## Optional tasks (⭐) I chose:
- On days that are even numbers read news from TV2 Sporten. 
- Sorts the news articles by date, with the most recent first.
- Created a Systemd timer unit instead of a contrab entry. 

## Optional tasks (⭐⭐) I chose:
- Retrieving a summary of each news article and adds it at as a fifth line in the information files. 
- Repo Update Script using HTTPS Token.

## The Main Script
The project starts when running the main script named `mainScript.sh`. 

The Main Script contains commands that runs the different Sripts one after one, in order (`scrapingScript.sh, pagesScript.sh, overviewScript.sh`).

The Main Script also includes Git commands that pushes the project automatically to Git Lab.

Remember to type: `chmod +x "filename.sh"` in the Terminal, to give the system permission to run.

## The Scraping Script 
Reads a news article and extracts the URLs, Titles, IMG-URLs and Summary Texts from various articles. 

### Scraping Script runs the following way:
1. Making a project folder named *idg1100-559688*, then goes inside it to continue. 
2. Stating the date, and making a variable that says todays date. 
3. Making a folder by todays date, and then go inside it to continue. 
4. I'm downloading/Scraping TV2 Nyheter and TV2 Sporten. But I'm only Scraping TV2 Sporten on even days (2, 4, 6 etc), which is an optional task (⭐⭐).
5. The Script then starts to sort away everything I don't need in the html, and only retrieving out what I need, by using `sed` and loops. 
6. For each news article, it creates an information txt file with 5 lines: URL, Title, IMG-URL, Date scraped, and the Summary Text. 
7. I choose to do the summary text that was an optional task (⭐⭐). I did this by going into each article, retrieving the article's URL and retrieving the summary text from inside each article. 

## The Pages Script 
Reads information about the extracted news txt articles and creates the necessary HTML pages.

### Pages Script runs the following way:
1. Enter the todays-date folder to continue the process. 
2. Making the HTML pages, by extracting the information from the txt articles, in a for-loop. 
3. On days that are not even (1, 3, 7 etc.) when TV2 Sporten is not Scraped, I made an if-loop that removes the excess news.txt (4-6), so it does not add it to the index.html overview page. 
4. Ends the script by going out of the date folder, using `cd`.

## The Overview Script 
Generates a summary HTML page that links to all the other generated pages.

### Overview Script runs the following way:
1. `Grep` out the title and URL from the news*.html pages, and placing it into a temporary-index txt file.
2. The temporary-index txt file now contains a list of every article. Making then a variable that reverses the articles inside the temporary-index txt file, so now the articles are sorted after date, where the newest article is at the top. This is an optional task (⭐). 
3. Placing the news articles that are now sorted by date, into *Index.html* file that contains the necessary html tags.
 4. Also adding a meta charset, so that the *Index.html* file can read the characters æ, ø and å.

## The Systemd Timer Script (optional task ⭐⭐)
Runs the scripts at 6hrs intervals.

### I set up the Systemd Timer Script by doing these steps in the Terminal:
1. `cd /etc/systemd/user `
2. Create a service file named *systemd*, by typing: `sudo nano systemd.service`. You can see what I put inside this service file, in the file attached to this project named *systemd.service*. There will be comments on what I did there. The service file states what files that you want to run.
3. Create a timer file named *systemd*, by typing: `sudo nano systemd.timer`. You can see what I put inside this service file, in the file attached to this project named *systemd.timer*. There will be comments on what I did there. The timer file makes sure the script runs after preffered time. I chose to run the script automatically every 6hrs, instead on a specific hour of the day, to make the scrip more dynamic. 
4. After making the files, I check if the system and timer are running by typing:
    - `systemctl --user enable contrabScript.service`
    - `systemctl --user start contrabScript.service`
    - `systemctl --user enable contrabScript.timer`
    - `systemctl --user start contrabScript.timer`
    - `systemctl --user daemon-reload`
5. Everything worked perfectly. 

## Repo Update Script (optional task ⭐⭐)
I set up the systemd timer by doing these steps:
1. Log in to GitLab
2. Navigate to my Exam Project on GitLab, and in the settings add an Access Token. I named the Token *raspberrypi*. 
3. Cloning my project with HTTPS.
4. Typing in the terminal: `git clone https://idg1100-559688:xvptHHbkntWyZEFQqyyz@gitlab.stud.idi.ntnu.no/lisamy/idg1100-559688.git` to add the HTTPS clone key. 
5. I can now add, commit and push my project to Git everytime it runs, without enter username and password.

I chose to set up a HTTPS/Access Token instead of SSH because it's more secure. 

## Nginx
The nginx configuration makes it possible to enter the Pi's IP address in the browser, to connect to the index.html Script. 
### To configurate the nginx, I did these steps in the Terminal:
1. Installing nginx on the Terminal.
2. `sudo nano /etc/nginx/sites-enabled/default`
3. Inside that file I changed the root to my path to the project: /home/pi/idg1100-559688;
4. Save the file by typing: `sudo nginx -t`
5. Then activate and restart the nginx by typing: `sudo systemctl restart nginx`.
6. Nginx worked as planned. 


## Errors that may occur in the project
- If there are not images in the TV2 Nyheter article at *www.tv2.no/nyheter*, unfortantly the news html files will be made in a wrong way, since there are not an IMG URL. Since I'm cathing the different lines from the news.txt files, it will catch the wrong line when the IMG URL are missing, and it will make the html news files in a wrong order. 
- This also applies for the TV2 Sporten articles. Sometimes the top articles at *www.tv2.no/sporten* has articles without images, and/or only videos without titles. The txt scripts will also be made in a wrong way.
- The nginx and systemd may not work on your computer, if you have not installed the right files in the right places on you computer. 
# IDG1100_Webscraping_Exam
