# ZYKeyboardManager
iOS开发中，难免会遇到键盘弹出遮挡了输入框的情景， 这种情况需要开发者自行处理，但每次
都处理这种重复的逻辑对开发者本身并没有任何的提升，在这种场景下，ZYKeyboardManager诞生了。我在自己公司的项目里面也在使用，经过2个版本的迭代，相比于最初更稳定，代码结构更清楚，希望大家支持，多多使用，多多反馈问题。
- easy to use, only one row code to avoid keyboard cover. green not invade!
- 简单易用， 一行代码搞定键盘遮挡问题， 绿色无侵入。
- V2.0发布， 核心代码重构。bug修复

## useage（用法）
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

## 期待
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
* 如果在使用过程中发现功能不够用，希望你能Issues我，我非常想为这个框架增加更多好用的功能，谢谢
* 如果你想为ZYSu输出代码，请拼命Pull Requests我