---
title: 常用Shell命令
date: 2017-11-30 10:59:23
update: 2018-1-15 17:22:00
author: 曾华经
tags: Shell
categories:
	- 编程基础
	- 开发工具
thumbnail: /img/thumbnail/2.jpg
blogexcerpt: 
toc: true
---
&emsp;&emsp;本人当前开发基本都是用苹果电脑（Mac），开发过程中难免要与命令行工具（Command Line Tools）打交道，因此掌握一些基本的Shell命令是必须的。
&emsp;&emsp;不同的Shell具备不同的功能，流行的Shell有：bash、csh、ksh、sh、tcsh、zsh等。可以进入/bin目录查看，以sh结尾的可执行文件即Shell脚本解析程序。本人Mac系统默认使用/bin/bash，bash也是目前大多数Linux系统默认使用的Shell。
<!--more-->

# 汇总表
|<div style="white-space: nowrap; word-wrap: normal; word-break: normal;">&emsp;分类&emsp;<div>| 命令 |
| --- | --- |
| <div style="text-align:center;"><a href="#文件管理">文件管理</a></div> | **<a href="#cat">cat</a>**&emsp;**<a href="#cd">cd</a>**&emsp;**<a href="#chgrp">chgrp</a>**&emsp;**<a href="#chmod">chmod</a>**&emsp;**<a href="#chown">chown</a>**&emsp;**<a href="#cksum">cksum</a>**&emsp;**<a href="#cmp">cmp</a>**&emsp;**<a href="#cp">cp</a>**&emsp;**<a href="#du">du</a>**&emsp;**<a href="#df">df</a>**&emsp;**<a href="#fsck">fsck</a>**&emsp;**<a href="#fuser">fuser</a>**&emsp;**<a href="#ln">ln</a>**&emsp;**<a href="#ls">ls</a>**&emsp;<a href="#lsof">lsof</a>&emsp;**<a href="#mkdir">mkdir</a>**&emsp;<a href="#mount">mount</a>&emsp;**<a href="#mv">mv</a>**&emsp;**<a href="#pwd">pwd</a>**&emsp;**<a href="#rm">rm</a>**&emsp;**<a href="#rmdir">rmdir</a>**&emsp;**<a href="#split">split</a>**&emsp;**<a href="#touch">touch</a>**&emsp;**<a href="#umask">umask</a>** |
| <div style="text-align:center;"><a href="#程序进程">程序进程</a></div> | <a href="#at">at</a>&emsp;<a href="#bg">bg</a>&emsp;<a href="#chroot">chroot</a>&emsp;<a href="#cron">cron</a>&emsp;**<a href="#exit">exit</a>**&emsp;<a href="#fg">fg</a>&emsp;<a href="#jobs">jobs</a>&emsp;<a href="#kill">kill</a>&emsp;<a href="#killall">killall</a>&emsp;<a href="#nice">nice</a>&emsp;<a href="#pgrep">pgrep</a>&emsp;<a href="#pidof">pidof</a>&emsp;<a href="#pkill">pkill</a>&emsp;<a href="#ps">ps</a>&emsp;<a href="#pstree">pstree</a>&emsp;<a href="#sleep">sleep</a>&emsp;<a href="#time">time</a>&emsp;<a href="#top">top</a>&emsp;<a href="#wait">wait</a> |
| <div style="text-align:center;"><a href="#系统环境">系统环境</a></div> | <a href="#env">env</a>&emsp;<a href="#finger">finger</a>&emsp;<a href="#id">id</a>&emsp;<a href="#logname">logname</a>&emsp;<a href="#mesg">mesg</a>&emsp;<a href="#passwd">passwd</a>&emsp;**<a href="#su">su</a>**&emsp;**<a href="#sudo">sudo</a>**&emsp;<a href="#uptime">uptime</a>&emsp;<a href="#w">w</a>&emsp;<a href="#wall">wall</a>&emsp;**<a href="#who">who</a>**&emsp;**<a href="#whoami">whoami</a>**&emsp;<a href="#write">write</a> |
| <div style="text-align:center;"><a href="#文档编辑">文档编辑</a></div> | <a href="#awk">awk</a>&emsp;<a href="#comm">comm</a>&emsp;**<a href="#cut">cut</a>**&emsp;**<a href="#ed">ed</a>**&emsp;<a href="#ex">ex</a>&emsp;<a href="#fmt">fmt</a>&emsp;<a href="#head">head</a>&emsp;<a href="#iconv">iconv</a>&emsp;<a href="#join">join</a>&emsp;<a href="#less">less</a>&emsp;<a href="#more">more</a>&emsp;**<a href="#paste">paste</a>**&emsp;**<a href="#sed">sed</a>**&emsp;**<a href="#sort">sort</a>**&emsp;<a href="#strings">strings</a>&emsp;<a href="#talk">talk</a>&emsp;<a href="#tac">tac</a>&emsp;<a href="#tail">tail</a>&emsp;**<a href="#tr">tr</a>**&emsp;**<a href="#uniq">uniq</a>**&emsp;**<a href="#vi">vi</a>**&emsp;**<a href="#wc">wc</a>**&emsp;<a href="#xargs">xargs</a> |
| <div style="text-align:center;"><a href="#5">脚本编程</a></div> | <a href="#alias">alias</a>&emsp;<a href="#basename">basename</a>&emsp;<a href="#dirname">dirname</a>&emsp;**<a href="#echo">echo</a>**&emsp;<a href="#expr">expr</a>&emsp;<a href="#false">false</a>&emsp;**<a href="#printf">printf</a>**&emsp;<a href="#text">text</a>&emsp;<a href="#true">true</a>&emsp;<a href="#unset">unset</a> |
| <div style="text-align:center;"><a href="#网络通讯">网络通讯</a></div> | <a href="#inetd">inetd</a>&emsp;<a href="#netstat">netstat</a>&emsp;**<a href="#ping">ping</a>**&emsp;<a href="#rlogin">rlogin</a>&emsp;<a href="#netcat">netcat</a>&emsp;<a href="#traceroute">traceroute</a> |
| <div style="text-align:center;"><a href="#搜索查找">搜索查找</a></div> | **<a href="#find">find</a>**&emsp;**<a href="#grep">grep</a>**&emsp;<a href="#locate">locate</a>&emsp;**<a href="#whereis">whereis</a>**&emsp;**<a href="#which">which</a>** |
| <div style="text-align:center;"><a href="#其他">其他</a></div> | <a href="#apropos">apropos</a>&emsp;<a href="#banner">banner</a>&emsp;<a href="#bc">bc</a>&emsp;<a href="#cal">cal</a>&emsp;**<a href="#clear">clear</a>**&emsp;**<a href="#date">date</a>**&emsp;<a href="#dd">dd</a>&emsp;<a href="#file">file</a>&emsp;<a href="#help">help</a>&emsp;<a href="#info">info</a>&emsp;<a href="#size">size</a>&emsp;<a href="#lp">lp</a>&emsp;**<a href="#man">man</a>**&emsp;<a href="#history">history</a>&emsp;<a href="#tee">tee</a>&emsp;<a href="#tput">tput</a>&emsp;<a href="#type">type</a>&emsp;<a href="#yes">yes</a>&emsp;**<a href="#uname">uname</a>**&emsp;**<a href="#whatis">whatis</a>** |

# <a id="文件管理">文件管理</a>

## <a id="cat">cat</a>
### 描述
Concatenate and print files
### 功能
连接文件并打印输出到文件或标准输出设备上
### 语法
显示文件内容

```
cat [-benstuv] file...

/*
先输出第一个文件的内容，当输入EOF（ctrl+D）时才会继续输出下一个文件的内容
当最后一个文件输出完毕，再次输入EOF时退出输出
*/
cat [-benstuv] file0 [- fileX]...
```

通过键盘为文件输入新的内容（输入的内容会覆盖原来的内容）

```
cat [-benstuv] > out_file
```

将几个文件的内容合并后输出到文件

```
cat [-benstuv] file... > out_file
```

### 选项参数
- **-b**：[--number-nonblank]对非空输出行编号
- **-e**：[--show-ends]在每行结尾打印输出$
- **-n**：[--number]对输出的一切行编号
- **-s**：[--squeeze-blank]连续多行空行当做一行空行输出
- **-t**：[--show-tabs]将制表符打印输出为\^I
- **-u**：禁用输出缓存
- **-v**：[--show-nonprinting]除了LFD和TAB之外，使用\^和M-符号输出非打印字符
- **file**：要连接的文件
- **out_file**：要输出的文件或设备

### 示例
把test.txt的文档内容加上行号后输出到当前命令行工具窗口

```
$ cat -n test.txt
```

把test1.txt和test2.txt的文档内容加上行号（空白行不加）之后将内容附加到test3.txt文档里

```
$ cat -b test1.txt test2.txt >> test3.txt
```

清空/etc/test.txt文档内容

```
$ cat /dev/null > /etc/test.txt
```

从软盘fd0制作镜像文件test.dmg

```
$ cat /dev/fd0 > test.dmg
```

把镜像文件test.dmg写到软盘fd0

```
$ cat test.dmg > /dev/fd0
```

## <a id="cd">cd</a>
### 描述
Change directory
### 功能
改变当前目录
### 语法

```
cd [-L|-P] [dir]
```

### 选项参数
- **-L**：如果要切换的目标目录是一个符号（软）链接，直接切换到符号链接所在的目录，而非符号链接所指向的目标目录
- **-P**：如果要切换到的目标目录是一个符号（软）链接，直接切换到符号链接指向的目标目录
- **dir**：要切换的目标目录（目录可以省略不写，与cd ~有相同的效果）
	- **/**：根目录
	- **.**：当前目录
	- **..**：上级目录
	- **~**：当前用户在该系统的Home目录
	
### 示例
跳到/usr/bin目录

```
$ cd /usr/bin
```

跳到自己的Home目录

```
$ cd ~
```

跳到当前目录的上两层

```
$ cd ../..
```

## <a id="chgrp">chgrp</a>
### 描述
Change group
### 功能
变更文件或目录的所属群组
### 语法

```
chgrp [-fhv] [-R [-H|-L|-P]] group file...
```

### 选项参数
- **-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息
- **-h**：只对于符号链接本身进行变更，而非该符号链接指向的目标目录
- **-v**：[--verbose]显示权限变更的详细资料
- **-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更
	- **-H**：如果指定了递归（-R），仅追踪遍历命令行参数中的符号链接，（对目录内的符号链接不会追踪遍历）
	- **-L**：如果指定了递归（-R），所有的符号链接都会被追踪遍历
	- **-P**：如果指定了递归（-R），不要追踪遍历任何符号链接，此参数默认缺省
- **group**：指定新的群组名或ID
- **file**：要变更的文件或目录

### 示例
改变文件test.txt的群组属性为TestGroup

```
$ chgrp -v TestGroup test.txt
```

## <a id="chmod">chmod</a>
### 描述
Change file modes or Access Control Lists
### 功能
变更文件或目录的权限（只有文件拥有者或者超级管理员才能修改文件权限）
### 语法

```
chmod [-fhv] [-R [-H|-L|-P]] mode file...

mode1：[augo][+|-|=][rstwx-][,...]
mode2：[????]
```

### 选项参数
- **-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息
- **-h**：只对于符号链接进行变更，而非该符号链接指向的目标目录
- **-v**：[--verbose]显示权限变更的详细资料
- **-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更
	- **-H**：如果指定了递归（-R），仅追踪遍历命令行参数中的符号链接，（对目录内的符号链接不会追踪遍历）
	- **-L**：如果指定了递归（-R），所有的符号链接都会被追踪遍历
	- **-P**：如果指定了递归（-R），不要追踪遍历任何符号链接，此参数默认缺省
- **mode**：权限设定字符串
	- **mode1**：符号模式，各子串之间用","隔开
		- **a**：[all]即全部用户
		- **u**：[user]表示文件或目录的拥有者
		- **g**：[group]表示文件或目录的所属群组
		- **o**：[other]表示除了文件或目录的拥有者及所属群组之外的其他用户
		- **+**：表示增加
		- **-**：表示取消
		- **=**：表示设置
		- **r**：[read]读取位，表示文件可读取，数字代号为4
		- **s**：SUID位和SGID位，表示文件在执行时设置用户ID和群组ID
		- **t**：粘滞位，其他用户有写权限，但只有文件拥有者才能执行删除和移动操作
		- **w**：[write]写入位，表示文件可写入，数字代号为2
		- **x**：[execute]执行位，表示文件可运行或搜索，数字代号为1
		- **-**：不具任何权限，数字代号为0
	- **mode2**：数值模式（4位8进制数），各组数值可相加
		- **4000**：等价于设置SUID位，在文件执行时设置uid为该文件拥有者的uid
		- **2000**：等价于设置SGID位，在文件执行时设置gid为该文件群组的gid
		- **1000**：等价于设置粘滞位
		- **0400**：等价于u=r
		- **0200**：等价于u=w
		- **0100**：等价于u=x
		- **0040**：等价于g=r
		- **0020**：等价于g=w
		- **0010**：等价于g=x
		- **0004**：等价于o=r
		- **0002**：等价于o=w
		- **0001**：等价于o=x
		- **0000**：等价于a=-
- **file**：要变更的文件或目录

### 示例
将文件test.txt设为所有人皆可读取

```
$ chmod ugo+r test.txt
$ chmod a+r test.txt
```

将文件test1.txt与test2.txt设为该文件拥有者，与其所属同一个群体者可写入，但其他以外的人则不可写入

```
$ chmod ug+w,o-w test1.txt test2.txt
```

将test.out设定为只有该文件拥有者可以执行

```
$ chmod u+x test.out
```

将目前目录下的所有文件与子目录皆设为任何人可读取

```
$ chmod -R a+r *
```

将文件test.out设为该文件拥有者，与其所属同一个群体者可读写执行，但其他以外的人则不可仅可读取不可写入和执行

```
$ chmod ug=rwx,o=r test.out
$ chmod 774 test.out
```

## <a id="chown">chown</a>
### 描述
Change file owner and group
### 功能
将指定文件的拥有者改为指定的用户或组
### 语法

```
chown [-fhv] [-R [-H|-L|-P]] user[:group] file...
chown [-fhv] [-R [-H|-L|-P]] :group file... 
```

### 选项参数
- **-f**：[--quiet或--silent]若该文件权限无法被更改也不要显示错误讯息
- **-h**：只对于符号链接进行变更，而非该符号链接指向的目标目录
- **-v**：[--verbose]显示权限变更的详细资料
- **-R**：[--recursive]对当前目录下的所有文件与子目录进行相同的权限变更
	- **-H**：如果指定了递归（-R），仅追踪遍历命令行参数中的符号链接，（对目录内的符号链接不会追踪遍历）
	- **-L**：如果指定了递归（-R），所有的符号链接都会被追踪遍历
	- **-P**：如果指定了递归（-R），不要追踪遍历任何符号链接，此参数默认缺省
- **user**：指定新的拥有者的用户名或ID
- **group**：指定新的所属群组的群组名或ID
- **file**：要变更的文件或目录

### 示例
将文件test.txt的群组设为群组TestGroup

```
$ chown :TestGroup test.txt
```

将当前目录下的所有文件与子目录的所有者和群组皆设为用户TestUser和群组TestGroup

```
$ chown -R TestUser:TestGroup *
```

## <a id="cksum">cksum</a>
### 描述
Display file checksums and block counts
### 功能
检查文件的CRC是否正确（输出信息中，第一个字符串表示校验码，第二个字符串表示字节数）
### 语法

```
cksum [-o 1|2|3] file...

//等价于 cksum -o 1 file...
sum file...
```

### 选项参数
- **-o**：使用历史算法而不是默认算法
	- **1**：BSD系统默认使用的校验算法
	- **2**：AT&T V系统默认所使用的校验算法
	- **3**：32位CRC校验算法
- **file**：要检查的文件

### 示例
计算文件test.txt的完整性

```
$ cksum test.txt
3311261222 35 test.txt
```

## <a id="cmp">cmp</a>
### 描述
Compare two files byte by byte
### 功能
比较两个文件是否有差异
### 语法

```
cmp [-bclv] [-n LIMIT] [-i SKIP1[:SLIP2]] file1 file2
```

### 选项参数
- **-b/-c**：[--print-chars]除了标明差异处的十进制字码之外，一并显示该字符所对应字符
- **-l**：[--verbose]标示出所有不一样的地方
- **-v**：[--version]显示版本信息
- **-n**：[--bytes=LIMIT]限制比较LIMIT个字节
- **-i** [--ignore-initial=SKIP1[:SKIP2]]指定从第几个字节开始进行比较
	- **SKIP1**：从文件1的第SKIP1个字节开始进行比较
	- **SKIP2**：从文件2的第SKIP2个字节开始进行比较
- **file1**：进行比较的第一个文件
- **file2**：进行比较的第二个文件

### 示例
比较test1.txt和test2.txt。如果文件相同，则不显示消息。如果文件不同，则显示第一个不同的位置

```
$ cmp test1.txt test2.txt
test1.txt test2.txt differ: char 1, line 1
```

从第7个字符位置开始比较test1.txt和test2.txt。显示所有不同的位置及对应的字符

```
$ cmp -cl -i 6 test1.txt test2.txt
 1 107 G    147 g
14 117 O    157 o
15 120 P    160 p
16 121 Q    161 q
26 130 X    170 x
27 131 Y    171 y
28 132 Z    172 z
```

## <a id="cp">cp</a>
### 描述
Copy files
### 功能
复制文件或目录
### 语法

```
cp [-R [-H|-L|-P]] [-fi|-n] [-apvX] source target
cp [-R [-H|-L|-P]] [-fi|-n] [-apvX] source ... directory
```

### 选项参数
- **-R**：[--recursive]对当前目录下的所有文件与子目录进行复制
	- **-H**：如果指定了递归（-R），仅追踪遍历命令行参数中的符号链接，（对目录内的符号链接不会追踪遍历）
	- **-L**：如果指定了递归（-R），所有的符号链接都会被追踪遍历
	- **-P**：如果指定了递归（-R），不要追踪遍历任何符号链接，此参数默认缺省
- **-f**：强制覆盖已存在的文件或目录
- **-i**：[--interactive]在覆盖目标文件或目录之前给出提示，要求用户确认是否覆盖
- **-n**：不要覆盖已存在的文件或目录
- **-a**：[--archive]等价于-pPR，此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容
- **-p**：[--preserve]除复制文件的内容外，还把修改时间和访问权限等也复制到新文件中
- **-r**：[--recursive]若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件
- **-v**：[--verbose]显示执行过程
- **-X**：[--one-file-system]复制的文件或目录存放的文件系统，必须与cp指令执行时所处的文件系统相同，否则不复制，亦不处理位于其他分区的文件
- **source**：原文件或目录
- **target**：新文件
- **directory**：目标目录

### 示例
将当前目录test1下的所有文件复制到新目录test2下

```
$ cp -r test1 test2
```

## <a id="du">du</a>
### 描述
Display disk usage statistics
### 功能
显示目录或文件的大小
### 语法

```
du [-H|-L|-P] [-a|-s|-d DEPTH] [-c] [-h|-k|-m|-g] [-x] [-I MASK] file...
```

### 选项参数
- **-H**：仅追踪遍历命令行参数中的符号链接，（对目录内的符号链接不会追踪遍历）
- **-L**：所有的符号链接都会被追踪遍历
- **-P**：不要追踪遍历任何符号链接，此参数默认缺省
- **-a**：[--all]显示目录中各个文件或目录的大小
- **-s**：[--summarize]仅显示总计
- **-d**：DEPTH指定目录层数，超过指定层数的目录予以忽略
- **-c**：[--total]除了显示各个文件或目录的大小外，同时也显示所有文件和目录的总和
- **-h**：[--human-readable]以K，M，G为单位，提高信息的可读性
- **-k**：[--kilobytes]以K为单位
- **-m**：[--megabytes]以M为单位
- **-g**：[--gigaByte]以G为单位
- **-x**：[--one-file-xystem]以一开始处理时的文件系统为准，若遇上其它不同的文件系统目录则略过
- **-I**：忽略MASK指定的文件或目录
- **file**：要显示大小的文件或目录

### 示例
显示目录或者文件所占空间

```
$ du
```

显示指定文件所占空间

```
$ du test.txt
```

方便阅读的格式显示test目录所占空间情况

```
$ du -h test
```

## <a id="df">df</a>
### 描述
Display free disk space
### 功能
检查文件系统的磁盘空间占用情况
### 语法

```
df [-b|-h|-H|-k|-m|-g|-P] [-ailn] [-T TYPE] [file|fileSystem] ...
```

### 选项参数
- **-b**：使用默认的512字节块。这是唯一一种能改变块大小的方法
- **-h**：[--human-readable]以KiB，MiB，GiB为单位，提高信息的可读性
- **-H**：[--si]类似-h，但以1000计量而不是1024，即KB、MB、GB等
- **-k**：使用KiB（1024Bytes）为单位
- **-m**：使用MiB（1024*1024Bytes）为单位
- **-g**：使用GiB（1024\*1024\*1024Bytes）为单位
- **-P**：[--portability]等价于-b，使用POSIX输出格式
- **-a**：[--all]显示所有文件系统的磁盘使用情况，包扩具有0块的文件系统
- **-i**：[--inodes]显示i节点信息，而不是块使用量
- **-l**：[--local]只显示本文件系统的信息
- **-n**：打印上一次文件系统计算所得并缓存的结果
- **-T**：[--type=TYPE]限制列出<文件系统类型>的文件系统
- **file**：指定文件或文件系统

### 示例
显示文件系统的磁盘使用情况统计

```
$ df
```

显示磁盘使用的文件系统信息

```
$ df test
```

输出显示inode信息而非块使用量

```
$ df -i
```

显示所有的信息

```
$ df -a
```

产生可读的格式df命令的输出

```
$ df -h
```

## <a id="fsck">fsck</a>
### 描述
Filesystem consistency check and interactive repair
### 功能
检查和维护不一致的文件系统
### 语法

```
fsck -p [-f]
fsck [-l MAX_PARALLEL] [-qynd]
```

### 选项参数
- **-p**：同时检查所有的文件系统
- **-f**：强制清理文件系统
- **-l**：限制同时执行文件系统检查的最大并行数为MAX_PARALLEL，缺省时默认最大并行数是硬盘个数
- **-q**：快速检查以确定文件系统被卸载干净
- **-y**：指定检测每个文件时自动输入yes，在不确定那些是不正常的时候
- **-n**：指定检测每个文件时自动输入no，在不确定那些是不正常的时候
- **-d**：打印出e2fsck的debug结果

### 示例
检查所以文件系统是否正常，如果有异常便自动修复

```
fsck -p
```

## <a id="fuser">fuser</a>
### 描述
List process IDs of all processes that have one or more files open
### 功能
由文件或设备去找出使用该文件或设备的进程ID
### 语法

```
fuser [-cfu] file ...
```

### 选项参数
- **-c**：包含的文件系统中关于任何打开的文件的报告
- **-f**：仅对指定的文件进行报告
- **-u**：在进程ID后使用圆括号显示当前进程的登录用户名
- **file**：指定进行查找所依据的文件或设备

### 示例
显示正在使用文件test、test1、test2的进程ID及该进程的登录用户

```
$ fuser -u test
test: 593(Kevin)
test1: 
test2:
```

## <a id="ln">ln</a>
### 描述
Make links
### 功能
为某一个文件在另外一个位置建立一个同步的链接

所谓的链接（link）可以将其视为文件的别名，而链接又可分为两种：硬链接（hard link）与软链接（symbolic link），硬链接的意思是一个文件可以有多个名称，而软链接的方式则是产生一个特殊的文件，该文件的内容是指向另一个文件的位置。硬链接是存在同一个文件系统中，而软链接却可以跨越不同的文件系统。不论是硬链接或软链接都不会将原本的文件复制一份，只会占用非常少量的磁碟空间。

| 分类 | 区别 |
| --- | --- |
| 软链接 | 1、存储的是文件路径（相对路径/绝对路径），查找文件时以文件路径为依据。类似于Windows操作系统中的快捷方式<br>2、可以跨文件系统<br>3、可以对一个不存在的文件名进行链接<br>4、可以对目录进行链接<br>5、删除源文件会使软链接失效 |
| 硬链接 | 1、存储的是文件的inode节点信息（数据在硬盘上的存储地址），查找文件以文件的inode节点为依据。类似于C语言的指针<br>2、不允许给目录创建硬链接<br>3、只有在同一个文件系统中才能创建<br>4、要把数据从硬盘删除（置为空闲）必须删除所有硬链接 |

### 语法

```
ln [-Ffhinsv] source_file [target_file]
ln [-Ffhinsv] source_file target_dir
```

### 选项参数
- **-F**：[--directory]如果目标文件存在且是一个目录则将其移除以便能够创建链接，该选项在使用-f或-i选项时才可用，如果没指定则默认是-f。当指定-s时-F选项无效。
- **-f**：[--force]强行建立文件或目录的链接，不论文件或目录是否存在
- **-h**：如果目标文件或目标目录是一个符号链接，不要追踪它
- **-i**：[--interactive]交互模式，文件存在则提示用户是否覆盖
- **-n**：[--no-dereference]把符号链接视为一般目录
- **-s**：[--symbolic]建立软链接（符号链接）
- **-v**：[--verbose]显示详细的处理过程
- **source_file**：源文件或源目录
- **target_file**：目标文件
- **target_dir**：目标目录

### 示例
为test.txt文件创建软链接test，如果test.txt丢失，test将失效

```
$ ln -s test.txt test
```

为test.txt文件创建硬链接test，test.txt与test的各项属性相同

```
$ ln test.txt test
```


## <a id="ls">ls</a>
### 描述
List directory contents
### 功能
显示目录下的内容
### 语法

```
ls [-ABCFGHLOPRSTUW@abcdefghiklmnopqrstuwx1] [file...]
```

### 选项参数
- **-A**：显示所有文件及目录，但不列出"."（目前目录）及".."（父目录）（ls内定将文件名或目录名称开头为"."的视为隐藏档，不会列出）
- **-B**：把文件名中不可输出的字符用反斜杠加字符编号（\XXX）的方式列出
- **-C**：按列输出，纵向排序（默认缺省）
- **-F**：在每个文件名后附上一个字符以阐明该文件的类型，“/”表明目录，“*”表明可执行的一般文件，“@”表明符号连接；“|”表明FIFO；“=”表明套接字
- **-G**：开启彩色输出模式，颜色取决于环境配置
- **-H**：命令行中的符号链接将被追踪。当未指定-F、-d或者-I时这个选项默认开启
- **-L**：追踪所有的符号链接，当指定-P时该选项关闭
- **-O**：当指定长输出（-l）时包含文件标志
- **-P**：当命令行中的参数是符号链接时，不进行追踪。此选项会使-H和-L无效
- **-R**：递归遍历目录
- **-S**：按文件大小排序
- **-T**：当使用-l选项时，显示文件的完整时间信息，包括月、日、小时、分钟、秒和年份
- **-U**：当使用-t或-l时，使用创建时间而不是修改时间进行排序
- **-W**：当扫描到目录时显示空白
- **-@**：在指定-l时显示扩展属性的键和大小
- **-a**：同-A，同时列出“.”（当前目录）和“..”（父目录）
- **-b**：同-B，但使用C语言的转义字符输出
- **-c**：当文件因前一次使用时间排序（-t）或长打印（-l）时改变后使用时间排序打印
- **-d**：目录被当做普通文件不会递归搜索
- **-e**：当使用长打印（-l）时打印相关的访问控制列表（ACL）
- **-f**：同-a，输出不进行排序
- **-g**：此选项仅可用于兼容POSIX，它是用来在指定-l选项是显示群组名
- **-h**：当指定-l选项时，自动使用KB、MB、GB、TB、PB等单位以使显示文件大小的数值少于三位
- **-i**：打印各文件的inode节点信息
- **-k**：当指定-s选项时，以字节为单位打印文件大小分配，而不是块，该选项将会覆盖块大小环境变量
- **-l**：除文件名称外，亦将文件型态、权限、拥有者、文件大小等资讯详细列出
- **-m**：以流格式输出，使用逗号分隔
- **-n**：显示用户ID和群组ID，此选项默认打开-l选项
- **-o**：以长格式输出，但不打印群组ID
- **-p**：如果文件是目录，在文件名后加“/”
- **-q**：将文件名中的非打印字符强制输出为“？”，这是终端打印的默认值
- **-r**：将文件以相反次序显示(原定依英文字母次序)
- **-s**：显示每个文件实际使用的文件系统块的数量，单位为512字节，其中部分单元被舍入到下一个整数值。如果输出是终端，所有的文件大小都是在列表之前的一行输出。环境变量中的块字节会覆盖512字节
- **-t**：将文件依建立时间之先后次序列出件
- **-u**：使用最后一次访问的时间排序，而不是最后修改时间或创建时间
- **-w**：对未打印字符进行强制打印。当输出不是终端时，这是默认值
- **-x**：同-C，按列输出，横向排序
- **-1**：一行只输出一个文件（单列输出）
### 示例
列出根目录下的所有目录

```
$ ls /
```

列出当前工作目录下所有名称是s开头的文件，越新的排越后面

```
$ ls -ltr s*
```

将/bin目录以下所有目录及文件详细资料列出

```
$ ls -lR /bin
```

列出当前工作目录下所有文件及目录，目录于名称后加"/", 可执行档于名称后加"*"

```
$ ls -AF
```

## <a id="mkdir">mkdir</a>
### 描述
Make directories
### 功能
创建一个子目录
### 语法

```
mkdir [-pv] [-m MODE] dir...
```

### 选项参数
- **-p**：确保目录名称存在，不存在就建一个
- **-v**：列出创建目录的详细说明
- **-m**：指定MODE为创建的目录权限
- **dir**：要创建的子目录名称

### 示例
在当前目录下创建名为test的子目录

```
$ mkdir test
```

在当前目录下的test1目录中创建一个名为test2的目录，如果test1目录原本不存在，则创建一个

```
$ mkdir -p test1/test2
```

## <a id="mv">mv</a>
### 描述
Move or rename files or directories
### 功能
为文件或目录改名、或将文件或目录移入其它位置
### 语法

```
mv [-f|-i|-n] [-v] source target
mv [-f|-i|-n] [-v] source ... directory
```

### 选项参数
- **-f**：[--force]若目标文件已存在，不询问直接覆盖
- **-i**：[--interactive]若目标文件已存在，覆盖之前先询问
- **-n**：（默认缺省）不覆盖任何已存在的文件
- **-v**：[--verbose]显示命令执行的信息
- **source**：原文件/原目录
- **target**：新文件
- **directory**：目标目录

### 示例
将文件test1更名为test2

```
$ mv test1 test2
```

将test1目录放入test2目录中

```
$ mv test1 test2
```

## <a id="pwd">pwd</a>
### 描述
Return working directory name
### 功能
显示路径
### 语法

```
pwd [-L|-P]
```

### 选项参数
- **-L**：如果环境变量包含了不包含文件名“.”或“..”的当前目录的绝对路径名，则显示环境变量的值。否则，-L与-P一样运行
- **-P**：显示当前目录的绝对路径名

### 示例
查看当前所在目录

```
$ pwd
```

## <a id="rm">rm</a>
### 描述
Remove directory entries
### 功能
删除一个文件或者目录（删除目录则必须配合-R/-r选项）
### 语法

```
rm [-dfiPRrvW] file ...
```

### 选项参数
- **-d**：尝试删除目录以及其他类型的文件
- **-f**：[--force]强制删除文件或目录
- **-i**：[--interactive]删除已有文件或目录之前先询问用户，该选项使-f无效
- **-P**：在删除常规文件之前，先用字节模式0xff，然后0x00，然后再0xff重写它们
- **-R/-r**：[--recursive]递归删除目录及其内容，该选项默认开启-d。
- **-v**：[--verbose]详细显示进行的步骤
- **-W**：试图恢复已删除的文件，该选项仅对文件数据区未被覆写的情况有效
- **file**：要删除的文件或目录

### 示例
删除test.txt文件

```
$ rm test.txt
```

## <a id="rmdir">rmdir</a>
### 描述
Remove directories
### 功能
删除空的目录
### 语法

```
rmdir [-p] dir
```

### 选项参数
- **-p**：是当子目录被删除后使它也成为空目录的话，则顺便一并删除
- **dir**：要删除的子目录名称

### 示例
将test目录下，名为test1的子目录删除（若删除test1后test目录变为空目录，则test也一起删除）

```
$ rmdir -p test/test1
```

## <a id="split">split</a>
### 描述
Split a file into pieces
### 功能
将一个文件分割成数个
### 语法

```
split [-a SUFFIX_LENGTH] [-b BYTE_COUNT[k|m]] [-l LINE_COUNT] [-p PATTERN] [file [name]]
```

### 选项参数
- **-a**：限制文件后缀的字母个数为SUFFIX_LENGTH
- **-b**：指定每BYTE_COUNT个字节切成一个小文件，如果指定k或m，则分割单位变为KB和MB
- **-l**：指定每LINE_COUNT行输出为一个小文件
- **-p**：每当遇到与正则表达式PATTERN匹配的内容时，文件就被分割。匹配的内容将作为下一个文件的起始输出内容。这个选择不能和-b或-l同时使用
- **file**：要分割的文件
- **name**：要输出的文件名

### 示例
文件test.txt每6行切割成一个文件

```
$ split test.txt
```

## <a id="touch">touch</a>
### 描述
Change file access and modification times
### 功能
修改文件或者目录的时间属性，包括存取时间、修改时间等（若文件不存在，会建立一个新的文件）
### 语法

```
touch [-A [-][[hh]mm]SS] [-acfhm] [-r REF_FILE] [-t [CC]YY]MMDDhhmm[.SS]] file...
```

### 选项参数
- **-A**：按指定值修改文件的时间属性
	- **-**：使调整变为负值：在原时间值上减去指定的时间
	- **hh**：可指定00-99小时
	- **mm**：可指定00-59分钟
	- **SS**：可指定00-59秒
- **-a**：更改指定的文件的访问时间。不会更改修改时间，除非也指定了-m
- **-c**：如果文件不存在，则不要进行创建。没有写任何有关此条件的诊断消息
- **-f**：尝试强制运行，而不管文件的读和写许可权
- **-m**：更改文件的修改时间。不会更改访问时间，除非也指定了-a
- **-r**：使用由REF_FILE变量指定的文件的相应时间，而不用当前时间
- **-t**：使用指定时间而不是当前时间
	- **CC**：指定年份的前两位数字
	- **YY**：指定年份的后两位数字
	- **MM**：指定一年的哪一月（从 01 到 12）
	- **DD**：指定一月的哪一天（从 01 到 31）
	- **hh**：指定一天中的哪一小时（从 00 到 23）
	- **mm**：指定一小时的哪一分钟（从 00 到 59）
	- **SS**：指定一分钟的哪一秒（从 00 到 59）

### 示例
修改文件test.txt的时间属性为当前系统时间（如果文件不存在，则会创建一个空白的test.txt文件）

```
$ touch test.txt
```

## <a id="umask">umask</a>
### 描述
Users file creation mask
### 功能
设置限制新建文件权限的掩码
### 语法

```
umask [-p] [-S] [mode]
```

### 选项参数
- **-p**：输出的权限掩码可直接作为指令来执行
- **-S**：以字符的形式来打印当前权限掩码
- **mode**：由3个八进制的数字所组成或由符号表示的权限掩码

### 示例
当前权限掩码

```
$ umask
```

# <a id="程序进程">程序进程</a>
## <a id="exit">exit</a>
### 描述
Exit the shell
### 功能
退出目前的shell
### 语法

```
exit [n]
```

### 选项参数
- **n**：以数值n为返回值（状态）退出shell。如果省略n，退出状态是执行的最后一个命令的状态

### 示例
退出终端

```
exit
```

# <a id="系统环境">系统环境</a>

## <a id="su">su</a>
### 描述
Substitute user identity
### 功能
变更为其他使用者的身份，除root外，需要键入该使用者的密码
### 语法

```
su [-lm] [user [args]]
```

### 选项参数
- **-l**：同-，重新以用户user身份登录，大部份环境变量（HOME、SHELL、PATH、TERM、USER等等）都是以该使用者user为主，并且工作目录也会改变，如果没有指定user，内定是root
- **-m**：改变身份时，不改变环境变量
- **user**：欲变更的用户名
- **args**：传入新的shell参数
### 示例
变更帐号为root并传入-f参数给新执行的shell

```
$ su root -f
```

变更帐号为TestUser并改变工作目录至TestUser的HOME目录

```
$ su - TestUser
```

## <a id="sudo">sudo</a>
### 描述
Execute a command as another user
### 功能
以其他身份来执行命令，预设的身份为root
### 语法

```
sudo -h|-K|-k|-V
sudo -v [-AknS] [-g group] [-h host] [-p prompt] [-u user]
sudo -l [-AknS] [-g group] [-h host] [-p prompt] [-U user] [-u user] [command]
sudo [-AbEHnPS] [-C num] [-g group] [-h host] [-p prompt] [-u user] [VAR=value] [-i|-s] [command]
sudoedit [-AknS] [-C num] [-g group] [-h host] [-p prompt] [-u user] file ...
```

### 选项参数
- **-A**：
- **-a type**：
- **-b**：在后台执行指令
- **-C num**：
- **-c class**：
- **-E**：
- **-e**：
- **-g group**：
- **-H**：将环境变数中的HOME目录指定为要变更身份的使用者HOME目录（如不加-u参数就是系统管理者root）
- **-h**：显示版本信息及命令说明
- **-h host**：
- **-i**：
- **-K**：
- **-k**：将会强迫使用者在下一次执行sudo时问密码（不论有没有超过N分钟）
- **-l**：显示执行sudo的使用者的权限
- **-n**：
- **-P**：
- **-p prompt**：可以更改问密码的提示语，其中%u会代换为使用者的帐号名称，%h会显示主机名称
- **-r role**：
- **-S**：
- **-s**：执行环境变数中的SHELL所指定的shell，或是/etc/passwd里所指定的shell
- **-t type**：
- **-U user**：
- **-u user**：不加此参数，代表要以root的身份执行命令，而加了此参数，可以以user的身份执行命令
- **-V**：显示版本信息
- **-v**：延长密码有效期限5分钟。因为sudo在第一次执行时或是在N分钟内没有执行（N预设为5）会问密码
- **command**：要执行的命令
- **file**：要执行的脚本文件

### 示例
指定用户执行命令

```
$ sudo -u TestUser ls -l
```

以root用户身份进行编辑文本

```
$ sudo vi test.html
```

## <a id="who">who</a>
### 描述
Display who is logged in
### 功能
显示目前登录系统的用户信息
### 语法

```
who [-abdHmqrsTu] [file]
```

### 选项参数
- **-a**：等价于-bdlprTtu
- **-b**：上次系统启动时间
- **-d**：打印死进程
- **-H**：显示标题
- **-m**：只打印当前终端的信息
- **-q**：快速模式，只列出当前登录的用户的名称和数量。使用此选项时，所有其他选项都将被忽略
- **-r**：打印当前的运行级别
- **-s**：使用简短的格式来显示
- **-T**：在用户名后打印字符：如果终端是可写的，则加上“+”；如果不可写，则加上“-”；如果遇到错误，则加上“？”
- **-u**：打印每个用户的空闲时间，以及相关的进程ID
- **file**：默认情况下，who命令从文件/var/run/utmpx提取信息，可以指定另一个文件

### 示例
显示当前登录系统的用户（显示标题栏）

```
$ who -H
USER     LINE     WHEN         
Kevin    console  Jan 10 07:29 
Kevin    ttys035  Jan 10 10:31 
Kevin    ttys036  Jan 10 10:45 
```

## <a id="whoami">whoami</a>
### 描述
Display effective user id
### 功能
显示当前用户名称
### 语法

```
whoami
```

### 选项参数
无
### 示例
显示用户名

```
$ whoami
Kevin
```

# <a id="文档编辑">文档编辑</a>
## <a id="cut">cut</a>
Cut out selected portions of each line of a file
## 功能
提取文件中每行的指定部分或字段
## 语法

```
cut -b list [-n] [file ...]
cut -c list [file ...]
cut -f list [-d delim] [-s] [file ...]
```

## 选项参数
- **-b list**：以字节为单位进行分割，list指定截取的字节位置（list可以用逗号“,”分隔指定多个位置或用连接符“-”指定连续的范围。要指定到行尾，可以留空连接符后面的数字）
- **-c list**：以字符为单位进行分割，list指定截取的字符位置（list可以用逗号“,”分隔指定多个位置或用连接符“-”指定连续的范围。要指定到行尾，可以留空连接符后面的数字）
- **-d delim**：使用delim作为分隔符。默认分隔符为制表符
- **-f list**：与-d一起使用，list指定显示分割后的区域位置（list可以用逗号“,”分隔指定多个位置或用连接符“-”指定连续的范围。要指定到行尾，可以留空连接符后面的数字）
- **-n**：与-b选项一起使用，不分割多字节字符（如果字符的最后一个字节落在由-b标志的list 参数指示的范围之内，该字符将被写出）
- **-s**：禁止没有字段分隔符的行。除非指定，否则没有分隔符的行将被忽略
- **file**：要处理的文件

## 示例
提取test.txt文件中每一行的第3个字节

```
$ cut -b 3 test.txt
```

打印test.txt文件中每行的第1个到第8个字符以及第18个字符之后的全部字符

```
$ cut -c 1-8,18- test.txt
```

显示当前计算机系统中所有用户名和其对应的HOME目录（即以“:”分割/etc/passwd文件中的每行并提取第1和第6个字段）

```
$ cut -d: -f1,6 /etc/passwd
```

## <a id="ed">ed</a>
### 描述
Text editor
### 功能
文本编辑（一次仅能编辑一行而非全屏幕）

### 语法

```
ed [-s|-] [-p string] [file]
```

### 选项参数
- **-s**：不执行开启文件时的检查功能
- **-p**：指定ed在命令模式的提示字符为string
- **file**：要编辑的文件

### 使用说明
#### 模式
- Command mode：命令模式（默认）。当处于文本输入模式时，在新的一行输入“.”并回车可以切换回命令模式
- Input mode：文本输入模式。可以使用内置命令a（Append）、c（Change）和i（Insert）切换到文本输入模式

#### 行地址
- **.**：显示缓冲区中的当前行
- **$**：显示缓冲区中的最后一行
- **n**：显示缓冲区中的第n行
- **-**：同\^，显示缓冲区中的前一行
- **-n**：同\^n，显示缓冲区中第n行的前一行
- **+**：显示缓冲区中的后一行
- **+n**：显示缓冲区中第n行的后一行
- **,**：同%，等价于1,$，显示缓冲区中的第一行到最后一行（全部行）
- **;**：等价于.,$，显示缓冲区中的当前行到最后一行
- **/re/**：显示缓冲区中匹配正则表达式re的下一行内容，可使用/重复执行
- **?re?**：显示缓冲区中匹配正则表达式re的上一行内容，可使用/重复执行
- **'lc**：显示缓冲区中使用k命令标记的行

#### 内置命令
- **(.)a**：切换到文本输入模式，在缓冲区的指定行（默认是当前行）之后追加新的内容
- **(.,.)c**：切换到文本输入模式，用输入的内容替换掉缓冲区中的指定行范围（默认是当前行）的内容
- **(.,.)d**：删除缓存区中指定行范围（默认是当前行）的文本内容
- **(.)i**：切换到文本输入模式，在缓冲区的指定行（默认是当前行）之前插入新的内容
- **(.,.)n**：打印缓冲区中指定范围行（默认是当前行）的行号和内容，当前地址设置为打印的最后一行
- **(.,.)p**：打印缓冲区中指定行范围（默认是当前行）的内容，设置当前行到打印的最后一行
- **q**：退出ed编辑器
- **Q**：退出ed编辑器，如果有未保存的修改不做提示
- **(.,.)s/re/replacement/[g|n]**：使用replacement替换缓冲区中指定范围（默认是当前行）与正则表达式re匹配的文本内容。g表示替换所有匹配项，数字n表示替换第n个匹配项，未指定g或n则只替换第一个匹配项
- **(1,$)w file**：将缓冲区中指定范围（默认是全部行）的内容以指定的文件名file写入文件，否则使用默认文件名
- **(1,$)wq file**：将缓冲区中指定范围（默认是全部行）的内容以指定的文件名file（没有则使用默认文件名）写入文件，完成后执行q命令（即退出ed编辑器）
- **(1,$)W file**：将缓冲区中指定范围（默认是全部行）的内容追加到指定的文件名file（没有则使用默认文件名）的后面

### 示例

```
//进入ed编辑器（默认进入命令模式）
$ ed
//切换到文本输入模式
a
//输入第一行内容
My name is Titan.
//输入第二行内容
And I love Perl very much.
//返回命令模式
.
//在最后一行之前插入内容
i
//将“I am 24.”插入“My name is Titan.”和“And I love Perl very much.”之间
I am 24.
//返回命令模式
.
//替换最后一行
c
//将“I am 24.”替换成“I am 24 years old.”
I am 24 years old.
//返回命令模式
.
//将文件命名为“readme.text”并保存
w test.txt
//退出ed编辑器
q
$
```

## <a id="paste">paste</a>
### 描述
Merge corresponding or subsequent lines of files
### 功能
将多个文件按照对应的行进行合并
### 语法

```
paste [-s] [-d list] file ...
```

### 选项参数
- **-d list**：使用一个或多个指定的字符来分隔输出行（默认使用制表符）。list中可以指定多个字符，第一个字符用于分隔第一个文件和第二个文件，第二个字符用于分隔第二个文件和第三个文件，以此类推。list是可以循环使用的，即如果文件数量多于list中列出的字符，则重新回到list的开头使用第一个字符
- **-s**：将指定单一文件的所有行进行连接。默认使用制表符分隔，除非使用-d选项指定分隔符
- **file**：要合并行内容的文件（file可以使用符号“-”表示从标准输入中获取内容）

### 示例
将文件test.txt、test1.txt、test2.txt进行合并

```
$ paste test.txt test1.txt test2.txt
```

将文件test.txt中的行合并为一行输出

```
$ paste -s test.txt
```

## <a id="sed">sed</a>
### 描述
Stream editor
### 功能
流编辑器（将指定命令应用在输入的每一行上，并将结果写入到标准输出）
### 语法

```
sed [-Ealn] command [file ...]
sed [-Ealn] [[-e command]...] [-f command_file] [-i extension] [file ...]
```

### 选项参数
- **-E**：使用扩展的正则表达式
- **-a**：延迟打开文件直到使用w命令
- **-e command**：使用command作为处理文本内容的操作（-e选项允许在同一行里执行多条命令）
- **-f command_file**：使用command_file文件中的内容作为处理文本内容的操作
- **-i extension**：以extension为扩展名备份文件。如果extension的长度为0，则不做备份（不推荐使用长度为0的扩展名，因为在磁盘空间用尽等情况下，部分内容可能会有损坏的风险）
- **-l**：缓冲输出行
- **-n**：仅输出处理后的结果（默认sed将输入的每一行都写入到标准输出中，不管其内容是否发生变化。-n选项一般和p命令搭配使用，p命令可以打印出符合指定范围或模式的所有行）
- **command**：处理文本的操作。如果没有指定，则使用标准输入
- **file**：待处理的文件

### 使用说明
#### 内置命令
- **a\\**：在当前行下面插入文本
- **i\\**：在当前行上面插入文本
- **c\\**：把选定的行改为新的文本
- **d**：删除选择的行
- **D**：删除模板块的第一行
- **s**：替换指定字符
- **h**：拷贝模板块的内容到内存中的缓冲区
- **H**：追加模板块的内容到内存中的缓冲区
- **g**：获得内存缓冲区的内容，并替代当前模板块中的文本
- **G**：获得内存缓冲区的内容，并追加到当前模板块文本的后面
- **l**：列表不能打印字符的清单
- **n**：读取下一个输入行，用下一个命令处理新的行而不是用第一个命令
- **N**：追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码
- **p**：打印模板块的行
- **P**：打印模板块的第一行
- **q**：退出sed
- **b lable**：分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾
- **r file**：从file中读行
- **t lable**：if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾
- **T label**：错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾
- **w file**：写并追加模板块到file末尾
- **W file**：写并追加模板块的第一行到file末尾
- **!**：表示后面的命令对所有没有被选定的行发生作用
- **=**：打印当前行号码
- **#**：把注释扩展到下一个换行符以前

#### 替换标记
- **g**：表示行内全面替换
- **p**：表示打印行
- **w**：表示把行写入一个文件
- **x**：表示互换模板块中的文本和缓冲区中的文本
- **y**：表示把一个字符翻译为另外的字符（但是不用于正则表达式）
- **\1**：子串匹配标记
- **&**：已匹配字符串标记

#### 元字符集（详见：[神兵利器之正则表达式](http://www.huajingzeng.com/post/神兵利器之正则表达式/)）
- **^**：匹配行开始
- **$**：匹配行结束
- **.**：匹配一个非换行符的任意字符
- **\***：匹配0个或多个字符
- **[]**：匹配一个指定范围内的字符
- **[\^]**：匹配一个不在指定范围内的字符
- **\\(..\\)**：匹配子串，保存匹配的字符
- **&**：保存搜索字符用来替换其他字符
- **\\<**：匹配单词的开始
- **\\>**：匹配单词的结束
- **x\\{m\\}**：重复字符x，m次
- **x\\{m,\\}**：重复字符x，至少m次
- **x\\{m,n\\}**：重复字符x，至少m次，不多于n次

### 示例
匹配file文件中每一行的第一个book替换为books

```
$ sed -i 's/book/books/g' file
```

将file文件中第3处匹配book的地方开始，替换为books

```
$ sed 's/book/books/3g' file
```

删除文件的第2行到末尾所有行

```
$ sed '2,$d' file
```

所有以192.168.0.1开头的行都会被替换成它自已加localhost

```
$ sed 's/^192.168.0.1/&localhost/' file
192.168.0.1localhost
```

将digit num替换为num

```
$ echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/'
```

替换test变量指定的内容（hello）替换为HELLO

```
$ test=hello
$ echo hello WORLD | sed "s/$test/HELLO"
HELLO WORLD
```

打印从第5行开始到第一个包含以test开始的行之间的所有行

```
$ sed -n '5,/^test/p' file
```

先删除第1行到第5行的内容，然后将test替换为check

```
$ sed -e '1,5d' -e 's/test/check/' file
```

file里的内容被读进来，显示在与test匹配的行后面，如果匹配多行，则file的内容将显示在所有匹配行的下面

```
$ sed '/test/r file' filename
```

在example中所有包含test的行都被写入file里

```
$ sed -n '/test/w file' example
```

在文件第2行之后插入this is a test line

```
$ sed -i '2a\this is a test line' file
```

将this is a test line追加到以test开头的行前面

```
$ sed '/^test/i\this is a test line' file
```

如果test被匹配，则移动到匹配行的下一行，替换这一行的aa，变为bb，并打印该行，然后继续

```
$ sed '/test/{ n; s/aa/bb/; }' file
```

把1~10行内所有abcde转变为大写（注意，正则表达式元字符不能使用这个命令）

```
$ sed '1,10y/abcde/ABCDE/' file
```

打印完第10行后，退出sed

```
$ sed '10q' file
```

把包含test与check的行互换

```
$ sed -e '/test/h' -e '/check/x' file
```

打印奇数行或偶数行

```
//奇数行
$ sed -n '1~2p' test.txt

//偶数行
$ sed -n '2~2p' test.txt
```


## <a id="sort">sort</a>
### 描述
Sort or merge records (lines) of text and binary files
### 功能
将文本文件进行排序，并将排序结果标准输出（默认按字母顺序升序排序，特殊字符按其编码排序）
### 语法

```
sort [-bcCdfghiRMmnrsuVz] [-k field1[,field2]] [-S memsize] [-T dir] [-t char] [-o output] [file ...]
```

### 选项参数
- **-b**：忽略每行前面开始出的空格字符
- **-c**：检查单个输入文件是否已排序。如果文件没有排序，将生成相应的错误消息，并返回1，否则返回0
- **-C**：同-c，不输出任何内容
- **-d**：排序时，除了英文字母、数字及空格字符外，忽略其他的字符
- **-f**：排序时，将小写字母视为大写字母
- **-g**：按一般数值排序。与-n相反，此选项可处理一般浮点数，但性能会下降
- **-h**：按数值排序，但使用人性化的单位后缀显示（k或K，以及M、G、T、P、E、Z、Y等）
- **-i**：排序时，除了040至176之间的ASCII字符外，忽略其他的字符（忽略非打印字符）
- **-R**：按随机顺序排序
- **-M**：将前面3个字母依照月份的缩写进行排序
- **-m**：将几个排序好的文件进行合并（输入文件被假定为已排序的）。如果没有排序，输出顺序是未定义的
- **-n**：依照数值的大小排序
- **-r**：以相反的顺序来排序
- **-s**：稳定排序
- **-u**：禁止所有具有与已处理过的key相等的行。如果使用-c或-C，排序检查没有重复键的行
- **-V**：按版本号排序
- **-z**：使用NUL作为记录分隔符。默认情况下，文件中的记录应该由换行符分隔。使用此选项时，空字符"\0"作为记录分隔符
- **-k field1[,field2]**：定义每行用于排序的起始字段field1和结束字段field2(可选)，如-k5表示对每行的第5个字段进行排序（字段之间默认是用空格或制表符分隔，如果要想使用其他分隔符，请结合-t选项使用）
- **-S memsize**：指定内容缓冲区的最大大小为memsize。可以使用单位有"%"，"B"，"K"，"M"，"G"，"T"，"P"，"E"，"Z"，"Y"。如果未指定大小，则默认使用内存的90%。如果文件太大，无法装入内存缓冲区，则使用临时磁盘文件执行排序
- **-T dir**：在目录dir中存储临时文件。默认路径是环境变量TMPDIR或/var/tmp（当TMPDIR未定义时）
- **-t char**：
- **-o output**：将输出打印到输出文件output，而不是标准输出（如果输入和输出文件不是同一个，可以使用输出重定向。但如果输入和输出文件都是同一个则只能使用-o选项指定输出文件，此时如果仍使用输出重定向，只会清空文件而不会写入任何内容）
- **file**：

### 示例
以默认的方式对文件的行进行排序

```
$ cat test.txt
test  
Hello  
Shell 
$ sort test.txt
$ cat test.txt
Hello  
Shell
test
```

## <a id="tr">tr</a>
### 描述
Translate characters
### 功能
转换或删除文件中的字符（只能处理单个字符，如果要处理多个字符，请使用sed）
### 语法

```
tr [-Ccsu] string1 string2
tr [-Ccu] -d string1
tr [-Ccu] -s string1
tr [-Ccu] -ds string1 string2
```

### 选项参数
- **-C**：反选设定字符。也就是符合string1的部份不做处理，不符合的剩余部份才进行转换
- **-c**：同-C
- **-d**：删除所有属于第一字符集string1的字符
- **-s**：缩减连续重复的字符成指定的单个字符
- **-u**：立即输出不做缓存
- **string1**：指定要转换或删除的原字符集
- **string2**：定要转换成的目标字符集（如果string1比string2长，则string2的最后一个字符被重复使用）

### 使用说明
#### 字符集合的范围
- **\\NNN**：NNN是字符的八进制值，如换行（LineFeed）的八进制表示为“\12”、 取消的八进制值为“\33”
- **\\a**：响铃（Bell），八进制值7
- **\\b**：退格符（Backspace），八进制值10
- **\\f**：换页(Formfeed)，八进制值14
- **\\n**：回车换行（Newline），八进制值12
- **\\r**：回车（Carriage Return），八进制值15
- **\\t**：制表符（Tab），八进制值11
- **\\v**：水平制表符
- **char1-char2**：字符范围从char1到char2的指定，范围的指定以ASCII码的次序为基础，只能由小到大，不能由大到小
- **[char\*]**：这是string2专用的设定，功能是重复指定的字符到与string1相同长度为止
- **[char*repeat]**：这也是string2专用的设定，功能是重复指定的字符到设定的repeat次数为止(repeat的数字采8进位制计算，以0为开始)
- **[:alnum:]**：所有字母字符与数字
- **[:alpha:]**：所有字母字符
- **[:blank:]**：所有水平空格
- **[:cntrl:]**：所有控制字符
- **[:digit:]**：所有数字
- **[:graph:]**：所有可打印的字符(不包含空格符)
- **[:lower:]**：所有小写字母
- **[:print:]**：所有可打印的字符(包含空格符)
- **[:punct:]**：所有标点字符
- **[:space:]**：所有水平与垂直空格符
- **[:upper:]**：所有大写字母
- **[:xdigit:]**：所有16进位制的数字
- **[=char=]**：所有符合指定的字符(等号里的char，代表你可自订的字符)

### 示例
将输入字符由大写转换为小写

```
$ tr 'A-Z' 'a-z' < file
```

删除数字字符

```
$ tr -d '0-9' < file
```

制表符转换为空格

```
$ tr '\t' ' ' < file
```

将重复出现的“s”字符替换为“s*”

```
$ tr -s 's*' < file
```

将小写字符替换成大写字符

```
$ tr '[:lower:]' '[:upper:]'
```

## <a id="uniq">uniq</a>
### 描述
Report or filter out repeated lines in a file
### 功能
查找或删除文件中的重复行（这里说的重复指的是连续出现的行）
### 语法

```
uniq [-c | -d | -u] [-i] [-f num] [-s chars] [input_file [output_file]]
```

### 选项参数
- **-c**：显示该行重复出现的次数
- **-d**：只把重复的行写入输出（这样的行只写入一次，不管连续出现多少次）
- **-f num**：忽略每个文件的第num个字段区域
- **-s chars**：忽略每个输入行的第一个字符chars
- **-u**：仅显示出现一次的行列
- **-i**：不区分大小写
- **input_file**：指定要去除的重复行文件。如果不指定此项，则从标准输入读取数据
- **output_file**：指定要去除重复行后的内容要写入的输出文件。如果不指定此选项，则将内容显示到标准输出设备（显示终端）

### 示例
删除重复行

```
$ uniq test.txt
$ sort test.txt | uniq
$ sort -u test.txt
```

只显示单一行

```
$ uniq -u test.txt
$ sort test.txt | uniq -u
```

统计各行在文件中出现的次数

```
$ sort test.txt | uniq -c
```

在文件中找出重复的行

```
$ sort test.txt | uniq -d
```

## <a id="vi">vi</a>
### 描述
Vi IMproved, a programmers text editor
### 功能
全屏幕纯文本编辑器
### 语法

```
vi [+num] [/patterns] [-AbCdDeEfFghHLlmMNnRsvxXyZ] [-c command] [-d device] [-i viminfo] [-r file] [-s scriptin] [-T terminal] [-u vimrc] [-U gvimrc] [-w|W scriptout] [file ...]
vi [+num] [/patterns] [-AbCdDeEfFghHLlmMNnRsvxXyZ] [-c command] [-d device] [-i viminfo] [-r file] [-s scriptin] [-T terminal] [-u vimrc] [-U gvimrc] [-w|W scriptout] -
vi [+num] [/patterns] [-AbCdDeEfFghHLlmMNnRsvxXyZ] [-c command] [-d device] [-i viminfo] [-r file] [-s scriptin] [-T terminal] [-u vimrc] [-U gvimrc] [-w|W scriptout] [-t tag]
vi [+num] [/patterns] [-AbCdDeEfFghHLlmMNnRsvxXyZ] [-c command] [-d device] [-i viminfo] [-r file] [-s scriptin] [-T terminal] [-u vimrc] [-U gvimrc] [-w|W scriptout] [-q errorfile]
```

### 选项参数
- **+ [num]**：光标定位于第一个文件的第num行，如果未指定num，则定位到最后一行
- **/patterns**：文本查找操作，用于从当前光标所在位置开始向文件尾部查找指定字符串的内容，查找的字符串会被加亮显示
- **-A**：如果支持ARABIC，则开启Arabic模式。如果不支持则退出并打印错误信息
- **-b**：以二进制模式打开文件，用于编辑二进制文件和可执行文件
- **-C**：兼容模式。使vim想vi那样工作，即使.vimrc文件存在
- **-d**：以diff模式打开文件，当多个文件编辑时，显示文件差异部分
- **-D**：在从脚本中执行第一个命令时，进入调试模式
- **-e**：在编辑器中使用ex模式
- **-E**：在编辑器中使用改良后的ex模式
- **-f**：编辑器只能在当前窗口下执行操作，知道退出为止
- **-F**：如果支持FKMAP，则开启Farsi模式。如果不支持则退出并打印错误信息
- **-g**：如果支持GUI，则将其开启。如果不支持则退出并打印错误信息
- **-h**：显示帮助信息
- **-H**：从右到左的编辑模式
- **-L**：等价于-r
- **-l**：模糊匹配模式
- **-m**：取消写文件功能，重设“write”选项
- **-M**：关闭修改功能
- **-N**：不兼容模式
- **-n**：不使用交换文件，崩溃时无法恢复
- **-R**：以只读方式打开文件
- **-s**：安静模式，不显示指令的任何错误信息
- **-v**：在vi模式下启动Vim
- **-x**：写入文件时进行加密
- **-X**：不要连接到X服务器。缩短终端中的启动时间，但窗口标题和剪贴板将不被使用
- **-y**：简单模式
- **-Z**：限制模式
- **-c command**：在完成对第一个文件编辑任务后，执行command命令
- **-d device**：在终端中打开device设备
- **-i viminfo**：使用viminfo代替默认的~/.viminfo，也可以指定名称为“NONE”来跳过.viminfo文件
- **-r file**：恢复模式。从指定文件file中恢复编辑状态和信息，file文件是以.swp结尾的
- **-s scriptin**：读取scriptin文件中的脚本并进行解析（就和你在终端中键入命令一样），同样的你也可以使用命令“:source!{scriptin}”进行读取。如果文件读取完后编辑器还未退出，你可以继续从终端输入命令字符进行操作
- **-T terminal**：告诉编辑器你正在使用的终端名称（一般只有在自动获取终端失败时才会用到）。terminal必须是vim能识别或者定义在文件termcap或者terminfo中的
- **-u vimrc**：使用gvimrc中的命令初始化，其他的初始化会被跳过。也可以指定名称“NONE”来跳过GUI初始化
- **-U gvimrc**：使用gvimrc中的命令初始化GUI，其他的初始化会被跳过。也可以指定名称“NONE”来跳过初始化
- **-w|W scriptout**：将所有字符写入scriptout指定的文件，-w选项会追加内容到已存在的scriptout文件，而-W会覆写整个scriptout文件
- **file**：要编辑的文件列表，第一个文件会被加载到缓冲区，光标将位于缓冲区的第一行上，可以使用“:next”命令跳转到其他文件
- **-**：要编辑的文件是从标准输入读取
- **-t tag**：要编辑的文件和初始光标位置取决于标签tag。这主要用于C程序，在这种情况下，tag可以是函数名。其效果是，包含该函数的文件成为当前文件，光标位于函数的开始位置
- **-q errorfile**：快速修复模式。读取错误文件并显示错误

### 使用说明
vi编辑器支持编辑模式和命令模式，编辑模式下可以完成文本的编辑功能，命令模式下可以完成对文件的操作命令
#### 工作方式
##### 命令方式
默认情况下在Shell提示符后输入命令vi，进入vi编辑器，并处于vi的命令方式。此时，从键盘上输入的任何字符都被作为编辑命令来解释。如果输入的字符不是vi的合法命令，则机器发出报警声，光标不移动。另外，在命令方式下输入的字符（即vi命令）并不在屏幕上显示出来
##### 输入方式
通过输入vi的插入命令i、附加命令a、打开命令o、替换命令s、修改命令c或取代命令r可以从命令方式进入输入方式。在输入方式下，从键盘上输入的所有字符都被插入到正在编辑的缓冲区中，被当做该文件的正文。进入输入方式后，输入的可见字符都在屏幕上显示出来，而编辑命令不再起作用，仅作为普通字母出现。  
由输入方式回到命令方式的办法是按下Esc键。如果已在命令方式下，那么按下Esc键就会发出嘟嘟声。为了确保用户想执行的vi命令是在命令方式下输入的，不妨多按几下Esc键，听到嘟声后再输入命令。  
##### ex转义方式
vi和ex编辑器的功能是相同的，二者的主要区别是用户界面。在vi中，命令通常是单个字母，如a、x、r等。而在ex中，命令是以Enter键结束的命令行。vi有一个专门的转义命令，可访问很多面向行的ex命令。为使用ex转义方式，可输入一个冒号:。作为ex命令提示符，冒号出现在状态行（通常在屏幕最下一行）。按下中断键（通常是Del键），可终止正在执行的命令。多数文件管理命令都是在ex转义方式下执行的（例如，读取文件，把编辑缓冲区的内容写到文件中等）。转义命令执行后，自动回到命令方式。

![	vi编辑器工作方式之间的转换](http://githubblog-1252104787.cosgz.myqcloud.com/vi%E7%BC%96%E8%BE%91%E5%99%A8%E5%B7%A5%E4%BD%9C%E6%96%B9%E5%BC%8F%E4%B9%8B%E9%97%B4%E7%9A%84%E8%BD%AC%E6%8D%A2.jpg)

#### 内置命令
![vi键盘图](http://githubblog-1252104787.cosgz.myqcloud.com/vi%E9%94%AE%E7%9B%98%E5%9B%BE.gif)

### 示例
编辑文件test.txt

```
$ vi test.txt
```

## <a id="wc">wc</a>
### 描述
Word, line, character, and byte count
### 功能
计算字数
### 语法

```
wc [-clmw] [file ...]
```

### 选项参数
- **-c**：显示字节数，使用此选项时-m无效
- **-l**：显示行数
- **-m**：显示字数
- **-w**：显示单词数
- **file**：要计算字数的文件

### 示例
统计text文件的字数
```
$ cat test
test
文件
$ wc test
1       2      11 test
```

# <a id="Shell脚本">Shell脚本</a>
## <a id="echo">echo</a>
### 描述
Write arguments to the standard output
### 功能
在shell中输出指定的字符串（建议使用printf）
### 语法

```
echo [-n] [string ...]
```

### 选项参数
- **-n**：不打印换行字符
- **string**：要输出的字符串

### 示例
echo命令打印文字“test”

```
echo "test"
```

## <a id="printf">printf</a>
### 描述
Formatted output
### 功能
格式化并输出结果到标准输出
### 语法

```
printf format [arguments ...]
```

### 选项参数
- **format**：指定数据输出时的格式
- **arguments**：指定要输出的数据

### 使用说明
#### 格式替代符

|替代符|说明|
| :---: | --- |
|%b|相对应的参数被视为含有要被处理的转义序列之字符串|
|%c|ASCII字符。显示相对应参数的第一个字符|
|%d, %i|十进制整数|
|%e, %E|浮点数，以指数形式“-x.xxx+-xx”表示|
|%f, %F|浮点数，以小数形式“-x.xxxxx”表示|
|%g|%e或%f转换，看哪一个较短，则删除结尾的零|
|%G|%E或%F转换，看哪一个较短，则删除结尾的零|
|%o|不带正负号的八进制值|
|%s|字符串|
|%u|不带正负号的十进制值|
|%x|不带正负号的十六进制值，使用a至f表示10至15|
|%X|不带正负号的十六进制值，使用A至F表示10至15|
|%%|字面意义的%|

#### 转义序列

|序列|说明|
| :---: | --- |
|\a|警告字符，通常为ASCII的BEL字符|
|\b|后退|
|\c|抑制（不显示）输出结果中任何结尾的换行字符（只在%b格式指示符控制下的参数字符串中有效），而且，任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符，都被忽略|
|\f|换页|
|\n|换行|
|\r|回车|
|\t|水平制表符|
|\v|垂直制表符|
|\\\\\\|字面意义的\\|
|\ddd|表示1到3位数八进制值的字符，仅在格式字符串中有效|
|\0ddd|表示1到3位的八进制值字符|

### 示例
打印字符串

```
$ printf "String:<%s>\n" "A\nB"
String:<A\nB>

$ printf "String:<%b>\n" "A\nB"
String:<A
B>

$ printf "String AB \a"
String AB $
```

# <a id="网络通讯">网络通讯</a>
## <a id="ping">ping</a>
### 描述
Send ICMP ECHO_REQUEST packets to network hosts
### 功能
测试主机之间网络的连通性（使用ICMP传输协议，发出要求回应的信息，若远端主机的网络功能没有问题，就会回应该信息，因而得知该主机运作正常）
### 语法

```
ping [-AaCDdfnoQqRrv] [-b boundif] [-c count] [-G sweepmaxsize] [-g sweepminsize] [-h sweepincrsize] [-i wait] [-k trafficclass] [-K netservicetype] [-l preload] [-M mask|time] [-m ttl] [-P policy] [-p pattern] [-S src_addr] [-s packetsize] [-t timeout] [-W waittime] [-z tos] [--apple-connect] [--apple-time] host
ping [-AaDdfLnoQqRrv] [-b boundif] [-c count] [-I iface] [-i wait] [-k trafficclass] [-K netservicetype] [-l preload] [-M mask|time] [-m ttl] [-P policy] [-p pattern] [-S src_addr] [-s packetsize] [-T ttl] [-t timeout] [-W waittime] [-z tos] [--apple-connect] [--apple-time] mcast-group
```

### 选项参数
- **-A**：当没有接收到数据包且在下一个数据包传输之前输出一个bell字符（ASCII 0x07）。由于传输的往返时间可能大于两次传输的间隔时间，因此只有当未接收的数据包的最大值增加时才会在丢包时输出bell字符
- **-a**：当接收到任意数据包时输出一个bell字符（ASCII 0x07），当指定其他选项时该选项被忽略
- **-b boundif**：将套接字绑定到接口boundif发送。此选项是苹果添加的
- **-C**：禁止套接字使用蜂窝网络接口。此选项是苹果添加的
- **-c count**：当发送或接收到指定个数（count）的数据包时停止。若未指定，ping将一直工作到中断。如果该选项与ping扫描一起指定，每个扫描包含数量为count的包
- **-D**：设置“不分片”（Don't Fragment）位
- **-d**：使用Socket的SO_DEBUG功能
- **-f**：极限检测。以最快的速度或每秒一百万次输出数据包。每发送一个ECHO_REQUEST以“.”间隔打印，每接收到一个ECHO_REPLY以空格间隔打印。此选项可快速显示数据包丢失数，但只有超级用户可以使用。这在网络上可能非常困难，应该谨慎使用
- **-G sweepmaxsize**：指定发送ping扫描时的最大ICMP数据大小为sweepmaxsize。此选项是ping扫描所必需的
- **-g sweepminsize**：指定开始发送ping扫描时的ICMP数据大小为sweepmaxsize。默认值是0
- **-h sweepincrsize**：指定每次扫描后ICMP数据的增量大小为sweepmaxsize字节。默认值是1
- **-I iface**：指定iface为多点传输的接口。此标志仅适用于ping目标是一个多站点地址时
- **-i wait**：指定收发信息的间隔时间wait。默认是在每个数据包之间等待一秒钟。等待时间可能是小数点，但只有超级用户可以指定小于0.1秒的值。此选项与-f选项不兼容
- **-k trafficclass**：指定用于发送ICMP数据包的传输类型。支持的类型有BK_SYS、BK、BE、RD、OAM、AV、RV、VI、VO和CTL等。默认情况下ping使用CTL。此选项是苹果添加的
- **-K netservicetype**：指定用于发送ICMP数据包的网络服务类型。支持的类型有BK_SYS、BK、BE、RV、AV、RD、OAM、VI、SIG和VO等。注意，这覆盖了默认的传输类型（-k仍然可以在-K之后使用）。此选项是苹果添加的
- **-L**：禁止多点传输回路。此标志仅适用于ping目标是一个多站点地址时
- **-l preload**：如果指定了preload，ping在进入正常模式之前会可能快地发送许多包。只有超级用户可以使用此选项
- **-M mask|time**：使用ICMP_MASKREQ或ICMP_TSTAMP代替ICMP_ECHO。指定mask时打印远程机器的子网掩码，设置net.inet.icmp.maskrepl MIB变量使ICMP_MASKREPLY生效。指定time时打印产生、接收和传输的时间戳
- **-m ttl**：为传输包设置时间ttl（IP Time To Live）。如果没有指定，内核默认使用net.inet.ip.ttl MIB变量的值
- **-n**：只输出数值。将不会尝试查找主机地址的符号名称
- **-o**：接收一个响应包后成功退出
- **-P policy**：为ping会话指定IPsec策略
- **-p pattern**：设置填满数据包的范本样式
- **-Q**：省略错误的输出。不要显示响应消息中的ICMP错误信息，默认情况下-v显示所有的错误信息
- **-q**：简略输出。不显示指令执行过程，开头和结尾的相关信息除外
- **-R**：记录路由过程。在ECHO_REQUEST中包含RECORD_ROUTE选项，并打印响应数据的路由缓存。注意，IP表头只允许存储9个路由表，traceroute命令能够用来确定把数据包带到特定目的地的最佳路由路径。如果有很多路由路径返回，如因非法伪造数据包，ping命令将打印路由表，然后将路由路径截断到最短。许多主机忽略或抛弃RECORD_ROUTE选项
- **-r**：忽略普通的Routing Table，直接将数据包送到远端主机上。如果主机不在直接连接的网络上，则返回错误。此选项可用于通过没有路由的接口对本地主机进行ping
- **-S src_addr**：
- **-s packetsize**：设置数据包的大小
- **-T ttl**：设置存活数值TTL的大小。此标志仅适用于ping目标是一个多站点地址时
- **-t timeout**：指定timeout秒为超时时间
- **-v**：详细显示指令的执行过程
- **-W waittime**：设置等待响应的时间为waittime毫秒。如果响应延迟到达，则该数据包不会打印为已响应，而是在计算统计数据时被视为已响应
- **-z tos**：使用指定的服务类型
- **--apple-connect**：将套接字连接到目标地址。此选项是苹果添加的
- **--apple-time**：打印接收到的包的时间。此选项是苹果添加的
- **host**：指定主机名称或IP地址
- **mcast-group**：指定主机群组名称或IP地址

### 示例
检测是否与主机连通，并指定多个参数

```
/*
-c 3 接收包的次数3次
-i 5 发送周期为5秒  
-s 1024 设置发送包的大小为1024字节
-t 255 设置TTL值为255秒
*/*
$ ping -c 3 -i 5 -s 1024 -t 255 192.168.1.1
PING 192.168.1.1 (192.168.1.1): 1024 data bytes
1032 bytes from 192.168.1.1: icmp_seq=0 ttl=255 time=1.779 ms
1032 bytes from 192.168.1.1: icmp_seq=1 ttl=255 time=1.624 ms
1032 bytes from 192.168.1.1: icmp_seq=2 ttl=255 time=1.544 ms

--- 192.168.1.1 ping statistics ---
3 packets transmitted, 3 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 1.544/1.649/1.779/0.098 ms
```


# <a id="搜索查找">搜索查找</a>
## <a id="find">find</a>
### 描述
Walk a file hierarchy
### 功能
在指定目录下查找文件
### 语法

```
find [-H|-L|-P] [-EXdsx] [-f fpath] path ... [expression]
find [-H|-L|-P] [-EXdsx] -f fpath [path ...] [expression]
```

### 选项参数
- **-E**：解析紧随-regex和-iregex之后字符串作为附加的正则表达式，
- **-H**：在命令行中指定的每个符号链接返回的文件信息和文件类型是链接引用的文件，而不是链接本身。如果引用文件不存在，则文件信息和类型将用于链接本身。命令行上所有符号链接的文件信息是链接本身的文件信息
- **-L**：每个符号链接返回的文件信息和文件类型是链接引用的文件，而不是链接本身。如果引用文件不存在，则文件信息和类型将用于链接本身
- **-P**：每个符号链接返回的文件信息和文件类型是链接本身。这是默认值
- **-X**：执行安全查找。如果文件名包含任何xargs的限制字符，则会输出标准错误信息，文件被跳过。限制字符为单引号“'”、双引号“"”、反斜线“\”、空格“ ”、制表符“\t”、换行符“\n”等
- **-d**：执行深度优先遍历，即先进入目录进行查找，再查找目录自身（默认情况下是先查找目录自身而不是目录中的内容）
- **-f fpath**：指定查找遍历的文件层次结构。文件层次结构也可以指定为紧跟在选项后面的操作
- **-s**：按字典顺序遍历文件的层次结构
- **-x**：防止进入与初始文件所在设备编号不同的目录查找
- **path**：查找文件的起始目录（在命令列上第一个“-( )”或“!()”之前的部份为path，之后的是 expression。如果path是空字串则使用目前路径，如果expression是空字串则使用-print为预设expression）
- **expression**：操作表达式
	- **-Bmin n**：在过去n分钟内被创建的文件
	- **-Bnewer file**：等价于-newerBm
	- **-Btime n[smhdw]**：在过去n个单位（默认单位d）内被创建的文件		- **s**：秒
		- **m**：分钟（60秒）
		- **h**：小时（60分钟）
		- **d**：天（24小时）
		- **w**：周（7天） 
	- **-acl**：可使用扩展的ACLs属性配合其他方式查找文件
	- **-amin n**：在过去n分钟内被读取过的文件
	- **-anewer file**：比文件file更晚被读取过的文件
	- **-atime n[smhdw]**：在过去n个单位（默认单位d）内被读取过的文件
		- **s**：秒
		- **m**：分钟（60秒）
		- **h**：小时（60分钟）
		- **d**：天（24小时）
		- **w**：周（7天）
	- **-cmin n**：在过去n分钟内变更过的文件
	- **-cnewer file**：比文件file更晚变更过的文件
	- **-ctime n[smhdw]**：在过去n个单位（默认单位d）内变更过的文件
		- **s**：秒
		- **m**：分钟（60秒）
		- **h**：小时（60分钟）
		- **d**：天（24小时）
		- **w**：周（7天）
	- **-d**：等价于depth
	- **-delete**：删除已找到的文件或目录
	- **-depth**：从指定目录下最深层的子目录开始查找
	- **-depth n**：从指定目录下第n层的子目录范围内开始查找
	- **-empty**：寻找文件大小为0 Byte的文件，或目录下没有任何子目录或文件的空目录
	- **-exec utility [argument ...] ;**：当find的返回值为true时就以argument作为参数执行utility命令
	- **-exec utility [argument ...] {} +**：同-exec，{}会被替换为find查找到的文件名
	- **-execdir utility [argument ...] ;**：同-exec，不同的是-execdir是在查找到的文件的当前目录下执行utility命令
	- **-execdir utility [argument ...] {} +**：同-execdir，{}会被替换为find查找到的文件名
	- **-flags [-|+]flags,notflags**：标志位为flags的文件，notflags为无标注位的文件
	- **-false**：find命令返回值设为false
	- **-fstype type**：文件系统为type的文件。lsvfs命令可以用来找出系统上可用的文件系统类型。此外，还有两个伪类型“local”和“rdonly”。前者与实际安装在查找执行系统的任何文件系统相匹配，后者与挂载的只读文件系统匹配。
	- **-gid n**：群组ID为n的文件
	- **-group gname**：群组名为gname的文件
	- **-ignore_readdir_race**：
	- **-ilname pattern**：同-lname（忽略大小写）
	- **-iname pattern**：同-name（忽略大小写）
	- **-inum n**：inode为n的文件
	- **-iregex pattern**：匹配正则表达式pattern的文件（忽略大小写）
	- **-iwholename pattern**：同-wholename pattern（忽略大小写）
	- **-links n**：有n个链接的文件
	- **-lname pattern**：匹配正则表达式pattern的符号链接
	- **-ls**：当find的返回值为true时就将文件或目录名称列出到标准输出
	- **-maxdepth n**：设置最大目录层级n
	- **-mindepth n**：设置最小目录层级n
	- **-mmin n**：在过去n分钟内被修改过的文件
	- **-mnewer file**：比文件file更晚被修改过的文件
	- **-mount**：在同一个文件系统下
	- **-mtime n[smhdw]**：在过去n个单位（默认单位d）内被修改过的文件
	- **-name pattern**：文件名为name的文件
	- **-newer file**：比文件file更晚被修改过的文件
	- **-newerXY file**：比文件file更晚被访问过的文件
	- **-nogroup**：不属于本地主机群组的文件
	- **-noignore_readdir_race**：用于GNU查找兼容性，此选项被忽略
	- **-noleaf**：用于GNU查找兼容性，它禁用了一个与查找无关的优化，此选项被忽略
	- **-nouser**：不属于本地主机用户的文件
	- **-ok utility [argument ...] ;**：同-exec，但在执行utility命令前会先询问用户
	- **-okdir utility [argument ...] ;**：同-execdir，但在执行utility命令前会先询问用户
	- **-path pattern**：路径匹配pattern的文件
	- **-perm [-|+]mode**：符合指定权限mode的文件
	- **-print**：当find的返回值为true时就将文件列出到标准输出，格式为每行一个名称，每个名称前皆有“./”字符串
	- **-print0**：同-print，格式为全部的名称皆在同一行
	- **-prune**：不要向下查找，总是返回ture。如果指定-d选项，则此表达式无效
	- **-regex pattern**：匹配正则表达式pattern的文件
	- **-samefile name**：硬链接名称为name的文件。如果指定-L选项，则同时查找符号链接为name的文件
	- **-size n[ckMGTP]**：文件大小为n个单位（默认单位）的文件
		- **c**：字符（1 bytes）
		- **k**：kB（1024 bytes）
		- **M**：MB（1024 kB）
		- **G**：GB（1024 MB）
		- **T**：TB（1024 GB）
		- **P**：PB（1024 TB）
	- **-true**：find命令的返回值设置为true
	- **-type t**：文件类型为t的文件
		- **b**：块设备
		- **c**：字符设备
		- **d**：目录（文件夹）
		- **f**：普通文件
		- **l**：符号链接
		- **p**：FIFO（输入输出）
		- **s**：套接字
	- **-uid n**：用户ID为n的文件
	- **-user uname**：用户名为uname的文件
	- **-wholename pattern**：同-path，用于GNU查找的兼容性
	- **-xattr**：有扩展名的文件
	- **-xattrname name**：扩展名是name的文件
	
### 使用说明

#### 操作表达式的使用
| expression | 说明 |
| :---: | --- |
|**(** expression **)**|分隔符|
|**!** expression<br>**-not** expression|逻辑非运算|
|expression **-and** expression<br>expression expression|逻辑与运算|
|expression **-or** expression|逻辑或运算|

### 示例
在当前目录及子目录下查找所有以.txt和.pdf结尾的文件

```
//等价于 find . -name "*.txt" -o -name "*.pdf"
$ find . \( -name "*.txt" -o -name "*.pdf" \)
```

找出/home下不是以.txt结尾的文件

```
$ find /home ! -name "*.txt"
```

找出当前目录下文件类型为符号链接的文件

```
$ find . -type l
```

搜索出深度距离当前目录至少2个子目录的所有文件

```
$ find . -mindepth 2 -type f
```

搜索恰好在七天前被访问过的所有文件

```
$ find . -type f -atime 7
```

搜索大于10KB的文件

```
$ find . -type f -size +10k
```

删除当前目录下所有.txt文件

```
$ find . -type f -name "*.txt" -delete
```

找出当前目录下权限不是644的php文件

```
$ find . -type f -name "*.php" ! -perm 644
```

找出当前目录下所有root的文件，并把所有权更改为用户TestUser

```
$ find .-type f -user root -exec chown TestUser {} \;
```

查找当前目录或者子目录下所有.txt文件，但是跳过子目录sk

```
$ find . -path "./sk" -prune -o -name "*.txt" -print
```

列出所有长度为零的文件

```
$ find . -empty
```

## <a id="grep">grep</a>
### 描述
File pattern searcher
### 功能
在一个或多个文件搜索指定的模式，并输出匹配的行（多个文件时，文件名会出现在输出行的每行之前）
### 语法

```
grep [-abcdDEFGHhIiJLlmnOopqRSsUVvwxZ] [-A num] [-B num] [-C[num]] [-e pattern] [-f file] [--binary-files=value] [--color[=when]] [--context[=num]] [--label] [--line-buffered] [--null] [pattern] [file ...]
```

### 选项参数
- **-A num**：同时输出匹配内容之后的num行内容
- **-a**：不要忽略二进制数据，将所有文件视为ASCII文本
- **-B num**：同时输出匹配内容之前的num行内容
- **-b**：输出匹配内容的第一个字符的偏移量（单位为字节）
- **-C[num]**：同时输出匹配内容之前和之后的num行内容（num的默认值是2）
- **-c**：只输出选定行数而不是文本内容
- **-D action**：为设备、FIFO或套接字指定操作action。默认值是read，表示按照正常文件读取。如果设置为skip，则跳过这些设备、FIFO或套接字
- **-d action**：为目录指定操作action。默认值是read，表示按照正常文件读取。如果设置为skip，则跳过目录。如果设置为recurse，则递归读取，此时等价于-R和-r选项
- **-E**：转为以egrep命令执行
- **-e pattern**：使用pattern匹配文本内容，匹配内容将作为输入行
- **-F**：转为以fgrep命令执行
- **-f file**：从file文件读取匹配表达式。文件中的空行表示匹配所有输入行，换行符不作为匹配内容。当file文件为空时，不匹配任何内容
- **-G**：普同匹配模式
- **-H**：在输出每个匹配内容之前打印文件名
- **-h**：在输出每个匹配内容之前不打印文件名
- **-I**：忽略二进制文件。等价于--binary-file=without-match选项
- **-i**：匹配时不区分大小写。默认情况下，搜索是大小写敏感的
- **-J**：使用bzip解压缩file文件后再执行匹配
- **-L**：只输出文件内容不匹配的文件名
- **-l**：只输出文件内容匹配的文件名
- **-m num**：在匹配num次后停止读取
- **-n**：在输出的每行前面打印该内容在文件中的行号。每个文件的行号从1开始。如果指定-c、-L、-l或者-q则此选项无效
- **-O**：如果指定-R选项，则只有当符号链接在command line中列出时才进行追踪。默认情况下不追踪符号链接
- **-o**：只打印输出匹配行中的匹配内容
- **-p**：如果指定-R选项，则不追踪任何符号链接（这是默认选项）
- **-q**：快速模式。不显示任何信息
- **-R**：递归搜索子目录
- **-r**：同-R
- **-S**：如果指定-R选项，则追踪所有的符号链接。默认情况下不追踪符号链接
- **-s**：静音模式。不显示错误信息
- **-U**：搜索二进制文件，但不打印他们
- **-V**：显示版本信息
- **-v**：反转查找（检索不匹配内容）
- **-w**：只显示全部字都匹配的内容
- **-x**：只显示全部行都匹配的内容
- **-y**：等价于-i，已作废
- **-Z**：转为以zgrep命令执行
- **-z**：转为以zgrep命令执行
- **--colour=[when]**：使用存储在环境变量GREP_COLOR中的颜色标记匹配的内容，when有以下可选值
	- **never**：从不
	- **always**：总是
	- **auto**：自动
- **--binary-files=value**：搜索和打印二进制文件，value有以下可选值
	- **binary**：只搜索二进制文件但不打印输出（默认值）
	- **without-match**：不要搜索二进制文件
	- **text**：将所有文件视为文本
- **--context[=num]**：输出前面num行和最后的num行（num默认值为2）
- **--line-buffered**：强制输出为行缓冲。默认情况下，当标准输出为终端时，输出是行缓冲的，否则块将被缓冲
- **--null**：在文件名之后打印一个零字节
- **pattern**：用来匹配的正则表达式
- **file**：要执行匹配的文件

### 示例
在当前目录中，查找前缀有test字样的文件中包含test字符串的文件，并打印出该字符串的行

```
$ grep test test*
test.txt:This a shell test
test1.txt:This is a shell test
test2.txt:test
```

以递归的方式查找当前目录及其子目录（如果存在子目录的话）下所有文件中包含字符串"test"的文件，并打印出该字符串所在行的内容

```
$ grep -r test1 . 
./test/test.txt:This a shell test
./test/test1.txt:This is a shell test
./test/test2.txt:test
```

查找文件名中包含test的文件中不包含test的行

```
$ grep -v test *test*
test1.txt:ABCDEFG
test1.txt:HIJKLMN
test1.txt:OPQRST
test1.txt:UVWXYZ
test2.txt:abcdefg
test2.txt:hijklmn
test2.txt:opqrst
test2.txt:uvwxyz
```

## <a id="whereis">whereis</a>
### 描述
Locate programs
### 功能
定位指令的二进制程序、源代码文件和man手册页等相关文件的路径
### 语法

```
whereis [program ...]
```

### 选项参数
- **program**：要查找的程序

### 示例
查看指令"bash"的位置

```
$ whereis bash 
/bin/bash
```

## <a id="which">which</a>
### 描述
Locate a program file in the user's path
### 功能
在环境变量PATH设置的目录里查找符合条件的程序
### 语法

```
which [-as] program ...
```

### 选项参数
- **-a**：列出所有找到的路径（默认情况下只打印第一个）
- **-s**：无任何输出。当所有的文件都找到时返回0，否则返回1
- **program**：要查找的程序

### 示例
查找显示命令pwd的路径

```
$ which pwd 
/bin/pwd
```

# <a id="其他">其他</a>
## <a id="clear">claer</a>
### 描述
Clear the terminal screen
### 功能
清除当前屏幕终端上的任何信息
### 语法

```
clear
```

### 选项参数
无
### 示例
清屏
```
$ clear
```

## <a id="date">date</a>
### 描述
Display or set date and time
### 功能
显示或设置系统时间与日期
### 语法

```
date [-jRu] [-r seconds|filename] [-v [+|-]val[ymwdHMS]] ... [+output_fmt]
date [-jnu] [[[mm]dd]HH]MM[[cc]yy][.ss]
date [-jnRu] -f input_fmt new_date [+output_fmt]
date [-d dst] [-t minutes_west]
```

### 选项参数
- **-d dst**：为夏时制设置内核的值。如果dst是非零值，则以后调用gettimeofday函数会返回一个非零值tz_dsttime
- **-f input\_fmt new\_date**：使用input\_fmt为格式字符串（默认使用的格式是[[[mm]dd]HH]MM[[cc]yy][.ss] ）解析new\_date
	- **cc**：世纪，19或20
	- **yy**：年，00~99（89->1989，06->2006）
	- **mm**：月，1~12
	- **dd**：日，1~31
	- **HH**：时，0~23
	- **MM**：分，0~59
	- **ss**：秒，0~59
- **-j**：不要尝试设定日期，此时可以使用+选项来将一种日期格式（input\_fmt或默认格式）转换为另一种日期格式（output\_fmt）
- **-n**：默认选项。如果正在运行定时任务，则date命令会设置本地组中所有设备的时间。-n选项会抑制此行为，并导致只在当前机器上设置时间
- **-R**：使用RFC 2822日期和时间输出格式。当LC_TIME变量设置为C时，这相当于使用“%a, %d %b %Y %T %z”作为输出格式
- **-r seconds**：以seconds为时间戳（以00:00:00 UTC, January 1, 1970为基准开始计算）打印日期和时间
- **-r filename**：打印文件filename最后一次修改的日期和时间
- **-t minutes_west**：设置系统的GMT（格林尼治时间）
- **-u**：显示或设置UTC（协调世界时，又称世界统一时间、世界标准时间、国际协调时间）
- **-v [+|-]val[ymwdHMS]**：根据val调整当前日期和时间并显示（仅显示而不做设定）。如果val指定符号“+”或“-”，则向前或向后调整时间，否则就以val为值设置。
	- **y**：指定设置年，80~38或1980~2038
	- **m**：指定设置月，1~12
	- **w**：指定设置星期，0~6（Sun~Sat）
	- **d**：指定设置日，1~31
	- **H**：指定设置小时，0~23
	- **M**：指定设置分钟，0~59
	- **S**：指定设置秒，0~59

### 使用说明
#### 时间格式

|格式符|说明|
| :---: | --- |
|%|印出%|
|%n|下一行|
|%t|跳格|
|%H|小时（00~23）|
|%I|小时（01~12）|
|%k|小时（0~23）|
|%l|小时（1~12）|
|%M|分钟（00~59）|
|%p|显示本地AM或PM|
|%r|直接显示时间（12小时制，格式为 hh:mm:ss [AP]M）|
|%s|从1970年1月1日 00:00:00 UTC到目前为止的秒数|
|%S|秒（00~61）|
|%T|直接显示时间（24小时制）|
|%X|相当于%H:%M:%S|
|%Z|显示时区|

#### 日期格式

|格式符|说明|
| :---: | --- |
|%a|星期几（Sun~Sat）|
|%A|星期几（Sunday~Saturday）|
|%b|月份（Jan~Dec）|
|%B|月份（January~December）|
|%c|直接显示日期与时间|
|%d|日（01~31）|
|%D|直接显示日期（mm/dd/yy）|
|%h|同%b|
|%j|一年中的第几天（001~366）|
|%m|月份（01~12）|
|%U|一年中的第几周（00~53）（以Sunday为一周的第一天的情形）|
|%w|一周中的第几天（0~6）|
|%W|一年中的第几周（00~53）（以Monday为一周的第一天的情形）|
|%x|直接显示日期（mm/dd/yy）|
|%y|年份的最后两位数字（00.99）|
|%Y|完整年份（0000~9999）|

### 示例
显示当前时间
```
$ date
三 5月 12 14:08:12 CST 2010

$ date '+%c' 
2010年05月12日 星期三 14时09分02秒

//显示完整的时间
$ date '+%D' 
05/12/10

//显示数字日期，年份两位数表示
$ date '+%x' 
2010年05月12日

//显示日期，年份用四位数表示
$ date '+%T' 
14:09:31

//显示24小时的格式
$ date '+%X' 
14时09分39秒
```

按自己的格式输出

```
$ date '+usr_time: $1:%M %P -hey'
usr_time: $1:16 下午 -hey
```

## <a id="man">man</a>
### 描述
Format and display the on-line manual pages
### 功能
查看命令、配置文件和编程等帮助信息
### 语法

```
man [-acdfFhkKtwW] [-m system] [-p string] [-C config_file] [-M pathlist] [-P pager] [-B browser] [-H htmlpager] [-S section_list] [section] name ...
```

### 选项参数
- **-a**：强制显示匹配name的所有帮助页面，而不仅仅是第一个（默认情况下，在显示第一个帮助页面后将退出）
- **-c**：当更新页面存在时重新格式化帮助页面
- **-d**：不显示帮助页面，只打印调试信息
- **-f**：等价于whatis
- **-F**：只做格式化，不显示
- **-h**：打印帮助信息并退出
- **-k**：等价于apropos
- **-K**：在所有的帮助页面中搜索指定的字符串section，指定该选项会减慢搜索速度
- **-t**：使用/usr/bin/groff格式化帮助页面到标准输出
- **-w**：[--path]不显示帮助页面，而是打印或显示的文件的位置。如果没有给出参数：则显示搜索帮助页面的目录列表
- **-W**：同-W，但在每行打印文件名，没有额外的信息
- **-m**：在给定的系统名称system下搜索帮助页面
- **-p**：指定执行的预处理器
- **-C**：使用config_file作为配置文件，默认配置文件是/private/etc/man.conf
- **-M**：指定用来搜索man页面的目录列表，多个目录用冒号分隔，空列表与未指定-M选项相同
- **-P**：指定要使用的pager。此选项将覆盖环境变量MANPAGER，从而改变变量PAGER。默认情况下，使用/usr/bin/less
- **-B**：指定要打开HTML文件的浏览器browser。此选项覆盖环境变量BROWSER。默认情况下，使用/usr/bin/less
- **-H**：指定将HTML文件作为文本呈现的命令。此选项将覆盖环境变量HTMLPAGER。默认情况下，使用/bin/cat，
- **-S**：指定手动搜索列表section_list，列表项用冒号分隔。此选项将覆盖环境变量MANSECT
- **section**：指定要显示的章节
- **name**：要显示帮助的名称

### 示例
显示cd命令的帮助手册

```
$ man cd
```

## <a id="uname">uname</a>
### 描述
Print operating system name
### 功能
打印当前系统相关信息
### 语法

```
uname [-amnprsv]
```

### 选项参数
- **-a**：显示全部的信息，等价于-mnrsv
- **-m**：显示硬件名称
- **-n**：显示在网络上的主机名称
- **-p**：输出处理器类型或"unknown"
- **-r**：显示操作系统的发行编号
- **-s**：显示操作系统名称（默认缺省）
- **-v**：显示操作系统的版本

### 示例
显示操作系统的全部信息

```
$ uname
Darwin mini.local 17.3.0 Darwin Kernel Version 17.3.0: Thu Nov  9 18:09:22 PST 2017; root:xnu-4570.31.3~1/RELEASE_X86_64 x86_64
```

## <a id="whatis">whatis</a>
### 描述
Search the whatis database for complete words
### 功能
查询命令执行什么功能，并将查询结果打印到终端上
### 语法

```
whatis keyword ...
```

### 选项参数
- **keyword**：要查询的关键词

### 示例
查询cp命令的功能

```
$ whatis cp
gcp(1), cp(1)            - copy files and directories
cp(1)                    - copy files
```


**PS：持续更新中……**

**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
