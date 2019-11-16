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
password: 20190718
abstract: 本文已加密，访问需密码
message: 本文已加密，访问需密码
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

![UIView绘制原理2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/UIView%E7%BB%98%E5%88%B6%E5%8E%9F%E7%90%862.png)

## 异步绘制原理

- [layer.delegate displayLayer:]
	- 代理负责生成对应的bitmap
	- 设置该bitmap作为layer.contents属性的值
	
![异步绘制](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%BC%82%E6%AD%A5%E7%BB%98%E5%88%B6.png)

## 离屏渲染

- On-Screen Rendering：意为当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行
	
- Off-Screen Rendering：意为离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
	- 圆角（当和maskToBounds一起使用时）
	- 图层蒙版
	- 阴影
	- 光栅化

为何要避免？

- 创建新的渲染缓存区
- 上下文切换

# OC语言

## 分类（Category）

### 特点

- 运行时决议
- 可以为系统类添加分类

### 可以添加的内容

- 实例方法
- 类方法
- 协议
- 属性

### 加载调用栈

![分类加载调用栈](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%88%86%E7%B1%BB%E5%8A%A0%E8%BD%BD%E8%B0%83%E7%94%A8%E6%A0%88.png)

- 分类添加的方法可以“覆盖”原类方法
- 同名分类方法谁生效取决于编译顺序
- 名字相同的分类会引起编译报错

## 关联对象

```objc
objc_getAssociatedObject(id object, const void *key);

objc_setAssociatedObject(id object, const void *key,
                         id value, objc_AssociationPolicy policy);

objc_removeAssociatedObjects(id object);
```

### 关联对象的本质

关联对象由`AssociationManager`管理并在`AssociationHashMap`存储。所有对象的关联内容都在**同一个全局容器**中。

![关联对象的本质](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%85%B3%E8%81%94%E5%AF%B9%E8%B1%A1%E7%9A%84%E6%9C%AC%E8%B4%A8.png)

```json
{
	"0x4927298742":{
		"@selector(text)":{
			"value":"Hello",
			"policy":"retain"
		},
		"@selector(title)":{
			"value":"a object",
			"policy":"copy"
		}
	},
	"0x3428163871":{
		"@selector(backgroundColor)":{
			"value":"0xff8205",
			"policy":"retain"
		}
	}
}
```

## 扩展

### 特点

- 编译时决议
- 只以声明的形式存在，多数情况下寄生于宿主类的.m中
- 不能为系统类添加扩展

## 代理

- 准确的说是一种软件设计模式
- iOS当中以**@protocol**形式提现
- 传递方式为**一对一**

![代理](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E4%BB%A3%E7%90%86.png)

- 一般声明为**weak**以规避循环引用

![代理2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E4%BB%A3%E7%90%862.png)

## 通知

- 使用**观察者模式**来实现的用于跨层传递消息的机制
- 传递方式为**一对对**

![通知](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%80%9A%E7%9F%A5.png)

![通知机制](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%80%9A%E7%9F%A5%E6%9C%BA%E5%88%B6.png)

## KVO

- KVO是Key-value observing的缩写
- KVO是Objective-C对**观察者模式**的又一实现
- Apple 使用了isa混写（**isa-swizzling**）来实现KVO

![KVO](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/KVO.png)

### 触发条件

- 使用setter方法改变值KVO才会生效
- 使用`setValue:forKey:`改变值KVO才会生效
- 成员变量直接修改需**手动添加**KVO才会生效

## KVC

KVC是Key-value coding的缩写

```objc
- (id)valueForKey:(NSString *)key;

- (void)setValue:(id)value forKey:(NSString *)key;
```

![KVC](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/KVC.png)

![KVC2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/KVC2.png)

### Accessor Method

- &#60;getKey&#62;
- &#60;key&#62;
- &#60;isKey&#62;

### Instance var

- _key
- _isKey
- key
- isKey

## 属性关键字

- 读写权限
	- readonly
	- **rewrite**
- 原子性
	- **atomic**
	- nonatomic
- 引用计数
	- retain/**strong**
	- **assign**/unsafe_unretained
	- weak
	- copy

### assign

- 修饰基本数据类型，如int、BOOL等
- 修饰对象类型时，不改变其引用计数
- 会产生悬垂指针

### weak

- 不改变被修饰对象的引用计数
- 所指对象在被释放之后会自动置为nil

### copy

- 浅拷贝：对内存地址的复制，让目标对象指针和源对象指向**同一片**内存空间
- 深拷贝：深拷贝让目标对象指针和源对象指针指向**两片**内容相同的内存空间

深拷贝VS浅拷贝

- 是否开辟了新的内存空间
- 是否影响了引用计数

![copy关键字](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/copy%E5%85%B3%E9%94%AE%E5%AD%97.png)

# Runtime

## 数据结构

### objc_object

![objc_object](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/objc_object.png)

### objc_class

![objc_class](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/objc_class.png)

### isa指针

共用体`isa_t`

![isa](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/isa.png)

`isa`指向

- 关于**对象**，其指向**类对象**
- 关于**类对象**，其指向**元类对象**

### cache_t

- 用于**快速**查找方法执行函数
- 是可**增量扩展**的**哈希表**结构
- 是**局部性原理**的最佳应用

![cache_t](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/cache_t.png)

### class\_data\_bits\_t

- `class_data_bits_t`主要是对`class_rw_t`的封装
- `class_rw_t`代表了类相关的**读写**信息、对`class_ro_t`的封装
- `class_ro_t`代表了类相关的**只读**信息

![class_rw_t](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/class_rw_t.png)

![class_ro_t](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/class_ro_t.png)

### method_t

![method_t](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/method_t.png)

Type Encodings

- const char *types

![Type Encodings](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Type%20Encodings.png)

### Objective-C对象数据结构

![OC对象数据结构](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/OC%E5%AF%B9%E8%B1%A1%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84.png)

## 对象、类对象、元类对象

![对象类对象元类对象](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%AF%B9%E8%B1%A1%E7%B1%BB%E5%AF%B9%E8%B1%A1%E5%85%83%E7%B1%BB%E5%AF%B9%E8%B1%A1.png)

## 消息传递机制

![消息传递](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%B6%88%E6%81%AF%E4%BC%A0%E9%80%92.png)

### 缓存查找

给定值是`SEL`，目标值是对应`bucket_t`中的`IMP`。

![缓存查找](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E7%BC%93%E5%AD%98%E6%9F%A5%E6%89%BE.png)

### 当前类中查找

- 对于**已排序好**的列表，采用二分查找算法查找方法对应执行函数。
- 对于**没有排序**的列表，采用一般遍历查找方法对应执行函数。

### 父类逐级查找

![父类逐级查找](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E7%88%B6%E7%B1%BB%E9%80%90%E7%BA%A7%E6%9F%A5%E6%89%BE.png)

## 消息转发机制

![消息转发流程](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%B6%88%E6%81%AF%E8%BD%AC%E5%8F%91%E6%B5%81%E7%A8%8B.png)

## Method-Swizzling

![MethodSwizzling](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/MethodSwizzling.png)

## 动态方法解析

@dynamic

- 动态运行时语言将函数决议推迟到运行时。
- 编译时语言在编译期进行函数决议。

# 内存

![内存分配](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%86%85%E5%AD%98%E5%88%86%E9%85%8D.png)

## 内存管理方案

- TaggedPointer：有些对象如果支持使用TaggedPointer（对象指针最后一位为1），苹果会直接将其指针值作为引用计数返回
- NONPOINTER_ISA：如果当前设备是64位环境并且使用Objective-C 2.0，那么“一些”对象会使用其isa指针的一部分空间来存储它的引用计数（isa指针最后一位为1）
- 散列表：包含自旋锁、引用计数表、弱引用表等

### arm64架构

![arm64架构](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/arm64%E6%9E%B6%E6%9E%84.png)

### 散列表方式

![SideTables](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/SideTables.png)

![SideTable](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/SideTable.png)

### Hash查找

给定值是对象内存地址，目标值是数组下标索引。

![Hash查找](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Hash%E6%9F%A5%E6%89%BE.png)

## 自旋锁

- `Spinlock_t`是“忙等”的锁。
- 适用于轻量访问。

## 引用技术表

### RefcountMap

![RefcountMap](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/RefcountMap.png)

### size_t

![size_t](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/size_t.png)

## 弱引用表

### weak_table_t

![weak_table_t](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/weak_table_t.png)

## ARC、MRC

### MRC

手动引用计数

![MRC](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/MRC.png)

### ARC

自动引用计数

- ARC是**LLVM**和**Runtime**协作的结果
- ARC中禁止手动调用`retain`/`release`/`retainCount`/`dealloc`
- ARC中新增`weak`、`strong`属性关键字

## 引用计数管理

### alloc实现

- 经过一系列调用，最终调用了C函数calloc。
- 此时并没有设置引用计数为1。

### retain实现

```objc
SideTable& table = SideTables()[this];

size_t& refcntStorage = table.refcnts[this];

refcntStorage += SIDE_TABLE_RC_ONE;
```


### release实现

```objc
SideTable& table = SideTables()[this];

RefcountMap::iterator it = table.refcnts.find(this);

it->second -= SIDE_TABLE_RC_ONE;
```

### retainCount实现

```objc
SideTable& table = SideTables()[this];

size_t refcnt_result = 1;

RefcountMap::iterator it = table.refcnts.find(this);

refcnt_result += it->second >> SIDE_TABLE_RC_SHIFT;
```

### dealloc实现

![dealloc](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/dealloc.png)

- object_dispose()

![object_dispose](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/object_dispose.png)

- objc_destructInstance()

![objc_destructInstance](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/objc_destructInstance.png)

- clearDeallocating()

![clearDeallocating](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/clearDeallocating.png)

## 弱引用管理

![弱引用管理](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%BC%B1%E5%BC%95%E7%94%A8%E7%AE%A1%E7%90%86.png)

- 添加weak变量

![添加weak变量](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%B7%BB%E5%8A%A0weak%E5%8F%98%E9%87%8F.png)

- 清除weak变量，同时设置指向为nil

![清除weak变量](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%B8%85%E9%99%A4weak%E5%8F%98%E9%87%8F.png)

## 自动释放池

![自动释放池](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E8%87%AA%E5%8A%A8%E9%87%8A%E6%94%BE%E6%B1%A0.png)

- 是以**栈**为结点通过**双向链表**的形式组合而成
- 是和**线程**一一对应的

### AutoreleasePoolPage

![AutoreleasePoolPage](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/AutoreleasePoolPage.png)

![AutoreleasePoolPage](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/AutoreleasePoolPage2.png)

### AutoreleasePoolPage::push

![AutoreleasePoolPagePush](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/AutoreleasePoolPagePush.png)

### autorelease

![autorelease](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/autorelease.png)

### AutoreleasePoolPage::pop

- 根据传入的哨兵对象找到对应位置
- 给上次push操作之后添加的对象依次发送release消息
- 回退next指针到正确位置

![AutoreleasePoolPagePop](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/AutoreleasePoolPagePop.png)

### @autoreleasepool总结

- 在当前RunLoop将要结束的时候调用AutoreleasePoolPage::pop()
- 多层嵌套就是多次插入哨兵对象
- 在for循环中alloc图片数据等内存消耗较大的场景手动插入autoreleasePool

## 循环引用

### 种类

- 自循环引用

![自循环引用](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E8%87%AA%E5%BE%AA%E7%8E%AF%E5%BC%95%E7%94%A8.png)

- 相互循环引用

![相互循环引用](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E7%9B%B8%E4%BA%92%E5%BE%AA%E7%8E%AF%E5%BC%95%E7%94%A8.png)

- 多循环引用

![多循环引用](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%A4%9A%E5%BE%AA%E7%8E%AF%E5%BC%95%E7%94%A8.png)

### 来源

- 代理
- Block
- NSTimer
- 大环引用

### 破解

- **避免产生循环引用**
- **在合适的时机手动断环**

具体解决方案：

- **__weak**
- **__block**
	- **MRC**下，__block修饰对象不会增加其引用计数，**避免**了循环引用
	- **ARC**下，__block修饰对象会被强引用，**无法避免**循环引用，**需手动解环**
- **__unsafe\_unretained**
	- 修饰对象不会增加其引用计数，**避免**了循环引用
	- 如果被修饰对象在某一时机被释放，会产生**悬垂指针**

### 示例

![NSTimer循环引用](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/NSTimer%E5%BE%AA%E7%8E%AF%E5%BC%95%E7%94%A8.png)

# Block

> Block是将**函数**及其**执行上下文**封装起来的**对象**。Block调用即是**函数的调用**

## 截获变量

- 局部变量
	- 基本数据类型：截获其**值**
	- 对象类型：**连同所有权修饰符**一起截获
- 静态局部变量：以**指针形式**截获
- 全局变量：**不截获**
- 静态全局变量：**不截获**

## __block修饰符

- **一般情况下**，对被截获变量进行**赋值**操作需要添加__block修饰符

![__block修饰符](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/__block%E4%BF%AE%E9%A5%B0%E7%AC%A6.png)

![__block修饰符2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/__block%E4%BF%AE%E9%A5%B0%E7%AC%A62.png)

![__block修饰符3](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/__block%E4%BF%AE%E9%A5%B0%E7%AC%A63.png)

- __block修饰的变量变成了对象

![__block修饰符4](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/__block%E4%BF%AE%E9%A5%B0%E7%AC%A64.png)

![__block修饰符5](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/__block%E4%BF%AE%E9%A5%B0%E7%AC%A65.png)

## Block的内存管理
 
![Block内存管理](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Block%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86.png)

![Block内存管理2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Block%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%862.png)

![Block内存管理3](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Block%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%863.png)

![Block内存管理4](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Block%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%864.png)

![Block内存管理5](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Block%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%865.png)

## Block的循环引用

![Block循环引用](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Block%E5%BE%AA%E7%8E%AF%E5%BC%95%E7%94%A8.png)

![Block循环引用2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Block%E5%BE%AA%E7%8E%AF%E5%BC%95%E7%94%A82.png)

### ARC下的循环引用

![Block循环引用3](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Block%E5%BE%AA%E7%8E%AF%E5%BC%95%E7%94%A83.png)

# 多线程

## GCD

### 同步/异步和串行/并发

- 同步串行：**dispatch\_sync**(serial\_queue, \^{ // 任务})

![同步串行](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%90%8C%E6%AD%A5%E4%B8%B2%E8%A1%8C.png)

**死锁原因**

![死锁原因](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%AD%BB%E9%94%81%E5%8E%9F%E5%9B%A0.png)

- 异步串行：dispatch\_async(serial\_queue, \^{ // 任务})
- 同步并发：**dispatch\_sync**(concurrent\_queue, \^{ // 任务})
- 异步并发：dispatch\_async(concurrent\_queue, \^{ // 任务})

### dispatch\_barrier\_async

使用场景：多读单写

![多读单写](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%A4%9A%E8%AF%BB%E5%8D%95%E5%86%99.png)

![多读单写2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%A4%9A%E8%AF%BB%E5%8D%95%E5%86%992.png)

```objc
- (id)objectForKey:(NSString *)key {
	__block id obj;
	// 同步读取指定数据
	dispatch_sync(concurrent_queue, ^{
		obj = [userCenterDic objectForKey:key];
	});
	
	return obj;
} 

- (void)setObject:(id)obj forKey:(NSString *)key {
	// 异步栅栏调用设置数据
	dispatch_barrier_async(concurrent_queue, ^{
		[userCenterDic setObject:obj forKey:key];
	});
} 
```

### dispatch\_group\_async

使用场景：A、B、C三个任务并发，完成后执行任务D

![dispatch_group_async](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/dispatch_group_async.png)

```objc
// 创建一个group
dispatch_group_t group = dispatch_group_create();
    
// for循环遍历各个元素执行操作
for (NSURL *url in arrayURLs) {
	// 异步组分派到并发队列当中
	dispatch_group_async(group, concurrent_queue, ^{
		// 根据url去下载图片
            
	});
}
    
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
	// 当添加到组中的所有任务执行完成之后会调用该Block
        
});
```

## NSOperation

需要和NSOperationQueue配合使用来实现多线程方案

- 添加任务依赖
- **任务执行状态控制**：
	- isReady
	- isExecuting
	- isFinished
	- isCancelled

如果只重写了**main**方法，底层控制变更任务执行完成状态，以及任务退出

如果重写了**start**方法，自行控制任务状态

- 最大并发量

## NSThread

![NSThread](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/NSThread.png)

## 锁

### @synchronized

一般在创建单例对象的时候使用

### automic

修饰属性的关键字，对被修饰对象进行原子操作（不负责使用）

### OSSpinLock

自旋锁
- **循环等待**询问，不释放当前资源
- 用于轻量级访问，简单的int值+1/-1操作

### NSLock

![NSLock死锁](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/NSLock%E6%AD%BB%E9%94%81.png)

### NSRecursiveLock

递归锁，可以重入

![NSRecursiveLock](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/NSRecursiveLock.png)

### dispatch\_semaphore\_t

信号量

- **dispatch\_semaphore\_create**(1)

```objc
struct semaphore {
	int value;
	List<Thread>;
}
```

- **dispatch\_semaphore\_wait**(semaphore, DISPATCH\_TIME\_FOREVER)

```objc
dispatch_semaphore_wait () {
	S.value = S.value - 1;
	if S.value < 0 then Block(S.List);// 阻塞是一个主动行为
}
```

- **dispatch\_semaphore\_signal**(semaphore);

```objc
dispatch_semaphore_signal () {
	S.value = S.value + 1;
	if S.value <= 0 then wakeup(S.List);// 唤醒是一个被动行为
}
```

# RunLoop

> Runloop是通过内部维护的**事件循环**来对**事件/消息进行管理**的一个对象

- 没有消息需要处理时，休眠以避免资源占用

![RunLoop-1](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/RunLoop-1.png)

- 有消息需要处理时，立刻被唤醒

![RunLoop-2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/RunLoop-2.png)

![RunLoop2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/RunLoop2.png)

## 数据结构

NSRunLoop是CFRunLoop的封装，提供了面向对象的API

### CFRunLoop

![CFRunLoop](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/CFRunLoop.png)

### CFRunLoopMode

![CFRunLoopMode](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/CFRunLoopMode.png)

### CFRunLoopSource

- source0：需要手动唤醒线程
- source1：**具备唤醒线程能力**

### CFRunLoopSource

和NSTimer是toll-free bridge的

### CFRunLoopObserver

观测时间点：

- kCFRunLoopEntry
- kCFRunLoopBeforeTimers
- kCFRunLoopBeforeSources
- kCFRunLoopBeforeWaiting
- kCFRunLoopAfterWaiting
- kCFRunLoopExit

### 各个数据结构之间的关系

![RunLoop3](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/RunLoop3.png)

![RunLoop4](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/RunLoop4.png)

### CommonMode的特性

- CommonMode**不是一个实际存在**的Mode
- 是同步Source/Timer/Observer到多个Mode中的**一种技术方案**

### 事件循环的实现机制

![事件循环](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E4%BA%8B%E4%BB%B6%E5%BE%AA%E7%8E%AF.png)

### RunLoop的核心

![RunLoop核心](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/RunLoop%E6%A0%B8%E5%BF%83.png)

### RunLoop与NSTimer

```objc
void CFRunLoopAddTimer(runloop, timer, commonMode)
```

### RunLoop与多线程

线程是和RunLoop一一对应的
自己创建的线程默认是没有RunLoop的

**怎样实现一个常驻线程？**

- 为当前线程开启一个RunLoop（CFRunLoopGetCurrent函数会在第一次调用时为当前线程创建一个RunLoop）
- 向RunLoop中添加一个Port/Source等维持RunLoop的事件循环
- 启动该RunLoop

```objc
// 创建一个Source
CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    
// 创建RunLoop，同时向RunLoop的DefaultMode下面添加Source
CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
// 如果可以运行
while (runAlways) {
	@autoreleasepool {
		// 令当前RunLoop运行在DefaultMode下面
		CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
	}
}
    
// 某一时机 静态变量runAlways = NO时 可以保证跳出RunLoop，线程退出
CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
CFRelease(source);
```


# 网络

## HTTP

> HTTP（HyperText Transfer Protocol），即超文本传输协议。

### 请求报文

![请求报文](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E8%AF%B7%E6%B1%82%E6%8A%A5%E6%96%87.png)

### 响应报文

![响应报文](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%93%8D%E5%BA%94%E6%8A%A5%E6%96%87.png)

### 请求方式

- `GET`
- `POST`
- `HEAD`
- `PUT`
- `DELETE`
- `OPTION`

### GET和POST的区别

- `GET`请求参数以?分割拼接到URL后面，`POST`请求参数在Body里面
- `GET`参数长度限制2048个字符，`POST`一般没有该限制
- `GET`请求不安全，`POST`请求比较安全

**从语义的角度来回答**

- `GET`：获取资源
	- 安全的
	- 幂等的
	- 可缓存的
- `POST`：处理资源
	- 非安全的
	- 非幂等的
	- 不可缓存的   

- 安全性：不引起Server端的任何状态变化（`GET`、`HEAD`、`OPTION`）
- 幂等性：同一个请求方法执行多次和执行一次的效果完全相同（`PUT`、`DELETE`）
- 可缓存性：请求是否可以被缓存（`GET`、`HEAD`）

### 状态码

- 1xx：信息，服务器收到请求，需要请求者继续执行操作
- 2xx：成功，操作被成功接收并处理
	- 200：请求成功。一般用于GET与POST请求
- 3xx：重定向，需要进一步的操作以完成请求
	- 301：永久移动。请求的资源已被永久的移动到新URI，返回信息会包括新的URI，浏览器会自动定向到新URI。今后任何新的请求都应使用新的URI代替
- 4xx：客户端错误，请求包含语法错误或无法完成请求
	- 401：请求要求用户的身份认证
	- 404：服务器无法根据客户端的请求找到资源（网页）
- 5xx：服务器错误，服务器在处理请求的过程中发生了错误
	- 500：服务器内部错误，无法完成请求

### HTTP连接

![HTTP连接](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/HTTP%E8%BF%9E%E6%8E%A5.png)

### HTTP的特点

- 无连接（HTTP的持久连接）
- 无状态（Cookie/Session）

### 持久连接

![持久连接](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%8C%81%E4%B9%85%E8%BF%9E%E6%8E%A5.png)

头部字段

- Connection：keep-alive
- time：20
- max：10

怎样判断一个连接是否结束？

- **Content-length**：1024
- **chunked**，最后会有一个空的chunked

### HTTP抓包

![HTTP抓包](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/HTTP%E6%8A%93%E5%8C%85.png)


## HTTPS

HTTPS = HTTP + SSL/TLS

![HTTPS](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/HTTPS.png)

![HTTPS2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/HTTPS2.png)

### HTTPS与网络安全

会话秘钥 = random S + random C + 预主秘钥

- 连接建立过程使用**非对称加密**，非对称加密很**耗时**的

![非对称加密](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%9D%9E%E5%AF%B9%E7%A7%B0%E5%8A%A0%E5%AF%86.png)

- 后续通信过程使用**对称加密**

![对称加密](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%AF%B9%E7%A7%B0%E5%8A%A0%E5%AF%86.png)

## UDP（用户数据报协议）

### 特点：

- 无连接
- 尽最大努力交付
- 面向报文（既不合并，也不拆分）

![面向报文](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%9D%A2%E5%90%91%E6%8A%A5%E6%96%87.png)

### 功能

- 复用、分用

![复用分用](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%A4%8D%E7%94%A8%E5%88%86%E7%94%A8.png)

## TCP（传输控制协议）

### 面向连接

- 数据传输开始之前，需要建立连接（三次握手）

![三次握手](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E4%B8%89%E6%AC%A1%E6%8F%A1%E6%89%8B.png)

- 数据传输结束之后，需要释放连接（四次挥手）

![四次挥手](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%9B%E6%AC%A1%E6%8C%A5%E6%89%8B.png)

### 可靠传输

- 无差错

![无差错](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%97%A0%E5%B7%AE%E9%94%99.png)

- 不丢失

![超时重传](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E8%B6%85%E6%97%B6%E9%87%8D%E4%BC%A0.png)

![确认丢失](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E7%A1%AE%E8%AE%A4%E4%B8%A2%E5%A4%B1.png)

![确认迟到](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E7%A1%AE%E8%AE%A4%E8%BF%9F%E5%88%B0.png)

- 不重复
- 按序到达

### 面向字节流

![面向字节流](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%9D%A2%E5%90%91%E5%AD%97%E8%8A%82%E6%B5%81.png)

### 流量控制

滑动窗口协议

![滑动窗口](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%BB%91%E5%8A%A8%E7%AA%97%E5%8F%A3.png)

### 拥塞控制

- **慢开始，拥塞避免**
- 快恢复，快重传

![拥塞控制](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%8B%A5%E5%A1%9E%E6%8E%A7%E5%88%B6.png)

## DNS解析

域名到IP地址的映射，DNS解析请求采用UDP数据报，且明文

![DNS解析](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/DNS%E8%A7%A3%E6%9E%90.png)

### 递归查询

![DNS解析2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/DNS%E8%A7%A3%E6%9E%902.png)

### 迭代查询

![DNS解析3](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/DNS%E8%A7%A3%E6%9E%903.png)

### DNS劫持

![DNS劫持](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/DNS%E5%8A%AB%E6%8C%81.png)

DNS劫持和HTTP是没有关系的

- DNS解析发生在HTTP建立连接之前
- DNS解析请求使用UDP数据报，端口号是53

### DNS解析转发

![DNS解析转发](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/DNS%E8%A7%A3%E6%9E%90%E8%BD%AC%E5%8F%91.png)

### httpDNS

使用HTTP协议向DNS服务器的80端口进行请求

![httpDNS](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/httpDNS.png)

### 长连接

![长连接](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%95%BF%E8%BF%9E%E6%8E%A5.png)

## Cookie

Cookie主要用来记录用户状态，区分用户；**状态保存在客户端**

![Cookie](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Cookie.png)

### 删除Cookie

- 新cookie覆盖旧cookie
- 覆盖规则：name、path、domain等需要与原cookie一致
- 设置cookie的**expire=过去的一个时间点**，或者**maxAge=0**

### Cookie安全

- 对Cookie进行加密处理
- 只在https上携带Cookie
- 设置Cookie的httpOnly，防止跨站脚本攻击

## Session

Session也是用来记录用户状态，区分用户的；**状态存放在服务器**

![Session](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/Session.png)


# 设计模式

## 六大设计原则

- 单一职责原则
	- 一个类只负责一件事
- 开闭原则
	- 对修改关闭，对扩展开放
- 接口隔离原则
	- 使用多个专门的协议，而不是一个庞大臃肿的协议
	- 协议中的方法应当尽量少
- 依赖倒置原则
	- 抽象不应该依赖于具体实现，具体实现可以依赖于抽象
- 里氏替换原则
	- 父类可以被子类无缝替换，且原有功能不受任何影响
- 迪米特法则
	- 一个对象应当对其他对象有尽可能少的了解
	- 高内聚，低耦合

## 责任链

![责任链](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E8%B4%A3%E4%BB%BB%E9%93%BE.png)

## 桥接

![桥接](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%A1%A5%E6%8E%A5.png)

## 适配器

一个现有类需要适应变化的问题

- **对象适配器**
- 类适配器

![适配器](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%80%82%E9%85%8D%E5%99%A8.png)

## 单例

## 命令

- 行为参数化
- **降低代码重合度**


# 架构/框架

- 模块化
- 分层
- 解耦
- 降低代码重合度

## 图片缓存

![图片缓存](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E7%89%87%E7%BC%93%E5%AD%98.png)

### 内存设计

- 以图片URL的单向Hash值作为Key

![图片缓存2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E7%89%87%E7%BC%93%E5%AD%982.png)

- 存储的Size

![图片缓存3](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E7%89%87%E7%BC%93%E5%AD%983.png)

- 淘汰策略
	- 以队列先进先出的方式淘汰
	- LRU算法（如30分钟内是否使用过）

![图片缓存4](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E7%89%87%E7%BC%93%E5%AD%984.png)

![图片缓存5](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E7%89%87%E7%BC%93%E5%AD%985.png)

### 磁盘设计

- 存储方式
- 大小限制（如100MB）
- 淘汰策略（如某一图片存储时间距今已超过7天）

### 网络设计

- 图片请求最大并发量
- 请求超时策略
- 请求优先级

### 图片解码

- 应用策略模式对不同图片格式进行解码
- 在哪个阶段做图片解码处理
	- 磁盘读取后
	- 网络请求返回后 

### 线程处理

![图片缓存6](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E7%89%87%E7%BC%93%E5%AD%986.png)

## 阅读时长统计

![阅读时长统计](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%98%85%E8%AF%BB%E6%97%B6%E9%95%BF%E7%BB%9F%E8%AE%A1.png)

### 记录器

- 基于不同分类场景提供的关于记录的封装、适配

### 记录的缓存 & 存储

- 定时写磁盘
- 限定内存缓存条数（如10条），超过该条数，即写磁盘

### 记录上传器

延迟上传场景：

- 前后台切换
- 从无网到有网的变化
- 通用轻量接口捎带

上传时机把控

- 立刻上传
- 延时上传
- 定时上传

## 复杂页面框架

### MVVM

![MVVM](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/MVVM.png)

### RN数据流思想

![RN](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/RN.png)

### 客户端整体架构

![客户端整体架构](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%AE%A2%E6%88%B7%E7%AB%AF%E6%95%B4%E4%BD%93%E6%9E%B6%E6%9E%84.png)

业务之间的解耦通信方式

- OpenURL
- **依赖注入**

![依赖注入](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5.png)


# 算法

## 字符串反转

![字符串反转](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%AD%97%E7%AC%A6%E4%B8%B2%E5%8F%8D%E8%BD%AC.png)

```objc
void char_reverse(char* cha)
{
    // 指向第一个字符
    char* begin = cha;
    // 指向最后一个字符
    char* end = cha + strlen(cha) - 1;
    
    while (begin < end) {
        // 交换前后两个字符,同时移动指针
        char temp = *begin;
        *(begin++) = *end;
        *(end--) = temp;
    }
}
```

## 单链表反转

![单链表反转](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E9%93%BE%E8%A1%A8%E5%8F%8D%E8%BD%AC.png)

```objc
struct Node* reverseList(struct Node *head)
{
    // 定义遍历指针，初始化为头结点
    struct Node *p = head;
    // 反转后的链表头部
    struct Node *newH = NULL;
    
    // 遍历链表
    while (p != NULL) {
        
        // 记录下一个结点
        struct Node *temp = p->next;
        // 当前结点的next指向新链表头部
        p->next = newH;
        // 更改新链表头部为当前结点
        newH = p;
        // 移动p指针
        p = temp;
    }
    
    // 返回反转后的链表头结点
    return newH;
}

struct Node* constructList(void)
{
    // 头结点定义
    struct Node *head = NULL;
    // 记录当前尾结点
    struct Node *cur = NULL;
    
    for (int i = 1; i < 5; i++) {
        struct Node *node = malloc(sizeof(struct Node));
        node->data = i;
        
        // 头结点为空，新结点即为头结点
        if (head == NULL) {
            head = node;
        }
        // 当前结点的next为新结点
        else{
            cur->next = node;
        }
        
        // 设置当前结点为新结点
        cur = node;
    }
    
    return head;
}

void printList(struct Node *head)
{
    struct Node* temp = head;
    while (temp != NULL) {
        printf("node is %d \n", temp->data);
        temp = temp->next;
    }
}
```

## 有序数组归并

![有序数组归并](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E6%9C%89%E5%BA%8F%E6%95%B0%E7%BB%84%E5%BD%92%E5%B9%B6.png)

```objc
void mergeList(int a[], int aLen, int b[], int bLen, int result[])
{
    int p = 0; // 遍历数组a的指针
    int q = 0; // 遍历数组b的指针
    int i = 0; // 记录当前存储位置
    
    // 任一数组没有到达边界则进行遍历
    while (p < aLen && q < bLen) {
        // 如果a数组对应位置的值小于b数组对应位置的值
        if (a[p] <= b[q]) {
            // 存储a数组的值
            result[i] = a[p];
            // 移动a数组的遍历指针
            p++;
        }
        else{
            // 存储b数组的值
            result[i] = b[q];
            // 移动b数组的遍历指针
            q++;
        }
        // 指向合并结果的下一个存储位置
        i++;
    }
    
    // 如果a数组有剩余
    while (p < aLen) {
        // 将a数组剩余部分拼接到合并结果的后面
        result[i] = a[p++];
        i++;
    }
    
    // 如果b数组有剩余
    while (q < bLen) {
        // 将b数组剩余部分拼接到合并结果的后面
        result[i] = b[q++];
        i++;
    }
}
```

## 哈希表

**在一个字符串中找到第一个只出现一次的字符**

字符char是一个长度为8的数据类型，因此总共有256中可能。每个字母根据其ASCII码值作为数组的下标对应数组的一个数字。数组中存储的是每个字符出现的次数。

![哈希表](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%93%88%E5%B8%8C%E8%A1%A8.png)

```objc
char findFirstChar(char* cha)
{
    char result = '\0';
    // 定义一个数组 用来存储各个字母出现次数
    int array[256];
    // 对数组进行初始化操作
    for (int i=0; i<256; i++) {
        array[i] =0;
    }
    // 定义一个指针 指向当前字符串头部
    char* p = cha;
    // 遍历每个字符
    while (*p != '\0') {
        // 在字母对应存储位置 进行出现次数+1操作
        array[*(p++)]++;
    }
    
    // 将P指针重新指向字符串头部
    p = cha;
    // 遍历每个字母的出现次数
    while (*p != '\0') {
        // 遇到第一个出现次数为1的字符，打印结果
        if (array[*p] == 1)
        {
            result = *p;
            break;
        }
        // 反之继续向后遍历
        p++;
    }
    
    return result;
}
```

## 共同父视图

![共同父视图](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%85%B1%E5%90%8C%E7%88%B6%E8%A7%86%E5%9B%BE.png)

```objc
- (NSArray <UIView *> *)findCommonSuperView:(UIView *)viewOne other:(UIView *)viewOther
{
    NSMutableArray *result = [NSMutableArray array];
    
    // 查找第一个视图的所有父视图
    NSArray *arrayOne = [self findSuperViews:viewOne];
    // 查找第二个视图的所有父视图
    NSArray *arrayOther = [self findSuperViews:viewOther];
    
    int i = 0;
    // 越界限制条件
    while (i < MIN((int)arrayOne.count, (int)arrayOther.count)) {
        // 倒序方式获取各个视图的父视图
        UIView *superOne = [arrayOne objectAtIndex:arrayOne.count - i - 1];
        UIView *superOther = [arrayOther objectAtIndex:arrayOther.count - i - 1];
        
        // 比较如果相等 则为共同父视图
        if (superOne == superOther) {
            [result addObject:superOne];
            i++;
        }
        // 如果不相等，则结束遍历
        else{
            break;
        }
    }
    
    return result;
}

- (NSArray <UIView *> *)findSuperViews:(UIView *)view
{
    // 初始化为第一父视图
    UIView *temp = view.superview;
    // 保存结果的数组
    NSMutableArray *result = [NSMutableArray array];
    while (temp) {
        [result addObject:temp];
        // 顺着superview指针一直向上查找
        temp = temp.superview;
    }
    return result;
}
```

## 无效数组职工查找中位数

- 排序算法+中位数
- **利用快排思想（分治思想）**

### 排序算法

- 冒泡排序
- 快速排序
- 堆排序
- ……

### 中位数

- 当n为奇数时，(n+1)/2
- 当n为偶数时，(n/2+(n/2+1))/2

### 快排思想

选取关键字，高低交替扫描

- 任意挑一个元素，以该元素为支点，划分集合为两部分。
- 如果左侧集合长度恰为(n-1)/2，那么支点恰为中位数。
- 如果左侧长度<(n-1)/2，那么中位点在右侧；反之，中位数在左侧。
- 进入相应的一侧继续寻找中位点。

![快排思想](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E5%BF%AB%E6%8E%92%E6%80%9D%E6%83%B3.png)

```objc
int findMedian(int a[], int aLen)
{
    int low = 0;
    int high = aLen - 1;
    
    int mid = (aLen - 1) / 2;
    int div = PartSort(a, low, high);
    
    while (div != mid)
    {
        if (mid < div)
        {
            //左半区间找
            div = PartSort(a, low, div - 1);
        }
        else
        {
            //右半区间找
            div = PartSort(a, div + 1, high);
        }
    }
    //找到了
    return a[mid];
}

int PartSort(int a[], int start, int end)
{
    int low = start;
    int high = end;
    
    //选取关键字
    int key = a[end];
    
    while (low < high)
    {
        //左边找比key大的值
        while (low < high && a[low] <= key)
        {
            ++low;
        }
        
        //右边找比key小的值
        while (low < high && a[high] >= key)
        {
            --high;
        }
        
        if (low < high)
        {
            //找到之后交换左右的值
            int temp = a[low];
            a[low] = a[high];
            a[high] = temp;
        }
    }
    
    int temp = a[high];
    a[high] = a[end];
    a[end] = temp;
    
    return low;
}
```

# 第三方

## AFNetworking

### 框架图

![AFNetworking](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/AFNetworking.png)

### 类关系图

![AFNetworking2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/AFNetworking2.png)

### AFURLSessionManager

- 创建和管理NSURLSession、NSURLSessionTask
- 实现NSURLSessionDelegate等协议的代理方法
- 引入AFSecurityPolicy保证请求安全
- 引入AFNetworkReachabilityManager监控网络状态

## SDWebImage

### 框架图

![SDWebImage](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/SDWebImage.png)

### 加载图片流程

![SDWebImage2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/SDWebImage2.png)

## ReactiveCocoa

### 类关系图

![ReactiveCocoa](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/ReactiveCocoa.png)

### 信号

![ReactiveCocoa2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/ReactiveCocoa2.png)

信号代表一连串的状态，在状态改变时，RACSubscriber就会收到通知执行相应的命令

![ReactiveCocoa3](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/ReactiveCocoa3.png)

### 订阅

![ReactiveCocoa4](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/ReactiveCocoa4.png)

![ReactiveCocoa5](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/ReactiveCocoa5.png)

## AsyncDisplayKit

![AsyncDisplayKit](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/AsyncDisplayKit.png)

### 基本原理

![AsyncDisplayKit2](https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/AsyncDisplayKit2.png)

针对ASNode的修改和提交，会对其进行封装并提交到全局容器当中。ASDK也在RunLoop中注册了一个Observer。当RunLoop进入休眠前，ASDK执行该loop内提交的所有任务。

# 面试题汇总

## OC底层面试题

- [一个NSObject对象占用多少内存空间？](https://www.jianshu.com/p/87ec5de0a236)


## UI相关面试题

- [UI相关面试题](https://www.jianshu.com/p/79b88d62b962)

## Animation相关面试题

- [请说一下对CALayer的认识](https://www.jianshu.com/p/e4eeebf56b97)
- [CALayer的contents有几个主要的属性](https://www.jianshu.com/p/ce0f37be5a63)

## Objective-C语言特性

- [KVC(Key-value coding)](https://www.jianshu.com/p/5411ce49f8bc)
- [KVO(Key-value observing)](https://www.jianshu.com/p/006fa7824af4)
- [分类、扩展、代理（Delegate）](https://www.jianshu.com/p/02a126ac641b)
- [属性关键字](https://www.jianshu.com/p/6c8db60c486a)
- [通知（NSNotification）](https://www.jianshu.com/p/1a6f2b6f05e4)

## iOS Runtime相关面试题

- [一个objc对象的isa的指针指向什么？有什么作用？](https://www.jianshu.com/p/c0030be57c02)
- [说一下对class\_rw\_t的理解](https://www.jianshu.com/p/f54c4f0c2253)
- [说一下对class\_ro\_t的理解](https://www.jianshu.com/p/2d92e6b8a815)
- [说一下对isa指针的理解](https://www.jianshu.com/p/167228b2c773)
- [说一下Runtime的方法缓存，存储的形式、数据结构以及查找的过程](https://www.jianshu.com/p/7c16b8782974)
- [使用Runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？](https://www.jianshu.com/p/c1b4841969e1)
- [实例对象的数据结构？](https://www.jianshu.com/p/0aa7a7997931)
- [什么是method swizzling（俗称黑魔法)](https://www.jianshu.com/p/c7b40b68d1fa)
- [什么时候会报unrecognized selector的异常？](https://www.jianshu.com/p/c37a9ef57072)
- [如何给Category添加属性？关联对象以什么形式进行存储？](https://www.jianshu.com/p/0408e6fb3b8f)
- [能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？](https://www.jianshu.com/p/faf14147c25d)
- [类对象的数据结构？](https://www.jianshu.com/p/c9573a8c97c0)
- [Runtime如何通过selector找到对应的IMP地址？](https://www.jianshu.com/p/f24fbb2c5db2)
- [Runtime如何实现weak变量的自动置nil？知道SideTable吗？](https://www.jianshu.com/p/5de63ac9dab7)
- [objc中向一个nil对象发送消息将会发生什么？](https://www.jianshu.com/p/891a849ca750)
- [objc在向一个对象发送消息时，发生了什么？](https://www.jianshu.com/p/fc400ba1df0c)
- [isKindOfClass与isMemberOfClass](https://www.jianshu.com/p/87ce88d0bb99)
- [Category在编译过后，是在什么时机与原有的类合并到一起的？](https://www.jianshu.com/p/0df4638a9748)
- [Category有哪些用途？](https://www.jianshu.com/p/3a59a49546ff)
- [Category的实现原理？](https://www.jianshu.com/p/265caa43022d)
- [\_objc\_msgForward函数是做什么的](https://www.jianshu.com/p/3d7b88b60203)
- [[self class]与[super class]](https://www.jianshu.com/p/7a2fc35dd607)
- [代码题 一](https://www.jianshu.com/p/a8e32de4858f)
- [代码题 二](https://www.jianshu.com/p/936d1dfc67c4)

## 内存管理相关面试题

- [在Obj-C中，如何检测内存泄漏？你知道哪些方式？](https://www.jianshu.com/p/e7ac38c9759f)
- [在MRC下如何重写属性的Setter和Getter](https://www.jianshu.com/p/1299891db739)
- [循环引用](https://www.jianshu.com/p/33b7b326dcc4)
- [说一下什么是悬垂指针？什么是野指针?](https://www.jianshu.com/p/47b148fea94f)
- [说一下对retain，copy，assign，weak，\_unsafe\_unretain关键字的理解](https://www.jianshu.com/p/ef55a24b02b2)
- [是否了解深拷贝和浅拷贝的概念，集合类深拷贝如何实现](https://www.jianshu.com/p/d7dcc1a4170a)
- [使用自动引用计数应遵循的原则](https://www.jianshu.com/p/be723dadae4a)
- [能不能简述一下Dealloc的实现机制](https://www.jianshu.com/p/c00e2fdb5afb)
- [内存中的5大区分别是什么？](https://www.jianshu.com/p/b5b2e929d63f)
- [内存管理默认的关键字是什么？](https://www.jianshu.com/p/fb155c5fbacd)
- [内存管理方案](https://www.jianshu.com/p/92bfaefa6bb7)
- [内存布局](https://www.jianshu.com/p/aecf0093b074)
- [讲一下iOS内存管理的理解](https://www.jianshu.com/p/743b1dcf4ba0)
- [讲一下@dynamic关键字？](https://www.jianshu.com/p/c0355708d6e4)
- [简要说一下@autoreleasePool的数据结构？](https://www.jianshu.com/p/e33383c4c3ad)
- [访问\_\_weak修饰的变量，是否已经被注册在了@autoreleasePool中？为什么？](https://www.jianshu.com/p/8524329777dd)
- [retain、release的实现机制？](https://www.jianshu.com/p/9147a2d92dda)
- [MRC（手动引用计数）和ARC(自动引用计数)](https://www.jianshu.com/p/c126fdc48520)
- [iOS内存管理面试题（BAD\_ACCESS在什么情况下出现? ）](https://www.jianshu.com/p/2c086bcf695a)
- [autoReleasePool什么时候释放?](https://www.jianshu.com/p/73150489071e)
- [ARC自动内存管理的原则](https://www.jianshu.com/p/2a481aad2e0b)
- [ARC在运行时做了哪些工作？](https://www.jianshu.com/p/d716bda927ac)
- [ARC在编译时做了哪些工作](https://www.jianshu.com/p/468b6071dd7c)
- [ARC的retainCount怎么存储的？](https://www.jianshu.com/p/f54dcc0bd45d)
- [\_\_weak属性修饰的变量，如何实现在变量没有强引用后自动置为nil？](https://www.jianshu.com/p/130e676efa4a)
- [\_\_weak和\_unsafe\_unretain的区别？](https://www.jianshu.com/p/86e4b5625ad5)

## Block相关面试题

- [Block的几种形式](https://www.jianshu.com/p/ab5cd4153bf8)
- [什么是Block？](https://www.jianshu.com/p/cc91ff650d6c)
- [Block变量截获](https://www.jianshu.com/p/dd5fea4dcea8)

## 多线程相关面试题

- [进程、线程](https://www.jianshu.com/p/fd3491d7affd)
- [多进程、多线程](https://www.jianshu.com/p/18797cf8e03c)
- [任务、队列](https://www.jianshu.com/p/7bb8a4a79407)
- [iOS中的多线程](https://www.jianshu.com/p/361e8a0a4e7e)
- [GCD队列](https://www.jianshu.com/p/7148373e1e19)
- [死锁](https://www.jianshu.com/p/1f1b9516c631)
- [GCD任务执行顺序](https://www.jianshu.com/p/3359dc188e61)
- [dispatch\_barrier\_async](https://www.jianshu.com/p/540c2b22ba38)
- [dispatch\_group\_async](https://www.jianshu.com/p/64450ba8c9cc)
- [Dispatch Semaphore](https://www.jianshu.com/p/8549a35b7bf2)
- [延时函数(dispatch\_after)](https://www.jianshu.com/p/19f83c20591f)
- [使用dispatch\_once实现单例](https://www.jianshu.com/p/d5de9d5a571c)
- [NSOperationQueue的优点](https://www.jianshu.com/p/cbf759bdfd0f)
- [NSOperation和NSOperationQueue](https://www.jianshu.com/p/9161a6490977)
- [NSThread+Runloop实现常驻线程](https://www.jianshu.com/p/f0bcc10abad0)
- [自旋锁与互斥锁](https://www.jianshu.com/p/80043c824d2d)

## iOS Runloop相关面试题

- [为什么NSTimer有时候不好使？](https://www.jianshu.com/p/39242dd0a5cb)
- [AFNetworking中如何运用Runloop?](https://www.jianshu.com/p/64b8f511cf29)
- [autoreleasePool在何时被释放？](https://www.jianshu.com/p/5d9e3d0c4d22)
- [PerformSelector的实现原理？](https://www.jianshu.com/p/8efd42bc1ede)
- [PerformSelector:afterDelay:这个方法在子线程中是否起作用？为什么？怎么解决？](https://www.jianshu.com/p/5cf2e7e5fda4)
- [RunLoop的Mode](https://www.jianshu.com/p/e5ef308cc2eb)
- [RunLoop的实现机制](https://www.jianshu.com/p/cc1bb6cba76d)
- [RunLoop和线程](https://www.jianshu.com/p/bfeb6fb0c057)
- [RunLoop的数据结构](https://www.jianshu.com/p/64c478fe2cf1)
- [RunLoop概念](https://www.jianshu.com/p/010bcea3dcbb)
- [RunLoop与NSTimer](https://www.jianshu.com/p/754e6175aede)
- [讲一下Observer？](https://www.jianshu.com/p/bac5c2462e69)
- [解释一下NSTimer](https://www.jianshu.com/p/6847b9e91028)
- [解释一下事件响应的过程？](https://www.jianshu.com/p/9c3d136302be)
- [解释一下手势识别的过程？](https://www.jianshu.com/p/32d97298d669)
- [利用runloop解释一下页面的渲染的过程？](https://www.jianshu.com/p/8900516f1644)
- [什么是异步绘制？](https://www.jianshu.com/p/0b821ee64860)

## 网络相关面试题

- [HTTP协议](https://www.jianshu.com/p/c8b818c535ed)
- [HTTPS、对称加密、非对称加密](https://www.jianshu.com/p/ac3a80ca59c3)
- [一个基于UDP的简单的聊天Demo](https://www.jianshu.com/p/f1347625814a)
- [UDP的特点、UDP的报文结构及差错检测](https://www.jianshu.com/p/1e1dd880cb4f)
- [TCP、三次握手、四次挥手、代码实现](https://www.jianshu.com/p/f52616e175c6)
- [可靠数据传输、流量控制(滑动窗口)、拥塞控制](https://www.jianshu.com/p/5fa1910b7a39)
- [DNS](https://www.jianshu.com/p/6cfece489114)
- [Cookie和Session](https://www.jianshu.com/p/0fb7b70a0a03)
- [IP协议、IP数据报分片、IPv4编址、网络地址转换（NAT）](https://www.jianshu.com/p/9bcd84bdac95)
- [IPv6、从IPv4到IPv6的迁移](https://www.jianshu.com/p/55f936d7ac1a)

## 设计模式相关面试题

- [如何设计一个时长统计框架？](https://www.jianshu.com/p/ac78cc5ed30d)
- [如何设计一个图片缓存框架？](https://www.jianshu.com/p/9d114a82f77b)
- [编程中的六大设计原则？](https://www.jianshu.com/p/369921db15e7)

## 数据结构与算法

- [iOS开发 数据结构](https://www.jianshu.com/p/622e929597a2)
- [iOS 算法面试题（一）](https://www.jianshu.com/p/e0b5140ca1b3)
- [iOS 算法面试题（二）](https://www.jianshu.com/p/bc2cb99bbf20)

## 性能优化

- [iOS 性能优化面试题](https://www.jianshu.com/p/c6469ecb3828)
- [光栅化](https://www.jianshu.com/p/25c9ca0bd008)
- [日常如何检查内存泄露？](https://www.jianshu.com/p/ef02333774a8)
- [如何高性能的画一个圆角？](https://www.jianshu.com/p/4deb3d6c5ddc)
- [如何提升tableview的流畅度？](https://www.jianshu.com/p/91ba3c007075)
- [如何优化APP的电量？](https://www.jianshu.com/p/e270ad11e25a)
- [如何有效降低APP包的大小？](https://www.jianshu.com/p/8502a35bf4d4)
- [什么是离屏渲染？什么情况下会触发？该如何应对？](https://www.jianshu.com/p/02ab3ba0212e)
- [如何检测离屏渲染？](https://www.jianshu.com/p/d7c5954dc6d6)
- [怎么检测图层混合？](https://www.jianshu.com/p/c6000c10dd3e)

## 数据安全及加密

- [RSA非对称加密](https://www.jianshu.com/p/1431264b257e)
- [简述SSL加密的过程用了哪些加密方法，为何这么作？](https://www.jianshu.com/p/50e3685ce912)

**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
