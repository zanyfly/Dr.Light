//
//  NSObject+KVOCrashSafety.m
//  ZYLightKit
//
//  Created by apple on 2017/2/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NSObject+KVOCrashSafety.h"
#import "objc/runtime.h"


static const void *keypathMapKey;

static const void *kvoSafteyToggleKey;


@implementation NSObject (KVOCrashSafety)


- (NSMapTable <id, NSHashTable<NSString *> *> *)keypathMap {
    
    NSMapTable *keypathMap = objc_getAssociatedObject(self, &keypathMapKey);
    if (keypathMap) {
        return keypathMap;
    }
    keypathMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
    objc_setAssociatedObject(self, &keypathMapKey, keypathMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return keypathMap;
}

- (void)setKeypathMap:(id)map{
 
    if (map) {
        objc_setAssociatedObject(self, keypathMapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

}

-(BOOL)kvoSafteyToggle{
    return  [objc_getAssociatedObject(self, &kvoSafteyToggleKey) boolValue];
}


-(void)setKvoSafteyToggle:(BOOL)on{
    
    objc_setAssociatedObject(self, &kvoSafteyToggleKey, @(on), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}


+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleAddObserver];
        [self swizzleRemoveObserver];

    });
    
}


+(void)swizzle:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

+(void)swizzleAddObserver{
    
    SEL originalSelector = @selector(addObserver:forKeyPath:options:context:);
    SEL swizzledSelector = @selector(zy_addObserver:forKeyPath:options:context:);
    
    [[self class] swizzle:originalSelector swizzledSelector:swizzledSelector];
    
    
}

+(void)swizzleRemoveObserver{
    
    SEL originalSelector = @selector(removeObserver:forKeyPath:);
    SEL swizzledSelector = @selector(zy_removeObserver:forKeyPath:);
    
    [[self class] swizzle:originalSelector swizzledSelector:swizzledSelector];
    
    
}



-(void)zy_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    
    if (self.kvoSafteyToggle) {
        
        
        if (!observer || !keyPath) {
            return;
        }
        
        
        NSHashTable *table = [[self keypathMap] objectForKey:observer];
        
        if (!table) {
            table =  [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
            [table addObject:keyPath];
            [[self keypathMap] setObject:table forKey:observer];
            [self zy_addObserver:observer forKeyPath:keyPath options:options context:context];
            return;
        }
        
        if ([table containsObject:keyPath]) {
            NSLog(@"%s ******* donot add the same observer and keypath %@ ",__FUNCTION__, self);
            
            return;
        }
        
        
        [table addObject:keyPath];

    }
    
    
    
    [self zy_addObserver:observer forKeyPath:keyPath options:options context:context];
    
}

-(void)zy_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    if (self.kvoSafteyToggle) {
        
        if(!observer || !keyPath){
            return;
        }
        
        NSHashTable *table = [[self keypathMap] objectForKey:observer];
        if (!table) {
            return;
        }
        
        
        if (![table containsObject:keyPath]) {
            NSLog(@"%s ******* donot remove the keypath not existed %@ ",__FUNCTION__, self);
            
            return;
        }
        
        
        [table removeObject:keyPath];
    }


    [self zy_removeObserver:observer forKeyPath:keyPath];
    

}



@end
