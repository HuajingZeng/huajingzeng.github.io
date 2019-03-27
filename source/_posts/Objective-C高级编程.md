---
title: Objective-C高级编程
date: 2019-03-27 13:58:18
update:
author: 曾华经
tags:
	- iOS
	- OS X
	- Objective-C
categories:
	- 编程基础
thumbnail: /img/thumbnail/11.jpg
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

```objc
+alloc
+allocWithZone:
class_createInstance
calloc
```

如下为class_createInstance源代码，摘自[objc-runtime-new.mm](https://opensource.apple.com/source/objc4/objc4-750.1/runtime/objc-runtime-new.mm.auto.html)

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

id 
class_createInstance(Class cls, size_t extraBytes)
{
    return _class_createInstanceFromZone(cls, extraBytes, nil);
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

如下为__CFDoExternRefOperation源代码，摘自[CFRuntime.c](https://opensource.apple.com/source/CF/CF-855.17/CFRuntime.c.auto.html)

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

如下是AutoreleasePoolPage源代码，摘自[objc-arr.mm](https://opensource.apple.com/source/objc4/objc4-493.9/runtime/objc-arr.mm.auto.html)

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

# Blocks


# Grand Central Dispatch


**欢迎转载，转载请注明出处：[曾华经的博客](http://www.huajingzeng.com)**
