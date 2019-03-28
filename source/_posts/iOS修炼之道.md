---
title: iOS修炼之道 
date: 2018-09-06 10:05:22 
update: 
author: 曾华经 
tags: 
	- iOS 
categories: 
	- 编程基础 
thumbnail: https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/iOS%E5%BC%80%E5%8F%91.jpeg 
blogexcerpt: 
toc: true 
---

&emsp;&emsp;从事移动应用开发已经两年多了，期间也做过微信小程序开发，但归根到底自己依然是一名iOS开发者。我是非科班转职并自学编程的，现在参与过的iOS项目也有三四个了。虽然离成为大神还有漫漫长路，但“修炼之道”莫不是“上下而求索”乎？在此汇总整理了一些iOS学习方面的东西，跟大家一起分享下。


<!--more-->

# 学习路线图

![最新iOS学习路线图](http://githubblog-1252104787.cosgz.myqcloud.com/%E6%9C%80%E6%96%B0iOS%E5%AD%A6%E4%B9%A0%E8%B7%AF%E7%BA%BF%E5%9B%BE.jpg)
![iOS学习路线](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/iOS%20%E5%AD%A6%E4%B9%A0%E8%B7%AF%E7%BA%BF.png)
![iOS技能要求](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/iOS%E6%8A%80%E8%83%BD%E8%A6%81%E6%B1%82.png)
# 网站

- [ObjC 中国](https://objccn.io/)
- [NSHipster 中文版](https://nshipster.cn/)
- [CocoaChina](http://www.cocoachina.com/)
- [Code4App](http://www.code4app.com/)
- [ASCIIwwdc](https://asciiwwdc.com/)

# 文章

## 架构
- [iOS应用架构谈 开篇](https://casatwy.com/iosying-yong-jia-gou-tan-kai-pian.html)
- [iOS应用架构谈 view层的组织和调用方案](https://casatwy.com/iosying-yong-jia-gou-tan-viewceng-de-zu-zhi-he-diao-yong-fang-an.html)
- [iOS应用架构谈 网络层设计方案](https://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html)
- [iOS应用架构谈 本地持久化方案及动态部署](https://casatwy.com/iosying-yong-jia-gou-tan-ben-di-chi-jiu-hua-fang-an-ji-dong-tai-bu-shu.html)
- [iOS应用架构谈 组件化方案](https://casatwy.com/iOS-Modulization.html)
- [论MVVM伪框架结构和MVC中M的实现机制](https://www.jianshu.com/p/33c7e2f3a613)
- [iOS的MVC框架之模型层的构建](https://www.jianshu.com/p/fce02188edec)
- [iOS的MVC框架之控制层的构建(上)](https://www.jianshu.com/p/02d6397436dc)
- [iOS的MVC框架之控制层的构建(下)](https://www.jianshu.com/p/4f7b3c9801f5)

## 布局
- [iOS的MyLayout布局系列-流式布局MyFlowLayout](https://www.jianshu.com/p/fbeb376584ed)
- [iOS的MyLayout布局体系--浮动布局MyFloatLayout](https://www.jianshu.com/p/0c075f2fdab2)
- [CSS中的float定位技术在iOS上的实现](https://www.jianshu.com/p/c77d9cff814b)
- [iOS界面布局的核心以及TangramKit介绍](https://www.jianshu.com/p/4c1eb0dd676f)
- [用MyLayout实现布局性能的提升以及对阿拉伯国家的支持](https://www.jianshu.com/p/b62ed0877e92)
- [iOS下的界面布局利器-MyLayout布局框架](https://www.jianshu.com/p/603fd470bbb0)
- [MyLayout和XIB或SB的混合使用方法](https://www.jianshu.com/p/a3c53efe5e0b)
- [路径布局-基于数学函数的视图布局方法](https://www.jianshu.com/p/4ac229057396)
- [UIButton实现各种图文结合的效果以及原理](https://www.jianshu.com/p/0fd782d67efb)
- [理解UIButton的imageEdgeInsets和titleEdgeInsets](http://blog.intmaxdev.com/2016/04/10/uibutton-edgeinsets/)
- [iOS多设备适配简史以及相应的API支撑实现](https://www.jianshu.com/p/b43b22fa40e3)

## 底层原理
- [深入iOS系统底层之汇编语言](https://www.jianshu.com/p/ff8ed52bdd67)
- [深入iOS系统底层之指令集介绍](https://www.jianshu.com/p/54884ce976ca)
- [深入iOS系统底层之XCODE对汇编的支持介绍](https://www.jianshu.com/p/365ed6c385e5)
- [深入iOS系统底层之CPU寄存器介绍](https://www.jianshu.com/p/6d7a57794122)
- [深入iOS系统底层之程序中的汇编代码](https://www.jianshu.com/p/3b83193ff851)
- [深入iOS系统底层之映像文件操作API介绍](https://www.jianshu.com/p/3b83193ff851)
- [深入iOS系统底层之静态库介绍](https://www.jianshu.com/p/ef3415255808)
- [深入iOS系统底层之crash解决方法介绍](https://www.jianshu.com/p/cf0945f9c1f8)
- [深入解构iOS的block闭包实现原理](https://www.jianshu.com/p/595a1776ba3a)
- [深入解构iOS系统下的全局对象和初始化函数](https://www.jianshu.com/p/e6300594c966)
- [深入解构objc_msgSend函数的实现](https://www.jianshu.com/p/df6629ec9a25)
- [趣探 Mach-O：文件格式分析](https://www.jianshu.com/p/54d842db3f69)
- [趣探 Mach-O：加载过程](https://www.jianshu.com/p/8498cec10a41)
- [趣探 Mach-O：FishHook 解析](https://www.jianshu.com/p/9e1f4d771e35)

## 其他
- [手把手教你查看和分析iOS的crash崩溃异常](https://www.jianshu.com/p/cf0945f9c1f8)
- [analyze](https://github.com/Draveness/analyze)（关于iOS开源框架源代码解析的文章）
- [iOS-Tech-Weekly](https://github.com/BaiduHiDeviOS/iOS-Tech-Weekly)（iOS技术周报）
- [awesome-ios](https://github.com/vsouza/awesome-ios)（iOS的集合贴）
- [深入解构iOS的block闭包实现原理](https://www.jianshu.com/p/595a1776ba3a)

# 书籍

## 经典系列
- [《Objective-C基础教程》](https://pan.baidu.com/s/1nREE191rwcKRfRRVCiuXCg)
- [《Objective-C编程全解》](https://pan.baidu.com/s/1HzquqGMkTpYEhaBCT0a5Bg)
- [《Objective-C高级编程：iOS与OS X多线程和内存管理》](https://pan.baidu.com/s/16g-bskr9o_7g72w8KTktkw)
- [《iOS编程》](https://pan.baidu.com/s/1sgX0vq6U9d7PbMbs0wZjgQ)
- [《Effective Objective-C 2.0：编写高质量iOS与OS X代码的52个有效方法》](https://pan.baidu.com/s/1sgl_CybRtgbl7Sd9qxY3PA)
- [《Objective-C编程之道：iOS设计模式解析》](https://pan.baidu.com/s/1o2F7UVy2N1iOihvvVIkxQg)
- [《iOS CORE ANIMATION ADVANCED TECHNIQUES》](https://pan.baidu.com/s/1igYwOx885GBlCTjGyypzMQ)
- [《iOS Animations by Tutorials》](https://pan.baidu.com/s/1qJu3DuhIq30JdexXoq_ylQ)
- [《A GUIDE TO IOS ANIMATION》](https://pan.baidu.com/s/1ZKX0VUPqGZhdXG0_-YpmRw)
- [《NSHipster Obscure Topics in Cocoa & Objective-C》](https://pan.baidu.com/s/1auAMXbqyWfP9IEpnas5LDA)
- [《Low Level Programming》](https://pan.baidu.com/s/1nkK_U9siuj-GWeKDjExW1A)
- [《iOS Auto Layout开发秘籍》](https://pan.baidu.com/s/1-wIDYQBh3q3WXdl6s6S_JA)
- [《iOS 10 by Tutorials》](https://pan.baidu.com/s/1a6ZquOzeLOpGjeaGKAmx-g)
- [《iOS编程实战》](https://pan.baidu.com/s/1dT25S8YT2h6Slmmokx-vww)
- [《深入解析 MAC OS X & IOS 操作系统》](https://pan.baidu.com/s/1_qaN7RYTGiCeqcE4qA6XJg)

## objc.io系列
- [《集合类型优化》](https://pan.baidu.com/s/1ZD35WJz-Uk4hCW66gVJEVQ)
- [《Core Data》](https://pan.baidu.com/s/1ePxFIb6ZSnoOFrXVRIS6_Q)
- [《函数式 Swift》](https://pan.baidu.com/s/1ZkMp7kEEJUncfu_jcYOkoQ)
- [《Swifter Swift开发者必备Tips》](https://pan.baidu.com/s/1j59W-BBZ-uE0VtLDVGCBAA)
- [《Swift 进阶》](https://pan.baidu.com/s/1h9eJZT-wR-bptliDnp6KNw)

# 官方文档

[Apple Developer Documentation](https://developer.apple.com/documentation/)

# 第三方框架

- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
- [SDWebImage](https://github.com/rs/SDWebImage)
- [GPUImage](https://github.com/BradLarson/GPUImage)
- [Masonry](https://github.com/SnapKit/Masonry)
- [lottie-ios](https://github.com/airbnb/lottie-ios)
- [realm-cocoa](https://github.com/realm/realm-cocoa)
- [YYKit](https://github.com/ibireme/YYKit)
- [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)
- [WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)
- [iCarousel](https://github.com/nicklockwood/iCarousel)
- [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)
- [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket)
- [RestKit](https://github.com/RestKit/RestKit)
- [FLEX](https://github.com/Flipboard/FLEX)
- [PNChart](https://github.com/kevinzhow/PNChart)
- [IGListKit](https://github.com/Instagram/IGListKit)
- [Shimmer](https://github.com/facebook/Shimmer)
- [MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)
- [MJRefresh](https://github.com/CoderMJLee/MJRefresh)
- [MJExtension](https://github.com/CoderMJLee/MJExtension)
- [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
- [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
- [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)
- [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedControl)
- [FMDB](https://github.com/ccgus/fmdb)
- [FMDBMigrationManager](https://github.com/layerhq/FMDBMigrationManager)
- [MSWeakTimer](https://github.com/mindsnacks/MSWeakTimer)
- [RSKImageCropper](https://github.com/ruslanskorb/RSKImageCropper)
- [EBBannerView](https://github.com/pikacode/EBBannerView)
- [SDCycleScrollView](https://github.com/gsdios/SDCycleScrollView)
- [DTCoreText](https://github.com/Cocoanetics/DTCoreText)
- [jsonmodel](https://github.com/jsonmodel/jsonmodel)
- [Reachability](https://github.com/tonymillion/Reachability)
- [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)
- [TZImagePickerController](https://github.com/banchichen/TZImagePickerController)

<br>
<br>
<br>

**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
