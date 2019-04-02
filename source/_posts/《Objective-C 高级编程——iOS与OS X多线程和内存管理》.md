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



# Grand Central Dispatch


**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
