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

#### alloc

```
+alloc
+allocWithZone:
class_createInstance
calloc
```

以下为class_createInstance的源代码，摘自[objc-runtime-new.mm](https://opensource.apple.com/source/objc4/objc4-750.1/runtime/objc-runtime-new.mm.auto.html)

```
id 
class_createInstance(Class cls, size_t extraBytes)
{
    return _class_createInstanceFromZone(cls, extraBytes, nil);
}
```

以下为_class_createInstanceFromZone的源代码，摘自[objc-runtime-new.mm](https://opensource.apple.com/source/objc4/objc4-750.1/runtime/objc-runtime-new.mm.auto.html)

```
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

#### retainCount/retain/release

```
-retainCount
__CFDoExternRefOperation
CFBasicHashGetCountOfKey
```

```
-retain
__CFDoExternRefOperation
CFBasicHashAddValue
```

```
-release
__CFDoExternRefOperation
CFBasicHashRemoveValue	//CFBasicHashRemoveValue返回0时，-release调用dealloc
```

以下为__CFDoExternRefOperation的源代码，摘自[CFRuntime.c](https://opensource.apple.com/source/CF/CF-855.17/CFRuntime.c.auto.html)

```
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

#### autolease

autorelease会像C语言的自动变量那样来对待对象实例。当超出其作用域（相当于变量作用域）时，对象实例的release实例方法被调用。另外，同C语言的自动变量不同的是，编程人员可以设定变量的作用域。具体使用方法如下：

- 生成并持有NSAutoreleasePool对象
- 调用已分配对象的autorelease实例方法
- 废弃NSAutoreleasePool对象

以下是AutoreleasePoolPage的源代码，摘自[objc-arr.mm](https://opensource.apple.com/source/objc4/objc4-493.9/runtime/objc-arr.mm.auto.html)

```
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

## ARC规则

ARC式的内存管理是编译器的工作。

### 所有权修饰符

- \_\_strong 修饰符
- \_\_weak 修饰符
- \_\_unsafe\_unretained 修饰符
- \_\_autoreleasing 修饰符

**PS：**\_\_strong、\_\_weak和\_\_autoreleasing可以保证将附有这些修饰符的自动变量初始化为nil。

#### \_\_strong 修饰符

\_\_strong 修饰符表示对对象的“强引用”，其修饰的变量在赋值时持有对象实例（retained）。强引用变量在超出其作用域时被废弃，随着强引用的失效（release），引用的对象会随之释放（dealloc）。

**PS：**ARC有效时，\_\_strong 修饰符是id类型和对象类型默认（非显示）的所有权修饰符。

#### \_\_weak 修饰符

\_\_weak 修饰符表示对对象的“弱引用”，其修饰的变量在赋值时不持有对象实例。弱引用变量在对象被废弃（dealloc）时，此变量将自动失效处于nil被赋值的状态（空弱引用）。使用\_\_weak 修饰符可避免循环引用。

#### \_\_unsafe\_unretained 修饰符

\_\_unsafe\_unretained 修饰符是不安全的所有权修饰符，其修饰的变量在赋值时不持有对象实例。赋值给附有\_\_unsafe\_unretained 修饰符变量的对象在通过该变量使用时，如果没有确保其确实存在，那么应用程序就会崩溃。

**PS：**附有\_\_unsafe\_unretained 修饰符的变量不属于编译器的内存管理对象。

#### \_\_autoreleasing 修饰符

\_\_autoreleasing 修饰符表示对象的“自动释放”，其修饰的变量在赋值时将添加到自动释放池（autorelease）。

显式地附加\_\_autoreleasing 修饰符很罕见，这是因为：

- 在ARC有效时，编译器会检查方法名是否以alloc/new/copy/mutableCopy开始，如果不是则自动将返回值的对象注册到autoreleasepool。
- 在访问弱引用对象的过程中，该对象有可能被废弃，所以编译器会自动生成用\_\_autoreleasing 修饰符修饰的中间变量，先把要访问的对象注册到autoreleasepool中再使用，确保其在@autoreleasepool块结束之前都存在。
- id的指针或对象的指针在没有显式指定时编译器会自动附加上\_\_autoreleasing 修饰符（甚至在需要的时候生成用\_\_autoreleasing 修饰符修饰的中间变量）。

**PS：**在显示地指定\_\_autoreleasing 修饰符时，必须注意对象变量要为自动变量（包括局部变量、函数以及方法参数）。

### @autoreleasepool

- @autoreleasepool块可以嵌套使用。
- NSRunLoop无论ARC是否有效，均能够随时释放注册到autoreleasepool中的对象。
- 无论ARC是否有效，调试用的非公开函数_objc_autoreleasePoolPrint()都可以使用，利用它可有效地帮助我们调试注册到autoreleasepool上的对象。

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
	- 要把对象型变量加入到结构体成员中使，可强制转换为void *或是附加/_/_unsafe/_unretained 修饰符
- 显示转换“id”和“void *”
	- id型或对象型变量赋值给void *或者逆向赋值时都要进行特定的转换，如果只想单纯地赋值，则可以使用“__bridge 转换”（转换为void *的/_/_bridge 转换，其安全性与赋值给/_/_unsafe/_unretained 修饰符相近，如果管理时不注意赋值对象的所有者，就会因垂悬指针而导致程序崩溃）
	- /_/_bridge/_retained 转换可使要转换的变量也持有所赋值的对象
	- /_/_bridge/_transfer 转换时被转换的变量所持有的对象在该变量被赋值给变换目标变量后随之释放 

# Blocks


# Grand Central Dispatch


**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
