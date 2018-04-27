#!/bin/bash

print_usage() {
    echo "Usage: $PROGRAM file action pass-name [path]"
    echo "Actions:"
    echo "  store|add|attach: add new file to password store"
    echo "  retrieve|show|cat: retrieve file from password store and print it to stdout"
    exit 0
}

cmd_store() {
    local path="$1.b64"
    local file="$2"
    local passfile="$PREFIX/$path.gpg"

    check_sneaky_paths "$1"
    set_git "$passfile"

    if [[ -z $path || -z $file ]]; then
        print_usage
    elif [[ ! -f $file ]]; then
        die "Error: $file does not exist."
    fi

    if [[ -f $passfile ]]; then
        read -r -p "A file with this name already exists in the store. Do you want to overwrite it? [y/N] " response
        if [[ $response != [yY] ]]; then
            exit 0;
        fi
    fi

    mkdir -p "$(dirname "$passfile")"

    set_gpg_recipients "$(dirname "$path")"

    base64 $file | $GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o "$passfile" "${GPG_OPTS[@]}" 

    git_add_file $passfile "Store arbitary file for $path to store."
}

cmd_retrieve() {
    local path="$1"
    local passfile="$PREFIX/$path.gpg"

    if [[ -z $path ]]; then 
        print_usage
    else
        check_sneaky_paths "$path"
        $GPG -d "${GPG_OPTS[@]}" "$passfile" | base64 -d || exit $?
    fi
}

case $1 in
    store|add|attach)
        shift && cmd_store "$@"
        ;;
    retrieve|show|cat)
        shift && cmd_retrieve "$@"
        ;;
    *)
        print_usage
        ;;
esac

