//
//  UIView+ViewCrashSafety.m
//  ZYLightKit
//
//  Created by apple on 2017/2/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UIView+ViewCrashSafety.h"
#import <objc/runtime.h>
#import "DrLightConfig.h"

@implementation UIView (ViewCrashSafety)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [class swizzleSetNeedsLayout];
        [class swizzleSetNeedsDisplay];
        [class swizzleSetNeedsDisplayInRect];
        [class swizzleSetNeedsUpdateConstraints];

    });
    
}

+(void)swizzleSetNeedsLayout{
    
    SEL originalSelector = @selector(setNeedsLayout);
    SEL swizzledSelector = @selector(zy_setNeedsLayout);

    DL_SWIZZLE(originalSelector,swizzledSelector)
}

+(void)swizzleSetNeedsDisplay{
    
    SEL originalSelector = @selector(setNeedsDisplay);
    SEL swizzledSelector = @selector(zy_setNeedsDisplay);
 
    DL_SWIZZLE(originalSelector,swizzledSelector)

}

+(void)swizzleSetNeedsDisplayInRect{
    
    SEL originalSelector = @selector(setNeedsDisplayInRect:);
    SEL swizzledSelector = @selector(zy_setNeedsDisplayInRect:);
    
    DL_SWIZZLE(originalSelector,swizzledSelector)
    
}

+(void)swizzleSetNeedsUpdateConstraints{
    
    SEL originalSelector = @selector(setNeedsUpdateConstraints);
    SEL swizzledSelector = @selector(zy_setNeedsUpdateConstraints);
    
    DL_SWIZZLE(originalSelector,swizzledSelector)
    
}



-(void)zy_setNeedsLayout{
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        //running on main thread
        [self zy_setNeedsLayout];
        
    }else{
        NSLog(@"%s ******* try to update ui not on main thread %@ ",__FUNCTION__, self);
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self zy_setNeedsLayout];
                       });
    }
    
    
}


-(void)zy_setNeedsDisplay{
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        //running on main thread
        [self zy_setNeedsDisplay];
        
    }else{
        NSLog(@"%s ******* try to update ui not on main thread %@ ",__FUNCTION__, self);
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self zy_setNeedsDisplay];
                       });
    }
    
    
}


-(void)zy_setNeedsDisplayInRect:(CGRect)rect{
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        //running on main thread
        [self zy_setNeedsDisplayInRect:rect];
        
    }else{
        NSLog(@"%s ******* try to update ui not on main thread %@ ",__FUNCTION__, self);
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self zy_setNeedsDisplayInRect:rect];
                       });
    }
    
    
}

-(void)zy_setNeedsUpdateConstraints{
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        //running on main thread
        [self zy_setNeedsUpdateConstraints];
        
    }else{
        NSLog(@"%s ******* try to update ui not on main thread %@ ",__FUNCTION__, self);
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self zy_setNeedsUpdateConstraints];
                       });
    }
    
    
}






@end
