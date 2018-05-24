#!/usr/bin/env bash

print_usage() {
    echo "Usage: $PROGRAM file action pass-name [path]"
    echo "Actions:"
    echo "  store|add|attach: add new file to password store"
    echo "  retrieve|show|cat: retrieve file from password store and print it to stdout"
    echo "  edit|vi: edit a file (warning: unencrypted file will be opened with \$EDITOR)"
    exit 0
}

cmd_store() {
    local path="$1"
    local file="$2"

    if [[ ${path: -4} != ".b64" ]]; then
	path="${path}.b64"
    fi

    local passfile="$PREFIX/$path.gpg"

    cd $OLDPWD # fix for relative paths

    check_sneaky_paths "$1"
    set_git "$passfile"

    if [[ -z $path || -z $file ]]; then
        print_usage
    elif [[ ! -f $file ]]; then
        die "Error: $file does not exist."
    fi

    if [[ -f $passfile ]] && [[ "$PASS_FILE_FORCE_OVERWRITE" != "true" ]]; then
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

    if [[ ${path: -4} != ".b64" ]]; then
	path="${path}.b64"
    fi

    local passfile="$PREFIX/$path.gpg"

    if [[ -z $path ]]; then 
        print_usage
    else
        check_sneaky_paths "$path"
        $GPG -d "${GPG_OPTS[@]}" "$passfile" | base64 -d || exit $?
    fi
}

cmd_edit() {
    local path="$1"
    local passfile="$PREFIX/$path.gpg"

    if [[ ${path: -4} != ".b64" ]]; then
	path="${path}.b64"
    fi
    if [[ -z $path ]]; then 
        print_usage
    elif [[ -z $EDITOR ]]; then
	echo "\$EDITOR not set, don't know how to open file."
	exit 1
    else
        check_sneaky_paths "$path"
	local tmpfile=$(mktemp)
	chmod 0600 $tmpfile
        cmd_retrieve $path $passfile > $tmpfile
	$EDITOR $tmpfile
	PASS_FILE_FORCE_OVERWRITE="true" cmd_store $path $tmpfile
	rm $tmpfile
    fi
}

case $1 in
    store|add|attach)
        shift && cmd_store "$@"
        ;;
    retrieve|show|cat)
        shift && cmd_retrieve "$@"
        ;;
    edit|vi)
	shift && cmd_edit "$@"
	;;
    *)
        print_usage
        ;;
esac

