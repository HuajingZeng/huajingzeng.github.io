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

- Block是将**函数**及其**执行上下文**封装起来的**对象**
- Block调用即是**函数的调用**

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

- NSRecursiveLock
- NSLock
- dispatch_samaphore_t

# RunLoop

## 事件循环

## 用户态

## 核心态

## 常驻线程

<!--
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

## 无序数组中找中位数


# 第三方

## AFNetworking

## ReactCocoa响应式编程库

-->

**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
