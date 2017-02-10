# Dr.Light

the name of Dr.Light is inspird by Dr.Strange, it is a very simple,light kit to avoid crash in some cases.

## range of protection
- fresh ui in nonmain thread.
- add/remove KVO unpaired
- pushing viewcontrollers frequently within a short perid.<br/>    for example,add push code in viewDidLoad,before viewDidAppear has called,it is dangerous.It may caused crash "cannot addsubView:self".  

  pushing the same viewcontroller into one stack.


## useage

### ui thread-safety

just include UIView+ViewCrashSafety.h、UIView+ViewCrashSafety.m in your project.

### kvo safety

include `UIView+ViewCrashSafety.h`、`UIView+ViewCrashSafety.m` in your project,then import the header.
   
```objective-c
#import "NSObject+KVOCrashSafety.h"
```
start protection for the KVO logic you coded.

```objective-c
school = [[School alloc] init];
school.schoolName = @"First school";
school.kvoSafteyToggle = YES;
    
[school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];
```
### navigation safety
 include `UINavigationController+NestedPushCrashSafety.h`、`UINavigationController+NestedPushCrashSafety.m` in your project.
 set the limit of time interval between pushing viewcontroller,defaut is 0.1.
 
```objective-c
self.navigationController.navStackChangeInterval = 0.1;
```



## Contact 
I'll add more features in a later release，you can contact me zanyfly@126.com.

## License

KVOController is released under a BSD License. See LICENSE file for details.


