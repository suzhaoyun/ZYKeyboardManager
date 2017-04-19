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

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, assign) BOOL isScrollMoveView;

@property (nonatomic, assign) BOOL isTextView;

@end
