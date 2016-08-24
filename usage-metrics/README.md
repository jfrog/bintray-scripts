Usage-Metrics contains scripts that helps user to calculate the download and storage stats based on the timeslice provided. 
=====================
##Prerequisites

You will need the command-line tool 'jq' for these scripts to function.  On a mac to install it 'brew install jq'


##total-repositories.sh
---------------------

total-repositories.sh will provide the total download and storage in bytes based on the timeslice provided in timeslice.json

##total-packages.sh
-----------------

total-packages.sh will provide the total_downloads of each package in the asked repository based on the timeslice provided

Details about the scripts
=========================


total-repositories.sh
---------------------

Usage
-----

To run the script, run `./total-repositories.sh`.

Requirements:
-------------

To run this script the user needs to provide BINTRAY_USERNAME, BINTRAY_APIKEY, BINTRAY_ORG in bintray.
secrets.

```
export BINTRAY_USERNAME=<insert username>
export BINTRAY_APIKEY=<insert APIKey>
export BINTRAY_ORG=<insert org name>
```


The user also needs to provide the timeslice.json, below is an example of timeslice.json

```
{
    "from":"2016-08-04T00:00:00.000Z",
    "to":"2016-08-05T00:00:00.000Z"
}
```

In the end the script would export the download_bytes and storage_bytes and percentage of total usage of each repository in usage.csv

total-packages.sh
-----------------

Usage
-----

To run the script, run `./total-packages.sh repo_name`.

Requirements:
-------------

To run this script the user needs to provide BINTRAY_USERNAME, BINTRAY_APIKEY, BINTRAY_ORG in bintray.
secrets.

```
export BINTRAY_USERNAME=<insert username>
export BINTRAY_APIKEY=<insert APIKey>
export BINTRAY_ORG=<insert org name>
```


The user also needs to provide the timeslice.json, below is an example of timeslice.json

```
{
    "from":"2016-08-04T00:00:00.000Z",
    "to":"2016-08-05T00:00:00.000Z"
}
```

In the end the script would export the package name and total_downloads of each package in package-dl.csv
