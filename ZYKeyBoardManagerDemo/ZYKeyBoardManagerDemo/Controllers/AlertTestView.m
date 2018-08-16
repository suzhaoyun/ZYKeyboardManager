//
//  LBVerifyClassRoomKeyCodeView.m
//  DragonCup
//
//  Created by ZYSu on 2017/9/20.
//  Copyright © 2017年 BeiJingLongBei. All rights reserved.
//

#import "AlertTestView.h"
#import "ZYKeyBoardManager.h"

@interface AlertTestView()

@property (nonatomic, copy) void (^cancleCall)();
@property (nonatomic, copy) void (^confirmCall)(NSString *text, UIView *codeView);
@property (weak, nonatomic) IBOutlet UITextField *textF;

@end

@implementation AlertTestView
+ (void)showWithCancleClick:(void (^)())cancle confirmClick:(void (^)(NSString *text, UIView *codeView))confirm
{
    AlertTestView *codeView = [[NSBundle mainBundle] loadNibNamed:@"AlertTestView" owner:nil options:nil].firstObject;
    codeView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    codeView.cancleCall = cancle;
    codeView.confirmCall = confirm;
    [[UIApplication sharedApplication].keyWindow addSubview:codeView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textF.superview.layer.cornerRadius = 10;
    self.textF.superview.layer.masksToBounds = YES;
    
    self.textF.zyMoveView = self.textF.superview;
    self.textF.zyKeyBoardDistance = 100;
}

- (IBAction)cancleClick:(id)sender {
    [self.textF resignFirstResponder];
    self.cancleCall?self.cancleCall():NULL;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)confirmClick:(id)sender {
    self.confirmCall?self.confirmCall(self.textF.text, self):NULL;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
