//
//  UINavigationController+NestedPushCrashSafety.m
//  DrLightDemo
//
//  Created by apple on 2017/2/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UINavigationController+NestedPushCrashSafety.h"
#import <objc/runtime.h>
#import "DrLightConfig.h"


static const void *navStackChangeIntervalKey=&navStackChangeIntervalKey;
static const void *navStackLastChangedTimeKey=&navStackLastChangedTimeKey;


@implementation UINavigationController (NestedPushCrashSafety)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [class swizzlePushViewController];
        
    });
    
}

- (NSTimeInterval)navStackChangeInterval
{
    NSTimeInterval time = [objc_getAssociatedObject(self, navStackChangeIntervalKey) doubleValue];
    
    if(time != 0){
        return time;
    }
 
    time = 0.1;
    [self setNavStackChangeInterval:time];
    return time;
 }


- (void)setNavStackChangeInterval:(NSTimeInterval)navStackChangeInterval
{
    objc_setAssociatedObject(self, navStackChangeIntervalKey, @(navStackChangeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSTimeInterval)navStackLastChangedTime
{
    NSTimeInterval time = [objc_getAssociatedObject(self, navStackLastChangedTimeKey) doubleValue];
    NSLog(@"get navStackLastChangedTime=%.2f",time);

    return time;
}

- (void)setNavStackLastChangedTime:(NSTimeInterval)navStackLastChangedTime
{
    NSLog(@"set NavStackLastChangedTime=%.2f",navStackLastChangedTime);
    objc_setAssociatedObject(self, navStackLastChangedTimeKey, @(navStackLastChangedTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+(void)swizzlePushViewController{
    
    SEL originalSelector = @selector(pushViewController:animated:);
    SEL swizzledSelector = @selector(zy_pushViewController:animated:);
    
    DL_SWIZZLE(originalSelector,swizzledSelector)
}

-(void)zy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"zy_pushViewController");
 
    if (viewController == self.topViewController) {
        NSLog(@"%s ******* try to push the existing viewcontroller into stack %@ ",__FUNCTION__, self);
        return;
    }
    
    NSTimeInterval now = CACurrentMediaTime();
    if (now - self.navStackLastChangedTime < self.navStackChangeInterval){
        
//        NSLog(@"%.2f, %.2f,%.2f",now, self.navStackLastChangedTime, self.navStackChangeInterval);
        
        NSLog(@"%s ******* try to push viewcontrollers frequently within %@ seconds %@ ,please excute at later time in case of navigation corruption",__FUNCTION__, @(self.navStackChangeInterval),self);
        return;
    }

    self.navStackLastChangedTime = now;

    [self pushViewControllerInMainQueue:viewController animated:animated];
}

-(void)pushViewControllerInMainQueue:(UIViewController *)viewController animated:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self zy_pushViewController:viewController animated:animated];
                   });
}



@end
