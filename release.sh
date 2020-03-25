#!/bin/bash

echo "删除本地AaronSwift库"

pod repo remove AaronSwift

echo "本地AaronSwift库——已删除"

echo "添加远程仓库到本地"

pod repo add AaronSwift https://github.com/AaronYin0514/AaronSwift.git

echo "添加远程仓库完成"

echo "发布新版本"

pod repo push AaronSwift AaronSwift.podspec --allow-warnings

echo "发布完成"

if [ -d "~/.cocoapods/repos/AaronSwift/AaronSwift/Classes/" ]; then
	echo "包含Class文件夹，正在删除"
	rm -rf ~/.cocoapods/repos/AaronSwift/AaronSwift/Classes
	echo "删除Class文件夹完成"
fi

if [ -d "~/.cocoapods/repos/AaronSwift/AaronSwift/Assets/" ]; then
	echo "包含Assets文件夹"
        rm -rf ~/.cocoapods/repos/AaronSwift/AaronSwift/Assets
	echo "删除Assets文件夹完成"
fi

