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

### UIView和CALayer

1、UIView负责响应事件，CALayer负责绘制UI

- `UIView`继承自`UIResponder`，而`UIResponder`是响应者对象，实现了如下API，所以继承自`UIResponder`的都具有响应事件的能力

```objc
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches;
```

- `CALayer`继承自`NSObject`，所以`CALayer`不具备响应处理事件的能力。`CALayer`是`QuartzCore`中的类，是一个比较底层的用来绘制内容的类。

2、UIView持有一个CALayer的属性，UIView是CALayer的代理，二者协同工作

- UIView设置frame、center、bounds等位置信息，其实都是UIView对CALayer的封装，使得我们可以很方便地设置控件的位置。但是圆角、阴影等属性，UIView就没有进一步封装，所以我们还是需要去设置Layer的属性来实现功能。
- UIView持有一个CALayer的属性，并且是该属性的代理，用来提供一些CALayer需要的数据，例如动画和绘制。

```objc
//绘制相关
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
//动画相关
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;
```

### 事件传递

UIView提供了以下两个方法，来进行iOS中事件的响应及传递（响应者链）

```objc
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
```

![iOS事件响应](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/iOS%E4%BA%8B%E4%BB%B6%E5%93%8D%E5%BA%94.png)

![iOS事件响应2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/iOS%E4%BA%8B%E4%BB%B6%E5%93%8D%E5%BA%942.png)


## UI绘制原理

### 图像显示原理

![图像显示原理](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E5%83%8F%E6%98%BE%E7%A4%BA%E5%8E%9F%E7%90%86.png)

![图像显示原理2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E5%83%8F%E6%98%BE%E7%A4%BA%E5%8E%9F%E7%90%862.png)

### CPU工作

![CPU工作](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/CPU%E5%B7%A5%E4%BD%9C.png)

### GPU渲染管线

![GPU渲染管线](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/GPU%E6%B8%B2%E6%9F%93%E7%AE%A1%E7%BA%BF.png)

### UI卡顿、掉帧的原因

![UI卡顿掉帧的原因](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/UI%E5%8D%A1%E9%A1%BF%E6%8E%89%E5%B8%A7.png)

### 滑动优化方案

- CPU
	- 对象创建、**调整**、**销毁**
	- 预排版（布局计算，文本计算）
	- **预渲染（文本异步绘制，图片编解码等）**
- GPU
	- **纹理渲染**
	- **视图混合**

### UIView绘制原理

![UIView绘制原理](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/UIView%E7%BB%98%E5%88%B6%E5%8E%9F%E7%90%86.png)

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
