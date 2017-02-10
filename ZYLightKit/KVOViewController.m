//
//  KVOViewController.m
//  DrLightDemo
//
//  Created by apple on 2017/2/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "KVOViewController.h"
#import "NSObject+KVOCrashSafety.h"

@interface School:NSObject
{
}
@property(nonatomic) NSString *schoolName;
@end


@implementation School
@end



@interface KVOViewController ()
{
    School *school;
}
@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    school = [[School alloc] init];
    school.schoolName = @"First school";
    school.kvoSafteyToggle = YES;
    
    [school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];

}

- (IBAction)action:(id)sender {
    
    //    [school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];
    //    [school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];
    //
    [school removeObserver:self forKeyPath:@"schoolName"];
    //    [school removeObserver:self forKeyPath:@"schoolName"];
    //
    //    [school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
}

-(void)dealloc{
    [school removeObserver:self forKeyPath:@"schoolName"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
