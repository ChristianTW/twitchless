#!/bin/bash
watch() {
    if [ "$1" = "who" ]
    then
        export $(egrep -v '^#' .env | xargs)
        auth="Authorization: Bearer $auth"
        client="Client-Id: $client"
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
        mpv -start 15 --force-seekable=yes https://twitch.tv/"$1"
    fi
}
$1 $2
