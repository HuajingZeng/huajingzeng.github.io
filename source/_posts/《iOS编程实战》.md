---
title: 《iOS编程实战》
date: 2019-05-06 15:03:30
update:
author:
tags:
	- iOS
categories:
	- 编程基础
thumbnail: https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E3%80%8AiOS%E7%BC%96%E7%A8%8B%E5%AE%9E%E6%88%98%E3%80%8B.jpg
blogexcerpt:
toc: true
---

如题

<!--more-->

# 你可能不知道的

## 命名

### 变量

- 变量的名字应该跟变量的类型相匹配，不要为了简略而造成歧义

### 方法

- 方法的命名应该用驼峰命名法，第一个字母小写
- 如果方法用`alloc`、`new`、`copy`、`mutableCopy`开头，那么调用者拥有返回的对象。属性命名应该避免以这些单词作为开头
- get开头的方法应该返回一个值的引用

## 属性和实例变量

**应该使用存取器（setter/getter）的情形**

- 键值观察：存取器中会调用`willChangeValueForKey:`和`didChangeValueForKey:`。如果直接访问实例变量，开发者需要自己调用这些方法以使其能够支持键值观察
- 副作用：开发者在存取器中可能实现通知、注册事件或增加缓存等，直接访问实例变量会绕开这些功能
- 惰性初始化：如果属性是惰性初始化的，必须用存取器使其正确释放
- 锁：如果为属性引入锁来管理多线程代码，直接访问实例变量会破坏锁并可能使程序崩溃
- 一致性：使用存取器会让代码易于阅读、评审和维护

**应该直接访问实例变量的情形**

- 在存取器内部：有些情况下会发生死循环
- dealloc：不要在`dealloc`中调用外部对象，对象可能处于不一致状态，观察者收到属性变化的多个通知可能会迷惑，而实际上真正含义是对象正在被销毁
- 初始化：对象可能处于不一致状态，在这个阶段一般不应该触发通知或者有别的副作用

## 分类

- 为避免碰撞，分类方法前面应该加上前缀，后面跟上下划线。
- 把多个实用方法放在一个分类中比较方便，但是要避免造成代码膨胀，因为Objective-C无法像C或C++那样高效地做无用代码删除

### +load和+initialize的对比

当分类第一次附着到类上时会运行`+load`方法。每个分类都可以实现`+load`方法，而且每个实现都会运行，运行顺序没有保证，也不应该手动调用。对于`load`和`initialize`方法，都不应该手动调用

**+load**

`load`函数是当类或分类（Category）被加载到Objective-C runtime时（就是被引用的时候）被调用的，实现这个方法可以让我们在类加载的时候执行一些类相关的行为。当类被引用进项目的时候就会执行load函数（在main函数开始执行之前），与这个类是否被用到无关，每个类的`load`函数只会自动调用一次。`load`函数调用特点如下：

- 当父类和子类都实现`load`函数时，二者的`load`方法都会被调用，父类的`load`方法执行顺序要优先于子类
- 当子类未实现`load`方法时，在加载该子类时，不会去调用其父类`load`方法
- 类中的`load`方法执行顺序要优先于类别（Category）
- 当有多个类别（Category）都实现了`load`方法，这几个`load`方法都会执行，但执行顺序与编译顺序一致，即与类别在Compile Sources中出现的顺序一致
- 当有多个不同的类的时候，每个类`load`执行顺序与编译顺序一致，即与其在Compile Sources出现的顺序一致

**+initialize**

`initialize`函数是在类或者其子类的收到第一条消息之前调用。这里所指的消息包括实例方法和类方法的调用。也就是说`initialize`方法是以懒加载的方式被调用的，如果程序一直没有给某个类或它的子类发送消息，那么这个类的`initialize`方法是永远不会被调用的。`initialize`函数调用特点如下：

- 父类的`initialize`方法会比子类先执行
- 当子类未实现`initialize`方法时，在该子类收到第一条消息之前，会调用父类`initialize`方法，子类实现`initialize`方法时，则会覆盖父类`initialize`方法。有点多态的意思
- 当有多个Category都实现了`initialize`方法，会覆盖类中的方法，只执行最后那个被编译的，即Compile Sources列表中最后一个Category的`initialize`方法

## 关联引用

```cpp
typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
    OBJC_ASSOCIATION_ASSIGN = 0,
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,
    OBJC_ASSOCIATION_RETAIN = 01401,
    OBJC_ASSOCIATION_COPY = 01403
};

void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);

id objc_getAssociatedObject(id object, const void *key);
```

- 关联引用基于键的内存地址，而不是值的。`key`中存着什么并不重要，只要`&key`是唯一不变的地址就行。所以一般用未赋值的`static char`变量作为键
- 关联引用有良好的内存管理，当相关对象被销毁时关联引用会被释放。可以用关联引用来追踪另一个对象何时被销毁
- 关联引用无法集成`encodeWithCoder:`，所以很难通过分类序列化对象

## 弱引用容器

指针容器类，可以配置为持有弱引用、非对象的指针或者其他罕见情形，在初始化时使用NSPointerFunctions类进行配置。详见：[NSHash​Table & NSMap​Table](https://nshipster.cn/nshashtable-and-nsmaptable/)

- NSPointerArray：类似NSArray，可以存储NULL值
- NSHashTable：类似NSSet
- NSMapTable：类似NSDictionary

## NSCache

NSCache是多线程安全的。它可以设计为能与`<NSDiscardableContent>`协议的对象（常见类型是NSPurgeableData）整合，通过`beginContentAccess`和`endContentAccess`，可以控制何时丢弃对象时安全的。

## NSURLComponents

NSURLComponents可以很方便地把URL分成几个部分，它定义在NSURL.h文件中，NSURL.h添加了一些有用的分类来处理URL。

## CFStringTransform

CFStringTransform可以把字符串变得容易标准化、索引、和搜索。

```cpp
CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, CFSTR("你好"));

CFStringTransform(string, NULL, kCFStringTransformToLatin, false);
// string => 'nǐ hǎo'

CFStringTransform(string, NULL, kCFStringTransformStripCombiningMarks, false); 
// string => 'ni hao'

CFRelease(string);
```

|转换方式|输入|输出|说明|
|:--|:--|:--|:--|
|kCFStringTransformLatinArabic|mrḥbạ|مرحبا|阿拉伯语拉丁字母|
|kCFStringTransformLatinCyrillic|privet|привет|西里尔拉丁字母|
|kCFStringTransformLatinGreek|geiá sou|γειά σου|希腊拉丁字母|
|kCFStringTransformLatinHangul|annyeonghaseyo|안녕하세요|韩文的拉丁字母|
|kCFStringTransformLatinHebrew|şlwm|שלום|希伯来语拉丁字母|
|kCFStringTransformLatinHiragana|hiragana|ひらがな|平假名拉丁字母|
|kCFStringTransformLatinKatakana|katakana|カタカナ|片假名拉丁字母|
|kCFStringTransformLatinThai|s̄wạs̄dī|สวัสดี|泰国拉丁字母|
|kCFStringTransformHiraganaKatakana|にほんご|ニホンゴ|平假名片假名|
|kCFStringTransformMandarinLatin|中文|zhōng wén|普通话拉丁字母|
|kCFStringTransformToLatin|你の名字|nǐno míng zì|非英文文本转为拉丁字母|
|kCFStringTransformStripCombiningMarks|zhōng wén|zhong wen|删除重音符号|
|kCFStringTransformStripDiacritics|nǐ hǎo|ni hao|去掉变音符号|
|kCFStringTransformFullwidthHalfwidth|ａｂｃｄｅｆｇ，|abcdefg,|全角转半角|
|kCFStringTransformToUnicodeName|😀|\N{GRINNING FACE}|转换为Unicode名称|
|kCFStringTransformToXMLHex|你好|\&\#x4F60;\&\#x597D;|转换为XML十六进制字符|

**PS：**CFStringTransform无法处理日文中的汉字，如果需要音译复杂的日文文本，可以参考00StevenG的[NSString-Japanese](https://github.com/00StevenG/NSString-Japanese)，它基于CFStringTokenizer

## instancetype

instancetype表示“当前类”。为保持一致性，init方法和快捷构造方法的返回类型最好都用instancetype。

## Base64和百分号编码

Base64是很多Web协议标准，可以使用`initWithBase64EncodedString:Options:`和`base64EncodedStringWithOptions:`在Base64和NSData之间相互转换。

百分号编码对Web协议也很重要，尤其是URL。可以使用NSString类的`stringByRemovingPercentEncoding`来解码百分号编码的字符串，可以使用`stringByAddingPercentEncodingWithAllowedCharacters:`来百分号编码字符串并控制需要百分号编码的字符。

## - [NSArray firstObject]

如果数组为空，使用`firstObject`返回nil，而不会像`objectAtIndex:0`那样崩溃。

# 故事板及自定义切换效果




**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
