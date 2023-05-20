#!/bin/bash
mkdir SDOUTPUT
cd SDOUTPUT
# ATMOS DL
download_and_extract_atmos() {
    url=$1
    filename=$(basename "$url")

    wget "$url" -O "$filename"
    if [[ "$filename" == *.zip ]]; then
        unzip "$filename"
        rm "$filename"
    fi
}

pre_release_url=$(curl -s "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases" | grep "browser_download_url" | awk -F '"' '{print $4}' | head -n 1)
if [[ -n "$pre_release_url" ]]; then
    download_and_extract_atmos "$pre_release_url"
fi
release_url=$(curl -s "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest" | grep "browser_download_url" | awk -F '"' '{print $4}')
download_and_extract_atmos "$release_url"

# Hekate DL

download_and_extract_hekate() {
    url=$1
    filename=$(basename "$url")

    wget "$url" -O "$filename"
    if [[ "$filename" == *.zip ]]; then
        unzip "$filename"
        rm "$filename"
    fi
}

pre_release_url=$(curl -s "https://api.github.com/repos/CTCaer/hekate/releases" | grep "browser_download_url" | awk -F '"' '{print $4}' | head -n 1)
if [[ -n "$pre_release_url" ]]; then
    download_and_extract_hekate "$pre_release_url"
fi
release_url=$(curl -s "https://api.github.com/repos/CTCaer/hekate/releases/latest" | grep "browser_download_url" | awk -F '"' '{print $4}')
download_and_extract_hekate "$release_url"

# Sigpatches
wget https://sigmapatches.coomer.party/sigpatches.zip && unzip sigpatches.zip

# Prepare stuff
rm nyx_usb_max_rate__run_only_once_per_windows_pc.reg
rm atmosphere/reboot_payload.bin
cp hekate_ctcaer* atmosphere/reboot_payload.bin
mv fusee.bin bootloader/payloads/fusee.bin

# Configs
touch bootloader/hekate_ipl.ini
touch exosphere.ini
mkdir atmosphere/hosts
touch atmosphere/hosts/emummc.txt
echo "[config]
autoboot=0
autoboot_list=0
bootwait=3
backlight=100
autohosoff=0
autonogc=1
updater2p=0
bootprotect=0

[emuMMC]
payload=bootloader/payloads/fusee.bin
icon=bootloader/res/icon_payload.bmp

[sysMMC]
fss0=atmosphere/package3
emummc_force_disable=1
icon=bootloader/res/icon_switch.bmp

[Stock]
fss0=atmosphere/package3
stock=1
emummc_force_disable=1" > bootloader/hekate_ipl.ini


echo "[exosphere]
debugmode=1
debugmode_user=0
disable_user_exception_handlers=0
enable_user_pmu_access=0
blank_prodinfo_sysmmc=0
blank_prodinfo_emummc=1
allow_writing_to_cal_sysmmc=0
log_port=0
log_baud_rate=115200
log_inverted=0" > exosphere.ini


echo "# Block Nintendo Servers
127.0.0.1 *nintendo.*
127.0.0.1 *nintendo-europe.com
127.0.0.1 *nintendoswitch.*
95.216.149.205 *conntest.nintendowifi.net
95.216.149.205 *ctest.cdn.nintendo.net" > atmosphere/hosts/emummc.txt

# Cleaning out
cd ../
cp -r SDOUTPUT SD_Out_Tools
mv SDOUTPUT SD_Out
# Tools Output
cd SD_Out_Tools

download_file() {
    url=$1
    filename=$(basename "$url")

    wget "$url" -O "$filename"
}

RELEASE_INFO=$(curl -s "https://api.github.com/repos/fortheusers/hb-appstore/releases/latest")
TAG_NAME=$(echo "$RELEASE_INFO" | grep -o '"tag_name": *"[^"]*"' | grep -o '[^"]*$')
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -o "browser_download_url\": *\"[^\"]*" | grep "appstore.nro" | grep -o '[^"]*$')
curl -LO "${DOWNLOAD_URL}"
mv appstore.nro switch/appstore.nro

RELEASE_INFO=$(curl -s "https://api.github.com/repos/rashevskyv/dbi/releases/latest")
TAG_NAME=$(echo "$RELEASE_INFO" | grep -o '"tag_name": *"[^"]*"' | grep -o '[^"]*$')
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -o "browser_download_url\": *\"[^\"]*" | grep "DBI.nro" | grep -o '[^"]*$')
curl -LO "${DOWNLOAD_URL}"
mv DBI.nro switch/DBI.nro
