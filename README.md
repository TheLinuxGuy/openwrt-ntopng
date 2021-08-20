# openwrt-ntopng
OpenWRT + ntopng support on a pocket router nanopi R4S

NanoPi R4S is not yet officially supported in OpenWRT official builds (only in snapshots code base) this requires you to build your own OpenWRT build or use FriendlyWRT image which I found to be missing critical items like IPv6 NAT6 kernel modules and its also an older openwrt release.

### Goals

Migrate away from opnsense firewall + ntopng which runs on a VM to a pocket router running OpenWRT. Attempt to leverage the magic of containers to tie it all together.

This repository are my public notes and contributions towards this effort, no guarantees or support provided.

### OpenWRT 21.02 + docker 

There is an arm64 image that we can run on NanoPi R4S - this works fine in friendlywrt 19 but fails to run on OpenWRT 21.02 vanilla.

After some debugging I have found the root cause and fixed it.

#### ntopng install on openwrt 21.02 as a container with host access

```

mkdir -p /mnt/data/ntopng/redis
mkdir -p /mnt/data/ntopng/lib
curl -Lo /mnt/data/ntopng/GeoIP.conf https://raw.githubusercontent.com/TheLinuxGuy/openwrt-ntopng/main/container-config/GeoIP.conf
curl -Lo /mnt/data/ntopng/ntopng.conf https://raw.githubusercontent.com/TheLinuxGuy/openwrt-ntopng/main/container-config/ntopng.conf
curl -Lo /mnt/data/ntopng/redis.conf https://raw.githubusercontent.com/TheLinuxGuy/openwrt-ntopng/main/container-config/redis.conf
```

#### Running container

```

docker run --net=host --privileged --restart always --name ntopng -v /mnt/data/ntopng/GeoIP.conf:/etc/GeoIP.conf -v /mnt/data/ntopng/ntopng.conf:/etc/ntopng/ntopng.conf -v /mnt/data/ntopng/redis.conf:/etc/redis/redis.conf -v /mnt/data/ntopng/lib:/var/lib/ntopng -v /mnt/data/ntopng/redis:/var/lib/redis dlk3/ntopng-udm:latest

```
