//
//  ZYKeyBoardManager.h
//  探索UItextField
//
//  Created by ZYSu on 2017/4/19.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYKeyBoardManager : NSObject

/**
 是否可用
 */
@property (nonatomic, assign) BOOL enable;

/**
 单例manager
 */
+ (instancetype)sharedManager;

/**
 开始监听
 */
- (void)startListening;

@end
