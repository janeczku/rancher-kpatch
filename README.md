# rancher-kpatch

On a fresh RancherOS 0.7.0 system, we can live patch the kernel using a Docker container:

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
