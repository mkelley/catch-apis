#! /bin/bash

### This is a script to simply call some routes and print out result:

printblock() {
    echo """

        ============================

    """
}

eval $(cat .env | sed 's/^/export /') ### Load vars defined in .env

printblock

## 2. GET ZTF
URL=${TEST_URL_BASE}'/ztf'
echo $URL
curl -k $URL

printblock

### 3. POST test-post
URL=${TEST_URL_BASE}'/demo'
echo $URL
curl -k $URL -H "Content-Type:application/json"

printblock

## 3. POST test-post
URL=${TEST_URL_BASE}'/demo'
echo $URL
curl -k $URL -X POST -H "Content-Type:application/json" -d "{\"username\": \"UMD\",\"password\": \"TheDude\"}"

printblock

## 4. GET moving-object-search
URL=${TEST_URL_BASE}'/moving-object-search/?start=0&end=10&objid=909'
echo $URL
curl -k $URL

printblock
