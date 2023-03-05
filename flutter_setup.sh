DOWNLOADS="$HOME/Downloads"
ANDROID_LOC="$HOME/Android/Sdk"

# https://docs.flutter.dev/get-started/install/linux
if ! type "flutter" > /dev/null;
then
    sudo snap install flutter --classic
    echo "You'll need to export flutter to your PATH"
    exit 1
fi

if ! type "studio" > /dev/null;
then
    if [ ! -f "$DOWNLOADS/android-studio-"* ]
    then
        echo "Download Android Studio. Opening browser"
        open https://developer.android.com/studio
        exit 2
    else
        sudo tar -xvf $DOWNLOADS/android-studio-*.tar.gz -C /usr/local/bin
        sudo ln -s /usr/local/bin/android-studio/bin/studio.sh /usr/local/bin/studio
        rm $DOWNLOADS/android-studio-*.tar.gz
    fi
fi

if [ ! -d "$ANDROID_LOC/cmdline-tools" ]
then
    echo "You need to open Android Studio, download SDK compnents and also cmdline-tools by selecting 'Android SDK Command-line tools (latest)' in the SDK manager of Android Studio"
    echo "Opening studio for you to do so..."
    studio
    exit 3
fi

# You need to accept licenses from command line.
flutter doctor --android-licenses
flutter doctor

sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

