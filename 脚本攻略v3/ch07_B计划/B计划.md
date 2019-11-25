B计划
========
| 目录                       | 主要命令 |
| -------------------------- | -------- |
| 使用tar归档                |          |
| 使用cpio归档               |          |
| 使用gzip压缩数据           |          |
| 使用zip归档及压缩          |          |
| 更快的归档工具pbzip2       |          |
| 创建压缩文件系统           |          |
| 使用rsync备份系统快照      |          |
| 差异化归档                 |          |
| 使用fsarchiver创建全盘镜像 |          |

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







#### 创建压缩文件系统







#### 使用rsync备份系统快照





#### 差异化归档





#### 使用fsarchiver创建全盘镜像



