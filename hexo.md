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

