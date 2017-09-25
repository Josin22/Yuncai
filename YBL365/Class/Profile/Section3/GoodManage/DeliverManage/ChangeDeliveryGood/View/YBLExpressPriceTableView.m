//
//  YBLExpressPriceTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLExpressPriceTableView.h"
#import "YBLSetLogisticsPricesCell.h"
#import "YBLGetProductShippPricesModel.h"
#import "YBLAreaRadiusItemModel.h"
#import "YBLGoodShippingPriceModel.h"

@interface YBLExpressPriceTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger index_default;
}
@property (nonatomic, assign) DistanceRadiusType distanceRadiusType;

@end

@implementation YBLExpressPriceTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style distanceRadiusType:(DistanceRadiusType)distanceRadiusType{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _distanceRadiusType = distanceRadiusType;
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        if (self.height>YBLWindowHeight*2/3) {
            self.emptyDataSetSource = self;
            self.emptyDataSetDelegate = self;
        }
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:NSClassFromString(@"YBLSetLogisticsPricesCell") forCellReuseIdentifier:@"YBLSetLogisticsPricesCell"];
        self.rowHeight = [YBLSetLogisticsPricesCell getItemCellHeightWithModel:nil];
        
        index_default = 0;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    return [self initWithFrame:frame style:style distanceRadiusType:DistanceRadiusTypeEdit];
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    if (self.distanceRadiusType == DistanceRadiusTypeExpressPriceChoose) {
        NSInteger index = 0;
        BOOL isHasSelect = NO;
        for (YBLShippingPriceItemModel *model in _dataArray) {
            if (model.is_select.boolValue) {
                index_default = index;
                isHasSelect = YES;
            }
            index++;
        }
        if (!isHasSelect) {
            YBLShippingPriceItemModel *model = _dataArray[0];
            model.is_select = @(YES);
        }
    }
    
    [self jsReloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLSetLogisticsPricesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLSetLogisticsPricesCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLSetLogisticsPricesCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id model = _dataArray[indexPath.row];
    
    if (_distanceRadiusType == DistanceRadiusTypeChoose && [model isKindOfClass:[YBLAreaRadiusItemModel class]]) {
        YBLAreaRadiusItemModel *itemModel = (YBLAreaRadiusItemModel *)model;
        cell.logisticsTitleLabel.text = [NSString stringWithFormat:@"%ld 公里配送半径内",(long)itemModel.radius.integerValue];
        cell.isSelectRow = itemModel.is_select;
        
    } else if (_distanceRadiusType == DistanceRadiusTypeExpressPriceChoose){
        YBLShippingPriceItemModel *shipPriceItemModel = (YBLShippingPriceItemModel *)model;
        //物流价格复选
        cell.logisticsTitleLabel.text = [NSString stringWithFormat:@"%@ ¥:%.2f",shipPriceItemModel.express_company,shipPriceItemModel.price.doubleValue];
        if (indexPath.row == index_default) {
            cell.isSelectRow = YES;
        } else {
            cell.isSelectRow = NO;
        }
        
    } else {
        
        [cell updateItemCellModel:model];
        cell.addSubView.currentFloatChangeBlock = ^(float doubleValue, YBLAddSubtractView *addSubView,BOOL isButtonClick) {
            [model setValue:@(doubleValue) forKey:@"price"];
        };
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = _dataArray[indexPath.row];
    BLOCK_EXEC(self.expressPriceTableViewCellDidSelectRowBlock,indexPath,model);
    
    if (_distanceRadiusType == DistanceRadiusTypeChoose && [model isKindOfClass:[YBLAreaRadiusItemModel class]]) {
        YBLAreaRadiusItemModel *itemModel = (YBLAreaRadiusItemModel *)model;
        itemModel.is_select = !itemModel.is_select;
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (_distanceRadiusType == DistanceRadiusTypeExpressPriceChoose){
        index_default = indexPath.row;
        for (YBLShippingPriceItemModel *shipPriceItemModel in _dataArray) {
            shipPriceItemModel.is_select = @(NO);
        }
        YBLShippingPriceItemModel *shipPriceItemModel = (YBLShippingPriceItemModel *)model;
        [shipPriceItemModel setValue:@(YES) forKey:@"is_select"];
        [self jsReloadData];
    } else if(_distanceRadiusType == DistanceRadiusTypeSingleGoodExpressPriceEdit){
        [YBLActionSheetView showActionSheetWithTitles:@[@"删除当前地区物流价格"] handleClick:^(NSInteger index) {
            switch (index) {
                case 0:
                {
                    [_dataArray removeObjectAtIndex:indexPath.row];
                    [self beginUpdates];
                    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [self endUpdates];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.isCanDelete&&self.distanceRadiusType==DistanceRadiusTypeEdit;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self endUpdates];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self endEditing:YES];
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data_express";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有添加数据~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

@end
