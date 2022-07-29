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





### Display Your Command Search Path in a Human Readable Format





### Create a Text File from the Command Line without Using an Editor





### Display a Block of Text between Two Strings





### Delete a Block of Text between Two Strings





### Fix Common Typos with Aliases





### Sort the Body of Output While Leaving the Header on the First Line Intact





### Remove a Character or set of Characters from a String or Line of Output





### Count the Number of Occurrences of a String





## Networking and SSH
### Serve Files in the Current Directory via a Web Interface





### Mount a Directory from a Remote Server on Your Local Host via SSH





### Get Your Public IP from the Command Line Using Curl





### SSH into a Remote System without a Password





### Show Open Network Connections





### Compare the Differences between a Remote and Local File
### Send Email from the Command Line





### Send an Email Attachment from the Command Line





### Create an SSH Tunnel to Access Remote Resources





### Find out Which Programs Are Listening on Which Ports





### Use a Different SSH Key for a given Remote Host





### Avoid Having to Type Your Username When Connecting via SSH





### Simplify Multi-Hop SSH Connections and Transparently Proxy SSH
### Connections





### Disconnect from a Remote Session and Reconnect at a Later Time, Picking up Where You Left Off





### Configure SSH to Append Domain Names to Host Names Based on a Pattern





### Run a Command Immune to Hangups, Allowing the Job to Run after You Disconnect





### Encrypt Your Web Browsing Data with an SSH SOCKS Proxy





### Download a Webpage, HTTP Data, or Use a Web API from the Command Line





### Use Vim to Edit Files over the Network





## Shell Scripting
### Use a for Loop at the Command Line





### Command Substitution





### Store Command Line Output as a Variable to Use Later





### Read in Input One Line at a Time





### Accept User Input and Store It in a Variable





### Sum All the Numbers in a given Column of a Text





### Automatically Answer Yes to Any Command





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





