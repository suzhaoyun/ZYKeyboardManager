//
//  ViewController.m
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ViewController.h"
#import "ZYKeyBoardManager.h"
#import "TableViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textF1;
@property (weak, nonatomic) IBOutlet UITextField *textF2;
@property (weak, nonatomic) IBOutlet UITextView *textV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"普通界面";
    
    // 指定被遮挡时 需要移动的view
    self.textF1.zyMoveView = self.view;
    
    // 可以设置文本框与键盘的间距
    self.textV.zyMoveView = self.view;
    self.textV.zyKeyBoardDistance = 30;
    
    self.textF2.zyMoveView = self.view;
}

@end
