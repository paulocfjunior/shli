#!/bin/zsh

alias gkk='gitkraken'
alias gadd='git add .'
alias grst='git reset --hard'
alias gst='git status'
alias gdel='git branch -d'
alias gcm='git commit -m'
alias gcma='git add . && git commit -m'
alias gcmff='git commit --no-verify -m'
alias gcmaff='git add . && git commit --no-verify -m'
alias gpx='git push'
alias gpxf='git push --force'
alias gpxff='git push --force --no-verify'
alias gpxu='git push origin -u $(git rev-parse --abbrev-ref HEAD)'
alias gpl='git pull'
alias gprb='git pull --rebase'
alias gco='git checkout'
alias gcof='git reset --hard && git checkout'
alias gcb='git checkout -b'
alias gmv='git branch -m'
alias gbs='git branch --sort=-committerdate | more'
alias gbss="git branch --sort=-committerdate | grep $1"
alias gback='git checkout -'
alias gsw='git switch'

gempty() {
    message=${1:-"chore: retrigger CI"}
    git commit --allow-empty -m "$message"
}

gsave() {
    if [ -z "$1" ]; then
        pretty "red bold" "You need to pass the commit message."
        return
    fi
    local commit_message=$1

    if [[ "$commit_message" == "now" ]]; then
        commit_message="wip "
        commit_message+=$(date +"%Y-%m-%d %H:%M:%S")
    fi

    git add . && git commit -m $1 && git push
}

gcot() {
    git checkout $(git branch --sort=committerdate | grep -m1 $1)
}

gcbt() {
    if [ -z "$1" ]; then
        echo "You need to pass the task description; Second argument is the environment and it's optional; The third argument is the user name and it's optional."
        return
    fi

    if [ -n "$2" ]; then
        if [[ ! "development staging preprod" =~ $2 ]]; then
            echo "The second argument must be one of the following: development, staging or preprod"
            return
        fi
    fi

    BRANCH_NAME=${3-paulocfjunior}/${2-development}/${1}

    if git show-ref --verify --quiet refs/heads/$BRANCH_NAME; then
        echo "The branch $BRANCH_NAME already exists. You can checkout to it using the following command: 'gco $BRANCH_NAME'"
        return
    fi

    git checkout -b $BRANCH_NAME
}
