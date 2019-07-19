---
title: iOS知识小集
date: 2019-07-18 09:48:49
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

&emsp;&emsp;在此汇总整理了一些iOS学习方面的东西，跟大家一起分享下。

<!--more-->

# UI视图

## 事件传递机制

【问】UIView和CALayer（区别）

【答】

1、UIView负责响应事件，CALayer负责绘制UI

- `UIView`继承自`UIResponder`，而`UIResponder`是响应者对象，实现了如下API，所以继承自`UIResponder`的都具有响应事件的能力

```objc
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches NS_AVAILABLE_IOS(9_1);
```

并且UIView提供了以下两个方法，来进行iOS中事件的响应及传递（响应者链）

```objc
- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event;
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;
```

- `CALayer`继承自`NSObject`，所以`CALayer`不具备响应处理事件的能力。`CALayer`是`QuartzCore`中的类，是一个比较底层的用来绘制内容的类。

2、UIView持有一个CALayer的属性，UIView是CALayer的代理，二者协同工作

- UIView设置frame、center、bounds等位置信息，其实都是UIView对CALayer的封装，使得我们可以很方便地设置控件的位置。但是圆角、阴影等属性，UIView就没有进一步封装，所以我们还是需要去设置Layer的属性来实现功能。
- UIView持有一个CALayer的属性，并且是该属性的代理，用来提供一些CALayer需要的数据，例如动画和绘制。

```objc
//绘制相关
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
//动画相关
- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;
```

## UI绘制原理

## 异步绘制原理

## 流氏页面的性能优化

## 离屏渲染


# OC语言

## KVO

## KVC

## 分类

## 关联对象


# Runtime

## 对象、类对象、元类对象

## 消息传递机制

## 消息转发机制

## Method-Swizzling


# 内存

## 引用技术表

## 弱引用表

## ARC、MRC

## 循环引用

## 内存管理


# Block

## Block本质

## 截获变量特性

## 内存管理

## 循环引用


# 多线程

## GCD、NSOperation

## 资源共享

## 线程同步

## SpinLock等


# RunLoop

## 事件循环

## 用户态

## 核心态

## 常驻线程


# 网络

## HTTPS

## 对称加密算法

## 非对称加密

## DNS解析

## HTTP、TCP


# 设计模式

## 桥接、适配器、命令

## 责任链、单例

## 六大设计原则


# 架构/框架

## MVVM、时长统计框架

## 图片缓存框架

## PV量级10亿级业务架构


# 算法

## 字符串反转

## 单链表反转

## 有序数组归并

## 无需数组中找中位数


# 第三方

## AFNetworking

## ReactCocoa响应式编程库

**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
