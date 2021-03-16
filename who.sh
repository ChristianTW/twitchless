#!/bin/bash
watch() {
    if [ "$1" = "who" ]
    then
        export $(egrep -v '^#' .env | xargs) >> /dev/null
        if [ "$client" = "" ]
        then
            echo "Please go to https://twitch.tv/console and click Register Application"
            echo "Set the name to whatever you want"
            echo "Set the OAuth Redirect URL to https://localhost"
            echo "Set Category to Application Integration"
            echo "Click Manage on your application"
            echo "Paste the Client ID in to this window:"
            read client
            echo "client=$client" >> .env
            echo ""
        fi
        if [ "$auth" = "" ]
        then
            echo "Please go to https://twitch.tv/console and click Register Application"
            echo "Set the name to whatever you want"
            echo "Set the OAuth Redirect URL to https://localhost"
            echo "Set Category to Application Integration"
            echo "Click Manage on your application"
            echo "Click New Secret"
            echo "Paste the Client Secret in to this window:"
            read secret
            searchURL="https://id.twitch.tv/oauth2/token?client_id=$client&client_secret=$secret&grant_type=client_credentials"
            DATA=$(curl -s -X POST "$searchURL")
            auth=$( (jq -r '.access_token' <<< $DATA) )
            echo "auth=$auth" >> .env
            echo ""
        fi
        if [ "$userName" = "" ]
        then
            echo "Please enter your twitch username: "
            read userName
            echo "userName=$userName" >> .env
            echo ""
        fi

        if ! command -v jq &> /dev/null
        then
            echo "Missing dependency: jq"
            exit
        fi

        auth="Authorization: Bearer $auth"
        client="Client-Id: $client"

        searchURL="https://api.twitch.tv/helix/users?login=$userName"
        DATA=$(curl -s -X GET "$searchURL" -H "$auth" -H "$client")
        userID=$( (jq -r '.data[] .id' <<< $DATA) )

        searchURL="https://api.twitch.tv/helix/users/follows?from_id=$userID&first=100"

        DATA=$(curl -s -X GET "$searchURL" -H "$auth" -H "$client")

        arr=$( (jq -r '.data[] .to_login' <<< $DATA) )
        read -a array <<< $arr
        for i in "${array[@]}"

        do
            searchURL="https://api.twitch.tv/helix/streams?user_login=$i"
            isStreaming=$(curl -s -X GET "$searchURL" -H "$auth" -H "$client")

            isAvail=$(jq '.data' <<< $isStreaming)

            if [ "$isAvail" != "[]" ]
            then
                echo "$i is available"
            fi

        done
    else
        if ! command -v mpv &> /dev/null
        then
            echo "Missing dependency: mpv"
            exit
        fi
        mpv -start 15 --force-seekable=yes https://twitch.tv/"$1"
    fi
}
$1 $2
