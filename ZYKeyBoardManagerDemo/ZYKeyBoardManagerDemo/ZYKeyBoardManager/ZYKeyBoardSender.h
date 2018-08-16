//
//  ZYKeyBoardSender.h
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/9/21.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYKeyBoardSenderProtocol <NSObject>

/// 与键盘之间的距离 默认为10
@property (nonatomic, assign) CGFloat zyKeyBoardDistance;

/// 需要做移动的view 默认为当前显示器的view
@property (nonatomic, weak) UIView *zyMoveView;

@end

@interface UITextField (ZYKeyBoardSender)<ZYKeyBoardSenderProtocol>

@end

@interface UITextView (ZYKeyBoardSender)<ZYKeyBoardSenderProtocol>

@end
