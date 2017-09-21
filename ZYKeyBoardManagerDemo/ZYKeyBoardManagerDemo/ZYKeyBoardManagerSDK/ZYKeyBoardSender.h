//
//  ZYKeyBoardSender.h
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/9/21.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYKeyBoardSenderProtocol.h"

@interface UITextField (ZYKeyBoardSender)<ZYKeyBoardSenderProtocol>
@end

@interface UITextView (ZYKeyBoardSender)<ZYKeyBoardSenderProtocol>
@end
