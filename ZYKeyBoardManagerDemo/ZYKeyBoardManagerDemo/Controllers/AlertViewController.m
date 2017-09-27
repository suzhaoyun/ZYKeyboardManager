//
//  AlertViewController.m
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/9/21.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "AlertViewController.h"
#import "AlertTestView.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"弹窗测试";
}

- (IBAction)alertClick:(id)sender {
    [AlertTestView showWithCancleClick:nil confirmClick:nil];
}

@end
