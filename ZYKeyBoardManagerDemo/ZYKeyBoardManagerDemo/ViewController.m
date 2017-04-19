//
//  ViewController.m
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ViewController.h"
#import "ZYKeyBoardManagerSDK.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textF1;
@property (weak, nonatomic) IBOutlet UITextField *textF2;
@property (weak, nonatomic) IBOutlet UITextView *textV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 首先开始监听 最好放在appdelegate的didFinishLaunch中
    [[ZYKeyBoardManager sharedManager] startListening];
    
    // 指定被遮挡时 需要移动的view
    self.textF1.zy_MoveView = self.view;
    
    // 可以设置文本框与键盘的间距
    self.textV.zy_MoveView = self.view;
    self.textV.zy_KeyBoardDistance = 30;
    
    self.textF2.zy_MoveView = self.view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
