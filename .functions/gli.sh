function gli() {
    if [[ -z "$1" ]]; then
        echo "No arguments"
        return
    fi

    local message="$1"
    gum log --time rfc822 --level info $1
}
