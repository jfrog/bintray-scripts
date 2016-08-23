#!/bin/bash
#Usage: ./total-repositories.sh
source bintray.secrets

curl -u$BINTRAY_USERNAME:$BINTRAY_APIKEY https://api.bintray.com/repos/$BINTRAY_ORG > repos.txt

NUM_REPOS=$(cat repos.txt | jq '. | length')
USAGE_URL="https://api.bintray.com/usage/$BINTRAY_ORG"
curl -u$BINTRAY_USERNAME:$BINTRAY_APIKEY -X POST "$USAGE_URL" -T timeslice.json > total_usage.txt
TOTAL_STORAGE=$(cat total_usage.txt | jq -r '.[0].storage_bytes')
TOTAL_DL=$(cat total_usage.txt | jq -r '.[0].download_bytes')
echo $NUM_REPOS
echo 'repository, storage(b), downloaded(b), storage %, downloaded %' > usage.csv
COUNTER=0
while [ $COUNTER -lt $NUM_REPOS ]; do
    REPONAME=$(cat repos.txt | jq -r ".[$COUNTER].name")
    USAGE_URL="https://api.bintray.com/usage/$BINTRAY_ORG/$REPONAME"
    echo $USAGE_URL
    curl -s -u$BINTRAY_USERNAME:$BINTRAY_APIKEY -X POST "$USAGE_URL" -T timeslice.json > usage.txt
    if cat usage.txt | jq -r '.[0]'; then
	DL=$(cat usage.txt | jq -r '.[0].download_bytes')
    STORAGE=$(cat usage.txt | jq -r '.[0].storage_bytes')
	#echo "Repository $REPONAME; Storage: $STORAGE Downloaded: $DL in timeslice"
	echo "$REPONAME, $STORAGE, $DL, $(bc -l <<< $STORAGE/$TOTAL_STORAGE), $(bc -l <<< $DL/$TOTAL_DL)" >> usage.csv
    else
	echo ERROR: $(cat usage.txt)
    fi
    let COUNTER=COUNTER+1
done
echo "Completed output to usage.csv"
