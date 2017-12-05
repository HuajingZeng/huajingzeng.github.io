---
title: 常用Shell命令
date: 2017-11-30 10:59:23
author: 曾华经
tags:
	- 操作系统
	- Shell
categories:
	- 编程基础
	- 开发工具
thumbnail: 
blogexcerpt: 
---

&emsp;&emsp;本人当前开发基本都是用苹果电脑（Mac），开发过程中难免要与命令行工具（Command Line Tools）打交道，因此掌握一些基本的Shell命令是必须的。

**PS：不同的Shell具备不同的功能，流行的Shell有：bash、csh、ksh、sh、tcsh、zsh等。可以进入/bin目录查看，以sh结尾的可执行文件即Shell脚本解析程序。本人Mac系统默认使用/bin/bash，bash也是目前大多数Linux系统默认使用的Shell，因此以下命令及参数均以bash为准。关于Shell，以后有机会再写一篇文章进行详细的介绍。**

<!--more-->

# 汇总表
| 分类 | 命令 |
| --- | --- |
| <div style="text-align:center;"><a href="#1">文件管理</a></div> | <a href="#cat">cat</a>&emsp;<a href="#cd">cd</a>&emsp;<a href="#chgrp">chgrp</a>&emsp;<a href="#chmod">chmod</a>&emsp;<a href="#chown">chown</a>&emsp;<a href="#cksum">cksum</a>&emsp;<a href="#cmp">cmp</a>&emsp;<a href="#cp">cp</a>&emsp;<a href="#du">du</a>&emsp;<a href="#df">df</a>&emsp;<a href="#fsck">fsck</a>&emsp;<a href="#fuser">fuser</a>&emsp;<a href="#ln">ln</a>&emsp;<a href="#ls">ls</a>&emsp;<a href="#lsattr">lsattr</a>&emsp;<a href="#lsof">lsof</a>&emsp;<a href="#mkdir">mkdir</a>&emsp;<a href="#mount">mount</a>&emsp;<a href="#mv">mv</a>&emsp;<a href="#pwd">pwd</a>&emsp;<a href="#rm">rm</a>&emsp;<a href="#rmdir">rmdir</a>&emsp;<a href="#split">split</a>&emsp;<a href="#touch">touch</a>&emsp;<a href="#umask">umask</a> |
| <div style="text-align:center;"><a href="#2">程序进程</a></div> | <a href="#at">at</a>&emsp;<a href="#bg">bg</a>&emsp;<a href="#chroot">chroot</a>&emsp;<a href="#cron">cron</a>&emsp;<a href="#exit">exit</a>&emsp;<a href="#fg">fg</a>&emsp;<a href="#jobs">jobs</a>&emsp;<a href="#kill">kill</a>&emsp;<a href="#killall">killall</a>&emsp;<a href="#nice">nice</a>&emsp;<a href="#pgrep">pgrep</a>&emsp;<a href="#pidof">pidof</a>&emsp;<a href="#pkill">pkill</a>&emsp;<a href="#ps">ps</a>&emsp;<a href="#pstree">pstree</a>&emsp;<a href="#sleep">sleep</a>&emsp;<a href="#time">time</a>&emsp;<a href="#top">top</a>&emsp;<a href="#wait">wait</a> |
| <div style="text-align:center;"><a href="#3">系统环境</a></div> | <a href="#env">env</a>&emsp;<a href="#finger">finger</a>&emsp;<a href="#id">id</a>&emsp;<a href="#logname">logname</a>&emsp;<a href="#mesg">mesg</a>&emsp;<a href="#passwd">passwd</a>&emsp;<a href="#su">su</a>&emsp;<a href="#sudo">sudo</a>&emsp;<a href="#uptime">uptime</a>&emsp;<a href="#w">w</a>&emsp;<a href="#wall">wall</a>&emsp;<a href="#who">who</a>&emsp;<a href="#whoami">whoami</a>&emsp;<a href="#write">write</a> |
| <div style="text-align:center;"><a href="#4">文档编辑</a></div> | <a href="#awk">awk</a>&emsp;<a href="#comm">comm</a>&emsp;<a href="#cut">cut</a>&emsp;<a href="#ed">ed</a>&emsp;<a href="#ex">ex</a>&emsp;<a href="#fmt">fmt</a>&emsp;<a href="#head">head</a>&emsp;<a href="#iconv">iconv</a>&emsp;<a href="#join">join</a>&emsp;<a href="#less">less</a>&emsp;<a href="#more">more</a>&emsp;<a href="#paste">paste</a>&emsp;<a href="#sed">sed</a>&emsp;<a href="#sort">sort</a>&emsp;<a href="#strings">strings</a>&emsp;<a href="#talk">talk</a>&emsp;<a href="#tac">tac</a>&emsp;<a href="#tail">tail</a>&emsp;<a href="#tr">tr</a>&emsp;<a href="#uniq">uniq</a>&emsp;<a href="#vi">vi</a>&emsp;<a href="#wc">wc</a>&emsp;<a href="#xargs">xargs</a> |
| <div style="text-align:center;"><a href="#5">Shell脚本</a></div> | <a href="#alias">alias</a>&emsp;<a href="#basename">basename</a>&emsp;<a href="#dirname">dirname</a>&emsp;<a href="#echo">echo</a>&emsp;<a href="#expr">expr</a>&emsp;<a href="#false">false</a>&emsp;<a href="#printf">printf</a>&emsp;<a href="#text">text</a>&emsp;<a href="#true">true</a>&emsp;<a href="#unset">unset</a> |
| <div style="text-align:center;"><a href="#6">网络通讯</a></div> | <a href="#inetd">inetd</a>&emsp;<a href="#netstat">netstat</a>&emsp;<a href="#ping">ping</a>&emsp;<a href="#rlogin">rlogin</a>&emsp;<a href="#netcat">netcat</a>&emsp;<a href="#traceroute">traceroute</a> |
| <div style="text-align:center;"><a href="#7">搜索查找</a></div> | <a href="#find">find</a>&emsp;<a href="#grep">grep</a>&emsp;<a href="#locate">locate</a>&emsp;<a href="#whereis">whereis</a>&emsp;<a href="#which">which</a> |
| <div style="text-align:center;"><a href="#8">其他</a></div> | <a href="#apropos">apropos</a>&emsp;<a href="#banner">banner</a>&emsp;<a href="#bc">bc</a>&emsp;<a href="#cal">cal</a>&emsp;<a href="#clear">clear</a>&emsp;<a href="#date">date</a>&emsp;<a href="#dd">dd</a>&emsp;<a href="#file">file</a>&emsp;<a href="#help">help</a>&emsp;<a href="#info">info</a>&emsp;<a href="#size">size</a>&emsp;<a href="#lp">lp</a>&emsp;<a href="#man">man</a>&emsp;<a href="#history">history</a>&emsp;<a href="#tee">tee</a>&emsp;<a href="#tput">tput</a>&emsp;<a href="#type">type</a>&emsp;<a href="#yes">yes</a>&emsp;<a href="#uname">uname</a>&emsp;<a href="#whatis">whatis</a> |

# <a id="1">文件管理</a>

## <a id="cat">cat</a>
### 描述
Concatenate and print (display) the content of files
### 功能
连接文件并打印输出到文件或标准输出设备上
### 语法
显示文件内容
```
cat [OPTION] FILE...
```
通过键盘为文件输入新的内容（输入的内容会覆盖原来的内容）
```
cat [OPTION] > OUT_FILE
```
将几个文件的内容合并后输出到文件
```
cat [OPTION] FILE... > OUT_FILE
```
### 参数说明
- **OPTION**：选项
    - **-b**：[--number-nonblank]对非空输出行编号
    - **-e**：[--show-ends]在每行结尾打印输出$
    - **-n**：[--number]对输出的一切行编号
    - **-s**：[--squeeze-blank]连续多行空行当做一行空行输出
    - **-t**：[--show-tabs]将制表符打印输出为\^I
    - **-u**：（被忽略）
    - **-v**：[--show-nonprinting]除了LFD和TAB之外，使用\^和M-符号输出非打印字符
- **FILE**：要链接的文件
- **OUT_FILE**：要输出的文件或设备

### 示例
把text1的文档内容加上行号后输出到当前命令行工具窗口
```
cat -n text1
```
把text1和text2 的文档内容加上行号（空白行不加）之后将内容附加到text3文档里
```
cat -b text1 text2 >> text3
```
清空/etc/test.txt文档内容
```
cat /dev/null > /etc/test.txt
```
制作软盘的镜像文件
```
cat /dev/fd0 > IMG_FILE
```
把镜像文件写到软盘
```
cat IMG_FILE > /dev/fd0
```

## <a id="cd">cd</a>
### 描述
Change directory
### 功能
改变当前目录
### 语法
```
cd [OPTION] [DIR]
```
### 参数说明
- **OPTION**：选项
    - **-L**：如果要切换的目标目录是一个符号（软）链接，直接切换到符号链接所在的目录，而非符号链接所指向的目标目录
    - **-P**：如果要切换到的目标目录是一个符号（软）链接，直接切换到符号链接指向的目标目录
- **DIR**：要切换的目标目录，缺省时默认为~或/，即当前用户home目录

### 示例
跳到/usr/bin目录
```
cd /usr/bin
```
跳到自己的home目录
```
cd ~
```
跳到当前目录的上两层
```
cd ../..
```

## <a id="chgrp">chgrp</a>
### 描述
Change group ownership
### 功能
变更文件或目录的所属群组
### 语法
```
chgrp [OPTION] GROUP FILE...
```
### 参数说明
- **OPTION**：选项
    - **-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息
    - **-h**：只对于符号链接本身进行变更，而非该符号链接指向的目标目录
    - **-v**：[--verbose]显示权限变更的详细资料
    - **-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更
- **GROUP**：指定新的群组名或ID
- **FILE**：要变更的文件或目录

### 示例
改变文件log.txt的群组属性为TEAM
```
chgrp -v TEAM log.txt
```

## <a id="chmod">chmod</a>
### 描述
Change access permissions
### 功能
变更文件或目录的权限
### 语法
```
chmod [OPTION] MODE FILE...

MODE1：[[ugoa][+-=][rwx-]][,...]
MODE2：abc
```
### 参数说明
- **OPTION**：选项
    - **-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息
    - **-h**：只对于符号链接进行变更，而非该符号链接指向的目标目录
    - **-v**：[--verbose]显示权限变更的详细资料
    - **-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更
- **MODE**：权限设定字串，MODE1可
    - **MODE1**：多条字串之间用","隔开
        - **u**：[user]表示文件或目录的拥有者
        - **g**：[group]表示文件或目录的所属群组
        - **o**：[other]表示除了文件或目录的拥有者及所属群组之外的其他用户
        - **a**：[all]即全部用户
        - **+**：表示增加权限
        - **-**：表示取消权限
        - **=**：表示唯一设定权限
        - **r**：[read]表示可读取，数字代号为4
        - **w**：[write]表示可写入，数字代号为2
        - **x**：[execute]表示可写入，数字代号为1
        - **-**：不具任何权限，数字代号为0
    - **MODE2**：
        - **abc**：a、b、c各为一个数字，分别表示User、Group、及Other的权限r（read）、w（write）、x（execute）对应数字代号之和
- **FILE**：要变更的文件或目录

### 示例
将文件file.txt设为所有人皆可读取
```
chmod ugo+r file.txt
chmod a+r file1.txt
```
将文件file1.txt与file2.txt设为该文件拥有者，与其所属同一个群体者可写入，但其他以外的人则不可写入
```
chmod ug+w,o-w file1.txt file2.txt
```
将ex.py设定为只有该文件拥有者可以执行
```
chmod u+x ex.py
```
将目前目录下的所有文件与子目录皆设为任何人可读取
```
chmod -R a+r *
```
将文件a.out设为该文件拥有者，与其所属同一个群体者可读写执行，但其他以外的人则不可仅可读取不可写入和执行
```
chmod ug=rwx,o=r a.out
chmod 774 a.out
```

## <a id="chown">chown</a>
### 描述
Change file owner and group
### 功能
将指定文件的拥有者改为指定的用户或组
### 语法
```
chown [OPTION] USER[:GROUP] FILE...
chown [OPTION] :GROUP FILE... 
```
### 参数说明
- **OPTION**：选项
    - **-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息
    - **-h**：只对于符号链接进行变更，而非该符号链接指向的目标目录
    - **-v**：[--verbose]显示权限变更的详细资料
    - **-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更
- **USER**：指定新的拥有者的用户名或ID
- **GROUP**：指定新的所属群组的群组名或ID
- **FILE**：要变更的文件或目录
### 示例
将文件file.txt的群组设为群组TEAM
```
chown :TEAM file.txt
```
将当前目录下的所有文件与子目录的所有者和群组皆设为用户ZHJ和群组TEAM
```
chown -R ZHJ:TEAM *
```

## <a id="cksum">cksum</a>
### 描述
Print CRC checksum and byte counts
### 功能
检查文件的CRC是否正确（输出信息中，第一个字符串表示校验码，第二个字符串表示字节数）
### 语法
```
cksum FILE...
```
### 参数说明
- **FILE**：要检查的文件

### 示例
计算文件abc.txt的完整性
```
cksum testfile
//3311261222 35 abc.txt
```

## <a id="cmp">cmp</a>
### 描述
Compare two files
### 功能
比较两个文件是否有差异
### 语法
```
cmp [-clsv] [-i <起始字符索引>] file1 file2
```
### 参数说明
- **-c**：[--print-chars]除了标明差异处的十进制字码之外，一并显示该字符所对应字符
- **-l**：[--verbose]标示出所有不一样的地方
- **-s**：[--quiet或--silent]不显示错误信息
- **-v**：[--version]显示版本信息
- **-i <起始位置>** [--ignore-initial=<起始位置>]指定比较的起始字符位置，第一个字符索引值为0
- **file1**：进行比较的第一个文件
- **file2**：进行比较的第二个文件

## <a id="cp">cp</a>
### 描述
Copy one or more files to another location
### 功能
复制文件或目录
### 语法
```
cp [-adfiprl] source target
cp [-adfiprl] source ... directory
```
### 参数说明
- **-a**：[--archive]此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合
- **-d**：[--no-dereference]复制时保留链接
- **-f**：[--force]覆盖已经存在的目标文件而不给出提示
- **-i**：[--interactive]在覆盖目标文件之前给出提示，要求用户确认是否覆盖
- **-p**：[--preserve]除复制文件的内容外，还把修改时间和访问权限也复制到新文件中
- **-r**：[--recursive]--recursive
- **-l**：[--link]不复制文件，只是生成链接文件
- **source**：原文件或目录
- **target**：新文件
- **directory**：目标目录

## <a id="du">du</a>
### 描述
Estimate file space usage
### 功能
显示目录或文件的大小
### 语法
```
du [-abcDhklmsSx] file
```
### 参数说明
- **-a**：[--all]显示目录中各个文件或目录的大小
- **-b**：[--bytes]显示目录或文件大小时，以byte为单位
- **-c**：[--total]除了显示各个文件或目录的大小外，同时也显示所有文件和目录的总和
- **-D**：[--dereference-args]显示指定符号链接的源文件大小
- **-h**：[--human-readable]以KB，MB，GB为单位，提高信息的可读性
- **-k**：[--kilobytes]以1024Bytes为单位
- **-l**：[--count-links]重复计算硬链接的文件
- **-m**：[--megabytes]以1MB为单位
- **-s**：[--summarize]仅显示总计
- **S**：[--separate-dirs]显示各个目录的大小时，并不含其子目录的大小
- **-x**：[--one-file-xystem]以一开始处理时的文件系统为准，若遇上其它不同的文件系统目录则略过
- **file**：要显示大小的文件或目录

## <a id="df">df</a>
### 描述
Display free disk space
### 功能
检查文件系统的磁盘空间占用情况
### 语法
```
df [-ahiklPT] [-tx <文件系统类型>] [file] ...
```
### 参数说明
- **-a**：[--all]包含所有的具有0Blocks 的文件系统
- **-h**：[--human-readable]以KB，MB，GB为单位，提高信息的可读性
- **-i**：[--inodes]显示i节点信息，而不是磁盘块
- **-l**：[--local]限制列出的文件结构
- **-P**：[--portability]使用POSIX输出格式
- **-t**：[--type=<文件系统类型>]限制列出<文件系统类型>的文件系统
- **-T**：[--print-type]显示文件系统类型
- **-x**：[--exclude-type=<文件系统类型>]限制列出非<文件系统类型>的文件系统
- **file**：指定显示该文件所在的文件系统

## <a id="fsck">fsck</a>
### 描述
File system consistency check and repair
### 功能
检查和维护不一致的文件系统
### 语法
```
fsck -p [-f]&emsp;fsck [-l <最大并行数>] [-dnqy]
```
### 参数说明
- **-p**：同时检查所有的文件系统
- **-f**：强制清理文件系统
- **-l**：限制同时执行文件系统检查的最大并行数，默认最大并行数是硬盘个数
- **-d**：打印出e2fsck的debug结果
- **-n**：指定检测每个文件时自动输入no，在不确定那些是不正常的时候
- **-q**：快速检查以确定文件系统被卸载干净
- **-y**：指定检测每个文件时自动输入yes，在不确定那些是不正常的时候

## <a id="fuser">fuser</a>
### 描述
Identify/kill the process that is accessing a file
### 功能
由文件或设备去找出使用文件、或设备的进程
### 语法
```
fuser [ -cfu ] file ...
```
### 参数说明
- **-c**：包含 File的文件系统中关于任何打开的文件的报告
- **-f**：仅对文件的打开实例报告
- **-u**：为进程号后圆括号中的本地进程提供登录名&emsp;**file**：指定进行查找所依据的文件或设备

## <a id="ln">ln</a>

## <a id="ls">ls</a>
### 描述
List information about file(s)
### 功能
显示当前目录下的内容
### 语法
```
ls [options]
```
### 参数说明
- **-a**： 显示所有文件及目录 (ls内定将文件名或目录名称开头为"."的视为隐藏档，不会列出)
- **-l**：除文件名称外，亦将文件型态、权限、拥有者、文件大小等资讯详细列出
- **-r**：将文件以相反次序显示(原定依英文字母次序)&emsp;**-t**：将文件依建立时间之先后次序列出
- **-A**：同-a，但不列出"."(目前目录)及".."(父目录)
- **-F**：在列出的文件名称后加一符号；例如可执行档则加 "\*", 目录则加 "/"
- **-R**：若目录下有文件，则以下之文件亦皆依序列出

## <a id="lsattr">lsattr</a>

## <a id="lsof">lsof</a>

## <a id="mkdir">mkdir</a>
### 描述
Create new folder(s)
### 功能
创建一个子目录
### 语法
```
mkdir [-p] dir
```
### 参数说明
- **-p**：确保目录名称存在，不存在就建一个
- **dir**：要创建的子目录名称

## <a id="mount">mount</a>

## <a id="mv">mv</a>
### 描述
Move or rename files or directories
### 功能
为文件或目录改名、或将文件或目录移入其它位置
### 语法
```
mv [-fin] [-v] source target
mv [-fin] [-v] source ... directory
```
### 参数说明
- **-f**：[--force]若目标文件已存在，不询问直接覆盖
- **-i**：[--interactive]若目标文件已存在，覆盖之前先询问
- **-n**：（默认缺省）不覆盖任何已存在的文件
- **-v**：[--verbose]显示命令执行的信息
- **source**：原文件/原目录
- **target**：新文件
- **directory**：目标目录

## <a id="pwd">pwd</a>
### 描述
Print Working Directory
### 功能
显示当前目录的路径
### 语法
```
pwd
```
### 参数说明
无

## <a id="rm">rm</a>
### 描述
Remove files
### 功能
删除一个文件或者目录
### 语法
```
rm [-fi] [-dPRrvW] file ...
```
### 参数说明
- **-f**：[--force]强制删除，忽略不存在的文件，不提示确认
- **-i**：[--interactive]在删除前需要确认
- **-d**：[--directory]删除可能仍有数据的目录（只限超级用户）
- **-P**：
- **-R/-r**：[--recursive]递归删除目录及其内容
- **-v**：[--verbose]详细显示进行的步骤
- **-W**：
- **file**：要删除的文件或目录

## <a id="rmdir">rmdir</a>
### 描述
Remove folder(s)
### 功能
删除空的目录
### 语法
```
rmdir [-p] dirName
```
### 参数说明
- **-p**：是当子目录被删除后使它也成为空目录的话，则顺便一并删除
- **dirName**：要删除的子目录名称

## <a id="split">split</a>

## <a id="touch">touch</a>

## <a id="umask">umask</a>

# <a id="2">程序进程<a>


# <a id="3">系统环境<a>


# <a id="4">文档编辑<a>


# <a id="5">Shell脚本<a>


# <a id="6">网络通讯<a>


# <a id="7">搜索查找<a>

# <a id="8">其他<a>

