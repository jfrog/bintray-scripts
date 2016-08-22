#!/bin/bash
#Usage: ./total-repositories.sh
source bintray.secrets

curl -u$BINTRAY_USERNAME:$BINTRAY_APIKEY https://api.bintray.com/repos/$BINTRAY_ORG > repos.txt

NUM_REPOS=$(cat repos.txt | jq '. | length')

echo $NUM_REPOS
echo "repository, storage, downloads" > usage.csv
COUNTER=0
while [ $COUNTER -lt $NUM_REPOS ]; do
    USAGE_URL="https://api.bintray.com/usage/$BINTRAY_ORG/$(cat repos.txt | jq -r ".[$COUNTER].name")"
    #echo $USAGE_URL
    curl -s -u$BINTRAY_USERNAME:$BINTRAY_APIKEY -X POST "$USAGE_URL" -T timeslice.json > usage.txt
    if cat usage.txt | jq -r '.[0]'; then
	echo "Repository $(cat repos.txt | jq -r ".[$COUNTER].name"); Storage: $(cat usage.txt | jq -r '.[0].storage_bytes') Downloaded: $(cat usage.txt | jq -r '.[0].download_bytes') in timeslice"
	echo "$(cat repos.txt | jq -r ".[$COUNTER].name"), $(cat usage.txt | jq -r '.[0].storage_bytes'), $(cat usage.txt | jq -r '.[0].download_bytes')" >> usage.csv
    else
	echo ERROR: $(cat usage.txt)
    fi
    let COUNTER=COUNTER+1
done
