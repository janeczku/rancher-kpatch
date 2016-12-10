# rancher-kpatch

On a fresh RancherOS 0.7.0 system, we can live patch the kernel using a Docker container:

```
[root@ip-172-31-2-194 rancher]# ros service enable https://raw.githubusercontent.com/SvenDowideit/rancher-kpatch/master/os-mypatch/service.yml
Pulling mykpatch (roast/mykpatch:0.7.0)...
0.7.0: Pulling from roast/mykpatch
Digest: sha256:393183dd55f6d5a91b12e1e6a0c9ae561210078a76da7c635f3a9cc81a0ea3b3
Status: Image is up to date for roast/mykpatch:0.7.0
[root@ip-172-31-2-194 rancher]# ros service list
enabled  amazon-ecs-agent
disabled kernel-extras
disabled kernel-headers
disabled kernel-headers-system-docker
disabled open-vm-tools
enabled  https://raw.githubusercontent.com/SvenDowideit/rancher-kpatch/master/os-mypatch/service.yml
[root@ip-172-31-2-194 rancher]# ros service up mykpatch
WARN[0000] The ECS_AGENT_VERSION variable is not set. Substituting a blank string.
INFO[0000] Project [os]: Starting project
INFO[0000] [0/21] [mykpatch]: Starting
INFO[0000] [1/21] [mykpatch]: Started
INFO[0000] Project [os]: Project started
mykpatch_1 | + insmod /kpatch.ko
mykpatch_1 | + /kpatch load kpatch-mypatch.ko
mykpatch_1 | loading patch module: kpatch-mypatch.ko
[root@ip-172-31-2-194 rancher]# lsmod | head
Module                  Size  Used by    Tainted: G
kpatch_mypatch         16384  1
kpatch                 53248  0
xt_nat                 16384  1
veth                   16384  0
ipt_MASQUERADE         16384  2
nf_nat_masquerade_ipv4    16384  1 ipt_MASQUERADE
xfrm_user              28672  1
xfrm_algo              16384  1 xfrm_user
iptable_nat            16384  1
[root@ip-172-31-2-194 rancher]# grep -i chunk /proc/meminfo
VMALLOCCHUNK:          0 kB
```


## or without a RancherOS service file

```
[root@ip-172-31-2-194 rancher]# system-docker pull roast/mykpatch:0.7.0
0.7.0: Pulling from roast/mykpatch
af49a5ceb2a5: Already exists
8f9757b472e7: Already exists
e931b117db38: Already exists
47b5e16c0811: Already exists
9332eaf1a55b: Already exists
f11ca47706eb: Already exists
7448d2ce3de4: Pull complete
Digest: sha256:393183dd55f6d5a91b12e1e6a0c9ae561210078a76da7c635f3a9cc81a0ea3b3
Status: Downloaded newer image for roast/mykpatch:0.7.0
[root@ip-172-31-2-194 rancher]# system-docker run --rm -it roast/mykpatch:0.7.0
+ insmod /kpatch.ko
insmod: ERROR: could not insert module /kpatch.ko: Operation not permitted
[root@ip-172-31-2-194 rancher]# grep -i chunk /proc/meminfo
VmallocChunk:          0 kB
[root@ip-172-31-2-194 rancher]# system-docker run --rm -it --privileged roast/mykpatch:0.7.0 
+ insmod /kpatch.ko
+ /kpatch load kpatch-mypatch.ko
loading patch module: kpatch-mypatch.ko
[root@ip-172-31-2-194 rancher]# grep -i chunk /proc/meminfo                                  VMALLOCCHUNK:          0 kB
```

The output above uses shows the example patch from https://github.com/dynup/kpatch, which only modifies the output in `/proc/meminfo`

## How it was built

This repo has 2 commands in it.

1 `build-original.sh`, which rebuilds the kernel source used for RancherOS v0.7.0 with DEBUG_INFO on, and saves the resulting container image (35GB)
2 `build-kpatch.sh`, which then uses that build to create a kpatch module, and then builds a small ubuntu based container that when run in privileged mode will load the kernel patch module.
