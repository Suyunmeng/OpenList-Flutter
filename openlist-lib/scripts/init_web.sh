#!/bin/bash

mkdir dist
curl -L $(eval "curl -fsSL --max-time 2 -H \"Accept: application/vnd.github.v3+json\" \"https://api.github.com/repos/OpenListTeam/OpenList-Frontend/releases/latest\"" | jq -r '.assets[] | select(.browser_download_url | test("openlist-frontend-dist") and (test("openlist-frontend-dist-lite") | not)) | .browser_download_url') -o dist.tar.gz
tar -zxvf dist.tar.gz -C dist
rm -rf ../public/dist
mv -f dist ../public
rm -rf dist.tar.gz