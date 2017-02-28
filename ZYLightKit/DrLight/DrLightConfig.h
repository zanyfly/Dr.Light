//
//  DrLightConfig.h
//  DrLightDemo
//
//  Created by apple on 2017/2/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef DrLightConfig_h
#define DrLightConfig_h


#define DL_SWIZZLE(_orisel_, _swisel_) { \
    Class class = [self class];\
    \
    Method originalMethod = class_getInstanceMethod(class, _orisel_);\
    Method swizzledMethod = class_getInstanceMethod(class, _swisel_);\
    BOOL didAddMethod = class_addMethod(class, \
                    _orisel_,\
                    method_getImplementation(swizzledMethod),\
                    method_getTypeEncoding(swizzledMethod));\
    \
    if (didAddMethod) {\
        class_replaceMethod(class,\
                            _swisel_,\
                            method_getImplementation(originalMethod),\
                            method_getTypeEncoding(originalMethod));\
    } else { \
        method_exchangeImplementations(originalMethod, swizzledMethod);\
    } \
}



#endif /* DrLightConfig_h */
