//
//  YBLStoreDynamicUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreDynamicUIService.h"
#import "YBLStoreDynamicCell.h"

@implementation YBLStoreDynamicUIService

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 226;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 8)];
    headerView.backgroundColor = YBLColor(242, 242, 242, 1);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBLStoreDynamicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreDynamicCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    return cell;
}

@end
