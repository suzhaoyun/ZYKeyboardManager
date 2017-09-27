//
//  LBVerifyClassRoomKeyCodeView.h
//  DragonCup
//
//  Created by ZYSu on 2017/9/20.
//  Copyright © 2017年 BeiJingLongBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertTestView : UIView

+ (void)showWithCancleClick:(void (^)())cancle confirmClick:(void (^)(NSString *text, UIView *codeView))confirm;

@end
