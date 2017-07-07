//
//  ZYResponder.h
//  探索UItextField
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYKB.h"

@interface ZYResponder : NSObject

@property (nonatomic, weak) UIView<ZYKB> *view;

/**
 记录文本框原有的位置
 */
@property (nonatomic, assign, readonly) CGRect frame;

/**
 记录scrollView原有的contentInset
 */
@property (nonatomic, assign, readonly) UIEdgeInsets contentInset;

/**
 记录scrollView原有的contentOffset
 */
@property (nonatomic, assign, readonly) CGPoint contentOffset;

/**
 保存view原有的tranform
 */
@property (nonatomic, assign, readonly) CGAffineTransform transform;

/**
 获取当前的移动视图是不是scrollView
 */
@property (nonatomic, assign, readonly) BOOL isScrollMoveView;

/**
 判断当前文本框是不是textView
 */
@property (nonatomic, assign, readonly) BOOL isTextView;

@end
