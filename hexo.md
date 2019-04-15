Github+Hexo的博客多终端同步

# 准备条件

- 安装了Node.js，Git，Hexo环境
- 完成Github与本地Hexo的对接，参考《[史上最详细的Hexo博客搭建图文教程](https://xuanwo.org/2015/03/26/hexo-intor/)》《[全民博客时代的到来——20分钟简要教程](https://www.jianshu.com/p/e99ed60390a8)》

# 在其中一个终端创建hexo分支并推送到github的远程分支hexo上

```
$ git init  //初始化本地仓库
$ git add . //将必要的文件添加到Git暂存区
$ git commit -m "Commit Updates" //提交更新
$ git branch hexo  //新建hexo分支
$ git checkout hexo  //切换到hexo分支上
$ git remote add origin https://github.com/HuajingZeng/huajingzeng.github.io.git  //将本地与Github项目对接
$ git push origin hexo  //push到Github项目的hexo分支上
```

# 另一终端完成clone和push更新

```
$ git clone -b hexo https://github.com/HuajingZeng/huajingzeng.github.io.git  //将Github中hexo分支clone到本地
$ cd huajingzeng.github.io  //切换到刚刚clone的文件夹内
$ npm install //注意，这里一定要切换到刚刚clone的文件夹内执行，安装必要的所需组件，不用再init
$ hexo new post "new blog name" //新建一个.md文件，并编辑完成自己的博客内容
$ git add . //将必要的文件添加到Git暂存区
$ git commit -m "Add/Update post" //提交更新
$ git push origin hexo  //更新分支
$ hexo d -g //push更新完分支之后将自己写的博客对接到自己搭的博客网站上，同时同步了Github中的master
```

# 不同终端间愉快地玩耍

```
$ git pull origin hexo  //先pull完成本地与远端的融合
$ hexo new post "new blog name"
$ git add .
$ git commit -m "Add/Update post"
$ git push origin hexo
$ hexo d -g
```


# 添加MathJax支持

## 安装插件

首先我们需要安装Mathjax插件

```
npm install hexo-math –save
```

更换Hexo的markdown渲染引擎，hexo-renderer-kramed引擎是在默认的渲染引擎hexo-renderer-marked的基础上修改了一些bug，两者比较接近，也比较轻量级。

```
npm uninstall hexo-renderer-marked –save 
npm install hexo-renderer-kramed –save
```

## 解决语义冲突

由于LaTeX与markdown语法有语义冲突，在markdown中，斜体和加粗可以用*或者_表示，在这里我们修改变量，将_用于LaTeX，而使用*表示markdown中的斜体和加粗。 
在博客根目录下，进入node_modules\kramed\lib\rules\inline.js，把第11行的escape变量的值做相应的修改：

```
  //escape: /^\\([\\`*{}\[\]()#$+\-.!_>])/,
  escape: /^\\([`*\[\]()#$+\-.!_>])/,
```

这一步是在原基础上取消了对,{,}的转义(escape)。 
同时把第20行的em变量也要做相应的修改:

```
  //  em: /^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,
  em: /^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,
```

## 更改配置文件

这里是最重要的一步，我找了好久才在这个网站中找到适用的解决办法。 
进入到主题目录，找到_config.yml配置问题，把mathjax默认的false修改为true，并更换cdn的url，具体如下：

```
# MathJax Support
mathjax:
  enable: true
  per_page: true
```

进入主题目录，找到/Users/Kevin/Git/huajingzeng.github.io/themes/xups/layout/_partial/head.ejs，添加MathJax脚本


```
<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>
```

## 写博客

在每次需要用LaTeX渲染的博文中，在文章的Front-matter里打开mathjax开关，具体如下：

```
title: index.html
date: 2018-2-8 21:01:30
tags:
mathjax: true
```

## 测试

输入：

```
$$lim_{1\to+\infty}P(|\frac{1}{n}\sum_i^nX_i-\mu|<\epsilon)=1, i=1,...,n$$  
```
