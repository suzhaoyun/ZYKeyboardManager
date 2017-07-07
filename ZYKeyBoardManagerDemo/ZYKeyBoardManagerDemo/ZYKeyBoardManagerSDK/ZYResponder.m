//
//  ZYResponder.m
//  探索UItextField
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ZYResponder.h"

@implementation ZYResponder

- (void)setView:(UIView<ZYKB> *)view
{
    _view = view;
    
    _isScrollMoveView = [view.zy_MoveView isKindOfClass:[UIScrollView class]];
    _isTextView = [view isKindOfClass:[UITextView class]];
    if (view){
        _frame = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
    }else{
        _frame = CGRectZero;
    }
    if (_isScrollMoveView) {
        _contentInset = ((UIScrollView *)view.zy_MoveView).contentInset;
        _contentOffset = ((UIScrollView *)view.zy_MoveView).contentOffset;
        _transform = CGAffineTransformIdentity;
    }else{
        _contentInset = UIEdgeInsetsZero;
        _contentOffset = CGPointZero;
        _transform = view.transform;
    }
}

@end
