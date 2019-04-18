---
title: 《Objective-C 高级编程——iOS与OS X多线程和内存管理》
date: 2019-03-27 13:58:18
update:
author: 曾华经
tags:
	- iOS
	- OS X
	- Objective-C
categories:
	- 编程基础
thumbnail: https://githubblog-1252104787.cos.ap-guangzhou.myqcloud.com/%E3%80%8AObjective-C%E9%AB%98%E7%BA%A7%E7%BC%96%E7%A8%8B%E3%80%8B.jpeg
blogexcerpt:
toc: true
mathjax: true
---

iOS与OS X中的ARC、Blocks和Grand Central Dispatch（GCD），是面向iOS、OS X应用开发时不可或缺。它们看似简单，但若无深入了解，就会变成技术开发的陷阱。要想掌握这些技术，除了阅读苹果公司的参考文档之外，还要进一步学习苹果公司公开的源代码，在此基础上深入剖析才能融汇贯通。

<!--more-->

# 自动引用计数

## 什么是自动引用计数

> 自动引用计数（ARC，Automatic Reference Counting）是指内存管理中对引用采用自动计数的技术。

## 内存管理/引用计数

### 内存管理的思考方式

- 自己生成的对象，自己持有
- 非自己生成的对象，自己也能持有
- 不需要自己持有的对象时释放
- 非自己持有的对象无法释放

### 内存管理的具体实现

|对象操作|Objective-C方法|
|:-:|:-:|
|生成并持有对象|alloc/new/copy/mutableCopy等方法|
|持有对象|retain方法|
|释放对象|release方法|
|自动释放对象（加入自动释放池）|autorelease方法|
|废弃对象|dealloc方法|

**alloc**

alloc方法的调用栈如下：

```objectivec
+alloc
+allocWithZone:
class_createInstance
calloc
```

以下为class_createInstance的源代码，摘自[objc-runtime-new.mm](https://opensource.apple.com/source/objc4/objc4-750.1/runtime/objc-runtime-new.mm.auto.html)

```objectivec
id 
class_createInstance(Class cls, size_t extraBytes)
{
    return _class_createInstanceFromZone(cls, extraBytes, nil);
}
```

以下为_class_createInstanceFromZone的源代码，摘自[objc-runtime-new.mm](https://opensource.apple.com/source/objc4/objc4-750.1/runtime/objc-runtime-new.mm.auto.html)

```cpp
static __attribute__((always_inline)) 
id
_class_createInstanceFromZone(Class cls, size_t extraBytes, void *zone, 
                              bool cxxConstruct = true, 
                              size_t *outAllocatedSize = nil)
{
    if (!cls) return nil;

    assert(cls->isRealized());

    // Read class's info bits all at once for performance
    bool hasCxxCtor = cls->hasCxxCtor();
    bool hasCxxDtor = cls->hasCxxDtor();
    bool fast = cls->canAllocNonpointer();

    size_t size = cls->instanceSize(extraBytes);
    if (outAllocatedSize) *outAllocatedSize = size;

    id obj;
    if (!zone  &&  fast) {
        obj = (id)calloc(1, size);
        if (!obj) return nil;
        obj->initInstanceIsa(cls, hasCxxDtor);
    } 
    else {
        if (zone) {
            obj = (id)malloc_zone_calloc ((malloc_zone_t *)zone, 1, size);
        } else {
            obj = (id)calloc(1, size);
        }
        if (!obj) return nil;

        // Use raw pointer isa on the assumption that they might be 
        // doing something weird with the zone or RR.
        obj->initIsa(cls);
    }

    if (cxxConstruct && hasCxxCtor) {
        obj = _objc_constructOrFree(obj, cls);
    }

    return obj;
}
```

**retainCount/retain/release**

retainCount/retain/release的调用栈如下：

```objectivec
-retainCount
__CFDoExternRefOperation
CFBasicHashGetCountOfKey
```

```objectivec
-retain
__CFDoExternRefOperation
CFBasicHashAddValue
```

```objectivec
-release
__CFDoExternRefOperation
CFBasicHashRemoveValue	//CFBasicHashRemoveValue返回0时，-release调用dealloc
```

以下为__CFDoExternRefOperation的源代码，摘自[CFRuntime.c](https://opensource.apple.com/source/CF/CF-855.17/CFRuntime.c.auto.html)

```cpp
#define DISGUISE(O) (~(uintptr_t)(O))

static struct {
    CFSpinLock_t lock;
    CFBasicHashRef table;
    uint8_t padding[64 - sizeof(CFBasicHashRef) - sizeof(CFSpinLock_t)];
} __NSRetainCounters[NUM_EXTERN_TABLES];

CF_EXPORT uintptr_t __CFDoExternRefOperation(uintptr_t op, id obj) {
    if (nil == obj) HALT;
    uintptr_t idx = EXTERN_TABLE_IDX(obj);
    uintptr_t disguised = DISGUISE(obj);
    CFSpinLock_t *lock = &__NSRetainCounters[idx].lock;
    CFBasicHashRef table = __NSRetainCounters[idx].table;
    uintptr_t count;
    switch (op) {
    case 300:   // increment
    case 350:   // increment, no event
        __CFSpinLock(lock);
	CFBasicHashAddValue(table, disguised, disguised);
        __CFSpinUnlock(lock);
        if (__CFOASafe && op != 350) __CFRecordAllocationEvent(__kCFObjectRetainedEvent, obj, 0, 0, NULL);
        return (uintptr_t)obj;
    case 400:   // decrement
        if (__CFOASafe) __CFRecordAllocationEvent(__kCFObjectReleasedEvent, obj, 0, 0, NULL);
    case 450:   // decrement, no event
        __CFSpinLock(lock);
        count = (uintptr_t)CFBasicHashRemoveValue(table, disguised);
        __CFSpinUnlock(lock);
        return 0 == count;
    case 500:
        __CFSpinLock(lock);
        count = (uintptr_t)CFBasicHashGetCountOfKey(table, disguised);
        __CFSpinUnlock(lock);
        return count;
    }
    return 0;
}
```

GNUstep将引用计数保存在对象占用内存块头部的变量中，而苹果则采用散列表（引用计数表）来管理引用计数。

- 通过内存块头部管理引用计数的好处：
	- 少量代码即可完成。
	- 能够统一管理引用计数用内存块与对象用内存块
- 通过引用计数表管理引用计数的好处：
	- 对象用内存块的分配无需考虑内存块头部
	- 引用计数表各记录中存有内存块地址，可从各个记录追溯到各对象的内存块

**autolease**

autorelease会像C语言的自动变量那样来对待对象实例。当超出其作用域（相当于变量作用域）时，对象实例的release实例方法被调用。另外，同C语言的自动变量不同的是，编程人员可以设定变量的作用域。具体使用方法如下：

- 生成并持有NSAutoreleasePool对象
- 调用已分配对象的autorelease实例方法
- 废弃NSAutoreleasePool对象

以下是AutoreleasePoolPage的源代码片段，摘自[objc-arr.mm](https://opensource.apple.com/source/objc4/objc4-493.9/runtime/objc-arr.mm.auto.html)

```cpp
class AutoreleasePoolPage 
{
    id *add(id obj)
    {
        assert(!full());
        unprotect();
        *next++ = obj;
        protect();
        return next-1;
    }

    void releaseAll() 
    {
        releaseUntil(begin());
    }

public:
    static inline id autorelease(id obj)
    {
        assert(obj);
        assert(!OBJC_IS_TAGGED_PTR(obj));
        id *dest __unused = autoreleaseFast(obj);
        assert(!dest  ||  *dest == obj);
        return obj;
    }

    static inline void *push() 
    {
        if (!hotPage()) {
            setHotPage(new AutoreleasePoolPage(NULL));
        } 
        id *dest = autoreleaseFast(POOL_SENTINEL);
        assert(*dest == POOL_SENTINEL);
        return dest;
    }

    static inline void pop(void *token) 
    {
        AutoreleasePoolPage *page;
        id *stop;

        if (token) {
            page = pageForPointer(token);
            stop = (id *)token;
            assert(*stop == POOL_SENTINEL);
        } else {
            // Token 0 is top-level pool
            page = coldPage();
            assert(page);
            stop = page->begin();
        }

        if (PrintPoolHiwat) printHiwat();

        page->releaseUntil(stop);

        // memory: delete empty children
        // hysteresis: keep one empty child if this page is more than half full
        // special case: delete everything for pop(0)
        if (!token) {
            page->kill();
            setHotPage(NULL);
        } else if (page->child) {
            if (page->lessThanHalfFull()) {
                page->child->kill();
            }
            else if (page->child->child) {
                page->child->child->kill();
            }
        }
    }

    static void init()
    {
        int r __unused = pthread_key_init_np(AutoreleasePoolPage::key, 
                                             AutoreleasePoolPage::tls_dealloc);
        assert(r == 0);
    }    
};

void *
objc_autoreleasePoolPush(void)
{
    if (UseGC) return NULL;
    return AutoreleasePoolPage::push();
}

void
objc_autoreleasePoolPop(void *ctxt)
{
    if (UseGC) return;

    // fixme rdar://9167170
    if (!ctxt) return;

    AutoreleasePoolPage::pop(ctxt);
}

id
objc_autorelease(id obj)
{
	return objc_msgSend_hack(obj, @selector(autorelease));
}
```

参考：[黑幕背后的Autorelease——Autorelease原理](http://blog.sunnyxx.com/2014/10/15/behind-autorelease/#Autorelease原理)

## ARC规则

### 所有权修饰符

\_\_strong、\_\_weak和\_\_autoreleasing可以保证将附有这些修饰符的id型/对象型自动变量初始化为nil，但并不保证将附有这些修饰符的id指针型/对象指针型自动变量初始化为nil。

**\_\_strong修饰符**

\_\_strong修饰符表示对对象的“强引用”，其修饰的变量在赋值时持有对象实例（retained）。强引用变量在超出其作用域时被废弃，随着强引用的失效（release），引用的对象会随之释放（dealloc）。ARC有效时，\_\_strong修饰符是id类型和对象类型默认（非显示）的所有权修饰符。

**\_\_weak修饰符**

\_\_weak修饰符表示对对象的“弱引用”，其修饰的变量在赋值时不持有对象实例。弱引用变量在对象被废弃（dealloc）时，此变量将自动失效处于nil被赋值的状态（空弱引用）。使用\_\_weak修饰符可避免循环引用。

**\_\_unsafe\_unretained修饰符**

\_\_unsafe\_unretained修饰符是不安全的所有权修饰符，其修饰的变量在赋值时不持有对象实例。赋值给附有\_\_unsafe\_unretained修饰符变量的对象在通过该变量使用时，如果没有确保其确实存在，那么应用程序就会崩溃。附有\_\_unsafe\_unretained修饰符的变量不属于编译器的内存管理对象。

**\_\_autoreleasing修饰符**

\_\_autoreleasing修饰符表示对象的“自动释放”，其修饰的变量在赋值时将添加到自动释放池（autorelease）。

显式地附加\_\_autoreleasing修饰符很罕见（在显示地指定\_\_autoreleasing修饰符时，必须注意对象变量要为自动变量，包括局部变量、函数以及方法参数），这是因为：

- 在ARC有效时，编译器会检查方法名是否以alloc/new/copy/mutableCopy开始，如果不是则自动将返回值的对象注册到autoreleasepool。
- 在访问弱引用对象的过程中，该对象有可能被废弃，所以编译器会自动生成用\_\_autoreleasing修饰符修饰的中间变量，先把要访问的对象注册到autoreleasepool中再使用，确保其在@autoreleasepool块结束之前都存在。
- id的指针或对象的指针在没有显式指定时编译器会自动附加上\_\_autoreleasing修饰符（甚至在需要的时候生成用\_\_autoreleasing修饰符修饰的中间变量）。

### @autoreleasepool

- @autoreleasepool块可以嵌套使用。
- NSRunLoop无论ARC是否有效，均能够随时释放注册到autoreleasepool中的对象。
- 无论ARC是否有效，都可以使用_objc_autoreleasePoolPrint函数调试注册到autoreleasepool上的对象。

### 规则

- 不能使用retain/release/retainCount/autorelease
- 不能使用NSAllocateObject/NSDeallocateObject
- 须遵守内存管理的方法命名规则
	- 以alloc/new/copy/mutableCopy开头的方法在返回对象时，必须返回给调用方所应当持有的对象
	- 以init开始的方法必须是实例方法，并且要返回对象。返回的对象应为id类型或该方法声明的对象类型，抑或是该类的超类型或子类型。该返回对象并不注册到autoreleasepool上，基本上只是对alloc方法返回值的对象进行初始化处理并返回对象 
- 不要显示调用dealloc
- 使用@autoreleasepool块替代NSAutoreleasePool
- 不能使用区域（NSZone）
- 对象型变量不能作为C语言结构体（struct/union）的成员
	- 要把对象型变量加入到结构体成员中使，可强制转换为void \*或是附加\_\_unsafe\_unretained修饰符
- 显示转换“id”和“void \*”（ARC无效时，将id变量强制转换void \*变量不会出问题）
	- id型或对象型变量赋值给void \*或者逆向赋值时都要进行特定的转换，如果只想单纯地赋值，则可以使用“\_\_bridge 转换”
	- \_\_bridge\_retained 转换可使要转换赋值的变量也持有所赋值的对象
	- \_\_bridge\_transfer 转换时被转换的变量所持有的对象在该变量被赋值给变换目标变量后随之释放
	
```objectivec
/*
 * 转换为void *的__bridge 转换
 * 其安全性与赋值给__unsafe_unretained修饰符相近
 * 如果管理时不注意赋值对象的所有者
 * 就会因垂悬指针而导致程序崩溃
 */

id obj = [[NSObject alloc] init];
void *p = (__bridge void *)obj;
id o = (__bridge id)p;
```


```objectivec
/*
 * __bridge_retained转换变为了retain
 * 变量obj和变量p同时持有对象
 */

id obj = [[NSObject alloc] init];
void *p = (__bridge_retained void *)obj;

/* ARC 无效 */
id obj = [[NSObject alloc] init];
void *p = obj;
[(id)p retain];
```

```objectivec
/*
 * __bridge_transfer转换变成了release
 * 变量obj持有对象而变量p随后释放对象
 */
 
id obj = (__bridge_transfer id)p;

/* ARC 无效 */
id obj = (id)p;
[obj retain];
[(id)p release];
```

**Toll-Free Bridge**

ARC无效时，CoreFoundation框架中的retain和release分别是CFRetain函数和CFRelease函数，使用CFGetRetainCount函数可以获取引用计数值。可以使用CFBridgingRetain函数和CFBridgingRelease函数简化\_\_bridge\_retained和\_\_bridge\_transfer等桥接转换的书写方式。

```objectivec
CFTypeRef CFBridgingRetain(id X) {
	return (__bridge_retained CFTypeRef)X;
}
```

```objectivec
id CFBridgingRelease(CFTypeRef X) {
	return (__bridge_transfer id)X;
}
```

### 属性

|属性声明的属性|所有权修饰符|
|:--|:--|
|assign|\_\_unsafe\_unretained修饰符|
|copy|\_\_strong修饰符（但是赋值的是被复制的对象）|
|retain|\_\_strong修饰符|
|strong|\_\_strong修饰符|
|unsafe\_unretained|\_\_unsafe\_unretained修饰符|
|weak|\_\_weak修饰符|

以上各种属性赋值给指定的属性中就相当于赋值给附加各属性对应的所有权修饰符的变量中。**在声明类成员变量时，如果同属性声明中的属性不一致则会引起编译错误。**

### 数组

```objectivec
NSArray * __strong *array = nil;
array = (id __strong *)calloc(entries, sizeof(id));
array[0] = [[NSObject alloc] init];
```

该源代码分配了entries个所需的内存块。使用\_\_strong修饰符的变量前必须先将其初始化为nil，所以使用使分配区域初始化为0的calloc函数来分配内存。也可用malloc函数分配内存后用memset等函数将内存填充为0。

```objectivec
for (NSUInteger i = 0; i < entries; i++) {
	array[i] = nil;
}

free(array);
```

**注意事项：**

- 将nil代入到malloc函数所分配的数组元素中来初始化是非常危险的。因为由malloc函数分配的内存区域没有初始化为0，因此nil会被赋值给附有\_\_strong修饰符的并被赋值了随机地址的变量中，从而释放一个不存在的对象。在分配内存时推荐使用calloc函数。
- 在动态数组中操作附有\_\_strong修饰符的变量时，需要自己释放所有元素。因为在静态数组中，编译器能够根据变量的作用域自动插入释放赋值对象的代码，而在动态数组中，编译器不能确定数组的生成周期，所以无从处理。
- 使用memset函数将内存填充为0也不会释放所赋值的对象，只会引起内存泄漏。所以必须用nil赋值给所有数组元素。
- 使用memcpy函数拷贝数组元素以及realloc函数重新分配内存块时，由于数组元素所赋值的对象有可能被保留在内存中或是重复被废弃，所以这两个函数也禁止使用。
- 可以像使用\_\_strong修饰符那样使用附有\_\_weak修饰符变量的动态数组。在\_\_autorelease修饰符的情况下，因为与设想的使用方法有差异，所以最好不要使用动态数组。\_\_unsafe\_unretained修饰符在编译器的内存管理对象之外，所以它与void *类型一样，只能作为C语言的指针类型来使用。

## ARC的实现

ARC是由以下工具、库来实现的：

- clang（LLVM编译器）3.0以上
- objc4 Objective-C 运行时库493.9以上

### \_\_strong修饰符

```objectivec
id __strong obj = [[NSObject alloc] init];

/* 编译器的模拟代码 */
id obj = objc_msgsend(NSObject, @selector(alloc));
objc_msgsend(obj, @selector(init));
objc_release(obj);
```

```objectivec
id __strong obj = [NSMutableArray array];

/* 编译器的模拟代码 */
id obj = objc_msgsend(NSMutableArray, @selector(array));
objc_retainAutoreleaseReturnValue(obj);
objc_release(obj);
```

```objectivec
+ (id)array {
	return [[NSMutableArray alloc] init];
}

/* 编译器的模拟代码 */
+ (id)array {
	id obj = objc_msgsend(NSObject, @selector(alloc));
	objc_msgsend(obj, @selector(init));
	return objc_autoreleaseReturnValue(obj);
}
```

objc\_autoreleaseReturnValue函数会检查使用该函数的方法或函数调用方的执行命令列表，如果方法或函数的调用方在调用了方法或函数后紧接着调用objc\_retainAutoreleaseReturnValue函数，那么就不将返回的对象注册到autoreleasepool中，而是直接传递到方法或函数的调用方，跳过objc\_retainAutoreleaseReturnValue函数执行其后面的代码。参考：[黑幕背后的Autorelease——Autorelease返回值的快速释放机制](http://blog.sunnyxx.com/2014/10/15/behind-autorelease/#Autorelease返回值的快速释放机制)

### \_\_weak修饰符

- 若附有\_\_weak修饰符的变量所引用的对象被废弃，则将nil赋值给该变量。
- 使用附有\_\_weak修饰符的变量，即是使用注册到autoreleasepool中的对象。

```objectivec
id __weak obj1 = obj;

/* 编译器的模拟代码 */
id obj1;
objc_initWeak(&obj1, obj);
objc_destroyWeak(&obj1);

/* 等价于 */
id obj1;
obj1 = 0;
objc_storeWeak(&obj1, obj);
objc_storeWeak(&obj1, 0);
```

objc_storeWeak函数把第二参数的赋值对象的地址作为键值，将第一参数的附有\_\_weak修饰符的变量的地址注册到\_\_weak 表中。如果第二参数为0，则把变量的地址从weak 表中删除。（由于一个对象可同时赋值给多个附有\_\_weak修饰符的变量中，所以对于一个键值，可注册多个变量的地址）

以下是objc\_release函数的调用栈

```objectivec
objc_release
dealloc // 因为引用计数为0所以执行
_objc_rootDealloc
object_dispose
objc_destructInstance
objc_clear_deallocating
```

objc_clear_deallocating函数的动作如下：

- 从weak表中获取废弃对象的地址为键值的记录
- 将包含在记录中的所有附有\_\_weak修饰符变量的地址，赋值为nil
- 从weak 表中删除该记录
- 从引用计数表中删除废弃对象的地址为键值的记录

```objectivec
id __weak obj1 = obj;
NSLog(@"%@", obj1);

/* 编译器的模拟代码 */
id obj1;
objc_initWeak(&obj1, obj);
id tmp = objc_loadWeakRetained(&obj1);
objc_autorelease(tmp);
NSLog(@"%@", tmp);
objc_destroyWeak(&obj1);
```

- objc_loadWeakRetained函数取出附有\_\_weak修饰符变量所引用的对象并retain
- objc_autorelease函数将对象注册到autoreleasepool中

**注意：**大量使用附有\_\_weak修饰符的变量，注册到autoreleasepool的对象也会大量地增加，因此在使用附有\_\_weak修饰符的变量时，最好先暂时赋值给附有\_\_strong修饰符的变量后再使用

不支持使用\_\_weak修饰符的情况：

- iOS4和OS X Leopard系统中
- 重写了retain/release并实现该类独立的引用计数机制的类，如：NSMachPort
- 类声明中附加了“\_\_attribute\_\_((objc\_arc\_weak\_reference\_unavailable))”这一属性，同时定义了NS\_AUTOMATED\_REFCOUNT\_WEAK\_UNAVAILABLE
- 当allowsWeakReference/retainWeakReference实例方法返回NO的情况（没有写入NSObject接口说明文档中）

### \_\_autoreleasing修饰符

```objectivec
@autoreleasepool {
	id __autoreleasepool obj = [[NSObject alloc] init];
}

/* 编译器的模拟代码 */
id pool = objc_autoreleasePoolPush();
id obj = objc_msgsend(NSObject, @selector(alloc));
objc_msgsend(obj, @selector(init));
objc_autorelease(obj);
objc_autoreleasepoolPop(pool);
```

```objectivec
@autoreleasepool {
	id __autoreleasepool obj = [NSMutableArray array];
}

/* 编译器的模拟代码 */
id pool = objc_autoreleasePoolPush();
id obj = objc_msgsend(NSMutableArray, @selector(array));
objc_retainAutoreleaseReturnValue(obj);
objc_autorelease(obj);
objc_autoreleasepoolPop(pool);
```

### 引用计数

获取引用计数数值的函数：

```objectivec
uintptr_t _objc_rootRetainCount(id obj);
```

**注意：**不能够完全信任该函数取得的数值，最好在了解其所具有的问题的基础上来使用。

# Blocks

## 什么是Blocks

> Blocks是C语言的扩充功能：带有自动变量（局部变量）的匿名函数。

在C语言中，可以通过函数指针来代替直接调用函数，但必须通过函数名才能取得函数的地址。

```cpp
int func(int count)
{
	return count + 1;
}
int (*funcptr)(int) = &func;
int result = (*funcptr)(10);
```

Blocks提供了类似由C++和Objective-C类生成实例或对象来保持变量的方法，其代码量与编写C语言函数差不多。

```objectivec
for (int i = 0; i < BUTTON_MAX; i++) {
	setButtonCallbackUsingBlock(BUTTON_IDOFFSET + i, ^(int event) {
		printf("buttonId:%d event=%d\n", i, event);
	})
}
```

在计算机科学中，“带有自动变量值的匿名函数”这一概念也称为闭包（Closure）、lambda计算（λ计算，lambda calculus）等。

|程序语言|Blcok名称|
|:--|:--|
|C + Blocks|Block|
|Smalltalk|Block|
|Ruby|Block|
|LISP|Lambda|
|Python|Lambda|
|C++11|Lambda|
|Javascript|Anonymous function|

## Blocks模式

### Block语法

Block表达式语法（Block Literal Syntax），

**完整形式：**表达式中含有return语句时，其类型必须与返回值类型相同。

`^` `返回值类型` `参数列表` `表达式`

**省略返回值类型：**如果表达式中有return语句就使用该返回值的类型，如果表达式没有return语句就使用void类型。

`^` `参数列表` `表达式`

**省略返回值类型和参数列表：**

`^` `表达式`

- 没有函数名，因为是匿名函数
- 返回值类型前带有“^”（插入记号，caret）记号，便于查找

### Block类型变量

声明Block类型变量仅仅是将声明函数指针类型变量的“\*”变为“\^”，可像C语言中其他类型变量一样使用Block类型变量。可以使用typedef为Block类型声明自定义别名。

typedef `返回值类型`(^`块类型别名`)(`参数列表`)

### 截获自动变量值

Block表达式截获所使用的自动变量的值，即保存该自动变量的瞬间值（在执行Block语法后，即使改写Block中使用的自动变量的值也不会影响Block执行时自动变量的值）。

### \_\_block说明符

自动变量值截获只能保存执行Block语法瞬间的值，保存后就不能改写该值。使用附有\_\_block修饰符的自动变量可在Block中赋值，该变量称为\_\_block变量。

### 截获的自动变量

- 截获Objective-C对象时，赋值给截获的自动变量的操作会产生编译错误，但使用截获的值（类对象用的结构体实例指针）不会有任何问题。
- 截获自动变量的方法并没有实现对C语言数组（如`const char text[] = "hello"`）的截获，因此必须改用指针(如`const char *text = "hello"`)解决。

## Blocks的实现

### Block的本质

Block即为Objective-C对象，它实际上是通过支持Block的编译器，将含有Block语法的源代码转换为一般C语言编译器能够处理的源代码，并作为极为普通的C语言源代码进行编译。使用`clang -rewrite-objc 源代码文件名`可将含有Block语法的源代码变换为C++的源代码（使用了struct结构的C语言源代码）

```cpp
int main () {
	void (^blk)(void) = ^ { 
		printf("Block\n");
	};
	
	blk();
	
	return 0;
}

/* clang转换后 */

struct __block_impl {
	void *isa; // 指向_NSConcreteStackBlock（相当于calss_t结构体实例）的地址 
	int Flags; 
	int Reserved;
	void *FuncPtr; // Block表达式对应的函数指针
};

struct __main_block_impl_0 {
	struct __block_impl impl;
	struct __main_block_desc_0* Desc;
	
	__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
		impl.isa = &_NSConcreteStackBlock;
		impl.Flags = flags;
		impl.FuncPtr = fp;
		Desc = desc;
	}
};

/*
 * 1、Block语法所属的函数名和该Block语法在该函数出现的顺序值来给经clang变换的函数命名
 * 2、参数__cself即指向Block值的变量，相当于C++的this指针和Objective-C的self变量
 */
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
	printf("Block\n");
}

static struct __main_block_desc_0 {
	unsigned long reserved;
	unsigned long Block_size;
} __main_block_desc_0_DATA = {
	0,
	sizeof(struct __main_block_impl_0)
}

int main ()
{
	/*
	 * 将__main_block_impl_0结构体类型的自动变量，
	 * 即栈上生成的__main_block_impl_0结构体实例的指针，
	 * 赋值给__mian_block_impl_0结构体指针类型的变量blk
	 */
	void (*blk)(void) = (void (*)(void))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA);
	
	((void (*)(struct __block_impl *))((struct __block_impl *)blk)->FuncPtr)((struct __block_impl *)blk);
	
	return 0;
}
```

### 截获自动变量值

```cpp
int main () {
	int dmy = 256;
	int val = 10;
	const char *fmt = "val = %d\n";
	
	void (^blk)(void) = ^ {
		printf(fmt, val);
	} ;
	
	blk();
	
	return 0;
}

/* clang转换后 */

/* 
 * Block语法表达式中使用的自动变量被作为成员变量追加到了__main_block_impl_0结构体中
 * Block语法表达式中没有使用的自动变量不会被追加
 */
struct __main_block_impl_0 {
	struct __block_impl impl;
	struct __main_block_desc_0 *Desc;
	const char *fmt;
	int val;
	
	__main_block_impl_0 (void *fp, struct __main_block_desc_0 *desc, const char *fmt, int val, int flags = 0) : fmt(_fmt), val(_val) {
		impl.isa = &_NSConcreteStackBlock;
		impl.Flags = flags;
		impl.FuncPtr = fp;
		Desc = desc;
	}
}

static void __main_block_func_0 (strcut __main_block_impl_0 *__cself) {
	/*
     * 通过__main_block_impl_0结构体实例的成员变量，重新声明定义截获到的自动变量 
	 */
	const char *fmt = __cself->fmt;
	int val = __cself->val;
	
	printf(fmt, val);
}

static struct __main_block_desc_0 {
	unsigned long reserved;
	unsigned long Block_size;
} __main_block_desc_0_DATA = {
	0,
	sizeof(struct __main_block_impl_0)
};

int main () {
	int dmy = 256;
	int val = 10;
	const char *fmt = "val = %d\n";
	
	void (*blk)(void) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA, fmt, val);
	
	((void (*)(struct __block_impl *))((struct __block_impl *)blk)->FuncPtr)((struct __block_impl *)blk);
	
	return 0;
}
```

### \_\_block说明符

```cpp
int main() {
	__block int val = 10;

	void (^blk)(void) = ^{
		val = 1;
	};

	blk();
	
	return 0;
}

/* 转换后 */

/*
 * __Block_byref_val_0结构体独立于__main_block_impl_0结构体之外
 * 是为了在多个Block中使用__block变量（val）
 */
struct __Block_byref_val_0 {
	void *__isa;
	__Block_byref_val_0 *__forwarding; // 指向自身
	int __flags;
	int __size;
	int val; // 持有自动变量val的值
}

struct __main_block_impl_0 {
	struct __block_impl impl;
	struct __main_block_desc_0 *Desc;
	__Block_byref_val_0 *val;
	
	__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_val_0 *_val, int flags=0) : val(_val->__forwarding) {
		impl.isa = &__NSConcreteStackBlcok;
		impl.Flags = flags;
		impl.FuncPtr = fp;
		Desc = desc;
	}
}

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
	__Block_byref_val_0 *val = __cself->val;
	
	(val->__forwarding->val) = i;
}

static void __main_block_copy_0(struct __main_block_impl_0 *dst, struct __main_block_impl_0 *src) {
	_Block_object_assign(&dst->val, src->val, BLOCK_FIELD_IS_BYREF);
}

static void __main_block_dispose_0(struct __main_block_impl_0 *src) {
	_Block_objcet_dispose(src->val, BLOCK_FIELD_IS_BYREF);
}

static struct __main_block_desc_0 {
	unsigned long reserved;
	unsigned long Block_size;
	void (*copy)(struct __main_block_impl_0 *, struct __main_block_impl_0 *);
	void (*dispose)(struct __main_block_impl_0 *);
} __main_block_desc_0_DATA = {
	0,
	sizeof(struct __main_block_impl_0),
	__main_block_copy_0,
	__main_block_dispose_0
}

int main(){
	// 栈上生成的__Block_byref_val_0结构体持有自动变量val的值
	__Block_byref_val_0 val = {
		0,
		&val,
		0,
		sizeof(__BLock_byref_val_0),
		10
	};
	
	blk = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA, &val, 0x22000000);
	
	return 0;
}
```

### Block存储域

- \_NSConcreteStackBlock：
	- Block语法的表达式中使用了应截获的自动变量时 
- \_NSConcreteGlobalBlock：
 	- 记述全局变量的地方有Block语法时
	- Block语法的表达式中不使用应截获的自动变量时
- \_NSConcreteMallocBlock：
	- 将配置在栈上的Block复制到堆上时

```cpp
typedef int (^blk_t)(int);

blk_t func(int rate) {
	return ^(int count) {
		return rate * count;
	};
}

/* 转换后 */

blk_t func(int rate) {

	/*
	 * 将通过Block语法生成的Block
	 * 即分配在栈上的Block用结构体实例
	 * 赋值给相当于Block类型的变量tmp中
	 */
	blk_t tmp = &__func_block_impl_0(__func_block_func_0, &__func_block_desc_0_DATA, rate);
	
	/*
	 * 等价于调用_Block_copy(tmp)
	 * 将栈上的Block复制到堆上
	 * 复制后，将堆上的地址作为指针赋值给变量tmp
	 */
	tmp = objc_retainBlock(tmp);
	
	/*
	 * 将堆上的Block作为Objective-C对象
	 * 注册到autoreleasepool中，然后返回该对象
	 */
	return objc_autoreleaseReturnValue(tmp);
}
```

ARC有效时，编译器会适当地进行判断，自动生成将Block从栈上复制到堆上的代码。向方法或函数的参数中传递Block时，编译器不能进行判断，所以需要手动使用“copy实例方法”将Block从栈上复制到堆上。

**以下方法或函数不用手动复制Block，因为方法和函数中适当地复制了传递过来的参数**

- Cocoa框架的方法且方法名中含有usingBlock等时
- Grand Central Dispatch的API

|Block的类|副本源的配置存储域|复制效果|
|:--|:--|:--|
|\_NSConcreteStackBlock|栈|从栈复制到堆|
|\_NSConcreteGlobalBlock|程序的数据区域|什么也不做|
|\_NSConcreteMallocBlock|堆|引用计数增加|

### \_\_block变量存储域

|\_\_block变量的配置存储域|Block从栈复制到堆时的影响|
|:--|:--|
|栈|从栈复制到堆并被Block持有|
|堆|被Block持有|

栈上的\_\_block变量用结构体实例在从栈复制到堆上时，会将成员变量\_\_forwarding的值替换为复制目标堆上的\_\_block变量用结构体实例的地址。这样无论是在Block语法中还是Block语法外使用\_\_block变量，都可以顺利地访问同一个\_\_block变量（堆上）。

### 截获对象

```cpp
blk_t blk;
{
	id array = [[NSMUtableArray alloc] init];
	blk = [^(id obj){
		[array addObjcet:obj];
	} copy];
}

blk([[NSObject alloc] init]);
blk([[NSObject alloc] init]);
blk([[NSObject alloc] init]);

/* 转换后 */
struct __main_block_impl_0 {
	struct __block_impl impl;
	struct __main_block_desc_0 *Desc;
	id __strong array;
	
	__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, id __strong _array, int flags=0) : array(_array) {
		impl.isa = &_NSConcreteStackBlock;
		impl.Flags = flags;
		impl.FuncPtr = fp;
		Desc = desc;
	}
}

static void __main_block_func_0(struct __main_block_impl_0 *__cself, id obj){
	id __strong array = __cself->array;
	[array addObject:obj];
	NSLog(@"array count = %ld", [array count]);
}

static void __main_block_copy_0(struct __main_block_impl_0 *dst, struct __main_block_impl_0 *src) {
	_Block_object_assign(&dst->array, src->array, BLOCK_FIELD_IS_OBJECT);
}

static void __main_block_dispose_0(struct __main_block_impl_0 *src) {
	_Block_object_dispose(src->array, BLOCK_FIELD_IS_OBJECT);
}

static scruct __main_block_desc_0 {
	unsigned long reserved;
	unsigned long Block_size;
	void (*copy)(struct __main_block_impl_0 *, struct __main_block_impl_0 *);
	void (*dispose)(struct __main_block_impl_0 *);
} __main_block_desc_0_DATA = {
	0,
	sizeof(struct __main_block_impl_0),
	__main_block_copy_0,
	__main_block_dispose_0,	
}

blk_t blk;
{
	id __strong array = [[NSMutableArray alloc] init];
	blk = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA, array, 0x22000000);
	blk = [blk copy]
}

(*blk->impl.FuncPtr)(blk, [[NSObject alloc] init]);
(*blk->impl.FuncPtr)(blk, [[NSObject alloc] init]);
(*blk->impl.FuncPtr)(blk, [[NSObject alloc] init]);
```

Objective-C的运行时库能够准确把握Block从栈复制到堆以及堆上的Block被废弃的时机，因此Block用结构体中即使含有附有\_\_strong修饰符或\_\_weak修饰符的变量，也可以恰当地进行初始化和废弃。为此需要使用在\_\_main\_block\_desc\_0结构体中增加的成员变量copy和dispose，以及作为指针赋值给该成员变量的\_\_main\_block\_copy\_0函数和\_\_main\_block\_dispose\_0函数。\_Block\_object\_assign函数相当于retain实例方法，而\_Block\_object\_dispose函数相当于release实例方法。

|函数|调用时机|
|:--|:--|
|copy函数|栈上的Block复制到堆时|
|dispose函数|堆上的Block被废弃时|

栈上Block复制到堆上的时机：

- 调用Block的copy实例方法
- Block作为函数返回值返回时
- 将Block赋值给附有\_\_strong修饰符id类型或Block类型成员变量时
- 在方法名中含有usingBlock的Cocoa框架方法或Grand Central Dispatch的API中传递Block时

通过BLOCK\_FIELD\_IS\_OBJECT和BLOCK\_FIELD\_IS\_BYREF参数，区分copy函数和dispose函数的对象类型是对象还是\_\_block变量

### \_\_block变量和对象

\_\_block说明符可以修饰任何类型（包括对象类型）的自动变量

### Block循环引用

避免循环引用的方法比较

- 使用\_\_weak修饰符

可以确认使用附有\_\_weak修饰符的变量时是否为nil，但更有必要使之生存以使用赋值给附有\_\_weak修饰符变量的对象

```objectivec
- (void)init {
	self = [super init];
	id __weak obj = _obj;
	_blk = ^ {
		NSLog(@"_obj = %@", obj);
	};
	return self;
} 
```

- 使用\_\_unsafe\_unretained修饰符

需要注意可能出现悬垂指针的情况，避免在该情况下使用该变量

```objectivec
- (void)init {
	self = [super init];
	id __unsafe_unretained tmp = self;
	_blk = ^ {
		NSLog(@"self = %@", tmp);
	};
	return self;
} 
```

- 使用\_\_block变量

优点

1. 通过\_\_blcok变量可控制对象的持有期间
2. 在不能使用\_\_weak修饰符的环境中不使用\_\_unsafe\_unretained修饰符即可（不必担心悬垂指针）。在执行Block时可动态地决定是否将nil或其他对象赋值在\_\_block变量中。

缺点

1. 为避免循环引用必须执行Block


```objectivec
- (id)init {
	self = [super init];
	
	__block id tmp = self;
	
	_blk = ^{
		NSLog(@"self = %@", tmp);
		tmp = nil;
	};
	
	return self;
}

- (void)execBlock {
	_blk();
}
```

### copy/release

ARC无效时，需要使用copy实例方法将Block从栈复制到堆，用release实例方法来释放Block。**只要有一次复制并配置在堆上，就可以通过retain实例方法持有Block。而对栈上的Block调用retain实例方法不起任何作用，因此推荐使用copy方法。**

在C语言中也可以使用Block语法，此时使用“Block\_copy函数”和“Block\_release函数”代替copy/release实例方法。

ARC无效时，\_\_block说明符被用来避免Block中的循环引用。

- 若Block使用的变量为附有\_\_block说明符的id类型或对象类型的自动变量，不会被retain
- 若Block使用的变量为没有\_\_block说明符的id类型或对象类型的自动变量，则被retain

# Grand Central Dispatch

## 什么是GCD

> Grand Central Dispatch（GCD）是异步执行任务的技术之一。

### 多线程编程

> “1个CPU执行的CPU命令序列为一条无分叉路径”即为“线程”，这种无分叉路径存在多条时即为多线程。

使用多线程的程序可以在某个线程和其他线程之间反复多次进行上下文切换，在多个CPU核时能够并列执行多个线程，这种利用多线程编程的技术就被称为多线程编程。

## GCD的API

### Diapatch Queue

开发者要做的只是定义想执行的任务并追加到适当的Dispatch Queue当中。

|Dispatch Queue种类|说明|
|:--|:--|
|Serial Dispatch Queue|等待现在执行中处理结束|
|Concurrent Dispatch Queue|不等待现在执行中处理结束|

### dispatch\_queue\_create

```cpp
dispatch_queue_t dispatch_queue_create(const char *_Nullable label, dispatch_queue_attr_t _Nullable attr);
```

- 第一个参数指定Serial Dispatch Queue的名称，推荐使用应用程序ID这种逆序全程域名（FQDN，fully qualified domain name）。
- 第二个参数指定为NULL表示生成Serial Dispatch Queue；指定为DISPATCH\_QUEUE\_CONCURRENT表示生成Concurrent Dispatch Queue。

**在ARC有效时，通过dispatch\_queue\_create生成的Dispatch Queue必须由程序员通过dispatch\_retain函数和diapatch\_release函数手动管理内存。**

### Main Dispatch Queue/Global Dispatch Queue

|名称|种类|说明|
|:--|:--|:--|
|Main Dispatch Queue|Serial Dispatch Queue|主线程执行|
|Global Dispatch Queue（High Priority）|Concurrent Dispatch Queue|执行优先级：高（最高优先）|
|Global Dispatch Queue（Default Priority）|Concurrent Dispatch Queue|执行优先级：默认|
|Global Dispatch Queue（Low Priority）|Concurrent Dispatch Queue|执行优先级：低|
|Global Dispatch Queue（Background Priority）|Concurrent Dispatch Queue|执行优先级：后台|

```cpp
/*
 * Main Dispatch Queue的获取方法
 */
dispatch_queue_t mainDispatchQueue = dispatch_get_main_queue();
 
/*
 * Global Dispatch Queue（高优先级）的获取方法
 */
 dispatch_queue_t globalDispatchQueueHigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
 
/*
 * Global Dispatch Queue（默认优先级）的获取方法
 */
 dispatch_queue_t globalDispatchQueueDefault = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 
/*
 * Global Dispatch Queue（低优先级）的获取方法
 */
 dispatch_queue_t globalDispatchQueueLow = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
 
/*
 * Global Dispatch Queue（后台优先级）的获取方法
 */
 dispatch_queue_t globalDispatchQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
```

**对Main Dispatch Queue和Global Dispatch Queue执行dispatch\_retain函数和dispatch\_release函数不会引起任何变化，也不会有任何问题**

### diapatch\_set\_target\_queue

dispatch\_queue\_create函数生成的Dispatch Queue都使用与默认优先级Global Dispatch Queue相同执行优先级的线程。

```cpp
void dispatch_set_target_queue(dispatch_object_t object, dispatch_queue_t _Nullable queue);
```

- 第一个参数指定要变更执行优先级的Dispatch Queue（不可指定为系统提供的Main Dispatch Queue和Global Dispatch Queue）
- 第二个参数指定与要使用的执行优先级相同优先级的Global Dispatch Queue

**在多个Serial Dispatch Queue中用dispatch\_set\_target\_queue函数指定目标为某一个Serial Dispatch Queue，那么原先本应并行执行的Serial Dispatch Queue，在目标Serial Dispatch Queue上只能同时执行一个处理。**

### dispatch\_after

dispatch\_after函数是在指定时间追加处理到Dispatch Queue，在有严格时间要求下使用会有偏差。

```cpp
void dispatch_after(dispatch_time_t when, dispatch_queue_t queue, dispatch_block_t block);
```

- 第一个参数指定追加到Dispatch Queue的延迟时间，改值使用dispatch\_time函数或dispatch\_walltime函数生成
- 第二个参数指定要追加处理的Dispatch Queue
- 第三个参数指定记述要执行处理Block

dispatch\_time函数用于计算相对时间，能够获取从第一个参数dispatch\_time\_t类型值中指定时间开始，到第二个参数指定的毫微秒单位时间后的时间。

```cpp
dispatch_time_t dispatch_time(dispatch_time_t when, int64_t delta);
```

- 第一个参数经常使用的值是DISPATCH\_TIME\_NOW，即表示现在的时间
- 第二个参数使用数值和NSEC\_PER\_SEC的乘机得到的单位为毫秒的数值。ull是C语言的数值字面量，是显式表面类型时使用的字符串（表示“unsigned long long”），如果使用NSEC\_PER\_MSEC则可以以毫秒未单位计算

dispatch\_walltime函数用于计算绝对时间，可以作为粗略的闹钟功能使用。

```cpp
dispatch_time_t dispatch_walltime(const struct timespec *_Nullable when, int64_t delta);
```

- 第一个参数struct timespec类型的时间，可以通过NSDate类对象生成
- 第二个参数表示相对第一个参数的时间差值

### Dispatch Group

Dispatch Group可以监视追加到Dispatch Queue中的处理，一旦检测到所有处理执行结束，就可将结束的处理追加到Dispatch Queue中。

```cpp
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();

dispatch_group_async(group, queue, ^{NSLog(@"blk0");});
dispatch_group_async(group, queue, ^{NSLog(@"blk0");});
dispatch_group_async(group, queue, ^{NSLog(@"blk0");});

dispatch_group_notify(group, dispatch_get_main_queue(), ^{NSLog(@"done");};
dispatch_release(group);
```

- 通过dispatch\_group\_async函数追加到Dispatch queue的Block属于Dispatch Group，Block通过dispatch\_retain持有Dispatch Group。一旦Block执行结束，就通过dispatch\_release释放持有的Dispatch Group。
- dispatch\_group\_notify函数会将执行的Block追加到Dispatch Queue中，将第一个参数指定为要监视的Dispatch Group，在追加到该Dispatch Group的全部处理执行结束时，将第三个参数的Block追加到第二个参数的Dispatch Queue中。

```cpp
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();

dispatch_group_async(group, queue, ^{NSLog(@"blk0");});
dispatch_group_async(group, queue, ^{NSLog(@"blk0");});
dispatch_group_async(group, queue, ^{NSLog(@"blk0");});

long result = dispatch_group_wait(group, time);

if (result == 0) {
	/*
	 * 属于Dispatch Group的全部处理执行结束
	 */
}else {
	/*
	 * 属于Dispatch Group的某一个处理还在执行中
	 */
}

dispatch_release(group);
```

- dispatch\_group\_wait函数的第二个参数指定为等待的时间（超时）。即调用dispatch\_group\_wait函数会停止当前线程，直到dispatch\_group\_wait函数返回。
	- 使用DISPATCH\_TIME\_FOREVER，意味着永久等待，中途不能取消。dispatch\_group\_wait的返回值恒为0
	- 指定DISPATC\_TIME\_NOW，则不用等待即可判定属于Dispatch Group的处理是否执行结束
	- 指定等待时间为其他值，需等待一定时间后才能进行判定

**在主线程RunLoop的每次循环中，可检查执行是否结束，从而不耗费多余的等待时间。但一般情况下推荐使用dispatch\_group\_wait函数以简化源代码**

### dispatch\_barrier\_async

dispatch\_barrier\_async函数会等待追加到Concurrent Dispatch Queue上的并行执行的处理全部结束之后，再将指定的处理追加到该Concurrent Dispatch Queue中。然后由dispatch\_barrier\_async函数追加的处理执行完毕后，Concurrent Dispatch Queue才恢复为一般的动作，追加到Concurrent Dispatch Queue的处理又开始并行执行。

```cpp
dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.ForBarrier", DISPATCH_QUEUE_CONCURRENT);

dispatch_async(queue, blk1_for_reading);
dispatch_async(queue, blk2_for_reading);
dispatch_async(queue, blk3_for_reading);

dispatch_barrier_async(queue, blk_for_writing);// 写入处理 

dispatch_async(queue, blk3_for_reading);
dispatch_async(queue, blk4_for_reading);
dispatch_async(queue, blk5_for_reading);
```

### dispatch\_async / dispatch\_sync

dispatch\_async函数的“async”意味着“非同步”（asynchronous），就是将指定的Block“非同步”地追加到指定的Dispatch Queue中。

dispatch\_sync函数的“sync”意味着“同步”（synchronous），也就是将指定的Block“同步”追加到指定的Dispatch Queue中。在追加的Block结束之前，dispatch\_sync函数会一直等待，即当前线程停止。**使用该函数要注意死锁问题（在当前线程的队列中同步追加任务）**

||并行队列<br>（Concurrent Queue）|串行队列<br>（Serial Queue）|主队列<br>（Main Queue）|
|:--|:--:|:--:|:--:|
|异步执行<br>（async）|开启多个线程<br>任务同时执行|开启一个新线程<br>任务按顺序执行|不开启新线程<br>任务按顺序执行|
|同步执行<br>（sync）|不开启新的线程<br>任务按顺序执行|不开启新的线程<br>任务按顺序执行|死锁|

### dispatch\_apply

dispatch\_apply函数是dispatch\_sync函数和Dispatch Group的关联API。该函数按指定的次数将指定的Block追加到指定的Dispatch Queue中，并等待全部处理执行结束。

```cpp
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_apply(10, queue, ^(size_t index){
	NSLog(@"%zu", index);
});
NSLog(@"Done");
```

- 第一个参数为重复次数
- 第二个参数为追加对象的Dispatch Queue
- 第三个参数为追加的处理

**推荐在dispatch\_async函数中非同步地执行dispatch\_apply函数：**

```cpp
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

/*
 * 在Global Dispatch Queue中非同步执行
 */

dispatch_async(queue, ^{
	/*
	 * Global Dispatch Queue
	 * 等待dispatch_apply函数中的处理执行结束
	 */
	 
	 dispatch_apply([array count], queue, ^(size_t index){
	 	/*
	 	 * 并列处理包含在NSArray对象的全部对象
	 	 */
	 	 
	 	 NSLog(@"%zu：%@", index, [array objectAtIndex:index]);
	 });
	 
	 /*
	  * dispatch_apply函数中的处理全部执行结束
	  */
	  
	 /*
	  * 在Main Dispatch Queue中非同步执行
	  */
	  
	 dispatch_async(dispatch_get_main_queue, ^{
	 	/*
	 	 * 在Main Dispatch Queue中执行处理
	 	 * 用户界面更新等
	 	 */
	 	NSLog(@"done");
	 });
});
```

### dispatch\_suspend / dispatch\_resume

dispatch\_suspend函数挂起指定的Dispatch Queue，dispatch\_resume函数恢复指定的Dispatch Queue。

### Dispatch Semaphone

Dispatch Semaphone是持有计数的信号，该计数是多线程编程中的计数类型信号。计数为0时等待，计数为1或大于1时，减去1而不等待。

```
dispatch_semaphone_t semaphone = dispatch_semaphone_create(1);
```



**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
