//
//  UITextView+ZYKB.m
//  探索UItextField
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "UITextView+ZYKB.h"
#import <objc/runtime.h>
#import "ZYKeyBoardManager.h"

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
    if (result && self.zy_MoveView) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[ZYKeyBoardManager sharedManager] performSelector:NSSelectorFromString(@"controlBeginEditing:") withObject:self];
#pragma clang diagnostic pop
    }
    return result;
}

#pragma mark - property

- (void)setZy_KeyBoardDistance:(CGFloat)zy_KeyBoardDistance
{
    objc_setAssociatedObject(self, @selector(zy_KeyBoardDistance), @(zy_KeyBoardDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zy_KeyBoardDistance
{
    id n = objc_getAssociatedObject(self, _cmd);
    return n?[n floatValue]:10.0;
}

- (void)setZy_MoveView:(UIView *)zy_MoveView
{
    objc_setAssociatedObject(self, @selector(zy_MoveView), zy_MoveView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)zy_MoveView
{
    return objc_getAssociatedObject(self, _cmd);
}
@end
