---
title: Shell脚本编程
date: 2017-11-25 09:24:43
update: 2017-11-25 09:24:43
author: 曾华经
tags: 
	- Shell
categories: 
	- 编程基础
	- 开发工具
thumbnail: /img/thumbnail/1.jpg
blogexcerpt:
---
&emsp;&emsp;Shell是类Unix系统下一个实用的工具程序，它有自己内建的编程语言（解释型）。Shell会分析所遇到的每一条语句，然后执行所发现的有效命令。这与C++及Swift这类编程语言（编译型）不同，这些语言的程序语句在执行之前通常都会被编译成可由机器执行的形式。
&emsp;&emsp;Shell脚本（Shell Script），是一种为Shell编写的脚本程序（扩展名为.sh）。我们通常说的“Shell编程”都是指Shell脚本编程，不是指开发Shell自身。
<!--more-->

# 1、基础概述

## 1.1、常用命令

|<div style="white-space: nowrap; word-wrap: normal; word-break: normal;">&emsp;&emsp;命令&emsp;&emsp;<div>|描述|
|:---:|---|
|cat file(s)|显示一个或多个文件的内容，如果没有提供参数的话，则显示标准输入内容|
|cd dir|将当前工作目录更改为dir|
|cp file1 file2|将file1复制到file2|
|cp file(s) dir|将一个或多个文件复制到dir中|
|date|显示日期和时间|
|echo args|显示给出的一个或多个参数|
|ln file1 file2|将file1链接到file2|
|ln file(s) dir|将一个或多个文件链接到dir中|
|ls file(s)|列出一个或多个文件|
|ls dir(s)|列出一个或多个目录中的文件，如果没有指定目录，则列出当前目录中的文件|
|mkdir dir(s)|创建一个或多个指定的目录|
|mv file1 file2|移动file1并将其重命名为file2（如果均处于相同目录下，则仅执行重命名操作）|
|mv file(s) dir|将一个或多个文件移动到指定目录dir中|
|ps|列出活动进程的信息|
|pwd|显示出当前工作目录的路径|
|rm file(s)|删除一个或多个文件|
|rmdir dir(s)|删除一个或多个目录|
|sort file(s)|将一个或多个文件中的行进行排序，如果没有指定文件，则对标准输入内容进行排序|
|wc file(s)|统计一个或多个文件中的行数、单词数和字符数，如果没有指定文件的话，则统计标准输入中的内容|
|who|显示出已登录的用户|

关于这些命令的用法，详见：[常用Shell命令](/post/常用Shell命令)

## 1.2、程序执行

Shell会根据输入的内容进行分析，然后决定执行什么操作。Shell是按行进行分析的，每行都遵循以下的基本格式：

```
command options arguments
```

Shell使用空白字符（whitespace characters，包括空格符、水平制表符和换行符）来确定命令名称、选项和参数的起止，连续的多个空白字符会被Shell忽略。选项一般使用“-”开头。

## 1.3、变量和文件名替换

### 变量
Shell允许将值赋值给变量。只要在命令行中将变量放在美元符号$之后，Shell就会将该变量替换成对应的变量值。

### 文件名
Shell在确定要执行的程序及其参数之前，会扫描命令行，查找文件名替换字符*、？或[...]

|替换字符|说明|
|:---:|---|
|*|匹配零个或多个字符|
|?|仅能匹配单个字符|
|[chars]/[char1-char2]|匹配指定字符集合中的某个字符|


## 1.4、I/O重定向

## 1.5、管道

## 1.6、标准错误

# 2、变量、引用和参数

# 3、控制语句

# 4、输入与输出

# 5、环境

# 6、交互

**PS：待补充更新...**

**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
