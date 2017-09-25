//
//  YBLOrderTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderTableView.h"
#import "YBLlittlebOrderItemCell.h"
#import "YBLBigBOrderItemCell.h"

@interface YBLOrderTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) OrderSource orderSource;

@end

@implementation YBLOrderTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    return [self initWithFrame:frame style:style orderSource:OrderSourceBuyer];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                  orderSource:(OrderSource)orderSource{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _orderSource = orderSource;
        
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [UIView new];
        
        if (self.orderSource == OrderSourceSeller) {
            [self registerClass:NSClassFromString(@"YBLBigBOrderItemCell") forCellReuseIdentifier:@"YBLBigBOrderItemCell"];
            self.rowHeight = [YBLBigBOrderItemCell getHI];
        } else {
            [self registerClass:NSClassFromString(@"YBLLittlebOrderItemCell") forCellReuseIdentifier:@"YBLLittlebOrderItemCell"];
            self.rowHeight = [YBLLittlebOrderItemCell getlittlebOrderItemCellHi];
        }
        
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderSource == OrderSourceSeller) {
        
        YBLBigBOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLBigBOrderItemCell" forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    } else {
        
        YBLLittlebOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLLittlebOrderItemCell" forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }
}


- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    NSInteger section = indexPath.section;
    WEAK
    YBLOrderItemModel *model = self.dataArray[section];
    /**
     *  大B
     */
    if ([cell isKindOfClass:[YBLBigBOrderItemCell class]]) {
        
        YBLBigBOrderItemCell *bigB_cell = (YBLBigBOrderItemCell *)cell;
        
        [bigB_cell updateModel:model];
        
        /**
         *  点击cell
         */
        bigB_cell.bigBOrderItemCellDiDSelectBlock = ^{
            STRONG
            if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
                [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:model tableview:self];
            }
        };
        
        /**
         *  点击cell button
         */
        bigB_cell.bigBOrderItemCellButtonClickBlock = ^(NSString *currentTitle,YBLOrderPropertyItemModel *clickButtonModel) {
            STRONG
            if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
                [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath 
                                                                 selectValue:@[model,
                                                                               indexPath,
                                                                               currentTitle,
                                                                               clickButtonModel,
                                                                               cell,
                                                                               @(YES),
                                                                               @(NO),
                                                                               ]
                                                                   tableview:self];
            }
//            [self.viewModel dealWithSellerAndBuyerCellButtonActionEventWithModel:model
//                                                                       indexPath:indexPath
//                                                                    currentTitle:currentTitle
//                                                          orderPropertyItemModel:clickButtonModel
//                                                                            cell:cell
//                                                                        isSeller:YES
//                                                                   isOrderDetail:NO
//                                                                orderDeleteBlock:nil
//                                                               orderRequestBlock:nil];
            
        };
        
    } else {
        /**
         *  小b
         */
        YBLLittlebOrderItemCell *littleb_cell = (YBLLittlebOrderItemCell *)cell;
        
        [littleb_cell updateOrderItemModel:model];
        
        littleb_cell.littlebOrderItemCellDiDSelectBlock = ^(YBLOrderItemModel *model,NSInteger index){
            STRONG
            if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
                [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:model tableview:self];
            }
        };
        littleb_cell.littlebOrderItemCellButtonBlock = ^(NSString *orderButtonCurrentTitle,YBLOrderPropertyItemModel *clickButtonModel){
            STRONG
            if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
                [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath
                                                                 selectValue:@[model,
                                                                               indexPath,
                                                                               orderButtonCurrentTitle,
                                                                               clickButtonModel,
                                                                               cell,
                                                                               @(NO),
                                                                               @(NO),
                                                                               ]
                                                                   tableview:self];
            }
//            [self.viewModel dealWithSellerAndBuyerCellButtonActionEventWithModel:model
//                                                                       indexPath:indexPath
//                                                                    currentTitle:orderButtonCurrentTitle
//                                                          orderPropertyItemModel:clickButtonModel
//                                                                            cell:cell
//                                                                        isSeller:NO
//                                                                   isOrderDetail:NO
//                                                                orderDeleteBlock:nil
//                                                               orderRequestBlock:nil];
            
        };
    }
    
    if ([YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:section]) {
        BLOCK_EXEC(self.prestrainBlock,);
    }
    
//    if (section == self.dataArray.count-PrestrainLessCount&&section>=PrestrainLessCount&&!self.viewModel.isNoMoreData) {
//        [self loadMoreDataIsReload:NO];
//    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    YBLOrderItemModel *model = self.dataArray[section];
    if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
        [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:model tableview:self];
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"none_order";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有相关订单 \n \n";
    
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


- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}


@end
