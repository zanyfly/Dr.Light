//
//  NSObject+SelectorCrashSafety.m
//  DrLightDemo
//
//  Created by apple on 2017/2/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NSObject+SelectorCrashSafety.h"
#import <objc/runtime.h>
#import "DrLightConfig.h"

@interface _UnregSelObjectProxy : NSObject
+ (instancetype) sharedInstance;
@end

@implementation _UnregSelObjectProxy
+ (instancetype) sharedInstance{
    
    static _UnregSelObjectProxy *instance=nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[_UnregSelObjectProxy alloc] init];
    });
    return instance;
}

+ (BOOL) resolveInstanceMethod:(SEL)selector {
    
    class_addMethod([self class], selector,(IMP)emptyMethodIMP,"v@:");
    return YES;
}

void emptyMethodIMP(){
}



@end


@implementation NSObject (SelectorCrashSafety)

#ifndef DRLIGHT_TOGGLE_CLOSED

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleMSFS];
        [self swizzleFI];

    });
    
}

#endif

+(void)swizzleMSFS{
    
    SEL originalSelector = @selector(methodSignatureForSelector:);
    SEL swizzledSelector = @selector(zy_methodSignatureForSelector:);
    
    DL_SWIZZLE(originalSelector,swizzledSelector)
}

+(void)swizzleFI{
    
    SEL originalSelector = @selector(forwardInvocation:);
    SEL swizzledSelector = @selector(zy_forwardInvocation:);
    
    DL_SWIZZLE(originalSelector,swizzledSelector)
}


- (NSMethodSignature *)zy_methodSignatureForSelector:(SEL)sel{
    
    NSMethodSignature *sig;
    sig = [self zy_methodSignatureForSelector:sel];
    if (sig) {
        return sig;
    }
    
    sig = [[_UnregSelObjectProxy sharedInstance] zy_methodSignatureForSelector:sel];
    if (sig){
        return sig;
    }
    
    return nil;
}

- (void)zy_forwardInvocation:(NSInvocation *)anInvocation{
    
   [anInvocation invokeWithTarget:[_UnregSelObjectProxy sharedInstance] ];
    NSLog(@"******* unrecognized selctor invoked %@ ", self);
}



@end
