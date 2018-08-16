//
//  ZYKeyBoardSender.m
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/9/21.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ZYKeyBoardSender.h"
#import "ZYKeyBoardManager.h"
#import <objc/runtime.h>

@implementation UITextField (ZYKB)

- (void)setZyMoveView:(UIView *)zyMoveView
{
    if (self.zyMoveView == zyMoveView) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(zyMoveView), zyMoveView, OBJC_ASSOCIATION_ASSIGN);
    
    [self addTarget:[ZYKeyBoardManager sharedManager] action:NSSelectorFromString(@"controlBeginEditing:") forControlEvents:UIControlEventEditingDidBegin];
}

- (UIView *)zyMoveView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZyKeyBoardDistance:(CGFloat)zyKeyBoardDistance
{
    objc_setAssociatedObject(self, @selector(zyKeyBoardDistance), @(zyKeyBoardDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zyKeyBoardDistance
{
    id n = objc_getAssociatedObject(self, _cmd);
    return n?[n floatValue]:10.0;
}

@end

@implementation UITextView (ZYKB)

+ (void)load
{
    // 拦截成为第一响应者方法
    Method sm = class_getInstanceMethod(self, @selector(canBecomeFirstResponder));
    Method mm = class_getInstanceMethod(self, @selector(zy_canBecomeFirstResponder));
    method_exchangeImplementations(sm, mm);
}

- (BOOL)zy_canBecomeFirstResponder
{
    BOOL result = [self zy_canBecomeFirstResponder];
    if (result && self.zyMoveView) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[ZYKeyBoardManager sharedManager] performSelector:NSSelectorFromString(@"controlBeginEditing:") withObject:self];
#pragma clang diagnostic pop
    }
    return result;
}

#pragma mark - property

- (void)setZyKeyBoardDistance:(CGFloat)zyKeyBoardDistance
{
    objc_setAssociatedObject(self, @selector(zyKeyBoardDistance), @(zyKeyBoardDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zyKeyBoardDistance
{
    id n = objc_getAssociatedObject(self, _cmd);
    return n?[n floatValue]:10.0;
}

- (void)setZyMoveView:(UIView *)zyMoveView
{
    if (self.zyMoveView == zyMoveView){
        return;
    }
    objc_setAssociatedObject(self, @selector(zyMoveView), zyMoveView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)zyMoveView
{
    return objc_getAssociatedObject(self, _cmd);
}
@end
