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



#### 使用gzip压缩数据 



#### 使用zip归档及压缩



#### 更快的归档工具pbzip2



#### 创建压缩文件系统



#### 使用rsync备份系统快照





#### 差异化归档



#### 使用fsarchiver创建全盘镜像

