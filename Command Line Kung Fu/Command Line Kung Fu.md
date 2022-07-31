# Command Line Kung Fu



## Shell History
### Run the Last Command as Root

```shell
$ sudo !!
$ su -c "!!"
```

If you ever forget to run a command with root privileges, you can simply repeat it by using sudo !! or su -c "!!".

```shell
$ adduser sam
-bash: /usr/sbin/adduser: Permission denied
$ sudo !!
sudo adduser sam
$ id sam
uid=1007(sam) gid=1007(sam) groups=1007(sam)
$ userdel -r sam
-bash: /usr/sbin/userdel: Permission denied
$ sudo !!
sudo userdel -r sam
$ id sam
id: sam: No such user
$ useradd jim
-bash: /usr/sbin/useradd: Permission denied
$ su -c "!!"
su -c "useradd jim"
Password:
$ id jim
uid=1007(jim) gid=1007(jim) groups=1007(jim)
```

This exclamation mark syntax is called an event designator. An event designator references a command in your shell history. Bang-Bang (!!) repeats the most recent command, but one of my favorite uses of the event designator is to run the most recent command that starts with a given string. Here’s an example.  

```shell
$ whoami
jason
$ uptime
12:33:15 up 35 min, 1 user, load average: 0.00, 0.00, 0.00
$ df -hT /boot
Filesystem Type Size Used Avail Use% Mounted on
/dev/vda1 ext4 485M 55M 406M 12% /boot
$ !u
uptime
12:33:29 up 35 min, 1 user, load average: 0.00, 0.00, 0.00
$ sudo !w
sudo whoamiroot
```

### Repeat the Last Command That Started with a given String

```shell
$ !<string>
```

This is another example of an event designator. To recall the most recent command that begins with \<string\>, run "!\<string\>". You can simply specify the first letter, or as much of the string to make it unique. This example demonstrates that concept  

```
$ who
jason pts/1 2014-04-06 21:04 (192.168.1.117)
$ w
jason pts/1 192.168.1.117 21:04 0.00s 0.33s 0.00s w
$ !w
w 
jason pts/1 192.168.1.117 21:04 0.00s 0.33s 0.00s w
$ !wh
who
jason pts/1 2014-04-06 21:04 (192.168.1.117)
```

Here is a practical example where you check to see if a process is running, kill it, and confirm that it did indeed stop.  

```
$ ps -fu apache
UID PID PPID C STIME TTY TIME CMD
apache 1877 1879 0 21:32 ? 00:00:00 /usr/sbin/httpdapache 1879 1 0 21:32 ? 00:00:00 usr/sbin/httpd
$ sudo service httpd stop
Stopping httpd: [ OK ]
$ !p
ps -fu apache
UID PID PPID C STIME TTY TIME CMD
$
```

### Reuse the Second Word (First Argument) from the Previous Command

```
$ !^
```

If you need to grab the second word from the previous command, you can use the "!^" word designator. Wherever you use "!^" it will be replaced by the second word from the previous command. You can also think of this as the first argument to the previous command.  

```
$ host www.google.com 8.8.8.8
Using domain server:
Name: 8.8.8.8
Address: 8.8.8.8#53
Aliases:
www.google.com has address 173.194.46.83
www.google.com has address 173.194.46.81
www.google.com has address 173.194.46.84
www.google.com has address 173.194.46.82
www.google.com has address 173.194.46.80
www.google.com has IPv6 address 2607:f8b0:4009:805::1013
$ ping -c1 !^
ping -c1 www.google.com
PING www.google.com (173.194.46.80) 56(84) bytes of data.64 bytes from ord08s11-in-f16.1e100.net (173.194.46.80): icmp_seq=1
ttl=51 time=17.0 ms
--- www.google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 49ms
rtt min/avg/max/mdev = 17.071/17.071/17.071/0.000 ms
$
```



### Reuse the Last Word (Last Argument) from the Previous Command

```
$ !$
```

Quite often I find myself needing to perform another operation on the last item on the previous command line. To access that item in your current command, use "!$".  

```
$ unzip tpsreport.zip
Archive: tpsreport.zip
inflating: cover-sheet.doc
$ rm !$
rm tpsreport.zip
$ mv cover-sheet.doc reports/
$ du -sh !$
du -sh reports/
4.7G reports/
$
```



### Reuse the Nth Word from a Previous Command

```
$ !!:N
$ <event_designator>:<number>
```

To access a word in the previous command use "!!:N" where N is the number of the word you wish to retrieve. The first word is 0, the second word is 1, etc. You can think of 0 as being the command, 1 as being the first argument to the command, 2 as being the second argument, and so on.  

You can use any event designator in conjunction with a word designator. In the following example, "!!" is the most recent command line: `avconv -i screencast.mp4 podcast.mp3`. The "!a" event designator expands to that same command since it's the most recent command that started with the letter "a."  

```
$ avconv -i screencast.mp4 podcast.mp3
$ mv !!:2 converted/
mv screencast.mp4 converted/
$ mv !a:3 podcasts/
mv podcast.mp3 podcasts/
$
```



### Repeat the Previous Command While Substituting a String

```
$ ^<string1>^<string2>^
```

This little trick is great for quickly correcting typing mistakes. If you omit ^\<string2\>^, then \<string1\> will be removed from the previous command. By default, only the first occurrence of \<string1\> is replaced. To replace every occurrence, append ":&". You can omit the trailing caret symbol, except when using ":&".  

```
$ grpe jason /etc/passwd
-bash: grpe: command not found
$ ^pe^ep
grep jason /etc/passwd
jason:x:501:501:Jason Cannon:/home/jason:/bin/bash
$ grep rooty /etc/passwd
$ ^y
grep root /etc/passwd
root:x:0:0:root:/root:/bin/bash
operator:x:11:0:operator:/root:/sbin/nologin
$ grep canon /etc/passwd ; ls -ld /home/canon
ls: cannot access /home/canon: No such file or directory
$ ^canon^cannon^:&
grep cannon /etc/passwd ; ls -ld /home/cannoncannon:x:1001:1001::/home/cannon:/bin/sh
drwxr-xr-x 2 cannon ball 4096 Apr 7 00:22 /home/cannon
```





### Reference a Word of the Current Command and Reuse It

```
$ !#:N
```

The "!#" event designator represents the current command line, while the :N word designator represents a word on the command line. Word references are zero based, so the first word, which is almost always a command, is :0, the second word, or first argument to the command, is :1, etc.  

```
$ mv Working-with-Files.pdf Chapter-18-!#:1
mv Working-with-Files.pdf Chapter-18-Working-with-Files.pdf
```





### Save a Copy of Your Command Line Session

```
$ script
```

If you want to document what you see on your screen, use the script command. The script command captures everything that is printed on your terminal and saves it to a file. You can provide script a file name as an argument or let it create the default file named typescript.  

```
$ script
Script started, file is typescript
$ cd /usr/local/bin
$ sudo ./upgradedb.sh
sudo password for jason:
Starting database upgrade.
...
Database upgrade complete.
$ exit
exit
Script done, file is typescript
$ cat typescript
Script started on Wed 09 Apr 2014 06:30:58 PM EDT
$ cd /usr/local/bin$ sudo ./upgradedb.sh
sudo password for jason:
Starting database upgrade.
...
Database upgrade complete.
$ exit
exit
Script done on Wed 09 Apr 2014 06:31:44 PM EDT
$
```





### Find out Which Commands You Use Most Often

```
$ history | awk '{print $2}' | sort | uniq -c | sort -rn | head
```

To get a list of the top ten most used commands in your shell history, use the following command.  

```
$ history | awk '{print $2}' | sort | uniq -c | sort -rn | head
61 ls
45 cd
40 cat
31 vi
24 ip
22 sudo
22 ssh
22 ll
19 rm
17 find
$
```



### Clear Your Shell History

```
$ history -c
```

To clear your shell history, use the -c option to the history command.  

```
$ history | tail -5
966 ls -lR Music/
967 find Music/ -type f -ls
968 dstat
969 sudo vi /etc/motd
970 cd ..
971 sudo du -s /home/* | sort -n
$ history -c
$ history
1 history
$
```



## Text Processing and Manipulation
### Strip out Comments and Blank Lines

```
$ grep -E -v "^#|^$" file
```

To strip out all the noise from a configuration file get rid of the comments and blank lines. These two regexes (regular expressions) do the trick. "^#" matches all lines that begin with a "#". "^$" matches all blank lines. The -E option to grep allows us to use regexes and the -v option inverts the matches.  

```
[jason@www conf]$ grep -E -v '^#|^$' httpd.conf | head
ServerTokens OS
ServerRoot "/etc/httpd"
PidFile run/httpd.pid
Timeout 60
KeepAlive Off
MaxKeepAliveRequests 100
KeepAliveTimeout 15
<IfModule prefork.c>
StartServers 8
MinSpareServers 5
[jason@www conf]$
```





### Use Vim to Edit Files over the Network

```
$ vim scp://remote-host//path/to/file
$ vim scp://remote-user@remote-host//path/to/file
```

If you want to edit a file with vim over SSH, you can let it do the heavy lifting of copying the file back and forth.  

```
$ vim scp://linuxserver//home/jason/notes.txt
```



### Display Output in a Table

```
$ alias ct='column -t'
$ command | ct
```

Use the column command to format text into multiple columns. By using the -t option, column will count the number of columns the input contains and create a table with that number of columns. This can really make the output of many command easier to read. I find myself using this so often that I created an alias for the command.  

```
$ alias ct='column -t'
$ echo -e 'one two\nthree four'
one two
three four
$ echo -e 'one two\nthree four' | ct
one		two
three	four
$ mount -t ext4
/dev/vda2 on / type ext4 (rw)
/dev/vda1 on /boot type ext4 (rw)
$ mount -t ext4 | ct
/dev/vda2	on	/		type	ext4	(rw)
/dev/vda1	on	/boot	type	ext4	(rw)
$
```



### Grab the Last Word on a Line of Output

```
$ awk '{print $NF}' file
$ cat file | awk '{print $NF}'
```

You can have awk print fields by using $FIELD_NUMBER notation. To print the first field use $1, to print the second use $2, etc. However, if you don't know the number of fields, or don't care to count them, use $NF which represents the total number of fields. Awk separates fields on spaces, but you can use the -F argument to change that behavior. Here is how to print all the shells that are in use on the system. Use a colon as the field separator and then print the last field.  

```
$ awk -F: '{print $NF}' /etc/passwd | sort -u
```

If you want to display the shell for each user on the system you can do this.

```
$ awk -F: '{print $1,$NF}' /etc/passwd | sort | column -t
adm /sbin/nologin
apache /sbin/nologin
avahi-autoipd /sbin/nologin
bin /sbin/nologin
bobb /bin/bash
...
```







### View Colorized Output with Less

```
$ ls --color=always | less -R
$ grep --color=always file | less -R
```

Some linux distributions create aliases for ls and grep with the --color=auto option. This causes colors to be used only when the output is going to a terminal. When you pipe the output from ls or grep the color codes aren't emitted. You can force color to always be displayed by ls or grep with --color=always. To have the less command display the raw control characters that create colors, use the -R option.  

```
$ grep --color=always -i bob /etc/passwd | less -R
$ ls --color=always -l /etc | less -R
```



### Preserve Color When Piping to Grep

```
$ ls -l --color=always | grep --color=never string
```

If you pipe colorized input into grep and grep is an alias with the --color=auto option, grep will discard the color from the input and highlight the string that was grepped for. In order to preserve the colorized input, force grep to not use colors with the --color=never option.  

```
$ ls -l --color=always *mp3 | grep --color=never jazz
-rw-r--r--. 1 jason jason 21267371 Feb 16 11:12 jazz-album-1.mp3
```



### Append Text to a File Using Sudo

```
$ echo text | sudo tee -a file
```

If you have ever tried to append text to a file using redirection following a "sudo echo" command, you quickly find this doesn't work. What happens is the echo statement is executed as root but the redirection occurs as yourself.  

```
$ sudo echo "PRODUCTION Environment" >> /etc/motd
-bash: /etc/motd: Permission denied
```

Fortunately, use can use sudo in combination the tee command to append text to a file.  

```
$ echo "PRODUCTION Environment" | sudo tee -a /etc/motd
PRODUCTION Environment
```



### Change the Case of a String

```
$ tr [:upper:] [:lower:]
$ tr [:lower:] [:upper:]
```

When you need to change the case of a string, use the tr command. You can supply ranges to tr like "tr a-z A-Z" or use "tr [:lower:][:upper]".  

```
$ ENVIRONMENT=PRODUCTION
$ DIRECTORY=$(echo $ENVIRONMENT | tr [:upper:] [:lower:])
$ echo $ENVIRONMENT | sudo tee -a /etc/motd
$ tail -1 /etc/motd
PRODUCTION
$ sudo mkdir /var/www/$DIRECTORY
$ sudo tar zxf wwwfiles.tgz -C /var/www/$DIRECTORY
```



### Display Your Command Search Path in a Human Readable Format

```
$ echo $PATH | tr ':' '\n'
```

Reading a colon separated list of items isn't as easy for us humans as it is for computers. To substitute new lines for colons, use the tr command.  

```
$ echo $PATH
/usr/bin:/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin
$ echo $PATH | tr ':' '\n'
/usr/bin
/bin
/usr/local/bin
/bin
/usr/bin
/usr/local/sbin
/usr/sbin
/sbin
$
```



### Create a Text File from the Command Line without Using an Editor

```
$ cat > file
<ctrl-d>
```

If you need to make a quick note and don't need a full blown text editor, you can simply use cat and redirect the output to a file. Press \<ctrl-d\> when you're finished to create the file.  

```
$ cat > shopping.list
eggs
bacon
coffee
<ctrl-d>
$ cat shopping.list
eggs
bacon
coffee
$
```



### Display a Block of Text between Two Strings

```
$ awk '/start-pattern/,/stop-pattern/' file.txt
$ command | awk '/start-pattern/,/stop-pattern/'
```

The grep command is great at extracting a single line of text. But what if you need to capture an entire block of text? Use awk and provide it a start and stop pattern. The pattern can simply be a string or even a regular expression.  

```
$ sudo dmidecode | awk /Processor/,/Manuf/
Processor Information
Socket Designation: SOCKET 0
Type: Central Processor
Family: Core i5
Manufacturer: Intel
$ awk '/worker.c/,/^$/' httpd.conf
<IfModule worker.c>
StartServers 4
MaxClients 300
MinSpareThreads 25
MaxSpareThreads 75
ThreadsPerChild 25
MaxRequestsPerChild 0</IfModule>
$
```



### Delete a Block of Text between Two Strings

```
$ sed '/start-pattern/,/stop-pattern/d' file
$ command | sed '/start-pattern/,/stop-pattern/d' file
```

You can delete a block of text with the sed command by providing it a start and stop pattern and telling it to delete that entire range. The patterns can be strings or regular expressions. This example deletes the the first seven lines since "#" matches the first line and "^$" matches the seventh line.  

```
$ cat ports.conf
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default
# This is also true if you have upgraded from before 2.2.9-3 (i.e. from
# Debian etch). See /usr/share/doc/apache2.2-common/NEWS.Debian.gz and
# README.Debian.gz
NameVirtualHost *:80
Listen 80
<IfModule mod_ssl.c>
    # If you add NameVirtualHost *:443 here, you will also have to change
    # the VirtualHost statement in /etc/apache2/sitesavailable/default-ssl
    # to <VirtualHost *:443>
    # Server Name Indication for SSL named virtual hosts is currently not
    # supported by MSIE on Windows XP.
    Listen 443
</IfModule>

<IfModule mod_gnutls.c>
    Listen 443
</IfModule>
$ sed '/#/,/^$/d' ports.conf
NameVirtualHost *:80
Listen 80
<IfModule mod_ssl.c>
<IfModule mod_gnutls.c>
    Listen 443
</IfModule>
$
```



### Fix Common Typos with Aliases

```
$ alias typo='correct spelling'
```

If you find yourself repeatedly making the same typing mistake over and over, fix it with an alias.  

```
$ grpe root /etc/passwd
bash: grpe: command not found
$ echo "alias grpe='grep'" >> ~/.bash_profile
$ . ~/.bash_profile
$ grpe root /etc/passwd
root:x:0:0:root:/root:/bin/bash
$
```



### Sort the Body of Output While Leaving the Header on the First Line Intact

Add this function to your personal initialization files such as ~/.bash_profile:  

```
body() {
    IFS=read -r header
    printf '%s\n' "$header"
    "$@"
}

$ command | body sort
$ cat file | body sort
```

I find myself wanting to sort the output of commands that contain headers. After the sort is performed the header ends up sorted right along with the rest of the content. This function will keep the header line intact and allow sorting of the remaining lines of output. Here are some examples to illustrate the usage of this function.  

```
$ df -h | sort -k 5
/dev/vda2 28G 3.2G 25G 12% /
tmpfs 504M 68K 504M 1% /dev/shm
/dev/vda1 485M 444M 17M 97% /boot
Filesystem Size Used Avail Use% Mounted on

$ df -h | body sort -k 5
Filesystem Size Used Avail Use% Mounted on
/dev/vda2 28G 3.2G 25G 12% /
tmpfs 504M 68K 504M 1% /dev/shm/dev/vda1 485M 444M 17M 97% /boot

$ ps -eo pid,%cpu,cmd | head -1
  PID %CPU CMD

$ ps -eo pid,%cpu,cmd | sort -nrk2 | head
  675 12.5 mysqld
  PID %CPU CMD
  994 0.0 /usr/sbin/acpid
  963 0.0 /usr/sbin/modem-manager
  958 0.0 NetworkManager
  946 0.0 dbus-daemon
  934 0.0 /usr/sbin/fcoemon --syslog
  931 0.0 [bnx2fc_thread/0]
  930 0.0 [bnx2fc_l2_threa]
  929 0.0 [bnx2fc]

$ ps -eo pid,%cpu,cmd | body sort -nrk2 | head
  PID %CPU CMD
  675 12.5 mysqld
  994 0.0 /usr/sbin/acpid
  963 0.0 /usr/sbin/modem-manager958 0.0 NetworkManager
  946 0.0 dbus-daemon
  934 0.0 /usr/sbin/fcoemon --syslog
  931 0.0 [bnx2fc_thread/0]
  930 0.0 [bnx2fc_l2_threa]
  929 0.0 [bnx2fc]
$
```



### Remove a Character or set of Characters from a String or Line of Output

```
$ command | tr -d "X"
$ command | tr -d [SET]
$ cat file | tr -d "X"
$ cat file | tr -d [set]
```

The tr command is typically used to translate characters, but with the -d option it deletes characters. This example shows how to get rid of quotes.  

```
$ cat cities.csv
1,"Chicago","USA","IL"
2,"Austin","USA","TX"
3,"Santa Cruz","USA","CA"

$ cat cities.csv | cut -d, -f2
"Chicago"
"Austin"
"Santa Cruz"

$ cat cities.csv | cut -d, -f2 | tr -d '"'
Chicago
Austin
Santa Cruz
$
```

You can also let tr delete a group of characters. This example removes all the vowels from the  output.

```
$ cat cities.csv | cut -d, -f2 | tr -d [aeiou]
"Chcg"
"Astn"
"Snt Crz"
$
```





### Count the Number of Occurrences of a String

```
$ uniq -c file
$ command | uniq -c
```

The uniq command omits adjacent duplicate lines from files. Since uniq doesn't examine an entire file or stream of input for unique lines, only unique adjacent lines, it is typically preceded by the sort command via a pipe. You can have the uniq command count the unique occurrences of a string by using the "-c" option. This comes in useful if you are trying to look through log files for occurrences of the same message, PID, status code, username, etc.

Let's find the all of the unique HTTP status codes in an apache web server log file named access.log. To do this, print out the ninth item in the log file with the awk command.

```
$ tail -1 access.log
18.19.20.21 - - [19/Apr/2014:19:51:20 -0400] "GET / HTTP/1.1" 200 7136 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.154 Safari/537.36"

$ tail -1 access.log | awk '{print $9}'
200

$ awk '{print $9}' access.log | sort | uniq
200
301
302
404
$
```

Let's take it another step forward and count how many of each status code we have.

```
$ awk '{print $9}' access.log | sort | uniq -c | sort -nr
5641 200
207 301
86 404
18 302
2 304
$
```

Now let's see extract the status code and hour from the access.log file and count the unique occurrences of those combinations. Next, lets sort them by number of occurrences. This will show us the hours during which the website was most active.

```
$ cat access.log | awk '{print $9, $4}' | cut -c 1-4,18-19 | uniq -c | sort -n | tail
72 200 09
76 200 06
81 200 06
82 200 06
83 200 06
83 200 06
84 200 06
109 200 20
122 200 20
383 200 10
$
```



## Networking and SSH
### Serve Files in the Current Directory via a Web Interface

```
$ python -m SimpleHTTPServer
$ python3 -m http.server
```

By default, this command starts a web server and serves up the content in the current directory over port 8000. You can change the port by specifying it at the end of the line. If no index.html file exists in the current directory, then the directory listing is shown. Start the web server and use a web browser to navigate to it. (firefox http://localhost:8000) This can come in handy when you are working on HTML content and you want to see how it looks in a web browser without installing and configuring a full blown web server.

```
$ python -m SimpleHTTPServer
Serving HTTP on 0.0.0.0 port 8000 …
localhost.localdomain - - [06/Apr/2014 21:49:20] "GET / HTTP/1.1"
200 -
```

Here's how to start the web server on the standard HTTP port. Since port 80 is a privileged port, IE it's 1024 or lower, doing this requires root privileges.

```
$ sudo python -m SimpleHTTPServer 80
Serving HTTP on 0.0.0.0 port 80 ...
```

### Mount a Directory from a Remote Server on Your Local Host via SSH

```
$ sshfs remote-host:/directory mountpoint
$ fusermount -u mountpiont
```

Sometimes it's easier to work on files and directories if they are, or appear to be, local to your machine. For example, maybe you have a local application that doesn't exist on the server that you use to manipulate files. Instead of downloading the file from the server, modifying it, and and uploading it back to the server, you can mount the remote directory on your local workstation. Here is an example of updating a website over SSH.

```
$ mkdir web-files
$ sshfs www.example.com:/home/jason/public_html
$ bluefish web-files/index.html
$ fusermount -u web-files
```

Just like ssh command, you can use the user@host format if your remote username is different from your local username. Also, if no directory is specified after the colon, then your home directory is assumed.

### Get Your Public IP from the Command Line Using Curl

```
$ curl ifconfig.me
```

If you ever need to determine your public (Internet) IP address you can use the ifconfig.me website.

```
$ curl ifconfig.me
198.145.20.140
$ curl ifconfig.me/ip
198.145.20.140
$ curl ifconfig.me/host
pub2.kernel.org
```



### SSH into a Remote System without a Password

```
$ ssh-keygen
$ ssh-copy-id remote-host
$ ssh remote-host
```

In order to SSH into a remote host without a password you'll need an SSH key pair consisting of a private and public key. On the remote host the contents of the public key need to be in ~/.ssh/authorized_keys. The ssh-copy-id script performs that work. If you want to generate a key without a password, simply hit enter when prompted for a passphrase. You can optionally supply a blank string to the -N option. (ssh-keygen -N '')

```
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/jason/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/jason/.ssh/id_rsa.
Your public key has been saved in /home/jason/.ssh/id_rsa.pub.
The key fingerprint is:
0d:2e:e4:32:dd:da:60:a5:2e:0f:c5:89:d5:78:30:ad
jason@laptop.localdomain
The key's randomart image is:
+--[ RSA 2048]----+
| o        .      |
| =        .      |
| +    .    =     |
| BEB         o   |
| +   @   S   .   |
| *         =     |
| o     o     .   |
| +               |
| .               |
+-----------------+
$ ssh-copy-id linuxserver
jason@192.168.122.60's password:
Now try logging into the machine, with "ssh 'linuxserver'"
, and check in: .ssh/authorized_keys to make sure we haven't added extra keys that you weren't expecting.
$ ssh linuxserver
$ hostname
linuxserver
$
```



### Show Open Network Connections

```
$ sudo lsof -Pn
```

The lsof command can not only be used to display open files, but open network ports, and network connections. The -P option prevents the conversion of port numbers to port names. The -n option prevents the conversion of IP addresses to host names. The -i option tells lsof to display network connections.

```
$ sudo lsof -Pni
COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
dhclient 989 root 6u IPv4 11522 0t0 UDP *:68
sshd 1202 root 3u IPv4 12418 0t0 TCP *:22 (LISTEN)
sshd 1202 root 4u IPv6 12423 0t0 TCP *:22 (LISTEN)
ntpd 1210 ntp 16u IPv4 12464 0t0 UDP *:123
ntpd 1210 ntp 17u IPv6 12465 0t0 UDP *:123
ntpd 1210 ntp 18u IPv4 12476 0t0 UDP 127.0.0.1:123
ntpd 1210 ntp 19u IPv4 12477 0t0 UDP 192.168.122.60:123
ntpd 1210 ntp 20u IPv6 12478 0t0 UDP [::1]:123
ntpd 1210 ntp 21u IPv6 12479 0t0 UDP [fe80::5054:ff:fe52:d858]:123
master 1364 root 12u IPv4 12761 0t0 TCP 127.0.0.1:25 (LISTEN)
clock-app 12174 jason 21u IPv4 78889 0t0 TCP
192.168.122.60:39021->184.25.102.40:80 (ESTABLISHED)
sshd 12339 root 3r IPv4 74023 0t0 TCP
192.168.122.60:22->192.168.122.1:34483 (ESTABLISHED)
sshd 12342 jason 3u IPv4 74023 0t0 TCP
192.168.122.60:22->192.168.122.1:34483 (ESTABLISHED)
$
```



### Compare the Differences between a Remote and Local File

```
$ ssh remote-host cat /path/to/remotefile | diff /path/to/localfile -
```

To display the differences between a local and remote file, cat a file over ssh and pipe the output into a diff or sdiff command. The diff and sdiff commands can accept standard input in lieu of a file by supplying it a dash for one of the file names.

```
$ ssh linuxsvr cat /etc/passwd | diff /etc/passwd -
32c32
< terry:x:503:1000::/home/terry:/bin/ksh
---
> terry:x:503:1000::/home/terry:/bin/bash
35a36
> bob:x:1000:1000:Bob Smith:/home/bob:/bin/bash
$
```



### Send Email from the Command Line

```
$ mail recipient@domain.com
$ echo 'message' | mail -s 'subject' recipient@domain.com
```

To send an email use the mail command. You can enter in a message interactively or via a pipe. End your interactive message with ctrl-d.

```
$ mail jim@mycorp.com
Subject: Message from the command line
Isn't this great?
EOT

$ echo "Here's the lazy way" | mail -s 'Message from the command line' jim@mycorp.com
```



### Send an Email Attachment from the Command Line

```
$ mail -a /path/to/attachment
$ echo 'message' | mail -s 'subject' -a /path/to/attachment recipient@domain.com
```

If you ever need to send an email attachment from the command line, use the -a option to the mail command.

```
$ echo "Here is the file you requested" | mail -s "The file" -a /tmp/files.tgz jim@mycorp.com
$
```



### Create an SSH Tunnel to Access Remote Resources

```
$ ssh -N -L local-port:host:remote-port remote-host
```

To create an SSH tunnel, use the -L option. The first port is the port that will be opened on your local machine. Connections to this port will be tunneled through remote-host and sent to the host and remote port specified in the -L option. The -N option tells SSH to not execute a command -- your shell -- on the remote host. Let's say you want to access a website that isn't available on the internet, but is accessible from a server that you have SSH access to. You can create a tunnel that allows you to browse that website like you were behind the company's firewall. This command will forward any connections from your local machine on port 8000 through the jump server to the intranet server on port 80. Point your web browser to http://localhost:8000 and start surfing.

```
$ ssh -N -L 8000:intranet.acme.com:80 jump-server &
[1] 23253
$ firefox http://localhost:8000
```

Another use case is to access a service that is running on a server that you have SSH access to. If you need access to a mysql server that only allows database connections from specific hosts, you can create an SSH tunnel for your connection. Since the mysql service is running on localhost:3306 of the remote machine, the -L option would look like this: -L 3306:localhost:3306. You can use the mysql command line client on your local machine to connect to the database, but what's even more interesting is to use graphical desktop applications that aren't available on the server. For example, you could use this tunnel and connect to the database with MySQL Workbench, Navicat, or some other application.

```
$ ssh -N -L 3306:localhost:3306 db01 &
[1] 13455

$ mysql -h 127.0.0.1
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 9 
Server version: 5.1.73 Source distribution
Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.
Oracle is a registered trademark of Oracle Corporation and/or its affiliates. Other names may be trademarks of their respective owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql>
 
```

### Find out Which Programs Are Listening on Which Ports

```
$ sudo netstat -nutlp
```

Here are the descriptions of the netstat options used in order to get a list of programs and the ports that they are listening on. 

- -n show numerical addresses instead of determining symbolic names 
- -u include the UDP protocol 
- -t include the TCP protocol 
- -l show only listening sockets 
- -p show the PID and program name

```
$ sudo netstat -nutlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address Foreign Address State PID/Program name
tcp 0 0 0.0.0.0:3306 0.0.0.0:* LISTEN 4546/mysqld
tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN 1161/sshd
tcp 0 0 127.0.0.1:25 0.0.0.0:* LISTEN 1325/master
tcp 0 0 :::80 :::* LISTEN 4576/httpd
tcp 0 0 :::22 :::* LISTEN 1161/sshd
udp 0 0 0.0.0.0:68 0.0.0.0:* 1008/dhclient
$
```



### Use a Different SSH Key for a given Remote Host

Put the following in the ~/.ssh/config file.

```
Host remote-host
IdentityFile ~/.ssh/id_rsa-remote-host
```

If you need or want to use different SSH keys for different hosts, you can explicitly specify them on the command line with the -i option to ssh.

```
$ ssh -i ~/.ssh/id_rsa-db1 db1.example.com
```

If you want to forego specifying the key each time you can create an entry in your ~/.ssh/config file and specify the key there.

```
$ cat ~/.ssh/config
Host db1.example.com
IdentityFile ~/.ssh/id_rsa-db1
$ ssh db1.example.com
```

You can use wildcards in the host specification

```
$ cat~/.ssh/config
Host db*
IdentityFile ~/.ssh/id_rsa-db1
Host *.work.net
IdentityFile ~/work-files/keys/id_rsa
$ ssh jim@jumpbox.work.net
```

If you name your SSH keys after the fully qualified domain names of the hosts they relate to, you can use the %h escape character to simplify your ~/.ssh/config file. Instead of having a host entry for each and every server, the %h syntax expands to the fully qualified domain name of the host your are connecting to.

```
$ cat ~/.ssh/config
Host *.example.com
IdentityFile ~/.ssh/id_rsa-%h

$ ls -1 ~/.ssh/id_rsa-*
id_rsa-lax-db-01.example.com
id_rsa-lax-db-01.example.com.pub
id_rsa-lax-web-01.example.com
id_rsa-lax-web-01.example.com.pub

$ ssh lax-db-01.example.com
```



### Avoid Having to Type Your Username When Connecting via SSH

Put the following in the ~/.ssh/config file.

```
Host remote-host
User username
```

If you have a different username on your local Linux machine than you do on the remote linux machine, you have to specify it when connecting via SSH. It looks like this.

```
$ ssh jim@server1.example.com
```

To avoid having to type "username@" each time, add a host entry to your ~/.ssh/config file.

```
Host server1.example.com
User jim
```

Once your have configured the host entry, you can simply ssh into the remote host.

```
$ whoami
james
$ ssh server1.example.com
$ whoami
jim
$
```



### Simplify Multi-Hop SSH Connections and Transparently Proxy SSH Connections
Put the following in the ~/.ssh/config file.

```
Host jumphost.example.com
ProxyCommand none
Host *.example.com
ProxyCommand ssh -W %h:%p jumphost.example.com
```

If you need to access a host that sits behind an SSH gateway server or jump server, you can make your life easier by telling SSH to automatically use the SSH gateway when you connect to the final remote host. Instead of first connecting to the gateway and then entering another ssh command to connect to the destination host, you simply type "ssh destination-host" from your local machine. Using the above configuration, this command will proxy your ssh connection to server1 through jumphost.

```
$ ssh server1.example.com
$ uname -n
server1
$
```



### Disconnect from a Remote Session and Reconnect at a Later Time, Picking up Where You Left Off

```
$ ssh remote-host
$ screen
ctrl-a, d
$ exit
$ ssh remote-host
$ screen -r
```

When I have a long running process that I need to complete on a remote host, I always start a screen session before launching that process.  I don't want a blip in my network connection to interrupt the work being performed on the remote host.  Sometimes I launch a process, detach from the session, and  reconnect later to examine all the output that occurred while I was away.

First, ssh into the remote host.  Next, start a screen session.  Start performing your work on the remote host.  Detach from the screen session by typing ctrl-a followed by d.  The process you started will still be running in the screen session while you're away.  Also, any output generated will be available for you to view at a later time.

```
$ ssh remote-host
$ screen
$ /usr/local/bin/migrate-db
Starting DB migration at Sun Apr 13 21:02:50 EDT 2014
<ctrl-a,d>
[detached]
$ exit
```

To reconnect to your screen session, connect to the remote host and type screen -r.  If there is any output that scrolled past the top of the screen, you can view by typing ctrl-a followed by the escape key.  Now use the vi navigation key bindings to view the output history.  For example, you can type k to move up one line or ctrl-b to page up.  Once you are finished looking at the output history, hit escape to return to the live session.  To quit your screen session, type exit.

```
$ ssh remote-host
$ screen -r
Starting DB migration at 21:02
table1 migrated at 21:34
table2 migrated at 22:11
table3 migrated at 22:54
DB migration completed at 23:04
$ exit
[screen is terminating]
$ exit
```

Screen is one of the most widely used and readily available screen multiplexers.  However, there are alternatives such as tmux, dtach, and byobu.

### Configure SSH to Append Domain Names to Host Names Based on a Pattern

The contents of ~/.ssh/config:

```
host-prefix* !*.domain.com
HostName %h.domain.com
```

If you connect to hosts in multiple domains via ssh it can get tiresome typing out the fully qualified domain name each time.  One way around this problem is to add each domain to the search list in /etc/resolv.conf.  The resolver will attempt the resolution for the specified host name in each of the domains in the search list until it finds one that resolves.

```
$ cat /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
search domain1.com domain2.com domain3.com domain4.com domain5.com domain6.com domain7.com
```

When typing "ssh remote-host" with the above resolv.conf in place, the resolver will attempt to translate remote-host.domain1.com into an IP address.  If that fails, it will attempt to resolve remote-host.domain2.com, etc.  The problem with the above reslov.conf is that the search list is limited to just six domains.  So, remote-host.domain7.com is never attempted.  Additionally, the search list is limited to 256 characters, regardless the number of domains.

How can you get around the six domain search list limit?  If you're lucky enough to have a pattern of hostnames that correlate with domain names, you can configure ssh to do the resolution.  For example, for FQDNs like "ny-www1.newyork.company.com" and "ny-mysql-07.newyork.company.com" you can create a rule that appends ".newyork.company.com" to any host that begins with "ny."  You'll also want to tell ssh to ignore any hosts that begin with "ny" that already have ".newyork.company.com" appended to them.  Here's an example ~/.ssh/config file that does that.

```
$ cat ~/.ssh/config
ny* !*.newyork.company.com
HostName %h.newyork.company.com
db* !*.databases.company.com
HostName %h.databases.company.com
jump* !*.company.com
HostName %h.company.com
```

Now when you type "ssh ny-test" ssh will attempt to connect to "ny-test.newyork.company.com."  For hosts that begin with "db," ssh will append ".databases.company.com" to the host name.  Hosts the begin with "jump" will have the ".company.com" domain name appended to them.

```
$ ssh ny-www1
$ hostname -f
ny-www1.newyork.company.com
$ exit
$ ssh jump-ny-01
$ hostname -f
jump-ny-01.company.com
$ exit
$
```



### Run a Command Immune to Hangups, Allowing the Job to Run after You Disconnect

```
$ nohup command &
```

Normally when you start a job in the background and log out of your session the job gets killed.  One way to ensure a command keeps running after you disconnect from the host is to use the nohup command.  No hup stands for no hang up.  By default the output of the command is stored in a file named "nohup.out" in the directory the program was launched in.  You can examine the contents of this file later to see the output of the command.  To use a different filename, employ redirection.

```
$ ssh db-server
$ nohup /usr/local/bin/upgradedb.sh &
[1] 13370
$ exit
$ ssh db-server
$ cat nohup.out
Starting database upgrade.
...
Database upgrade complete.
$ nohup /usr/local/bin/post-upgrade.sh > /tmp/post.log &
[1] 16711
$ exit
$ ssh db-server
$ cat /tmp/post.log
Post processing completed.
$
```



### Encrypt Your Web Browsing Data with an SSH SOCKS Proxy

```
$ ssh -D PORT remote-host
```

If you are using an open wireless hotpot and want to ensure your web browsing data is encrypted, you can redirect your web browsing traffic through another host via SSH.  Start ssh with the "-D" option and provide a port to open up on your local computer for proxy connections. If you only want to perform the port forwarding and not actually log into the shell of the remote host, use the "-N" option for ssh.  Configure your web browser to use a SOCKS 5 proxy using localhost for the host and the port you supplied to ssh.

```
$ ssh -ND 1080 ubuntu@ec2-75-101-157-145.compute-1.amazonaws.com
$ firefox http://www.mybank.com
```



### Download a Webpage, HTTP Data, or Use a Web API from the Command Line

```
$ curl -o file.html http://website/webpage
$ wget http://website/webpage
```

The curl and wget commands can be used to download a webpage or anything that is available on a web server.  You can use these commands to interact with HTTP APIs, download software packages, download a status page, or even get the current weather.

Here's an example of checking the status page of your local apache web server.

```
$ curl -o server-status.html http://localhost/server-status
  % Total        % Received % Xferd  Average Speed   Time        Time         Time Current Dload  Upload   Total   Spent        Left  Speed
100  6148  100  6148        0         0  1070k          0 --:--:-- --:--:-- --:--:-- 1200k

$ wget http://localhost/server-status
--2014-04-19 14:37:18--  http://localhost/server-status
Resolving localhost (localhost)... 127.0.0.1
Connecting to localhost (localhost)|127.0.0.1|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 6377 (6.2K) [text/html]
Saving to: `server-status'
100%[=====>] 6,377           --.-K/s   in 0s          
2014-04-19 14:37:18 (105 MB/s) - `server-status' saved [6377/6377]

$ grep uptime server-status*
server-status:<dt>Server uptime:  50 minutes 13 seconds</dt>
server-status.html:<dt>Server uptime:  50 minutes 5 seconds</dt>
```

Here's an example of getting the current weather.

```
$ curl -so lax-weather.html http://weather.noaa.gov/pub/data/observations/metar/decoded/KLAX.TXT
$ cat lax-weather.html
LOS ANGELES INTERNTL AIRPORT, CA, United States (KLAX) 33-56N 118-23W 46M
Apr 19, 2014 - 02:53 PM EDT / 2014.04.19 1853 UTC
Wind: from the W (260 degrees) at 10 MPH (9 KT):0
Visibility: 10 mile(s):0
Sky conditions: mostly cloudy
Temperature: 64.9 F (18.3 C)
Dew Point: 54.0 F (12.2 C)
Relative Humidity: 67%
Pressure (altimeter): 30.03 in. Hg (1016 hPa)
ob: KLAX 191853Z 26009KT 10SM FEW022 BKN220 18/12 A3003 RMK AO2 SLP167 T01830122
cycle: 19

$ wget -q http://weather.noaa.gov/pub/data/observations/metar/decoded/KLAX.TXT
$ cat KLAX.TXT
LOS ANGELES INTERNTL AIRPORT, CA, United States (KLAX) 33-56N 118-23W 46M
Apr 19, 2014 - 02:53 PM EDT / 2014.04.19 1853 UTC
Wind: from the W (260 degrees) at 10 MPH (9 KT):0
Visibility: 10 mile(s):0
Sky conditions: mostly cloudy
Temperature: 64.9 F (18.3 C)
Dew Point: 54.0 F (12.2 C)
Relative Humidity: 67%
Pressure (altimeter): 30.03 in. Hg (1016 hPa)
ob: KLAX 191853Z 26009KT 10SM FEW022 BKN220 18/12 A3003 RMK AO2 SLP167 T01830122
cycle: 19
$
```

Download and install a package.

```
$ wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.deb

$ sudo dpkg -i elasticsearch-1.1.1.deb
Selecting previously unselected package elasticsearch.
(Reading database ... 162097 files and directories currently installed.)
Unpacking elasticsearch (from elasticsearch-1.1.1.deb) ...
Setting up elasticsearch (1.1.1) ...
Adding system user `elasticsearch' (UID 116) ...
Adding new user `elasticsearch' (UID 116) with group `elasticsearch' ...
Not creating home directory `/usr/share/elasticsearch'.
### NOT starting elasticsearch by default on bootup, please execute sudo update-rc.d elasticsearch defaults 95 10
### In order to start elasticsearch, execute sudo /etc/init.d/elasticsearch start
Processing triggers for ureadahead ...

$ sudo /etc/init.d/elasticsearch start
 * Starting Elasticsearch Server [ OK ]
$
```

Interact with a web API.

```
$ curl http://localhost:9200
{
  "status" : 200,
  "name" : "NFL Superpro",
  "version" : {
        "number" : "1.1.1",
        "build_hash" : "f1585f096d3f3985e73456debdc1a0745f512bbc",
        "build_timestamp" : "2014-04-16T14:27:12Z",
        "build_snapshot" : false,
        "lucene_version" : "4.7"
  },
  "tagline" : "You Know, for Search"
  }
  
$ curl http://localhost:9200/_cluster/health?pretty
{
  "cluster_name" : "elasticsearch",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0
}
$
```



## Shell Scripting
### Use a for Loop at the Command Line

```
$ for VAR in LIST
> do
> # use $VAR
> done
```

When you need to perform the same action for a list of items, you can use a for loop right from your shell.

```
$ for USER in bob jill fred
> do
> sudo passwd -l $USER
> logger -t naughty-user $USER
> done
Locking password for user bob.
passwd: Success
Locking password for user jill.
passwd: Success
Locking password for user fred.
passwd: Success

$ sudo tail -3 /var/log/messages
Apr 8 19:29:03 linuxserver naughty-user: bob
Apr 8 19:29:03 linuxserver naughty-user: jill
Apr 8 19:29:03 linuxserver naughty-user: fred
```

You can also type entire loop on one command line

```
$ for USER in bob jill fred; do sudo passwd -l $USER; logger -t naughty-user $USER; done
...
```



### Command Substitution

```
$ VAR=`command`
$ VAR=$(command)
```

There are two forms of command substitution. The first form uses backticks (`) to surround a command while the second form uses a dollar sign followed by parenthesis that surround a command. They are functionally equivalent with the backtick form being the older style. The output of the command can be used as an argument to another command, to set a variable, or for generating the argument list for a for loop.

```
$ EXT_FILESYSTEMS=$(grep ext fstab | awk '{print $2}')
$ echo $EXT_FILESYSTEMS
/ /boot
$ cp file.txt file.txt.`date +%F`
$ ls file.txt*
file.txt file.txt.2014-04-08
$ ps -fp $(cat /var/run/ntpd.pid)
UID PID PPID C STIME TTY TIME CMD
ntp 1210 1 0 Apr06 ? 00:00:05 ntpd -u ntp:ntp -p /var/run/ntpd
$ sudo kill -9 $(cat /var/run/ntpd.pid)
$ for x in $(cut -d: -f1 /etc/passwd); do groups $x; done
jason : jason sales
bobdjr : sales
jim : jim
```



### Store Command Line Output as a Variable to Use Later

```
$ for VAR in LIST
> do
> VAR2=$(command)
> VAR3=$(command)
> echo "$VAR2 VAR3"
> done
```

Command substitution can be used to assign values to variables. If you need to reuse the output of a command multiple times, assign it to a variable once and reuse the variable. This example shows how the output of the id command is used multiple times in one script.

```
$ for USER in $(cut -f1 -d: /etc/passwd)
> do
> UID_MIN=$(grep ^UID_MIN /etc/login.defs | awk '{print $NF}')
> USERID=$(id -u $USER)
> [ $USERID -lt $UID_MIN ] || {
> echo "Forcing password expiration for $USER with UID of $USERID."
> sudo passwd -e $USER
> }
> done
Forcing password expiration for bob with UID of 1000.
Forcing password expiration for bobdjr with UID of 1001.
Forcing password expiration for bobh with UID of 1002.
```



### Read in Input One Line at a Time

```
$ while read LINE
> do
> # Do something with $LINE
> done < file.txt

$ command | while read LINE
> do
> # Do something with $LINE
> done
```

If you want to iterate over a list of words, use a for loop. If you want to iterate over a line, use a while loop in combination with a read statement and redirection. 

Let's look for file systems that are over 90% utilized. If we try to use an if statement it will break up the output into word chunks like this.

```
$ df | head -1
Filesystem 1K-blocks Used Available Use% Mounted on

$ for x in $(df)
> do
> echo $x
> done
Filesystem
1K-blocks
Used
Available
Use%
Mounted
on
...
```

We need to read in entire lines at a time like this.

```
$ df | while read LINE
> do
> echo $LINE
> done
Filesystem 1K-blocks Used Available Use% Mounted on
...
```

Here is one way to find file systems that are over 90% utilized.

```
$ df
Filesystem 1K-blocks Used Available Use% Mounted on
/dev/sda2 28891260 3270340 25327536 12% /
tmpfs 515320 72 515248 1% /dev/shm
/dev/sda1 495844 453683 16561 97% /boot

$ df | grep [0-9]% | while read LINE
> do
> use=$(echo $LINE | awk '{print $5}' | tr -d '%')
> mountpoint=$(echo $LINE | awk '{print $6}')
> [ $use -gt 90 ] && echo "$mountpoint is over 90% utilized."
> done
/boot is over 90% utilized.
$
```

Instead of assigning variables within the while loop, you can assign them with the read statement. Here is how this method looks.

```
$ df | grep [0-9]% | while read fs blocks used available use mountpoint
> do
> use=$(echo $use | tr -d '%')
> [ $use -gt 90 ] && echo "$mountpoint is over 90% utilized."
> done
/boot is over 90% utilized.
```



### Accept User Input and Store It in a Variable

```
$ read VAR
$ read -n 1 VAR
$ read -p "Prompt text" VAR
```

To accept user input from a user, use the read command. Read will accept an entire line of input and store it into a variable. You can force read to only read a limited number of characters by using the -n option. Instead of using echo statements before a read command, you can supply a prompt by using the -p option. Here is a sample script that uses these techniques. 

The contents of backup.sh:

```
#!/bin/bash
while true
do
  read -p "What server would you like to backup? " SERVER
  echo "Backing up $SERVER"
  /usr/local/bin/backup $SERVER
  read -p "Backup another server? (y/n) " -n 1 BACKUP_AGAIN
  echo
  [ "$BACKUP_AGAIN" = "y" ] || break
done

$ ./backup.sh
What server would you like to backup? thor
Backing up thor
Backup another server? (y/n) y
What server would you like to backup? loki
Backing up loki
Backup another server? (y/n) n
$
```





### Sum All the Numbers in a given Column of a Text

```
$ awk '{ sum += $1 } END { print sum }' file
$ cat file | awk '{ sum += $1 } END { print sum }
```

Awk can be used to tally up a column of values. You can use this trick to add up all the disk space used across all the file systems on a given system, for example.

```
$ df -mt ext4
Filesystem 1M-blocks Used Available Use% Mounted on
/dev/mapper/vg_root-lv_root 28215 3285 24644 12% /
/dev/sda1 485 55 406 12% /boot

$ df -mt ext4 | awk '{ sum += $3 } END {print sum}'
3340

$ sudo dmidecode --type memory
    Size: No Module Installed
    Size: 4096 MB
    Size: No Module Installed
    Size: 4096 MB

$ sudo dmidecode --type memory | grep 'Size:' | awk '{sum+=$2} END
{print sum}'
8192
$
```



### Automatically Answer Yes to Any Command

```
$ yes | command
$ yes "string" | command
```

If you are trying to automate a process that requires user input, check out the yes command. By default yes simply prints out "y" until it is killed. You can make yes repeat any string. If you wanted to automatically answer "no" you could run "yes no."

```
$ ./install-my-app.sh
Are you sure you want to install my-app? (y/n) y
Ok, my-app installed.

$ yes | ./install-my-app.sh
Ok, my-app installed.
$
```



## System Administration
### Display Mounted File Systems in a Tabular Format





### Kill All Processes for a given User or Program





### Repeat a Command until It Succeeds





### Find Who Is Using the Most Disk Space





### Find the Files That Are Using the Most Disk Space





### List Processes, Sorted by Memory Usage





### List Processes, Sorted by CPU Usage





### Quickly Tell If You Are on a 32 Bit or 64 Bit System





### Generate a Random Password





## Files and Directories
### Quickly Make a Backup of a File





### Quickly Change a File's Extension





### Create Backups of Files by Date with Ease





### Overwrite the Contents of a File







### Empty a File That Is Being Written To





### Append a String to a File







### Follow a File as It Grows





### Watch Multiple Log Files at the Same Time





### Delete Empty Directories





### Print a List of Files That Contain a given String





### An Easy-to-Read Recursive File Listing





### View Files and Directories in a Tree Format





### Replace a String in Multiple Files





### Extract the Nth Line from a File





### Convert Text Files from Windows Format to Linux Format and  Vice-Versa





## Miscellaneous
### Change to the Previous Working Directory





### Reset Your Terminal Emulator Display





### Search Wikipedia from the Command Line





### Make Non-Interactive Shell Sessions Behave the Same as Interactive Sessions





### Make Your Computer to Talk to You





### Display the Current Date and Time in a Different Time Zone





### Display a Calendar at the Command Line





### Extract a Tar Archive to a Different Directory





### Transform the Directory Structure of a Tar File When Extracting It





### Use a Spreadsheet from the Command Line





### Rudimentary Command Line Stopwatch





### Repeat a Command at Regular Intervals and Watch Its Changing Output





### Execute a Command at a given Time





### Share Your Screen Session with Another User





### Execute an Unaliased Version of an Aliased Command





### Save the Output of a Command as an Image





