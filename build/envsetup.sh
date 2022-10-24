#!/bin/bash
#
# Copyright (C) 2022 Giovanni Ricca
#
# SPDX-License-Identifier: Apache-2.0
#

if [[ "$1" = "-h" || "$1" = "--help" ]]; then
    cat <<'END'
Usage:
 . vendor/extra/build/envsetup.sh [ARG]
     -h/--help: Shows this screen
     -p/--apply-patches: Apply the patches inside vendor/extra/build/patches folder
END
    return 0
fi

# Setup android env
. build/envsetup.sh

# Defs
export VENDOR_EXTRA_PATH=$(gettop)/vendor/extra
export VENDOR_PATCHES_PATH="$VENDOR_EXTRA_PATH"/build/patches

# Apply patches
if [[ "$1" = "-p" || "$1" = "--apply-patches" ]]; then
    . "$VENDOR_PATCHES_PATH"/apply-patches.sh
fi

# functions
pull_prebuilts() {
    # Vars
    local VENDOR_EXTRA_PREBUILTS="$VENDOR_EXTRA_PATH"/prebuilt
    local VENDOR_EXTRA_EXTERNAL="$VENDOR_EXTRA_PATH"/external
    local VENDOR_EXTRA_APPS="$VENDOR_EXTRA_PREBUILTS"/apps

    # ih8sn vars
    local ih8sn_url_stem="https://github.com/ItsVixano/ih8sn"

    if [ -d "$VENDOR_EXTRA_EXTERNAL"/ih8sn ]; then
        # Resync ih8sn
        rm -rf "$VENDOR_EXTRA_EXTERNAL"/ih8sn
    fi

    git clone ${ih8sn_url_stem} "$VENDOR_EXTRA_EXTERNAL"/ih8sn &> /dev/null
}

los_ota_json() {
    if [[ "$1" = "-h" || "$1" = "--help" ]]; then
        cat <<'END'
Usage:
 los_ota_json [DEVICE CODENAME]
END
        return 0
    fi

    # Check is $1 is empty
    if [ -z "$1" ]; then
        echo -e "\nPlease mention the device codename first"
        return 0
    fi

    # Defs
    DEVICE="$1"

    # Generate the OTA Json
    croot
    cd out/target/product/"$DEVICE"/ &> /dev/null
    "$VENDOR_EXTRA_PATH"/tools/los_ota_json.py

    # Return to source root dir
    croot
}

mka_build() {
    # Call for help
    if [[ "$1" = "-h" || "$1" = "--help" ]]; then
        cat <<'END'
Usage:
 mka_build [DEVICE CODENAME] [ARG]
     -d/--dirty: Avoids running 'mka installclean' before building
END
        return 0
    fi

    # Check is $1 is empty
    if [[ -z "$1" || "$1" = "-d" || "$1" = "--dirty" ]]; then
        echo -e "\nPlease mention the device to build first"
        return 0
    fi

    # Defs
    DEVICE="$1"
    BUILD_TYPE="userdebug" # ToDo: Don't hardcode it
    if [[ "$2" = "-d" || "$2" = "--dirty" ]]; then
        echo -e "\nWarning: Building without cleaning up $DEVICE out dir\n"
        rm -rf out/target/product/"$DEVICE"/lineage-20*.zip &> /dev/null
        DIRTY_BUILD="no"
    else
        echo -e "\nWarning: Building with cleaned up $DEVICE out dir\n"
        DIRTY_BUILD="yes"
    fi

    sleep 3

    # Build
    croot # Make sure we are inside the source root dir
    pull_prebuilts
    lunch lineage_"$DEVICE"-"$BUILD_TYPE"
    if [ "$DIRTY_BUILD" = "yes" ]; then
        mka installclean
    fi
    mka bacon -j16

    # Upload build + extras
    cd out/target/product/"$DEVICE"/ &> /dev/null
    for file in lineage-*.zip recovery.img boot.img obj/PACKAGING/target_files_intermediates/*/IMAGES/vendor_*.img dtbo.img; do
        echo -e "\nUploading $file\n"
        transfer wet $file
    done

    # Output OTA JSON
    los_ota_json "$DEVICE"

    echo -e "\n\nDone!"
}
