//
//  ViewController.m
//  JDLog
//
//  Created by JD on 2018/5/30.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "ViewController.h"
#import "JDLogViewController.h"
#import "JDLogFileManager.h"

@interface ViewController () {
    NSTimer *_timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[JDLogFileManager shareInstance] start];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)log {
    long i = random();
    NSLog(@"%ld",i);
    NSLog(@"%@",self);
}
- (IBAction)exceptionAction:(id)sender {
    if ([@"1" containsString:nil]) {
    }
}

- (IBAction)showAction:(id)sender {
    [self.navigationController pushViewController:[[JDLogViewController alloc] init] animated:YES];
}
- (IBAction)timerLogAction:(id)sender {
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(log) userInfo:nil repeats:YES];
}
- (IBAction)stopLogAction:(id)sender {
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
