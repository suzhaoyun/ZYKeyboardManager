//
//  TableViewController.m
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/9/21.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "TableViewController.h"
#import "ZYKeyBoardManager.h"

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UITextField *textF;

@end

@implementation TableViewCell

@end
@interface TableViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TableView";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.textF.zy_MoveView = self.tableView;
    cell.titleL.text = [NSString stringWithFormat:@"来玩啊 啊 啊啊啊%zd", indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

@end

