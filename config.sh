#!/bin/sh
#(umask  077 ; echo $SSH_KEY | base64 --decode > ~/.ssh/id_rsa)
#Set Remote URL for the repository dynamically using Username and Personal Access Token
export REMOTE_URL=$CI_PROJECT_URL
REMOTE_URL="${REMOTE_URL:0:8}$GITLAB_USERNAME:$GITLAB_TOKEN@${REMOTE_URL:8}.git/"
git config remote.origin.url $REMOTE_URL
git config core.quotePath false
export TIMESTAMP=$(date +%Y%m%d%H%M%S)
