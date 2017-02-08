//
//  ViewController.m
//  ZYLightKit
//
//  Created by apple on 2017/2/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+KVOCrashSafety.h"

@interface School:NSObject
{
}
@property(nonatomic) NSString *schoolName;
@end


@implementation School
@end


@interface ViewController ()
{
    School *school;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    school = [[School alloc] init];
    school.schoolName = @"First school";
    school.kvoSafteyToggle = YES;
    
    [school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action1:(id)sender {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.label.text = @"that is right";
    });
    

}

- (IBAction)action2:(id)sender {
    
//    [school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];
//    [school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];
//
    [school removeObserver:self forKeyPath:@"schoolName"];
//    [school removeObserver:self forKeyPath:@"schoolName"];
//
//    [school addObserver:self forKeyPath:@"schoolName" options:NSKeyValueObservingOptionNew context:nil];

    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
}


@end
