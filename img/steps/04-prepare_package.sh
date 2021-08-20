#!/bin/bash
ROOTDIR=$(pwd)
echo $ROOTDIR
if [ ! -e "$ROOTDIR/build" ]; then
    echo "Please run from root / no build dir"
    exit 1
fi

cd "$ROOTDIR/build"

# clone stangri repo
rm -rf stangri_repo
git clone https://github.com/stangri/source.openwrt.melmac.net stangri_repo

# install feeds
cd openwrt

./scripts/feeds update -a
./scripts/feeds install -a -p packages
./scripts/feeds install -a -p luci
./scripts/feeds install -a -p routing
./scripts/feeds install -a -p telephony


# replace vpn routing packages
rm -rf feeds/packages/net/vpn-policy-routing/
cp -R ../stangri_repo/vpn-policy-routing feeds/packages/net/

# this does not work
#./scripts/feeds uninstall luci-app-vpn-policy-routing
#./scripts/feeds install -p stangri_repo luci-app-vpn-policy-routing

# Time stamp with $Build_Date=$(date +%Y.%m.%d)
echo -e '\ngithub.com/TheLinuxGuy build @'$(date "+%Y.%m.%d")'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='github.com/TheLinuxGuy build@$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/luciversion/d' feeds/luci/modules/luci-base/luasrc/version.lua

rm -rf .config
