#!/bin/bash
#Usage: ./total-packages.sh <reponame as parameter>
source bintray.secrets
curl -s -u$BINTRAY_USERNAME:$BINTRAY_APIKEY "https://api.bintray.com/repos/$BINTRAY_ORG/$1/packages" > packages.txt

NUM_PACKAGES=$(cat packages.txt | jq '. | length')

echo "Total Number of Packages in this Repo" $NUM_PACKAGES
echo "Adding the Package name and total_downloads in package-dl.csv"
echo "Package, Total_Downloads" > package-dl.csv
COUNTER=0
while [ $COUNTER -lt $NUM_PACKAGES ]; do
     USAGE_URL=https://api.bintray.com/packages/$BINTRAY_ORG/$1/$(cat packages.txt | jq -r ".[$COUNTER].name")
     PACKAGE_NAME=$(cat packages.txt | jq -r ".[$COUNTER].name") 
     DOWNLOAD_STATUS=$(curl -s -u$BINTRAY_USERNAME:$BINTRAY_APIKEY -X POST $USAGE_URL/stats/total_downloads -T timeslice.json | jq '.records | map(.count) | add')
     echo "$PACKAGE_NAME, $DOWNLOAD_STATUS" >> package-dl.csv
     echo -ne '#'
let COUNTER=COUNTER+1
done
echo -e "\nCompleted exporting data to package-dl.csv"
