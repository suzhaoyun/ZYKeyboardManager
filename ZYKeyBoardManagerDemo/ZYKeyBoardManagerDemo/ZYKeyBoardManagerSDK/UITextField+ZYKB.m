//
//  UITextField+ZYKB.m
//  探索UItextField
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "UITextField+ZYKB.h"
#import <objc/runtime.h>
#import "ZYKeyBoardManager.h"

@implementation UITextField (ZYKB)

- (void)setZy_MoveView:(UIView *)zy_MoveView
{
    objc_setAssociatedObject(self, @selector(zy_MoveView), zy_MoveView, OBJC_ASSOCIATION_ASSIGN);
    
    [self addTarget:[ZYKeyBoardManager sharedManager] action:NSSelectorFromString(@"controlBeginEditing:") forControlEvents:UIControlEventEditingDidBegin];
}

- (UIView *)zy_MoveView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZy_KeyBoardDistance:(CGFloat)zy_KeyBoardDistance
{
    objc_setAssociatedObject(self, @selector(zy_KeyBoardDistance), @(zy_KeyBoardDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zy_KeyBoardDistance
{
    id n = objc_getAssociatedObject(self, _cmd);
    return n?[n floatValue]:10.0;
}

@end
