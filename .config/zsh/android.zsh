# Android SDK environment. The SDK itself is installed by
# install/development/android-sdk.sh; this only wires up the environment, so it
# is a no-op on a machine where the `android-sdk` feature is off.
#
# NOTE: the platform branch below is duplicated in install/common.sh's
# android_sdk_dir(). .zshrc must not depend on the install/ layer, so the two
# are kept deliberately in sync — change both.
if [[ "$OSTYPE" == "darwin"* ]]
then
    _android_sdk="$HOME/Library/Android/sdk"
else
    _android_sdk="$HOME/Android/Sdk"
fi

if [ -d "$_android_sdk" ]
then
    # ANDROID_HOME is what Gradle, AGP and Flutter read. ANDROID_SDK_ROOT is the
    # deprecated name some older tools still look at first; point both at the
    # same place so they can't disagree.
    export ANDROID_HOME="$_android_sdk"
    export ANDROID_SDK_ROOT="$_android_sdk"

    export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi

unset _android_sdk
