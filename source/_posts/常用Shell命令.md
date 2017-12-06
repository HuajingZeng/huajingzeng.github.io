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

&emsp;&emsp;不同的Shell具备不同的功能，流行的Shell有：bash、csh、ksh、sh、tcsh、zsh等。可以进入/bin目录查看，以sh结尾的可执行文件即Shell脚本解析程序。本人Mac系统默认使用/bin/bash，bash也是目前大多数Linux系统默认使用的Shell，因此以下命令及参数均以bash为准。

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
### 参数说明
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
### 参数说明
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
Change group ownership
### 功能
变更文件或目录的所属群组
### 语法
```
chgrp [-fhv] [-R [-H|-L|-P]] group file...
```
### 参数说明
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
Change access permissions
### 功能
变更文件或目录的权限（只有文件拥有者或者超级管理员才能修改文件权限）
### 语法
```
chmod [-fhv] [-R [-H|-L|-P]] mode file...

mode1：[augo][+|-|=][rstwx-][,...]
mode2：[????]
```
### 参数说明
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
	- **mode2**：数值模式（4位8进制数），各组数值可同位相加
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
计算文件test.txt的完整性
```
cksum test.txt
//3311261222 35 test.txt
```

## <a id="cmp">cmp</a>
### 描述
Compare two files
### 功能
比较两个文件是否有差异
### 语法
```
cmp [OPTION] [-i <起始位置>] FILE1 FILE2
```
### 参数说明
- **OPTION**：
    - **-c**：[--print-chars]除了标明差异处的十进制字码之外，一并显示该字符所对应字符
    - **-l**：[--verbose]标示出所有不一样的地方
    - **-s**：[--quiet或--silent]不显示错误信息
    - **-v**：[--version]显示版本信息
- **-i <起始位置>** [--ignore-initial=<起始位置>]指定比较的起始字符位置，第一个字符索引值为0
- **FILE1**：进行比较的第一个文件
- **FILE2**：进行比较的第二个文件

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
Copy one or more files to another location
### 功能
复制文件或目录
### 语法
```
cp [OPTION] SOURCE TARGET
cp [OPTION] SOURCE ... DIRECTORY
```
### 参数说明
- **OPTION**：选项
    - **-a**：[--archive]此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容
    - **-i**：[--interactive]在覆盖目标文件之前给出提示，要求用户确认是否覆盖
    - **-p**：[--preserve]除复制文件的内容外，还把修改时间和访问权限也复制到新文件中
    - **-r**：[--recursive]若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件
    - **-v**：[--verbose]显示执行过程
    - **-X**：[--one-file-system]复制的文件或目录存放的文件系统，必须与cp指令执行时所处的文件系统相同，否则不复制，亦不处理位于其他分区的文件
- **SOURCE**：原文件或目录
- **TARGET**：新文件
- **DIRECTORY**：目标目录

### 示例
将当前目录test1下的所有文件复制到新目录test2下
```
cp -r test1 test2
```

## <a id="du">du</a>
### 描述
Estimate file space usage
### 功能
显示目录或文件的大小
### 语法
```
du [OPTION1] [OPTION2] [OPTION3] [OPTION4] FILE
```
### 参数说明
- **OPTION1**：选项1
    - **-a**：[--all]显示目录中各个文件或目录的大小
    - **-s**：[--summarize]仅显示总计
    - **-d <DEPTH>**：DEPTH指定目录层数，超过指定层数的目录予以忽略
- **OPTION2**：选项2
    - **-c**：[--total]除了显示各个文件或目录的大小外，同时也显示所有文件和目录的总和
    - **-g**：[--gigaByte]以GB为单位
    - **-h**：[--human-readable]以KB，MB，GB为单位，提高信息的可读性
    - **-k**：[--kilobytes]以KB为单位
    - **-m**：[--megabytes]以MB为单位
- **OPTION3**：选项3
    - **S**：[--separate-dirs]显示各个目录的大小时，并不含其子目录的大小
    - **-x**：[--one-file-xystem]以一开始处理时的文件系统为准，若遇上其它不同的文件系统目录则略过
- **FILE**：要显示大小的文件或目录

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

