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
thumbnail: /img/thumbnail/4.jpg
blogexcerpt: 
---

&emsp;&emsp;本人当前开发基本都是用苹果电脑（Mac），开发过程中难免要与命令行工具（Command Line Tools）打交道，因此掌握一些基本的Shell命令是必须的。

&emsp;&emsp;不同的Shell具备不同的功能，流行的Shell有：bash、csh、ksh、sh、tcsh、zsh等。可以进入/bin目录查看，以sh结尾的可执行文件即Shell脚本解析程序。本人Mac系统默认使用/bin/bash，bash也是目前大多数Linux系统默认使用的Shell，因此以下命令及参数均以bash为准。

<!--more-->

# 汇总表
| 分类 | 命令 |
| --- | --- |
| <div style="text-align:center;"><a href="#1">文件管理</a></div> | **<a href="#cat">cat</a>**&emsp;**<a href="#cd">cd</a>**&emsp;**<a href="#chgrp">chgrp</a>**&emsp;**<a href="#chmod">chmod</a>**&emsp;**<a href="#chown">chown</a>**&emsp;**<a href="#cksum">cksum</a>**&emsp;**<a href="#cmp">cmp</a>**&emsp;**<a href="#cp">cp</a>**&emsp;**<a href="#du">du</a>**&emsp;**<a href="#df">df</a>**&emsp;**<a href="#fsck">fsck</a>**&emsp;**<a href="#fuser">fuser</a>**&emsp;**<a href="#ln">ln</a>**&emsp;**<a href="#ls">ls</a>**&emsp;<a href="#lsof">lsof</a>&emsp;**<a href="#mkdir">mkdir</a>**&emsp;<a href="#mount">mount</a>&emsp;**<a href="#mv">mv</a>**&emsp;**<a href="#pwd">pwd</a>**&emsp;**<a href="#rm">rm</a>**&emsp;**<a href="#rmdir">rmdir</a>**&emsp;**<a href="#split">split</a>**&emsp;**<a href="#touch">touch</a>**&emsp;**<a href="#umask">umask</a>** |
| <div style="text-align:center;"><a href="#2">程序进程</a></div> | <a href="#at">at</a>&emsp;<a href="#bg">bg</a>&emsp;<a href="#chroot">chroot</a>&emsp;<a href="#cron">cron</a>&emsp;<a href="#exit">exit</a>&emsp;<a href="#fg">fg</a>&emsp;<a href="#jobs">jobs</a>&emsp;<a href="#kill">kill</a>&emsp;<a href="#killall">killall</a>&emsp;<a href="#nice">nice</a>&emsp;<a href="#pgrep">pgrep</a>&emsp;<a href="#pidof">pidof</a>&emsp;<a href="#pkill">pkill</a>&emsp;<a href="#ps">ps</a>&emsp;<a href="#pstree">pstree</a>&emsp;<a href="#sleep">sleep</a>&emsp;<a href="#time">time</a>&emsp;<a href="#top">top</a>&emsp;<a href="#wait">wait</a> |
| <div style="text-align:center;"><a href="#3">系统环境</a></div> | <a href="#env">env</a>&emsp;<a href="#finger">finger</a>&emsp;<a href="#id">id</a>&emsp;<a href="#logname">logname</a>&emsp;<a href="#mesg">mesg</a>&emsp;<a href="#passwd">passwd</a>&emsp;<a href="#su">su</a>&emsp;<a href="#sudo">sudo</a>&emsp;<a href="#uptime">uptime</a>&emsp;<a href="#w">w</a>&emsp;<a href="#wall">wall</a>&emsp;<a href="#who">who</a>&emsp;<a href="#whoami">whoami</a>&emsp;<a href="#write">write</a> |
| <div style="text-align:center;"><a href="#4">文档编辑</a></div> | <a href="#awk">awk</a>&emsp;<a href="#comm">comm</a>&emsp;<a href="#cut">cut</a>&emsp;**<a href="#ed">ed</a>**&emsp;<a href="#ex">ex</a>&emsp;<a href="#fmt">fmt</a>&emsp;<a href="#head">head</a>&emsp;<a href="#iconv">iconv</a>&emsp;<a href="#join">join</a>&emsp;<a href="#less">less</a>&emsp;<a href="#more">more</a>&emsp;<a href="#paste">paste</a>&emsp;<a href="#sed">sed</a>&emsp;<a href="#sort">sort</a>&emsp;<a href="#strings">strings</a>&emsp;<a href="#talk">talk</a>&emsp;<a href="#tac">tac</a>&emsp;<a href="#tail">tail</a>&emsp;<a href="#tr">tr</a>&emsp;<a href="#uniq">uniq</a>&emsp;<a href="#vi">vi</a>&emsp;<a href="#wc">wc</a>&emsp;<a href="#xargs">xargs</a> |
| <div style="text-align:center;"><a href="#5">Shell脚本</a></div> | <a href="#alias">alias</a>&emsp;<a href="#basename">basename</a>&emsp;<a href="#dirname">dirname</a>&emsp;<a href="#echo">echo</a>&emsp;<a href="#expr">expr</a>&emsp;<a href="#false">false</a>&emsp;<a href="#printf">printf</a>&emsp;<a href="#text">text</a>&emsp;<a href="#true">true</a>&emsp;<a href="#unset">unset</a> |
| <div style="text-align:center;"><a href="#6">网络通讯</a></div> | <a href="#inetd">inetd</a>&emsp;<a href="#netstat">netstat</a>&emsp;<a href="#ping">ping</a>&emsp;<a href="#rlogin">rlogin</a>&emsp;<a href="#netcat">netcat</a>&emsp;<a href="#traceroute">traceroute</a> |
| <div style="text-align:center;"><a href="#7">搜索查找</a></div> | <a href="#find">find</a>&emsp;<a href="#grep">grep</a>&emsp;<a href="#locate">locate</a>&emsp;<a href="#whereis">whereis</a>&emsp;<a href="#which">which</a> |
| <div style="text-align:center;"><a href="#8">其他</a></div> | <a href="#apropos">apropos</a>&emsp;<a href="#banner">banner</a>&emsp;<a href="#bc">bc</a>&emsp;<a href="#cal">cal</a>&emsp;<a href="#clear">clear</a>&emsp;<a href="#date">date</a>&emsp;<a href="#dd">dd</a>&emsp;<a href="#file">file</a>&emsp;<a href="#help">help</a>&emsp;<a href="#info">info</a>&emsp;<a href="#size">size</a>&emsp;<a href="#lp">lp</a>&emsp;**<a href="#man">man</a>**&emsp;<a href="#history">history</a>&emsp;<a href="#tee">tee</a>&emsp;<a href="#tput">tput</a>&emsp;<a href="#type">type</a>&emsp;<a href="#yes">yes</a>&emsp;<a href="#uname">uname</a>&emsp;<a href="#whatis">whatis</a> |

# <a id="1">文件管理</a>

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
cat -n test.txt
```
把test1.txt和test2.txt的文档内容加上行号（空白行不加）之后将内容附加到test3.txt文档里
```
cat -b test1.txt test2.txt >> test3.txt
```
清空/etc/test.txt文档内容
```
cat /dev/null > /etc/test.txt
```
从软盘fd0制作镜像文件test.dmg
```
cat /dev/fd0 > test.dmg
```
把镜像文件test.dmg写到软盘fd0
```
cat test.dmg > /dev/fd0
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
cd /usr/bin
```
跳到自己的Home目录
```
cd ~
```
跳到当前目录的上两层
```
cd ../..
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
chgrp -v TestGroup test.txt
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
chmod ugo+r test.txt
chmod a+r test.txt
```
将文件test1.txt与test2.txt设为该文件拥有者，与其所属同一个群体者可写入，但其他以外的人则不可写入
```
chmod ug+w,o-w test1.txt test2.txt
```
将test.out设定为只有该文件拥有者可以执行
```
chmod u+x test.out
```
将目前目录下的所有文件与子目录皆设为任何人可读取
```
chmod -R a+r *
```
将文件test.out设为该文件拥有者，与其所属同一个群体者可读写执行，但其他以外的人则不可仅可读取不可写入和执行
```
chmod ug=rwx,o=r test.out
chmod 774 test.out
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
chown :TestGroup test.txt
```
将当前目录下的所有文件与子目录的所有者和群组皆设为用户TestUser和群组TestGroup
```
chown -R TestUser:TestGroup *
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
cksum test.txt
//3311261222 35 test.txt
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
cmp test1.txt test2.txt
//test1.txt test2.txt differ: char 1, line 1
```
从第7个字符位置开始比较test1.txt和test2.txt。显示所有不同的位置及对应的字符
```
cmp -cl -i 6 test1.txt test2.txt
/*
 1 107 G    147 g
14 117 O    157 o
15 120 P    160 p
16 121 Q    161 q
26 130 X    170 x
27 131 Y    171 y
28 132 Z    172 z
*/
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
cp -r test1 test2
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
du
```
显示指定文件所占空间
```
du test.txt
```
方便阅读的格式显示test目录所占空间情况
```
du -h test
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
df
```
显示磁盘使用的文件系统信息
```
df test
```
输出显示inode信息而非块使用量
```
df -i
```
显示所有的信息
```
df -a
```
产生可读的格式df命令的输出
```
df -h
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
fuser -u test
/*
test: 593(Kevin)
test1: 
test2:
*/
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
ln -s test.txt test
```
为test.txt文件创建硬链接test，test.txt与test的各项属性相同
```
ln test.txt test
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
ls /
```
列出当前工作目录下所有名称是s开头的文件，越新的排越后面
```
ls -ltr s*
```
将/bin目录以下所有目录及文件详细资料列出
```
ls -lR /bin
```
列出当前工作目录下所有文件及目录，目录于名称后加"/", 可执行档于名称后加"*"
```
ls -AF
```

## <a id="lsof">lsof</a>
### 描述
List open files
### 功能
列出当前系统打开文件的工具
### 语法
```
lsof  [-?abChKlnNOPRtUvVX] [-A A] [-c c] [+c c] [+|-d d] [+|-D D] [+|-e s] [+|-E] [+|-f [cfgGn]] [-F [f]] [-g [s]] [-i [i]] [-k k] [+|-L [l]] [+|-m m] [+|-M] [-o [o]] [-p s] [+|-r [t[m<fmt>]]] [-s [p:s]] [-S [t]] [-T [t]] [-u u] [+|-w] [-x [fl]] [-z [z]] [-Z [Z]] [--] [names]
```
### 选项参数
- **-?**：同-h，在遇到错误时显示简短的帮助信息
- **-a**：
- **-b**：
- **-C**：
- **-h**：同-?
- **-K**：
- **-l**：
- **-n**：
- **-N**：
- **-O**：
- **-P**：
- **-R**：
- **-t**：
- **-U**：
- **-v**：
- **-V**：
- **-X**：
- **-A**：
- **-c**：
- **+|-d**：
- **+|-D**：
- **+|-e**：
- **+|-f**：
- **-F**：
- **-g**：
- **-i**：
- **-k**：
- **+|-L**：
- **+|-m**：
- **+|-M**：
- **-o**：
- **-p**：
- **+|-r**：
- **-s**：
- **-S**：
- **-T**：
- **-u**：
- **+|-w**：
- **-x**：
- **-z**：
- **-Z**：
- **--**：
- **names**：指定文件

### 示例

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
mkdir test
```
在当前目录下的test1目录中创建一个名为test2的目录，如果test1目录原本不存在，则创建一个
```
mkdir -p test1/test2
```

## <a id="mount">mount</a>
### 描述
Mount file systems
### 功能
挂载系统外的文件
### 语法
```
mount [-adfruvw] [-t lfs|external_type]
mount [-dfruvw] special | mount_point
mount [-dfruvw] [-o options] [-t lfs|external_type] special mount_point
```
### 选项参数
- **-a**：将/etc/fstab中定义的所有档案系统挂上
- **-d**：
- **-f**：在试图将文件系统挂载状态从读写降级为只读时强制撤销写访问
- **-r**：将文件系统加载为只读模式
- **-u**：
- **-v**：输出指令执行的详细信息
- **-w**：将文件系统加载为可读写模式
- **-t**：
- **-o**：
	- **async**：
	- **force**：
	- **noasync**：
	- **noauto**：
	- **nodev**：
	- **noexec**：
	- **noowners**：
	- **nosuid**：
	- **rdonly**：
	- **sync**：
	- **update**：
	- **union**：
	- **noatime**：
	- **nobrowse**：
- **special**：
- **mount_point**：

### 示例


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
mv test1 test2
```
将test1目录放入test2目录中
```
mv test1 test2
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
pwd
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
rm test.txt
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
rmdir -p test/test1
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
split test.txt
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
touch test.txt
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
umask
```

# <a id="2">程序进程<a>

## <a id="at">at</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="bg">bg</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="chroot">chroot</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="cron">cron</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="exit">exit</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="fg">fg</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="jobs">jobs</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="kill">kill</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="killall">killall</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="nice">nice</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="pgrep">pgrep</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="pidof">pidof</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="ps">ps</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="pstree">pstree</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="sleep">sleep</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="time">time</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="top">top</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="wait">wait</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

# <a id="3">系统环境<a>

## <a id="env">env</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="finger">finger</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="id">id</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="logname">logname</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="mesg">mesg</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="passwd">passwd</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

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
su root -f
```
变更帐号为TestUser并改变工作目录至TestUser的HOME目录
```
su - TestUser
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

### 示例

## <a id="uptime">uptime</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="w">w</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="wall">wall</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="who">who</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="whoami">whoami</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="write">write</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

# <a id="4">文档编辑<a>

## <a id="awk">awk</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="comm">comm</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="cut">cut</a>
### 描述
### 语法
### 选项参数
### 示例

## <a id="ed">ed</a>
### 描述
Text editor
### 功能
文本编辑（一次仅能编辑一行而非全屏幕）
**PS：ed命令是通过将文本内容拷贝到buffer进行编辑的，使用起来不是很方便，推荐使用vi进行文本编辑**

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

## <a id="ex">ex</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="fmt">fmt</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="head">head</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="iconv">iconv</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="join">join</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="less">less</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="more">more</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="paste">paste</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="sed">sed</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="sort">sort</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="strings">strings</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="talk">talk</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="tac">tac</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="tail">tail</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="tr">tr</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="uniq">uniq</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="vi">vi</a>
### 描述

### 功能
### 语法

```
vim [options] [file ..]
vim [options] -
vim [options] -t tag
vim [options] -q [errorfile]
       ```
### 选项参数
### 示例

## <a id="wc">wc</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="xargs">xargs</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

# <a id="5">Shell脚本<a>

## <a id="alias">alias</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="basename">basename</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="dirname">dirname</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="echo">echo</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="expr">expr</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="false">false</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="printf">printf</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="text">text</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="true">true</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="unset">unset</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

# <a id="6">网络通讯<a>

## <a id="inetd">inetd</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="netstat">netstat</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="ping">ping</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="rlogin">rlogin</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="netcat">netcat</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="traceroute">traceroute</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

# <a id="7">搜索查找<a>

## <a id="find">find</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="grep">grep</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="locate">locate</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="whereis">whereis</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="which">which</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

# <a id="8">其他<a>

## <a id="apropos">apropos</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="banner">banner</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="bc">bc</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="cal">cal</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="clear">clear</a>
### 描述
Clear the terminal screen
### 功能
清除屏幕
### 语法
```
clear
```
### 选项参数
无
### 示例
无

## <a id="date">date</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="dd">dd</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="file">file</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="help">help</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="info">info</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="size">size</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="lp">lp</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

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
man cd
```

## <a id="history">history</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="tee">tee</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="tput">tput</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="type">type</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="yes">yes</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="uname">uname</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

## <a id="whatis">whatis</a>
### 描述
### 功能
### 语法
### 选项参数
### 示例

**PS：持续更新中……**

