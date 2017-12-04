---
title: Mac常用Shell命令
date: 2017-11-30 10:59:23
author: 曾华经
tags:
	- Mac
	- Shell
categories:
	- 编程基础
	- 开发工具
thumbnail: 
blogexcerpt: 
---

&emsp;&emsp;本人当前开发基本都是用苹果电脑（Mac），开发过程中难免要与命令行工具（Command Line Tools）打交道，因此掌握一些基本的Shell命令是必须的，这里分享一些比较常用的。

**PS：不同的Shell具备不同的功能，流行的Shell有：bash、csh、ksh、sh、tcsh、zsh等。可以进入/bin目录查看，以sh结尾的可执行文件即Shell脚本解析程序。本人Mac系统默认使用/bin/bash，bash也是目前大多数Linux系统默认使用的Shell，因此以下命令及参数均以bash为准。关于Shell，以后有机会再写一篇文章进行详细的介绍。**

<!--more-->

# 1、文件管理
| 命令 | 全拼 | 功能 | 格式  | 参数说明 |
| --- | --- | --- | --- | --- |
| cat | Concatenate and print (display) the content of files | 链接文件并打印到标准输出设备上（Command Line Tools当前窗口） | cat [-benstuv] file ... | **-b**：[--number-nonblank]对非空输出行编号<br>**\-e**：[--show-ends]在每行完毕处显现$<br>**-n**：[--number]对输出的一切行编号<br>**-s**：[--squeeze-blank]连续多行空行当做一行空行输出<br>**-t**：[--show-tabs]将制表符显现为\^I<br>**-u**：（被忽略）<br>**-v**：[--show-nonprinting]除了LFD和TAB之外，使用\^和M-符号打印非打印字符<br>**file**：要链接的文件或路径 |
| cd | Change directory | 改变当前目录 | cd [-LP] dir | **-L**：如果要切换的目标目录是一个符号链接，直接切换到符号链接所在的目录，而非符号链接所指向的目标目录<br>**-P**：如果要切换到的目标目录是一个符号链接，直接切换到符号链接指向的目标目录<br>**dir**：要切换的目标目录 |
| chgrp | Change group ownership | 变更文件或目录的所属群组 | chgrp [-cfhvR] [group] [file] ...<br>chgrp [-cfhvR] [--reference=<参考文件或目录>] [file] ... | **-c**：[--changes]若该文件权限确实已经更改，才显示其更改动作<br>**-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息<br>**-h**：只对于符号链接进行变更，而非该符号链接指向的目标目录<br>**-v**：[--verbose]显示权限变更的详细资料<br>**-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更<br>**group**：指定群组名或群组ID<br>**--reference=<参考文件或目录>**：指定变更成和参考文件或目录相同的群组<br>**file**：要变更的文件或目录 |
| chmod | Change access permissions | 变更文件或目录的权限 | chmod [-cfhvR]  mode file...<br><br>**mode1**：[ugoa...][[+-=][rwx-]...][,...]<br>**mode2**：abc | **-c**：[--changes]若该文件权限确实已经更改，才显示其更改动作<br>**-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息<br>**-h**：只对于符号链接进行变更，而非该符号链接指向的目标目录<br>**-v**：[--verbose]显示权限变更的详细资料<br>**-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更<br>**mode**：权限设定字串，格式参考左侧mode1和mode2<br>**u**：[user]表示文件或目录的拥有者<br>**g**：[group]表示文件或目录的所属群组<br>**o**：[other]表示除了文件或目录拥有者或所属群组之外的其他用户<br>**a**：[all]即全部用户<br>**+**：表示增加权限<br>**-**：表示取消权限<br>**=**：表示唯一设定权限<br>**r**：[read]表示可读取，数字代号为4<br>**w**：[write]表示可写入，数字代号为2<br>**x**：[execute]表示可写入，数字代号为1<br>**-**：不具任何权限，数字代号为0<br>**abc**：a、b、c各为一个数字，分别表示User、Group、及Other的权限。a、b、c的值为rwx对应数字代号之和<br>**file**：要变更的文件或目录 |
| chown | Change file owner and group | 将指定文件的拥有者改为指定的用户或组 | chown [-cfhvR] user[:group] file ...<br>chown [-cfhvR] :group file ... | **-c**：[--changes]若该文件权限确实已经更改，才显示其更改动作**-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息<br>**-h**：只对于符号链接进行变更，而非该符号链接指向的目标目录<br>**-v**：[--verbose]显示权限变更的详细资料<br>**-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更<br>**user**：新的文件拥有者的用户名或用户ID<br>**group**：新的文件所属群组的群组名或群组ID<br>**file**：要变更的文件 |
| cksum | Print CRC checksum and byte counts | 检查文件的CRC是否正确（输出信息中，第一个字符串表示校验码，第二个字符串表示字节数） | cksum file ... | **file**：要检查的文件 |
| cmp | Compare two files | 比较两个文件是否有差异 | cmp [-clsv] [-i <起始字符索引>] file1 file2 | **-c**：[--print-chars]除了标明差异处的十进制字码之外，一并显示该字符所对应字符<br>**-l**：[--verbose]标示出所有不一样的地方<br>**-s**：[--quiet或--silent]不显示错误信息<br>**-v**：[--version]显示版本信息<br>**-i <起始位置>** [--ignore-initial=<起始位置>]指定比较的起始字符位置，第一个字符索引值为0<br>**file1**：进行比较的第一个文件<br>**file2**：进行比较的第二个文件 |
| cp | Copy one or more files to another location | 复制文件或目录 | cp [-adfiprl] source target<br>cp [-adfiprl] source ... directory | **-a**：[--archive]此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合<br>**-d**：[--no-dereference]复制时保留链接<br>**-f**：[--force]覆盖已经存在的目标文件而不给出提示<br>**-i**：[--interactive]在覆盖目标文件之前给出提示，要求用户确认是否覆盖<br>**-p**：[--preserve]除复制文件的内容外，还把修改时间和访问权限也复制到新文件中<br>**-r**：[--recursive]--recursive<br>**-l**：[--link]不复制文件，只是生成链接文件<br>**source**：原文件或目录<br>**target**：新文件<br>**directory**：目标目录 |
| du | Estimate file space usage | 显示目录或文件的大小 | du [-abcDhklmsSx]  file | **-a**：[--all]显示目录中各个文件或目录的大小<br>**-b**：[--bytes]显示目录或文件大小时，以byte为单位<br>**-c**：[--total]除了显示各个文件或目录的大小外，同时也显示所有文件和目录的总和<br>**-D**：[--dereference-args]显示指定符号链接的源文件大小<br>**-h**：[--human-readable]以KB，MB，GB为单位，提高信息的可读性<br>**-k**：[--kilobytes]以1024Bytes为单位<br>**-l**：[--count-links]重复计算硬链接的文件<br>**-m**：[--megabytes]以1MB为单位<br>**-s**：[--summarize]仅显示总计<br>**S**：[--separate-dirs]显示各个目录的大小时，并不含其子目录的大小<br>**-x**：[--one-file-xystem]以一开始处理时的文件系统为准，若遇上其它不同的文件系统目录则略过<br>**file**：要显示大小的文件或目录 |
| df | Display free disk space | 检查文件系统的磁盘空间占用情况 | df [-ahiklPT] [-tx <文件系统类型>] [file] ... | **-a**：[--all]包含所有的具有0Blocks 的文件系统<br>**-h**：[--human-readable]以KB，MB，GB为单位，提高信息的可读性<br>**-i**：[--inodes]显示i节点信息，而不是磁盘块<br>**-l**：[--local]限制列出的文件结构<br>**-P**：[--portability]使用POSIX输出格式<br>**-t**：[--type=<文件系统类型>]限制列出<文件系统类型>的文件系统<br>**-T**：[--print-type]显示文件系统类型<br>**-x**：[--exclude-type=<文件系统类型>]限制列出非<文件系统类型>的文件系统<br>**file**：指定显示该文件所在的文件系统 |
| fsck | File system consistency check and repair | 检查和维护不一致的文件系统 | fsck -p [-f]<br>fsck [-l <最大并行数>] [-dnqy] | **-p**：同时检查所有的文件系统<br>**-f**：强制清理文件系统<br>**-l**：限制同时执行文件系统检查的最大并行数，默认最大并行数是硬盘个数<br>**-d**：打印出e2fsck的debug结果<br>**-n**：指定检测每个文件时自动输入no，在不确定那些是不正常的时候<br>**-q**：快速检查以确定文件系统被卸载干净<br>**-y**：指定检测每个文件时自动输入yes，在不确定那些是不正常的时候 |
| fuser | Identify/kill the process that is accessing a file | 由文件或设备去找出使用文件、或设备的进程 | fuser [ -cfu ] file ... | **-c**：包含 File的文件系统中关于任何打开的文件的报告<br>**-f**：仅对文件的打开实例报告<br>**-u**：为进程号后圆括号中的本地进程提供登录名<br>**file**：指定进行查找所依据的文件或设备 |
| ls | List information about file(s) | 显示当前目录下的内容 | ls [options] | **-a**： 显示所有文件及目录 (ls内定将文件名或目录名称开头为"."的视为隐藏档，不会列出)<br>**-l**：除文件名称外，亦将文件型态、权限、拥有者、文件大小等资讯详细列出<br>**-r**：将文件以相反次序显示(原定依英文字母次序)<br>**-t**：将文件依建立时间之先后次序列出<br>**-A**：同-a，但不列出"."(目前目录)及".."(父目录)<br>**-F**：在列出的文件名称后加一符号；例如可执行档则加 "\*", 目录则加 "/"<br>**-R**：若目录下有文件，则以下之文件亦皆依序列出 |
| mkdir | Create new folder(s) | 创建一个子目录 | mkdir [-p] dirName | **-p**：确保目录名称存在，不存在就建一个<br>**dirName**：要创建的子目录名称 |
| mv | Move or rename files or directories | 为文件或目录改名、或将文件或目录移入其它位置 | mv [-fin] [-v] source target<br>mv [-fin] [-v] source ... directory | **-f**：[--force]若目标文件已存在，不询问直接覆盖<br>**-i**：[--interactive]若目标文件已存在，覆盖之前先询问<br>**-n**：（默认缺省）不覆盖任何已存在的文件<br>**-v**：[--verbose]显示命令执行的信息<br>**source**：原文件/原目录<br>**target**：新文件<br>**directory**：目标目录 |
| pwd | Print Working Directory | 显示当前目录的路径 | pwd | 无 |
| rm | Remove files | 删除一个文件或者目录 | rm [-fi] [-dPRrvW] file ... | **-f**：[--force]强制删除，忽略不存在的文件，不提示确认<br>**-i**：[--interactive]在删除前需要确认<br>**-d**：[--directory]删除可能仍有数据的目录（只限超级用户）<br>**-P**：<br>**-R/-r**：[--recursive]递归删除目录及其内容<br>**-v**：[--verbose]详细显示进行的步骤<br>**-W**：<br>**file**：要删除的文件或目录 |
| rmdir | Remove folder(s) | 删除空的目录 | rmdir [-p] dirName | **-p**：是当子目录被删除后使它也成为空目录的话，则顺便一并删除<br>**dirName**：要删除的子目录名称 |

# 2、程序进程
| 命令 | 全拼 | 功能 | 格式  | 参数说明 |
| --- | --- | --- | --- | --- |

# 3、系统环境
| 命令 | 全拼 | 功能 | 格式  | 参数说明 |
| --- | --- | --- | --- | --- |

# 4、文档编辑
| 命令 | 全拼 | 功能 | 格式  | 参数说明 |
| --- | --- | --- | --- | --- |

# 5、Shell脚本
| 命令 | 全拼 | 功能 | 格式  | 参数说明 |
| --- | --- | --- | --- | --- |

# 6、网络通讯
| 命令 | 全拼 | 功能 | 格式  | 参数说明 |
| --- | --- | --- | --- | --- |

# 7、搜索查找
| 命令 | 全拼 | 功能 | 格式  | 参数说明 |
| --- | --- | --- | --- | --- |

# 8、其他
| 命令 | 全拼 | 功能 | 格式  | 参数说明 |
| --- | --- | --- | --- | --- |

**PS：在Command Line Tools中可以使用info [命令名]的方式查看到对应命令的使用方法和详细说明**

