//
//  ZYKeyBoardResponder.m
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/9/21.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ZYKeyBoardResponder.h"

@implementation ZYKeyBoardResponder

- (void)setView:(UIView<ZYKeyBoardSenderProtocol> *)view
{
    if (view.zy_MoveView == _view.zy_MoveView) {
        _view = view;
        return;
    }else{
        _view = view;
    }
    
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
