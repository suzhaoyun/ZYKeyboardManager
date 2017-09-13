//
//  ZYKeyBoardManager.m
//  探索UItextField
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ZYKeyBoardManager.h"
#import <UIKit/UIKit.h>
#import "ZYResponder.h"

@interface ZYKeyBoardManager ()

/**
 当前的响应者
 */
@property (nonatomic, strong) ZYResponder *responder;

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
        _manager.responder = [[ZYResponder alloc] init];
    });
    return _manager;
}

- (void)startListening
{
    self.enable = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardShow:(NSNotification *)notify
{
    if (!self.enable || !self.responder.view) {
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
    
    // 如果是scrollView
    if (self.responder.isScrollMoveView) {
        UIScrollView *moveV = (UIScrollView *)self.responder.view.zy_MoveView;
        [UIView animateWithDuration:duration animations:^{
            moveV.contentInset = UIEdgeInsetsMake(self.responder.contentInset.top, self.responder.contentInset.left, self.responder.contentInset.bottom + offset, self.responder.contentInset.right);
            moveV.contentOffset = CGPointMake(self.responder.contentOffset.x, self.responder.contentOffset.y + offset);
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.responder.view.zy_MoveView.transform = CGAffineTransformTranslate(self.responder.transform, 0, -(offset));
        }];
    }
    
}

- (void)keyBoardHidden:(NSNotification *)notify
{
    if (!self.enable || !self.responder.view) {
        return;
    }
    
    // 恢复移动视图位置
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.responder.isScrollMoveView) {
        UIScrollView *moveV = (UIScrollView *)self.responder.view.zy_MoveView;
        [UIView animateWithDuration:duration animations:^{
            moveV.contentInset = self.responder.contentInset;
            moveV.contentOffset = self.responder.contentOffset;
        }completion:^(BOOL finished) {
            self.responder.view = nil;
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.responder.view.zy_MoveView.transform = self.responder.transform;
        }completion:^(BOOL finished) {
            [self.responder.view.zy_MoveView removeGestureRecognizer:self.closeGes];
            self.responder.view = nil;
        }];
    }
}

/**
 获取view的最低部和键盘之间的距离
 
 @param frame 键盘的位置
 @return offset
 */
- (CGFloat)getOffsetKeyboardFrame:(CGRect)frame
{
    return CGRectGetMaxY(self.responder.frame) - frame.origin.y  + self.responder.view.zy_KeyBoardDistance;
}

/**
 开始编辑
 
 @param control control description
 */
- (void)controlBeginEditing:(UIView<ZYKB> *)control
{
    if (!self.enable || control.zy_MoveView == nil) {
        return;
    }
    
    if (self.responder.view && self.responder.isScrollMoveView == NO) {
        [self.responder.view.zy_MoveView removeGestureRecognizer:self.closeGes];
    }
    
    self.responder.view = control;
    
    // 添加关闭手势
    if (self.responder.isScrollMoveView) {
        UIScrollView *sclV = (UIScrollView *)control.zy_MoveView;
        if (sclV.keyboardDismissMode != UIScrollViewKeyboardDismissModeOnDrag) {
            sclV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        }
    }else{
        if ([control.zy_MoveView isKindOfClass:[UIView class]] && [control.zy_MoveView.gestureRecognizers containsObject:self.closeGes] == NO) {
            [control.zy_MoveView addGestureRecognizer:self.closeGes];
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
