# Dr.Light

the name of Dr.Light is inspird by Dr.Strange, it is a very simple,light kit to avoid crash in some cases.

## range of protection
- fresh ui in nonmain thread.
- add/remove KVO unpaired

## useage

### ui thread-safety

just include UIView+ViewCrashSafety.h、UIView+ViewCrashSafety.m in your project.

### kvo safety

1. include UIView+ViewCrashSafety.h、UIView+ViewCrashSafety.m in your project.
2. import the header 

```objective-c
#import "NSObject+KVOCrashSafety.h"
```

3. start protection for the KVO logic you coded.

```objective-c
school = [[School alloc] init];
school.schoolName = @"First school";
school.kvoSafteyToggle = YES;
    
[school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];
```
## Contact 
I'll add more features in a later release，you can contact me zanyfly@126.com.

## License

KVOController is released under a BSD License. See LICENSE file for details.


