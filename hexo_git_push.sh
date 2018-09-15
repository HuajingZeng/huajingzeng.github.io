#!/bin/sh
cd /Users/Kevin/Git/huajingzeng.github.io
echo $NODE_PATH
export NODE_PATH=/usr/local/lib/node_modules
git pull origin hexo
git add .
git commit -m "Update posts"
git push origin hexo
hexo d -g