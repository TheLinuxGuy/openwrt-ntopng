# openwrt-ntopng
OpenWRT + ntopng support on a pocket router nanopi R4S

NanoPi R4S is not yet officially supported in OpenWRT official builds (only in snapshots code base) this requires you to build your own OpenWRT build or use FriendlyWRT image which I found to be missing critical items like IPv6 NAT6 kernel modules and its also an older openwrt release.

### Goals

Migrate away from opnsense firewall + ntopng which runs on a VM to a pocket router running OpenWRT. Attempt to leverage the magic of containers to tie it all together.

This repository are my public notes and contributions towards this effort, no guarantees or support provided.

## Quickstart

This repository may have a combination of items, all related to my nanopi R4S effort to run openwrt+ntopng.

At the moment the following components exist:
- NanoPi R4S openwrt build (not yet ready)
- NanoPi R4S ntopng install as a container inside openwrt on FriendlyWRT 19 or OpenWRT 21.02 using my image. You don't need my build to install.

I'm also experimenting with using Ansible for configuration management and deployment of OpenWRT devices. It may eventually be published here.

### OpenWRT 21.02 + docker 

There is an arm64 image that we can run on NanoPi R4S - this works fine in friendlywrt 19 but fails to run on OpenWRT 21.02 vanilla.

After some debugging I have found the root cause and fixed it.

#### A note about /opt/docker folder

You may want to create a separate partition to avoid "/" filling up or crashing openwrt. After you have created a partition and new folder, say "/data" and its automount works every reboot of openwrt then modify the configuration in /etc/config/dockerd specifically `option data_root` path to the new /data/dockerd folder.

#### ntopng install on openwrt 21.02 as a container with host access

```

mkdir -p /opt/ntopng/redis
mkdir -p /opt/ntopng/lib
curl -Lo /opt/ntopng/GeoIP.conf https://raw.githubusercontent.com/TheLinuxGuy/openwrt-ntopng/main/container-config/GeoIP.conf
curl -Lo /opt/ntopng/ntopng.conf https://raw.githubusercontent.com/TheLinuxGuy/openwrt-ntopng/main/container-config/ntopng.conf
curl -Lo /opt/ntopng/redis.conf https://raw.githubusercontent.com/TheLinuxGuy/openwrt-ntopng/main/container-config/redis.conf
```

#### Running container

```

docker run --net=host --privileged --restart always --name ntopng -v /opt/ntopng/GeoIP.conf:/etc/GeoIP.conf -v /opt/ntopng/ntopng.conf:/etc/ntopng/ntopng.conf -v /opt/ntopng/redis.conf:/etc/redis/redis.conf -v /opt/ntopng/lib:/var/lib/ntopng -v /opt/ntopng/redis:/var/lib/redis dlk3/ntopng-udm:latest

```
