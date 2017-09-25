//
//  YBLStoreDetailUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreDetailUIService.h"
#import "YBLStoreDetailCell.h"
#import "YBLStoreCommentCell.h"

@interface YBLStoreDetailUIService ()
@property (nonatomic, strong) NSMutableArray * sectionArr;
@property (nonatomic, strong) NSMutableArray * sectionDetailArr;
@end

@implementation YBLStoreDetailUIService

- (NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        _sectionArr = [NSMutableArray array];
        NSArray * titleArrOne = @[@"公司名称",@"店铺简介",@"开店时间",@"经营模式",@"所在地区",@"主营产品"];
        NSArray * titleArrTwo = @[@"供应等级",@"交易勋章",@"交易勋章",];
        NSArray * titleArrThree = @[@"联系卖家",@"店铺二维码",@"证照信息",];
        [_sectionArr addObject:titleArrOne];
        [_sectionArr addObject:titleArrTwo];
        [_sectionArr addObject:titleArrThree];
    }
    return _sectionArr;
}

- (NSMutableArray *)sectionDetailArr {
    if (!_sectionDetailArr) {
        _sectionDetailArr = [NSMutableArray array];
        NSArray * titleArrOne = @[@"河南云采",@"给你一个美好生活的开始",@"2016。12.24",@"生活超市",@"河南郑州",@"各种生活用品"];
        NSArray * titleArrTwo = @[@"2",@"3",];
        NSArray * titleArrThree = @[@"store_contract",@"store_brcard",@"store_photo",];
        [_sectionDetailArr addObject:titleArrOne];
        [_sectionDetailArr addObject:titleArrTwo];
        [_sectionDetailArr addObject:titleArrThree];
    }
    return _sectionDetailArr;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 10)];
    headerView.backgroundColor = YBLColor(242, 242, 242, 1);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0 || section == 2) {
        YBLStoreDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreDetailCell" forIndexPath:indexPath];
        return [self getDetailCell:cell indexPath:indexPath];
        
    }else if (section == 1) {
        if (indexPath.row == 2) {
            YBLStoreCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreCommentCell" forIndexPath:indexPath];
            return [self getCommentCell:cell indexPath:indexPath];
        }else {
            YBLStoreDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreDetailCell" forIndexPath:indexPath];
            return [self getDetailCell:cell indexPath:indexPath];
        }
        
    }
    return 0;
}

- (YBLStoreDetailCell *)getDetailCell:(YBLStoreDetailCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSArray * arry = self.sectionArr[indexPath.section];
    NSArray * detailArr = self.sectionDetailArr[indexPath.section];
    [cell updateCellWithTitle:arry[indexPath.row] detail:detailArr[indexPath.row] indexPatn:indexPath];
    return cell;
}

- (YBLStoreCommentCell *)getCommentCell:(YBLStoreCommentCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 95;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellSelectBlock) {
        self.cellSelectBlock(indexPath);
    }
}


@end
