//
//  MainViewController.m
//  ZYKeyBoardManagerDemo
//
//  Created by ZYSu on 2017/9/21.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "AlertViewController.h"
#import "TableViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"ZYKeyBoardManager";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    if (indexPath.row == 0) {
        vc = [UIStoryboard storyboardWithName:@"ViewController" bundle:nil].instantiateInitialViewController;
    }
    else if (indexPath.row == 1){
        vc = [[AlertViewController alloc] init];
    }
    else if (indexPath.row == 2){
        vc = [UIStoryboard storyboardWithName:@"TableViewController" bundle:nil].instantiateInitialViewController;
    }
    else if (indexPath.row == 3){
        vc = [UIStoryboard storyboardWithName:@"TestTableViewController" bundle:nil].instantiateInitialViewController;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
