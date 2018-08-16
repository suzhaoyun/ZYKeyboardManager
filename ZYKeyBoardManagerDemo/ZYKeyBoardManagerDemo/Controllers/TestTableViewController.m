//
//  TestTableViewController.m
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/9/27.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "TestTableViewController.h"
#import "TableViewCell.h"
#import "ZYKeyBoardManager.h"

@interface TestTableViewController ()

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 因为在UITableViewController中系统会自动对键盘遮挡进行处理, 如果我们再做处理的话,就会出现偏差
    self.navigationItem.title = @"测试在UITableViewController中";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.textF.zyMoveView = self.tableView;
    cell.titleL.text = [NSString stringWithFormat:@"试一试呗 啊啊啊%zd", indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}


@end
