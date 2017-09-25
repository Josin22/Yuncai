//
//  YBLGoodsClassifyUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLGoodsClassifyUIService.h"

@implementation YBLGoodsClassifyUIService

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 10)];
    headerView.backgroundColor = YBLColor(242, 242, 242, 1);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (section == 0 ) {
        cell.textLabel.text = @"全部商品";
    }else  {
        cell.textLabel.text = @"【热销爆款】";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


@end
