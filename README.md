![alt](https://github.com/suzhaoyun/ZYKeyboardManager/blob/master/demo.gif)
# ZYKeyboardManager
iOS开发中，难免会遇到键盘弹出遮挡了输入框的情景， 这种情况需要开发者自行处理，但每次
都处理这种重复的逻辑对开发者本身并没有任何的提升，在这种场景下，ZYKeyboardManager诞生了。我在自己公司的项目里面也一直在使用，经过2个版本的迭代，相比于最初更稳定，代码结构更清楚，希望大家支持，多多使用，多多反馈问题，我也会继续的维护下去。
- Easy to use, only one row code to avoid keyboard cover. safe not invade!
- 简单易用， 一行代码搞定键盘遮挡问题， 绿色无侵入，任意场景都可适用。
- V2.0发布， 核心代码重构，bug修复。
## 用法 useage
1. 在需要使用的文件中导入ZYKeyboardManager.h
```objc
#import "ZYKeyBoardManager.h"
```
2. 指定输入框被遮挡时需要移动的view
```objc
self.textField.zyMoveView = self.view;
```
3. 支持自定义输入框和键盘的距离 如果不设置默认是10
```objc
self.textField.zyKeyBoardDistance = 30;
```

2.0版本支持在tableView中的使用
```objc
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.textF.zyMoveView = self.tableView;
    return cell;
}
```
## 核心代码
思路： 通过ZYKeyBoardSender往外发送所有的输入框触发事件，ZYKeyBoardManager收到事件，根据发送者信息，创建ZYKeyBoardResponder,最后ZYKeyBoardManager监听键盘弹出隐藏通知，responder处理响应。

1. 利用runtime的Associated给UITextField, UITextView扩充属性，记录用户设置的moveView, distance
```objc
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
```
2. 检测文本框的响应：
在检测文本框响应的时候遇到了一些问题， UITextField可以通过添加UIControlEventEditingDidBegin的action方式直接获取到键盘响应，但UITextView并没有此类事件。
在研究中发现开发者主动调用becomeFirstResponder方法可以主动触发键盘弹出，于是猜测输入框被点击时会不会也会触发这个方法。结果查看调用栈发现了一个更合适的方法，canBecomeFirstResponder，这个方法会决定输入框能不能成为响应者。当找到这个方法的时候，思路就明确了，利用runtime的method_exchange黑魔法将系统的canBecomeFirstResponder替换掉，自己可以在能成为响应者的时候，向ZYKeyBoardManager发送事件，完美。
```objc
// UITextField
objc_setAssociatedObject(self, @selector(zyMoveView), zyMoveView, OBJC_ASSOCIATION_ASSIGN);
[self addTarget:[ZYKeyBoardManager sharedManager] action:NSSelectorFromString(@"controlBeginEditing:") forControlEvents:UIControlEventEditingDidBegin];

// UITextView
+ (void)load
{
    // 拦截成为第一响应者方法
    Method sm = class_getInstanceMethod(self, @selector(canBecomeFirstResponder));
    Method mm = class_getInstanceMethod(self, @selector(zy_canBecomeFirstResponder));
    method_exchangeImplementations(sm, mm);
}

- (BOOL)zy_canBecomeFirstResponder
{
    BOOL result = [self zy_canBecomeFirstResponder];
    if (result && self.zyMoveView) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[ZYKeyBoardManager sharedManager] performSelector:NSSelectorFromString(@"controlBeginEditing:") withObject:self];
#pragma clang diagnostic pop
    }
    return result;
}
```
3. ZYKeyBoardManager收到事件，创建responder
```objc
/**
 开始编辑
 
 @param control control description
 */
- (void)controlBeginEditing:(UIView<ZYKeyBoardSenderProtocol> *)control
{
    if (!self.enable || control.zyMoveView == nil) {
        return;
    }
    
    // 删除手势
    [self.closeGes.view removeGestureRecognizer:self.closeGes];
    
    // 修改当前响应者
    self.responder.view = control;
    
    // 添加关闭手势
    if (self.responder.isScrollMoveView) {
        UIScrollView *sclV = (UIScrollView *)control.zyMoveView;
        [sclV setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }else{
        if ([control.zy_MoveView isKindOfClass:[UIView class]] && [control.zyMoveView.gestureRecognizers containsObject:self.closeGes] == NO) {
            [control.zyMoveView addGestureRecognizer:self.closeGes];
        }
    }
}
```

4. ZYKeyBoardManager监听键盘通知，让responder做出响应
```objc
- (void)keyBoardShow:(NSNotification *)notify
{   
    // 获取键盘最终的位置
    CGRect keyBoardEndFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 记录偏移量
    CGFloat offset = [self getOffsetKeyboardFrame:keyBoardEndFrame];
    
    // 如果被遮挡
    if (offset <= 0) {
        return;
    }
    
    // 处理键盘弹出
    [self.responder keyboardShow:duration offset:offset];
}

- (void)keyBoardHidden:(NSNotification *)notify
{   
    // 恢复移动视图位置
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.responder keyboardHidden:duration];
}
```
5. 迭代过程中发现很多坑，做了很多修正，不一一叙述
## 期待
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
* 如果在使用过程中发现功能不够用，希望你能Issues我，我非常想为这个框架增加更多好用的功能，谢谢
* 如果你想为ZYSu输出代码，请拼命Pull Requests我
