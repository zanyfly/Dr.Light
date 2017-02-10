//
//  NestedViewControllerA.m
//  DrLightDemo
//
//  Created by apple on 2017/2/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NestedViewControllerA.h"
#import "NestedViewControllerB.h"
#import "UINavigationController+NestedPushCrashSafety.h"
@interface NestedViewControllerA ()
@property(nonatomic) BOOL pushing;
@end

@implementation NestedViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navStackChangeInterval = 0.1;
    NestedViewControllerB *vc = [NestedViewControllerB new];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)push:(id)sender {
    
    NestedViewControllerB *vc = [NestedViewControllerB new];
    [self.navigationController pushViewController:vc animated:YES];
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:vc animated:YES];
    });


}

@end
