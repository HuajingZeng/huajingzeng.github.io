#!/bin/sh
cd /Users/Kevin/Git/huajingzeng.github.io
echo $NODE_PATH
export NODE_PATH=/usr/local/lib/node_modules
pm2 stop hexo_server.js