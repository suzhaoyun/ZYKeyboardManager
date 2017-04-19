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
    
    //如果有移动 开始frame-结束frame
    CGRect keyBoardBeginFrame = [notify.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyBoardEndFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 如果没有移动
    if (keyBoardEndFrame.origin.y - keyBoardBeginFrame.origin.y == 0) {
        return;
    }
    
    // 记录偏移量
    CGFloat offset = [self getOffsetKeyboardFrame:keyBoardEndFrame withView:self.responder.view];
    
    // 如果被遮挡
    if (offset > 0) {
        self.responder.offset = offset;
        
        // 如果是scrollView
        if (self.responder.isScrollMoveView) {
            UIScrollView *moveV = (UIScrollView *)self.responder.view.zy_MoveView;
            [UIView animateWithDuration:duration animations:^{
                moveV.contentInset = UIEdgeInsetsMake(moveV.contentInset.top, moveV.contentInset.left, moveV.contentInset.bottom + offset, moveV.contentInset.right);
                moveV.contentOffset = CGPointMake(moveV.contentOffset.x, moveV.contentOffset.y + offset);
            }];
        }else{
            [UIView animateWithDuration:duration animations:^{
                self.responder.view.zy_MoveView.transform = CGAffineTransformTranslate(self.responder.view.zy_MoveView.transform, 0, -(offset));
            }];
        }
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
            moveV.contentInset = UIEdgeInsetsMake(moveV.contentInset.top, moveV.contentInset.left, moveV.contentInset.bottom - self.responder.offset, moveV.contentInset.right);
        }completion:^(BOOL finished) {
            self.responder.view = nil;
            self.responder.offset = 0;
            self.responder.isScrollMoveView = NO;
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.responder.view.zy_MoveView.transform = CGAffineTransformTranslate(self.responder.view.zy_MoveView.transform, 0, self.responder.offset);
        }completion:^(BOOL finished) {
            [self.responder.view.zy_MoveView removeGestureRecognizer:self.closeGes];
            self.responder.view = nil;
            self.responder.offset = 0;
            self.responder.isScrollMoveView = NO;;
        }];
    }
}

/**
 获取view的最低部和键盘之间的距离

 @param frame 键盘的位置
 @param v 要比较的view
 @return offset
 */
- (CGFloat)getOffsetKeyboardFrame:(CGRect)frame withView:(UIView<ZYKB> *)v
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect wFrame = [v convertRect:v.bounds toView:window];
    return CGRectGetMaxY(wFrame) - frame.origin.y  + v.zy_KeyBoardDistance;
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
    self.responder.isScrollMoveView = [control.zy_MoveView isKindOfClass:[UIScrollView class]];
    self.responder.isTextView = [control isKindOfClass:[UITextView class]];
    
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
