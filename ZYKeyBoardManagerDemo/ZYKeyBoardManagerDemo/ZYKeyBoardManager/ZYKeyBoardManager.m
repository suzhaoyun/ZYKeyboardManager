//
//  ZYKeyBoardManager.m
//  探索UItextField
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ZYKeyBoardManager.h"
#import <UIKit/UIKit.h>
#import "ZYKeyBoardResponder.h"

@interface ZYKeyBoardManager ()

/**
 当前的响应者
 */
@property (nonatomic, strong) ZYKeyBoardResponder *responder;

/**
 键盘关闭手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *closeGes;

@end


@implementation ZYKeyBoardManager

+ (instancetype)sharedManager
{
    static ZYKeyBoardManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
        _manager.responder = [[ZYKeyBoardResponder alloc] init];
    });
    return _manager;
}

+ (void)load
{
    // 类装载 开始监听
    [[self sharedManager] startListening];
}

- (void)startListening
{
    self.enable = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardShow:(NSNotification *)notify
{
    // 在tableViewController中不处理 系统会自动处理
    if (self.enable == NO || self.responder.view == nil || self.responder.inTableViewController) {
        return;
    }
    
    // 获取键盘最终的位置
    CGRect keyBoardEndFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 记录偏移量
    CGFloat offset = [self getOffsetKeyboardFrame:keyBoardEndFrame];
    
    // 如果被遮挡
    if (offset <= 0) {
        return;
    }
    
    // 处理键盘弹出
    [self.responder keyboardShow:duration offset:offset];
}

- (void)keyBoardHidden:(NSNotification *)notify
{
    if (self.enable == NO || self.responder.view == nil || self.responder.inTableViewController) {
        return;
    }
    
    // 恢复移动视图位置
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.responder keyboardHidden:duration];
}

/**
 获取view的最低部和键盘之间的距离
 
 @param frame 键盘的位置
 @return offset
 */
- (CGFloat)getOffsetKeyboardFrame:(CGRect)frame
{
    return CGRectGetMaxY(self.responder.frame) - frame.origin.y  + self.responder.view.zyKeyBoardDistance;
}

/**
 开始编辑
 
 @param control control description
 */
- (void)controlBeginEditing:(UIView<ZYKeyBoardSenderProtocol> *)control
{
    if (!self.enable || control.zyMoveView == nil) {
        return;
    }
    
    // 删除手势
    [self.closeGes.view removeGestureRecognizer:self.closeGes];
    
    // 修改当前响应者
    self.responder.view = control;
    
    // 添加关闭手势
    if (self.responder.isScrollMoveView) {
        UIScrollView *sclV = (UIScrollView *)control.zyMoveView;
        [sclV setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }else{
        if ([control.zyMoveView isKindOfClass:[UIView class]] && [control.zyMoveView.gestureRecognizers containsObject:self.closeGes] == NO) {
            [control.zyMoveView addGestureRecognizer:self.closeGes];
        }
    }
}
- (void)closekeyBoard:(UITapGestureRecognizer *)closeGes
{
    [closeGes.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UITapGestureRecognizer *)closeGes
{
    if (_closeGes == nil) {
        _closeGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closekeyBoard:)];
    }
    return _closeGes;
}

@end
