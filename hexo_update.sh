#!/bin/sh
cd /Users/Kevin/Git/huajingzeng.github.io
git pull origin hexo
git add .
git commit -m "Update posts"
git push origin hexo
hexo d -g