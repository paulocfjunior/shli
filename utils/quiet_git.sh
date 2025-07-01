#!/bin/zsh

quiet_git() {
    stdout=$(mktemp)
    stderr=$(mktemp)

    if ! git "$@" </dev/null >$stdout 2>$stderr; then
        cat $stderr >&2
        rm -f $stdout $stderr
        exit 1
    fi

    rm -f $stdout $stderr
}
