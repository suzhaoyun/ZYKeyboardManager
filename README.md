# ZYKeyboardManager
iOS开发中，难免会遇到键盘弹出遮挡了输入框的情景， 这种情况需要开发者自行处理，但每次
都处理这种重复的逻辑对开发者本身并没有任何的提升，在这种场景下，ZYKeyboardManager诞生了。我在自己公司的项目里面也一直在使用，经过2个版本的迭代，相比于最初更稳定，代码结构更清楚，希望大家支持，多多使用，多多反馈问题，我也会长期的维护下去。
- easy to use, only one row code to avoid keyboard cover. green not invade!
- 简单易用， 一行代码搞定键盘遮挡问题， 绿色无侵入。
- V2.0发布， 核心代码重构。bug修复

## 用法 useage
1. 在需要使用的文件中导入ZYKeyboardManager.h
```
#import "ZYKeyBoardManager.h"
```
2. 指定输入框被遮挡时需要移动的view
```
self.textField.zy_MoveView = self.view;
```
3. 支持自定义输入框和键盘的距离 如果不设置默认是10
```
self.textField.zy_KeyBoardDistance = 30;
```

2.0版本支持在tableView中的使用
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.textF.zy_MoveView = self.tableView;
    return cell;
}
```
## 核心代码
思路： 通过ZYKeyBoardSender往外发送所有的输入框触发事件，ZYKeyBoardManager收到事件，根据发送者信息，创建ZYKeyBoardResponder,最后ZYKeyBoardManager监听键盘弹出隐藏通知，responder处理响应。

利用runtime的Associated给UITextField, UITextView扩充属性，记录用户设置的moveView, distance
```
@protocol ZYKeyBoardSenderProtocol <NSObject>

/// 与键盘之间的距离 默认为10
@property (nonatomic, assign) CGFloat zy_KeyBoardDistance;

/// 需要做移动的view 默认为当前显示器的view
@property (nonatomic, weak) UIView *zy_MoveView;

@end

@interface UITextField (ZYKeyBoardSender)<ZYKeyBoardSenderProtocol>

@end

@interface UITextView (ZYKeyBoardSender)<ZYKeyBoardSenderProtocol>

@end
```
检测文本框的响应：
在检测文本框响应的时候遇到了一些问题， UITextField可以通过添加UIControlEventEditingDidBegin的action方式直接获取到键盘响应，但UITextView并没有此类事件。
在研究中发现开发者主动调用becomeFirstResponder方法可以主动触发键盘弹出，于是猜测输入框被点击时会不会也会触发这个方法。结果查看调用栈发现了一个更合适的方法，canBecomeFirstResponder，这个方法会决定输入框能不能成为响应者。当看到这个方法的时候，心中就有思路了，利用runtime的methodexchange将系统的canBecomeFirstResponder替换掉，自己可以在能成为响应者的时候，向ZYKeyBoardManager发送事件。
```
// UITextField
objc_setAssociatedObject(self, @selector(zy_MoveView), zy_MoveView, OBJC_ASSOCIATION_ASSIGN);
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
    if (result && self.zy_MoveView) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[ZYKeyBoardManager sharedManager] performSelector:NSSelectorFromString(@"controlBeginEditing:") withObject:self];
#pragma clang diagnostic pop
    }
    return result;
}
```

## 期待
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
* 如果在使用过程中发现功能不够用，希望你能Issues我，我非常想为这个框架增加更多好用的功能，谢谢
* 如果你想为ZYSu输出代码，请拼命Pull Requests我