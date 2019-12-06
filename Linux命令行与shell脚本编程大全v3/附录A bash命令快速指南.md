bash命令快速指南
========

本章内容

- bash内建命令
- GNU的其他shell命令
- bash环境变量



#### A.1 内建命令

bash shell含有许多常用的命令，这些命令都已经内建在了shell中。在使用这些命令时，执行
速度就要快很多。表A-1列出了bash shell中直接可用的内建命令

**表A-1 bash内建命令**

| 命 令     | 描 述                                             |
| --------- | ------------------------------------------------- |
| :         | 扩展参数列表，执行重定向操作                      |
| .         | 读取并执行指定文件中的命令（在当前shell环境中）   |
| alias     | 为指定命令定义一个别名                            |
| bg        | 将作业以后台模式运行                              |
| bind      | 将键盘序列绑定到一个readline函数或宏              |
| break     | 退出for、while、select或until循环                 |
| builtin   | 执行指定的shell内建命令                           |
| caller    | 返回活动子函数调用的上下文                        |
| cd        | 将当前目录切换为指定的目录                        |
| command   | 执行指定的命令，无需进行通常的shell查找           |
| compgen   | 为指定单词生成可能的补全匹配                      |
| complete  | 显示指定的单词是如何补全的                        |
| compopt   | 修改指定单词的补全选项                            |
| continue  | 继续执行for、while、select或until循环的下一次迭代 |
| declare   | 声明一个变量或变量类型                            |
| dirs      | 显示当前存储目录的列表                            |
| disown    | 从进程作业表中删除指定的作业                      |
| echo      | 将指定字符串输出到STDOUT                          |
| enable    | 启用或禁用指定的内建shell命令                     |
| eval      | 将指定的参数拼接成一个命令，然后执行该命令        |
| exec      | 用指定命令替换shell进程                           |
| exit      | 强制shell以指定的退出状态码退出                   |
| export    | 设置子shell进程可用的变量                         |
| fc        | 从历史记录中选择命令列表                          |
| fg        | 将作业以前台模式运行                              |
| getopts   | 分析指定的位置参数                                |
| hash      | 查找并记住指定命令的全路径名，并输出hit次数       |
| help      | 显示帮助文件                                      |
| history   | 显示命令历史记录                                  |
| jobs      | 列出活动作业                                      |
| kill      | 向指定的进程ID（PID）发送一个系统信               |
| let       | 计算一个数学表达式中的每个参数                    |
| local     | 在函数中创建一个作用域受限的变量                  |
| logout    | 退出登录shell                                     |
| mapfile   | 从STDIN读取数据行，并将其加入索引数组             |
| popd      | 从目录栈中删除记录                                |
| printf    | 使用格式化字符串显示文本                          |
| pushd     | 向目录栈添加一个目录                              |
| pwd       | 显示当前工作目录的路径名                          |
| read      | 从STDIN读取一行数据并将其赋给一个变量             |
| readarray | 从STDIN读取数据行并将其放入索引数组               |
| readonly  | 从STDIN读取一行数据并将其赋给一个不可修改的变量   |
| return    | 强制函数以某个值退出，这个值可以被调用脚本提取    |
| set       | 设置并显示环境变量的值和shell属性                 |
| shift     | 将位置参数依次向下降一个位置                      |
| shopt     | 打开/关闭控制shell可选行为的变量值                |
| source    | 读取并执行指定文件中的命令（在当前shell环境中）   |
| suspend   | 暂停shell的执行，直到收到一个SIGCONT信号          |
| test      | 基于指定条件返回退出状态码0或1                    |
| times     | 显示累计的用户和系统时间                          |
| trap      | 如果收到了指定的系统信号，执行指定的命令          |
| type      | 显示指定的单词如果作为命令将会如何被解释          |
| typeset   | 声明一个变量或变量类型                            |
| ulimit    | 为系统用户设置指定的资源的上限                    |
| umask     | 为新建的文件和目录设置默认权限                    |
| unalias   | 删除指定的别名                                    |
| unset     | 删除指定的环境变量或shell属性                     |
| wait      | 等待指定的进程完成，并返回退出状态码              |

相比外部命令，内建命令提供了更高的性能，但shell中包含的内建命令越多，消耗的内存就
会越大，而有些命令几乎永远也不会用到。除此之外，bash shell还包含了一些能够为shell提供扩
展功能的外部命令。这些都会在A.2节中讨论

#### A.2 常见的 bash 命令

除了内建命令外，bash shell还使用外部命令来让你操控文件系统以及处理文件和目录。表
A-2列出了在使用bash shell时会用到的常见外部命令

**表A-2 bash shell外部命令**

| 命 令      | 描 述                                                        |
| ---------- | ----------------------------------------------------- |
| bzip2      | 采用Burrows-Wheeler块排序文本压缩算法和霍夫曼编码进行压缩    |
| cat        | 列出指定文件的内容                                           |
| chage      | 修改指定系统用户账户的密码过期日期                           |
| chfn       | 修改指定用户账户的备注信息                                   |
| chgrp      | 修改指定文件或目录的默认属组                                 |
| chmod      | 为指定文件或目录修改系统安全权限                             |
| chown      | 修改指定文件或目录的默认属主                                 |
| chpasswd   | 读取一个包含登录名/密码的文件并更新密码                      |
| chsh       | 修改指定用户账户的默认shell                                  |
| clear      | 从终端仿真器或虚拟控制台终端删除文本                         |
| compress   | 最初的Unix文件压缩工具                                       |
| coproc     | 在后台模式中生成子shell，并执行指定的命令                    |
| cp         | 将指定文件复制到另一个位置                                   |
| crontab    | 初始化用户的crontable文件对应的编辑器（如果允许的话）        |
| cut        | 删除文件行中指定的位置                                       |
| date       | 以各种格式显示日期                                           |
| df         | 显示所有挂载设备的当前磁盘空间使用情况                       |
| du         | 显示指定文件路径的磁盘使用情况                               |
| emacs      | 调用emacs文本编辑器                                          |
| file       | 查看指定文件的文件类型                                       |
| find       | 对文件进行递归查找                                           |
| free       | 查看系统上可用的和已用的内存                                 |
| gawk       | 使用编程语言命令的流编辑器                                   |
| grep       | 在文件中查找指定的文本字符串                                 |
| gedit      | 调用GNOME桌面编辑器                                          |
| getopt     | 解析命令选项（包括长格式选项）                               |
| groups     | 显示指定用户的组成员关系                                     |
| groupadd   | 创建新的系统组                                               |
| groupmod   | 修改已有的系统组                                             |
| gzip       | 采用Lempel-Ziv编码的GNU项目压缩工具                          |
| head       | 显示指定文件内容的开头部分                                   |
| help       | 显示bash内建命令的帮助页面                                   |
| killall    | 根据进程名向运行中的进程发送一个系统信号                     |
| kwrite     | 调用KWrite文本编辑器                                         |
| less       | 查看文件内容的高级方法                                       |
| link       | 用别名创建一个指向文件的链接                                 |
| ln         | 创建针对指定文件的符号链接或硬链接                           |
| ls         | 列出目录内容                                                 |
| makewhatis | 创建能够使用手册页关键字进行搜索的whatis数据库               |
| man        | 显示指定命令或话题的手册页                                   |
| mkdir      | 在当前目录下创建指定目录                                     |
| more       | 列出指定文件的内容，在每屏数据后暂停下来                     |
| mount      | 显示虚拟文件系统上挂载的磁盘设备或将磁盘设备挂载到虚拟文件系统上 |
| mv         | 重命名文件                                                   |
| nano       | 调用nano文本编辑器                                           |
| nice       | 在系统上使用不同优先级来运行命令                             |
| passwd     | 修改某个系统用户账户的密码                                   |
| ps         | 显示系统上运行中进程的信息                                   |
| pwd        | 显示当前目录                                                 |
| renice     | 修改系统上运行中应用的优先级                                 |
| rm         | 删除指定文件                                                 |
| rmdir      | 删除指定目录                                                 |
| sed        | 使用编辑器命令的文本流行编辑器                               |
| sleep      | 在指定的一段时间内暂停bash                                   |
| sort       | 基于指定的顺序组织数据文件中的数据                           |
| stat       | 显示指定文件的文件统计数据                                   |
| sudo       | 以root用户账户身份运行应用                                   |
| tail       | 显示指定文件内容的末尾部分                                   |
| tar        | 将数据和目录归档到单个文件中                                 |
| top        | 显示活动进程以及其他重要的系统统计数据                       |
| touch      | 新建一个空文件，或更新一个已有文件的时间戳                   |
| umount     | 从虚拟文件系统上删除一个已挂载的磁盘设备                     |
| uptime     | 显示系统已经运行了多久                                       |
| useradd    | 新建一个系统用户账户                                         |
| userdel    | 删除已有系统用户账户                                         |
| usermod    | 修改已有系统用户账户                                         |
| vi         | 调用vim文本编辑器                                            |
| vmstat     | 生成一个详尽的系统内存和CPU使用情况报告                      |
| whereis    | 显示指定命令的相关文件，包括二进制文件、源代码文件以及手册页 |
| which      | 查找可执行文件的位置                                         |
| who        | 显示当前系统中的登录用户                                     |
| whoami     | 显示当前用户的用户名                                         |
| xargs      | 从STDIN中获取数据项，构建并执行命令                          |
| zip        | Windows下PKZIP程序的Unix版本                                 |

可以用这些命令在命令行上完成几乎所有的事情

#### A.3 环境变量

bash shell还使用了许多环境变量。虽然环境变量不是命令，但它们通常会影响shell命令的执
行，所以了解这些shell环境变量很重要。表A-3列出了bash shell中可用的默认环境变量

*表A-3 bash shell环境变量*

| 变 量                 | 描 述                                                 |
| --------------------- | ------------------------------------------ |
| *                     | 含有所有命令行参数（以单个文本值的形式）              |
| @                     | 含有所有命令行参数（以多个文本值的形式）              |
| #                     | 命令行参数数目                                        |
| ?                     | 最近使用的前台进程的退出状态码                        |
| -                     | 当前命令行选项标记                                    |
| $                     | 当前shell的进程ID（PID）                              |
| !                     | 最近执行的后台进程的PID                               |
| 0                     | 命令行中使用的命令名称                                |
| _                     | shell的绝对路径名？（应该是上一个命令的最后一个参数） |
| BASH                  | 用来调用shell的完整文件名 |
| BASHOPTS              | 允许冒号分隔列表形式的shell选项 |
| BASHPID               | 当前bash shell的进程ID |
| BASH_ALIASED          | 含有当前所用别名的数组 |
| BASH_ARGC             | 当前子函数中的参数数量 |
| BASH_ARGV             | 含有所有指定命令行参数的数组 |
| BASH_CMDS             | 含有命令的内部散列表的数组 |
| BASH_COMMAND          | 当前正在被执行的命令名 |
| BASH_ENV              | 如果设置了的话，每个bash脚本都会尝试在运行前执行由该变量定义的起始文件 |
| BASH_EXECUTION_STRING | 在-c命令行选项中用到的命令 |
| BASH_LINENO           | 含有脚本中每个命令的行号的数组 |
| BASH_REMATCH          | 含有与指定的正则表达式匹配的文本元素的数组 |
| BASH_SOURCE           | 含有shell中已声明函数所在源文件名的数组 |
| BASH_SUBSHELL         | 当前shell生成的子shell数目 |
| BASH_VERSINFO         | 含有当前bash shell实例的主版本号和次版本号的数组 |
| BASH_VERSION          | 当前bash shell实例的版本号 |
| BASH_XTRACEFD         | 当设置一个有效的文件描述符整数时，跟踪输出生成，并与诊断和错误信息分离开。文件描述符必须设置-x启动 |
| COLUMNS               | 含有当前bash shell实例使用的终端的宽度 |
| COMP_CWORD | 含有变量COMP_WORDS的索引值，COMP_WORDS包含当前光标所在的位置 |
| COMP_KEY | 调用补全功能的按键 |
| COMP_LINE | 当前命令行 |
| COMP_POINT | 当前光标位置相对于当前命令起始位置的索引 |
| COMP_TYPE | 补全类型所对应的整数值 |
| COMP_WORDBREAKS | 在进行单词补全时用作单词分隔符的一组字符 |
| COMP_WORDS | 含有当前命令行上所有单词的数组 |
| COMPREPLY |含有由shell函数生成的可能补全码的数组|
| COPROC | 含有用于匿名协程I/O的文件描述符的数组 |
| DIRSTACK | 含有目录栈当前内容的数组 |
| EMACS | 如果设置了该环境变量，则shell认为其使用的是emacs shell缓冲区，同时禁止行编辑功能 |
| ENV | 当shell以POSIX模式调用时，每个bash脚本在运行之前都会执行由该环境变量所定义的起始文件 |
| EUID | 当前用户的有效用户ID（数字形式） |
| FCEDIT | fc命令使用的默认编辑器 |
| FIGNORE | 以冒号分隔的后缀名列表，在文件名补全时会被忽略 |
| FUNCNAME |当前执行的shell函数的名称|
| FUNCNEST | 嵌套函数的最高层级 |
| GLOBIGNORE | 以冒号分隔的模式列表，定义了文件名展开时要忽略的文件名集合 |
| GROUPS | 含有当前用户属组的数组 |
| histchars | 控制历史记录展开的字符（最多可有3个） |
| HISTCMD | 当前命令在历史记录中的编号 |
| HISTCONTROL | 控制哪些命令留在历史记录列表中 |
| HISTFILE | 保存shell历史记录列表的文件名（默认是.bash_history） |
| HISTFILESIZE |保存在历史文件中的最大行数|
| HISTIGNORE | 以冒号分隔的模式列表，用来决定哪些命令不存进历史文件 |
| HISTSIZE | 最多在历史文件中保存多少条命令 |
| HISTIMEFORMAT | 设置后，决定历史文件条目的时间戳的格式字符串 |
| HOSTFILE | 含有shell在补全主机名时读取的文件的名称 |
| HOSTNAME | 当前主机的名称 |
| HOSTTYPE | 当前运行bash shell的机器 |
| IGNOREEOF | shell在退出前必须收到连续的EOF字符的数量。如果这个值不存在，默认是1 |
| INPUTRC |readline初始化文件名（默认是.inputrc）|
| LANG | shell的语言环境分类 |
| LC_ALL | 定义一个语言环境分类，它会覆盖LANG变量 |
| LC_COLLATE |设置对字符串值排序时用的对照表顺序|
| LC_CTYPE | 决定在进行文件名扩展和模式匹配时，如何解释其中的字符 |
| LC_MESSAGES | 决定解释前置美元符（$）的双引号字符串的语言环境设置 |
| LC_NUMERIC | 决定格式化数字时的所使用的语言环境设置 |
| LINENO | 脚本中当前执行代码的行号 |
| LINES | 定义了终端上可见的行数 |
| MACHTYPE | 用“cpu-公司-系统”格式定义的系统类型 |
| MAILCHECK | shell多久查看一次新邮件（以秒为单位，默认值是60） |
| MAPFILE |含有mapfile命令所读入文本的数组，当没有给出变量名的时候，使用该环境变量|
| OLDPWD | shell之前的工作目录 |
| OPTERR | 设置为1时，bash shell会显示getopts命令产生的错误 |
| OSTYPE |定义了shell运行的操作系统|
| PIPESTATUS | 含有前台进程退出状态码的数组 |
| POSIXLY_CORRECT | 如果设置了该环境变量，bash会以POSIX模式启动 |
| PPID | bash shell父进程的PID |
| PROMPT_COMMAND | 如果设置该环境变量，在显示命令行主提示符之前会执行这条命令 |
| PS1 | 主命令行提示符字符串 |
| PS2 | 次命令行提示符字符串 |
| PS3 | select命令的提示符 |
| PS4 |如果使用了bash的-x选项，在命令行显示之前显示的提示符|
| PWD | 当前工作目录 |
| RANDOM | 返回一个0~32 767的随机数，对其赋值可作为随机数生成器的种子 |
| READLINE_LINE |保存了readline行缓冲区中的内容|
| READLINE_POINT | 当前readline行缓冲区的插入点位置 |
| REPLY | read命令的默认变量 |
| SECONDS |自shell启动到现在的秒数，对其赋值将会重置计时器|
| SHELL | shell的全路径名 |
| SHELLOPTS | 已启用bash shell选项列表，由冒号分隔 |
| SHLVL |表明shell层级，每次启动一个新的bash shell时计数加1|
| TIMEFORMAT | 指定了shell显示的时间值的格式 |
| TMOUT | select和read命令在没输入的情况下等待多久（以秒为单位）。默认值为零，表示无限长 |
| TMPDIR |如果设置成目录名，shell会将其作为临时文件目录|
| UID | 当前用户的真实用户ID（数字形式） |

可以用set内建命令来显示这些环境变量。对于不同的Linux发行版，开机时设置的默认shell
环境变量经常会不一样