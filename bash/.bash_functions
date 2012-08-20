# opens a browser window
function browse {
    if [[ $platform == 'cygwin' ]]; then
        /cygdrive/c/Windows/explorer.exe /e,`cygpath -w "$1"`
    elif [[ $platform == 'linux' ]]; then
        nautilus "$1"
    fi
}

