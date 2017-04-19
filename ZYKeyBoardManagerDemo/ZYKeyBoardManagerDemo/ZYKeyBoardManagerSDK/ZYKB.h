//
//  ZYKB.h
//  探索UItextField
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZYKB <NSObject>

/// 与键盘之间的距离 默认为10
@property (nonatomic, assign) CGFloat zy_KeyBoardDistance;

/// 需要做移动的view 默认为当前显示器的view
@property (nonatomic, weak) UIView *zy_MoveView;

@end
