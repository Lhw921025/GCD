//
//  ViewController.m
//  GCD定时器
//
//  Created by 刘红伟 on 2019/4/9.
//  Copyright © 2019 刘红伟. All rights reserved.
//

#import "ViewController.h"
#import "GCDTimer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i=0; i<15; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40+(20+10)*i, 200, 20)];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"取消定时器" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        __block int j = 0;
        [[GCDTimer sharedInstance] scheduleGCDTimerWithName:[NSString stringWithFormat:@"timer---%ld",i] Interval:1.0 event:^{
            [btn setTitle:[NSString stringWithFormat:@"timer=====%d",j] forState:UIControlStateNormal];
            j++;
        }];
    }
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 500, 200, 20)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"取消定时器" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
//    __block int k=0;
//    [[GCDTimer sharedInstance] scheduleGCDTimerWithInterval:2.0 repeatCount:5 event:^{
//        NSLog(@"kkkkkkkkkk=%d",k);
//        k++;
//    }];
//
//    [[GCDTimer sharedInstance] scheduleGCDTimerAfterWithInterval:5.0 event:^{
//        NSLog(@"kkkkkkkkkk=%d",k);
//    }];
}
- (void)click{
    for (NSInteger i=0; i<10; i++) {
        [[GCDTimer sharedInstance] cancelTimerWithName:[NSString stringWithFormat:@"timer---%ld",i]];
    }
}
- (void)btnClick{
    for (NSInteger i=10; i<15; i++) {
        [[GCDTimer sharedInstance] cancelTimerWithName:[NSString stringWithFormat:@"timer---%ld",i]];
    }
}

@end
