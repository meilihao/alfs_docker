# issue
solved in script, by "grep issue #{xxx}"

## build lfs
in `{some script}.sh`

## qemu image
1. `Sep 06 12:17:58 lfs kernel: evbug: Event. Dev: input1, Type: 1, Code: 33, Value: 1`

    echo "blacklist evbug" >>  /etc/modprobe.d/blacklist.conf
2. `Failed to start Name Service Cache Daemon`

    NSCD(Name Service Cache Daemon)是服务缓存守护进程，它为NIS和LDAP等服务提供更快的验证.

    debug:
    ```bash
    # nscd -d
    ...
    stat failed for file `/etc/netgroup'; will try again later: No such file or directory
    /var/run/nscd/socket: No such file or directory
    ...
    ```

    1. `touch /etc/netgroup` when build glibc