B计划
========
| 目录                       | 主要命令             |
| -------------------------- | -------------------- |
| 使用tar归档                | tar                  |
| 使用cpio归档               | cpio                 |
| 使用gzip压缩数据           | gzip                 |
| 使用zip归档及压缩          | zip                  |
| 更快的归档工具pbzip2       | pbzip2               |
| 创建压缩文件系统           | mksquashfs           |
| 使用rsync备份系统快照      | rsync                |
| 差异化归档                 | find、tar、zip、cpio |
| 使用fsarchiver创建全盘镜像 | fsarchiver           |

#### 使用tar归档

tar命令可以归档文件。它最初是设计用来将数据存储在磁带上，因此其名字也来源于Tape
ARchive。tar可以将多个文件和文件夹打包为单个文件，同时还能保留所有的文件属性，如所
有者、权限等。由tar创建的文件通常称为tarball

tar命令可以创建、更新、检查以及解包归档文件

1. 用tar创建归档文件

```shell
$ tar -cf output.tar [SOURCES] 

# 选项-c表示创建新的归档文件。选项-f表示归档文件名，该选项后面必须跟一个文件名称
$ tar -cf archive.tar file1 file2 file3 folder1 .. 
```

2. 选项-t可以列出归档文件中所包含的文件

```shell
$ tar -tf archive.tar
file1
file2 
```

3. 选项-v或-vv参数可以在命令输出中加入更多的细节信息。这个特性叫作“冗长模式（v，
   verbose）”或“非常冗长模式（vv，very verbose）”。对于能够在终端中生成报告的命令，
   -v是一个约定的选项。该选项能够显示出更多的细节，例如文件权限、所有者所属的分
   组、文件修改日期等信息

```shell
$ tar -tvf archive.tar
-rw-rw-r-- shaan/shaan 0 2013-04-08 21:34 file1
-rw-rw-r-- shaan/shaan 0 2013-04-08 21:34 file2
```

文件名必须紧跟在-f之后出现，而且-f应该是选项中的最后一个。假如你
希望使用冗长模式，应该像这样写：

```shell
$ tar -cvf output.tar file1 file2 file3 folder1 .. 
```

tar命令可以接受一组文件名或是通配符（如*.txt），以此指定需要进行归档的源文件

命令行参数有数量限制，我们无法一次性传递数百个文件或目录。如果要归档的文件很多，
那么使用追加选项（详见下文）要更安全些

补充内容

1. 向归档文件中追加文件

```shell
# 选项-r可以将新文件追加到已有的归档文件末尾
$ tar -rvf original.tar new_file 
```

2. 从归档文件中提取文件或目录

```shell
# 选项-x可以将归档文件的内容提取到当前目录
$ tar -xf archive.tar

# 使用-x时，tar命令将归档文件中的内容提取到当前目录
# 我们也可以用选项-C来指定将文件提取到哪个目录
$ tar -xf archive.tar -C /path/to/extraction_directory 

# 我们可以通过将文件名作为命令行参数来提取特定的文件
$ tar -xvf file.tar file1 file4
# 上面的命令只提取file1和file4，忽略其他文件
```

3. 在tar中使用stdin和stdout

在归档时，我们可以将stdout指定为输出文件，这样另一个命令就可以通过管道来读取（作
为stdin）并进行其他处理

```shell
# 当通过安全shell（Secure Shell，SSH）传输数据时，这招很管用
$ tar cvf - files/ | ssh user@example.com "tar xv -C Documents/" 
# 在上面的例子中，对files目录中的内容进行了归档并将其输出到stdout（由-指明），然后提取到远程系统中的Documents目录中
```

4. 拼接两个归档文件

我们可以用选项-A合并多个tar文件

```shell
# 假设我们现在有两个tar文件：file1.tar和file2.tar
# 下面的命令可以将file2.tar的内容合并到file1.tar中
$ tar -Af file1.tar file2.tar 

# 查看内容，验证操作是否成功：
$ tar -tvf file1.tar
```

5. 通过检查时间戳来更新归档文件中的内容

追加选项（-r）可以将指定的任意文件加入到归档文件中。如果同名文件已经存在，那么归
档文件中就会包含两个名字一样的文件。我们可以用更新选项-u指明：只添加比归档文件中的同
名文件更新（newer）的文件

```shell
$ tar -tf archive.tar
filea
fileb
filec 

# 仅当filea自上次被加入archive.tar后出现了改动才对其执行追加操作
$ tar -uf archive.tar filea 
# 如果两个filea的时间戳相同，则什么都不会发生

# 使用touch命令修改文件的时间戳，然后再用tar命令
$ tar -uvvf archive.tar filea
-rw-r--r-- slynux/slynux 0 2010-08-14 17:53 filea 

# 因为时间戳比归档文件中的同名文件更新，因此执行追加操作。可以用选项-t来验证
$ tar -tf archive.tar
-rw-r--r-- slynux/slynux 0 2010-08-14 17:52 filea
-rw-r--r-- slynux/slynux 0 2010-08-14 17:52 fileb
-rw-r--r-- slynux/slynux 0 2010-08-14 17:52 filec
-rw-r--r-- slynux/slynux 0 2010-08-14 17:53 filea
# 如你所见，一个新的filea被加入到了归档文件中。当从中提取文件时，tar会挑选最新的filea
```

6. 比较归档文件与文件系统中的内容

```shell
# 选项-d可以将归档中的文件与文件系统中的文件作比较
# 这个功能能够用来确定是否需要创建新的归档文件
$ tar -df archive.tar
afile: Mod time differs
afile: Size differs 
```

7. 从归档中删除文件

```shell
# 我们可以用--delete选项从归档中删除文件
$ tar -f archive.tar --delete file1 file2 ..
# 或者
$ tar --delete --file archive.tar [FILE LIST] 

# 示例
$ tar -tf archive.tar
filea
fileb
filec

$ tar --delete --file archive.tar filea

$ tar -tf archive.tar
fileb
filec 
```

8. 压缩tar归档文件

tar命令默认只归档文件，并不对其进行压缩。不过tar支持用于压缩的相关选项。压缩能
够显著减少文件的体积。归档文件通常被压缩成下列格式之一

- gzip格式：file.tar.gz或file.tgz
- bzip2格式：file.tar.bz2
- Lempel-Ziv-Markov格式：file.tar.lzma

不同的tar选项可以用来指定不同的压缩格式：

- -j指定bunzip2格式
- -z指定gzip格式
- --lzma指定lzma格式

不明确指定上面那些特定的选项也可以使用压缩功能。tar能够基于输出或输入文件的扩
展名来进行压缩。为了让tar支持根据扩展名自动选择压缩算法，使用-a或--auto-compress
选项：

```shell
$ tar -acvf archive.tar.gz filea fileb filec
filea
fileb 
filec

$ tar -tf archive.tar.gz
filea
fileb
filec 
```

9. 在归档过程中排除部分文件

选项--exclude [PATTERN]可以将匹配通配符模式的文件排除在归档过程之外

```shell
$ tar -cf arch.tar * --exclude "*.txt" 
# 注意，模式应该使用双引号来引用，避免shell对其进行扩展

# 也可以将需要排除的文件列表放入文件中，同时配合选项-X
$ cat list
filea
fileb

$ tar -cf arch.tar * -X list
```

10. 排除版本控制目录

tar文件的用处之一是用来分发源代码。很多源代码都是使用版本控制系统进行维护的，如
subversion、Git、mercurial、CVS。版本控制系统中的代码目录通常包含一些特殊
目录，如.svn或.git。这些目录由版本控制系统负责管理，对于开发者之外的用户并没有什么用。
因此无需将其包含在分发给用户的tar文件内

```shell
# tar的选项--exclude-vcs可以在归档时排除版本控制相关的文件和目录
$ tar --exclude-vcs -czvvf source_code.tar.gz eye_of_gnome_svn
```

11. 打印总字节数

选项-totals可以打印出归档的总字节数。注意，这是实际数据的字节数。如果使用了压缩
选项，文件大小会小于总的归档字节数

```shell
$ tar -cf arc.tar * --exclude "*.txt" --totals
Total bytes written: 20480 (20KiB, 12MiB/s) 
```

#### 使用cpio归档

cpio类似于tar。它可以归档多个文件和目录，同时保留所有的文件属性，如权限、文件所
有权等。cpio格式被用于RPM软件包（Fedora使用这种格式）、Linux内核的initramfs文件（包含
了内核镜像）等

cpio通过stdin获取输入文件名并将归档文件写入stdout。我们必须将stdout重定向到文
件中来保存cpio的输出

示例：

```shell
# 创建测试文件
$ touch file1 file2 file3 

# 归档测试文件
$ ls file* | cpio -ov > archive.cpio 

# 列出cpio归档文件中的内容
$ cpio -it < archive.cpio 

# 从cpio归档文件中提取文件
$ cpio -id < archive.cpi
```

对于归档命令cpio：

- -o指定了输出
- -v用来打印归档文件列表

当进行提取时，cpio会将归档内容提取到绝对路径中。但是tar会移去绝对路径开头的/，将其转换为相对路径



对于列出给定cpio归档文件中所有内容的命令：

- -i用于指定输入
- -t用于列出归档文件中的内容

在提取命令中，-o表示提取，cpio会直接覆盖文件，不作任何提示；-d在需要的时候创建
新的目录

#### 使用gzip压缩数据 

gzip是GNU/Linux平台下常用的压缩格式。gzip、gunzip和zcat都可以处理这种格式。但
这些工具只能压缩/解压缩单个文件或数据流，无法直接归档目录和多个文件。好在gzip可以同
tar和cpio配合使用

gzip和gunzip可以分别用于压缩与解压缩

```shell
# 使用gzip压缩文件
$ gzip filename
$ ls
filename.gz 

# 解压缩gzip文件
$ gunzip filename.gz
$ ls
filename

# 列出压缩文件的属性信息
$ gzip -l test.txt.gz
compressed uncompressed ratio uncompressed_name
35 6 -33.3% test.txt

# gzip命令可以从stdin中读入文件并将压缩文件写出到stdout
# 从stdin读入并将压缩后的数据写出到
$ cat file | gzip -c > file.gz 

# 选项 -c用来将输出指定到stdout。该选项也可以与cpio配合使用
$ ls * | cpio -o | gzip -c > cpiooutput.gz
$ zcat cpiooutput.gz | cpio -it 

# 我们可以指定gzip的压缩级别。--fast或--best选项分别提供最低或最高的压缩率
```

补充内容

gzip命令通常与其他命令结合使用，另外还有一些高级选项可以用来指定压缩率

1. 压缩归档文件

后缀.gz表示的是经过gzip压缩过的tar归档文件

有两种方法可以创建此类文件：

```shell
# 1
$ tar -czvvf archive.tar.gz [FILES] 
# 或者
$ tar -cavvf archive.tar.gz [FILES] 
# 选项-z指明用gzip进行压缩，选项-a指明根据文件扩展名推断压缩格式
```

```shell
# 2
# 首先，创建一个tar归档文件
$ tar -cvvf archive.tar [FILES] 
# 压缩tar归档文件
$ gzip archive.tar
```

如果有大量文件（上百个）需要归档及压缩，我们可以采用第二种方法并稍作变动。将多个
文件作为命令行参数传递给tar的问题在于后者能够接受的参数有限。要解决这个问题，我们可
以在循环中使用追加选项（-r）来逐个添加文件：

```shell
FILE_LIST="file1 file2 file3 file4 file5"
for f in $FILE_LIST;
  do
    tar -rvf archive.tar $f
  done

gzip archive.tar 

# 下面的命令可以提取经由gzip压缩的归档文件中的内容
$ tar -xavvf archive.tar.gz -C extract_directory 
# 其中，选项-a用于自动检测压缩格式
```

2. zcat——直接读取gzip格式文件

zcat命令无需经过解压缩操作就可以将.gz文件的内容输出到stdout。.gz文件不会发生任
何变化

```shell
$ ls
test.gz
$ zcat test.gz
A test file
# 文件test中包含了一行文本"A test file"
$ ls
test.gz 
```

3. 压缩率

我们可以指定压缩率，它共有9级，其中：

- 1级的压缩率最低，但是压缩速度最快
- 9级的压缩率最高，但是压缩速度最慢

```shell
# 你可以按照下面的方法指定压缩比：
$ gzip -5 test.img
# gzip默认使用第6级，倾向于在牺牲一些压缩速度的情况下获得比较好的压缩率
```

4. 使用bzip2 

bzip2在功能和语法上与gzip类似。不同之处在于bzip2的压缩效率比gzip更高，但花费的
时间比gzip更长

```shell
# 用bzip2进行压缩
$ bzip2 filename 

# 解压缩bzip2格式的文件
$ bunzip2 filename.bz2 

# 生成tar.bz2文件并从中提取内容的方法同之前介绍的tar.gz类似
$ tar -xjvf archive.tar.bz2 
# 其中，-j表明该归档文件是以bzip2格式压缩的
```

5. 使用lzma 

lzma的压缩率要优于gzip和bzip2

```shell
# 使用lzma进行压缩
$ lzma filename

# 解压缩lzma文件
$ unlzma filename.lzma

# 可以使用--lzma选项压缩生成的tar归档文件
$ tar -cvvf --lzma archive.tar.lzma [FILES] 
# 或者
$ tar -cavvf archive.tar.lzma [FILES] 

# 将lzma压缩的tar归档文件中的内容提取到指定的目录中
$ tar -xvvf --lzma archive.tar.lzma -C extract_directory 
# 或者
$ tar -xavvf archive.tar.lzma -C extract_directory 
```

#### 使用zip归档及压缩

ZIP作为一种流行的压缩格式，在Linux、Mac和Windows平台中都可以看到它的身影。在Linux
下，它的应用不如gzip或bzip2那么广泛，但是向其他平台分发数据的时候，这种格式很有用

1. 创建zip格式的压缩归档文件（zip archive）

```shell
$ zip archive_name.zip file1 file2 file3... 

$ zip file.zip file 
```

2. 选项-f可以对目录进行递归式归档

```shell
$ zip -r archive.zip folder1 folder2 
```

3. unzip命令可以从ZIP文件中提取内容

```shell
$ unzip file.zip
# 在完成提取操作之后，unzip并不会删除file.zip（这一点与unlzma和gunzip不同）
```

4. 选项-u可以更新压缩归档文件中的内容

```shell
$ zip file.zip -u newfile 
```

5. 选项-d从压缩归档文件中删除一个或多个文件

```shell
$ zip -d arc.zip file.txt 
```

6. 选项-l可以列出压缩归档文件中的内容

```shell
$ unzip -l archive.zip
```

尽管同大多数我们已经讲过的归档、压缩工具类似，但zip在完成归档之后并不会删除源文
件，这一点与lzma、gzip、bzip2不同。尽管与tar相像，但zip可以进行归档和压缩操作，而
单凭tar是无法进行压缩的

#### 更快的归档工具pbzip2

我们目前已经看到的多数压缩命令只能利用单个处理器核心。pbzip2、plzip、pigz和
lrzip命令都采用了多线程，能够借助多核来降低压缩文件所需的时间

大多数发行版中都没有安装这些工具，可以使用apt-get或yum自行安装

1. 压缩单个文件

```shell
pbzip2 myfile.tar 
# pbzip2会自动检测系统中处理器核心的数量，然后将myfile.tar压缩成myfile.tar.bz2
```

2. 要压缩并归档多个文件或目录，可以使用tar配合pbzip2来实现

```shell
tar cf sav.tar.bz2 --use-compress-prog=pbzip2 dir
# 或者
tar -c directory_to_compress/ | pbzip2 -c > myfile.tar.bz2 
```

3. 从pbzip2格式的文件中进行提取

```shell
# 选项-d可以解压缩
pbzip2 -d myfile.tar.bz2 

# 如果是tar.bz2文件，我们可以利用管道完成解压缩和提取
pbzip2 -dc myfile.tar.bz2 | tar x 
```

工作原理

pbzip2在内部使用的压缩算法和bzip2一样，但是它会利用pthreads（一个线程库）来同
时压缩多个数据块。线程化对于用户而言都是透明的，结果就是获得更快的压缩速度

同gzip或bzip2一样，pbzip2并不会创建归档文件，它只能对单个文件进行操作。要想压
缩多个文件或目录，还得结合tar或cpio来使用

补充内容

1. 手动指定处理器数量

```shell
# 如果无法自动检测处理器核心数量或是希望能够释放一些处理核心供其他任务使用，-p选项就能派上用场了
pbzip2 -p4 myfile.tar 
# 上面的命令告诉pbzip2使用4个处理器核心
```

2. 指定压缩比

从选项-1到-9可以指定最快到最好的压缩效果，其中-1的压缩速度最快，-9的压缩率最高

#### 创建压缩文件系统

squashfs程序能够创建出一种具有超高压缩率的只读型文件系统。它能够将2GB~3GB的数
据压缩成一个700MB的文件。Linux LiveCD（或是LiveUSB）就是使用squashfs创建的。这类
CD利用只读型的压缩文件系统将根文件系统保存在一个压缩文件中。可以使用环回方式将其挂
载并装入完整的Linux环境。如果需要某些文件，可以将它们解压，然后载入内存中使用



果需要压缩归档文件并能够随机访问其中的内容，那么squashfs就能够大显身手了。解
压体积较大的压缩归档文件可得花上一阵工夫。但如果将其以环回形式挂载，那速度会变得飞快。
因为只有出现访问请求时，对应的那部分压缩文件才会被解压缩



所有的现代Linux发行版都支持挂载squashfs文件系统。但是创建squashfs文件的话，则
需要使用包管理器安装squashfs-tools：

```shell
$ sudo apt-get install squashfs-tools 
# 或者
$ yum install squashfs-tools 
```

1. 使用mksquashfs命令添加源目录和文件，创建一个squashfs文件

```shell
$ mksquashfs SOURCES compressedfs.squashfs 
# SOURCES可以是通配符、文件或目录路径

# 示例 
$ sudo mksquashfs /etc test.squashfs
Parallel mksquashfs: Using 2 processors
Creating 4.0 filesystem on test.squashfs, block size 131072.
[=======================================] 1867/1867 100% 
```

2. 利用环回形式挂载squashfs文件

```shell
mkdir /mnt/squash
mount -o loop compressedfs.squashfs /mnt/squash

# 你可以通过/mnt/squashfs访问文件内容
```

补充内容

```shell
# 在创建squashfs文件时排除部分文件
# 选项-e可以排除部分文件和目录
$ sudo mksquashfs /etc test.squashfs -e /etc/passwd /etc/shadow 

# 也可以将需要排除的文件名列表写入文件，然后用选项-ef指定该文件
$ cat excludelist
/etc/passwd
/etc/shadow

$ sudo mksquashfs /etc test.squashfs -ef excludelist

# 如果希望在排除文件列表中使用通配符，需要使用-wildcard选项
```

#### 使用rsync备份系统快照

数据备份需要定期完成。除了备份本地文件，可能还涉及远程数据。rsync可以在最小化数
据传输量同时，同步不同位置上的文件和目录。相较于cp命令，rsync的优势在于比较文件修改
日期，仅复制较新的文件。另外，它还支持远程数据传输以及压缩和加密

1. 将源目录复制到目的路径

```shell
$ rsync -av source_path destination_path 

$ rsync -av /home/slynux/data slynux@192.168.0.6:/home/backups/data 
# 源路径和目的路径既可以是远程路径，也可以是本地路径，两个都是远程路径也行
```

其中：

- -a表示进行归档操作
- -v（verbose）表示在stdout上打印出细节信息或进度

2. 将数据备份到远程服务器或主机

```shell
$ rsync -av source_dir username@host:PATH 
# 要想保持两端的数据同步，需要定期运行同样的rsync命令。它只会复制更改过的文件
```

3. 下面的命令可以将远程主机上的数据恢复到本地

```shell
$ rsync -av username@host:PATH destination 
# 确保远程主机上已安装并运行着OpenSSH服务器，可以配置免密登录
```

4. 通过网络进行传输时，压缩数据能够明显改善传输效率。我们可以用rsync的选项-z指
   定在传输时压缩数据

```shell
$ rsync -avz source destination 
```

5. 将一个目录中的内容同步到另一个目录

```shell
$ rsync -av /home/test/ /home/backups 
```

6. 将包括目录本身在内的内容复制到另一个目录中

```shell
$ rsync -av /home/test /home/backups 
```

就路径格式而言，如果我们在源路径末尾使用/，那么rsync会 将sourch_path中结尾目录内所有内容复制到目的地

如果没有在源路径末尾使用/，rsync会将sourch_path中的结尾目录本身也复制过去

选项-r强制rsync以递归方式复制目录中所有的内容



补充内容

1. 在使用rsync进行归档时排除部分文件

```shell
# 选项--exclude和--exclude-from可以指定不需要传输的文件
--exclude PATTERN 

# 可以使用通配符指定需要排除的文件
$ rsync -avz /home/code/app /mnt/disk/backup/code --exclude "*.o"

# 或者我们也可以通过一个列表文件指定需要排除的文件
# 这需要使用--exclude-from FILEPATH
```

2. 在更新rsync备份时，删除不存在的文件

```shell
# 默认情况下，rsync并不会在目的端删除那些在源端已不存在的文件。如果要删除这类文件，可以使用rsync的--delete选项
$ rsync -avz SOURCE DESTINATION --delete 
```

3. 定期备份

你可以创建一个cron任务来定期进行备份

```shell
# 下面是一个简单的例子：
$ crontab -ev

# 添加上这么一行：
0 */10 * * * rsync -avz /home/code user@IP_ADDRESS:/home/backups 
# 上面的crontab项将rsync调度为每10小时运行一次

# */10处于crontab语法中的钟点位（hour position），/10表明每10小时执行一次备份
# 如果*/10出现在分钟位（minutes position），那就是每10分钟执行一次备份
```

#### 差异化归档

到目前为止，我们所描述的备份方法都是完整地复制当时的文件系统。如果在出现问题的时
候你立刻就能发现，然后使用最近的快照来恢复，那么这种方法是有用的。但如果你没有及时发
现问题，直到又制作了新的快照，先前正确的数据已被目前存在错误的数据覆盖，这种方法就派
不上用场了

rsync、tar和cpio可以用来制作文件系统的每日快照。但这样做成本太高。每天创建一份
独立的快照，一周下来所需要的存储空间是所备份文件系统的7倍

差异化备份只需要保存自上次完整备份之后发生变化的文件。Unix中的倾印/恢复（dump/restore）
工具支持这种形式的归档备份。但可惜的是，这些工具是设计用于磁带设备的，所以用起来不太
容易

find命令配合tar或cpio可以实现相同的功能

```shell
# 使用tar创建第一份完整备份
tar -cvz /backup/full.tgz /home/user 

# 使用find命令的-newer选项确定自上次完整备份之后，都有哪些文件作出了改动，然后创建一份新的归档
tar -czf day-`date +%j`.tgz `find /home/user –newer /backup/full.tgz`
```

因为从第一份完整备份往后，越来越多的文件会发生改动，所以每天的差异化归档也会越来越大。当归档大小超出预期的时候，需要再制作一份新的完整备份

#### 使用fsarchiver创建全盘镜像

fsarchiver可以将整个磁盘分区中的内容保存成一个压缩归档文件。和tar或cpio不同，
fsarchiver能够保留文件的扩展属性，可用于将当前文件系统恢复到磁盘中。它能够识别并保
留Windows和Linux系统的文件属性，因此适合于迁移Samba挂载的分区



fsarchiver默认并没有安装在大多数发布版中。你得用软件包管理器自行安装

更多的信息可以参考http://www.fsarchiver.org/Installation



1. 创建文件系统/分区备份

```shell
# 使用fsarchiver的savefs选项
fsarchiver savefs backup.fsa /dev/sda1 
# backup.fsa是最终的备份文件，/dev/sda1是要备份的分区
```

2. 同时备份多个分区

```shell
fsarchiver savefs backup.fsa /dev/sda1 /dev/sda2 
```

3. 从备份归档中恢复分区

```shell
# 使用fsarchiver的restfs选项
fsarchiver restfs backup.fsa id=0,dest=/dev/sda1
# id=0表明我们希望从备份归档中提取第一个分区的内容，将其恢复到由dest=/dev/sda1所指定的分区

# 从备份归档中恢复多个分区
fsarchiver restfs backup.fsa id=0,dest=/dev/sda1 id=1,dest=/dev/sdb1 
```

和tar一样，fsarchiver遍历整个文件系统来生成一个文件列表，然后将所有的文件保存
在压缩过的归档文件中。但不像tar那样只保存文件信息，fsarchiver还会备份文件系统。这
意味着它可以很容易地将备份恢复到一个全新的分区，无须再重新创建文件系统

