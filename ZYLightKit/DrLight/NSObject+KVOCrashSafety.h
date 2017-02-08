//
//  NSObject+KVOCrashSafety.h
//  ZYLightKit
//
//  Created by apple on 2017/2/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 avoid crash when add\remove KVO repeatly. 
 */

@interface NSObject (KVOCrashSafety)


/**
 NO default ，set YES to open kvo safety.
 */
@property(nonatomic) BOOL kvoSafteyToggle;

@end
