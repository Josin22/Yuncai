//
//  YBLOrderService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderService.h"
#import "YBLOrderViewModel.h"
#import "YBLOrderViewController.h"
#import "YBLlittlebOrderItemCell.h"
#import "YBLOrderItemModel.h"
#import "YBLOrderDetailViewController.h"
#import "YBLBigBOrderItemCell.h"
#import "YBLActionSheetView.h"
#import "YBLPopWriteCodeView.h"

#import "YBLOrderTableView.h"
#import "YBLTextSegmentControl.h"

@interface OrderTitleButton : UIButton

@property (nonatomic, retain) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation OrderTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    CGFloat iconWi = 12;
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width-iconWi-5, self.height)];
    self.textLabel.textColor = BlackTextColor;
    self.textLabel.font = YBLFont(18);
    self.textLabel.text = @"我的订单";
    self.textLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.textLabel];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.textLabel.right+5, 0, iconWi, 6)];
    self.iconImageView.centerY = self.height/2;
    self.iconImageView.image = [UIImage imageNamed:@"order_sanjiao"];
    [self addSubview:self.iconImageView];
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.iconImageView.transform = CGAffineTransformRotate(self.iconImageView.transform, M_PI);
                     }
                     completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                     }];
}

@end

@interface YBLOrderService ()<YBLTableViewDelegate,UIScrollViewDelegate,YBLTextSegmentControlDelegate>

@property (nonatomic, weak  ) YBLOrderViewModel *viewModel;

@property (nonatomic, weak  ) YBLOrderViewController *Vc;

@property (nonatomic, strong) OrderTitleButton *orderTitleButton;

@property (nonatomic, strong) YBLTextSegmentControl *orderSegment;

@property (nonatomic, strong) UIScrollView *contentScrollView;
//@property (nonatomic, strong) UITableView *orderTableView;

@end

@implementation YBLOrderService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        _Vc = (YBLOrderViewController *)VC;
        _viewModel = (YBLOrderViewModel *)viewModel;
        _viewModel.Vc = _Vc;

        if (self.viewModel.orderSource == OrderSourceBuyer) {
            self.Vc.navigationItem.title = @"我的订单";
        } else {
            self.Vc.navigationItem.title = @"订单管理";
        }
        
        [self.Vc.view addSubview:self.orderSegment];
        [self.Vc.view addSubview:self.contentScrollView];
        
        [self loadMoreDataIsReload:YES];
        
        WEAK
        [RACObserve(self.viewModel, isReqesuting) subscribeNext:^(NSNumber *  _Nullable x) {
            STRONG
            self.orderSegment.enableSegment = !x.boolValue;
        }];
    }
    return self;
}

- (void)loadMoreDataIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel SingalForOrderIsReload:isReload] subscribeNext:^(NSMutableArray *x) {
        STRONG
        YBLOrderTableView *orderTableView = [self getOrderTableViewWithIndex:self.viewModel.currentFoundIndex];
        [orderTableView.mj_header endRefreshing];
        NSMutableArray *cureentData = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
        orderTableView.dataArray = cureentData;
        [orderTableView jsReloadData];
    } error:^(NSError *error) {
    }];
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:[_Vc.view bounds]];
        _contentScrollView.top = self.orderSegment.bottom;
        _contentScrollView.height = YBLWindowHeight-kNavigationbarHeight-self.orderSegment.bottom;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.backgroundColor = self.Vc.view.backgroundColor;
        NSInteger allCount = self.orderSegment.dataArray.count;
        _contentScrollView.contentSize = CGSizeMake(_contentScrollView.width*allCount, _contentScrollView.height);
        [_contentScrollView setContentOffset:CGPointMake(self.viewModel.currentFoundIndex*_contentScrollView.width, 0) animated:NO];
        [_contentScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.Vc.navigationController.interactivePopGestureRecognizer];
    }
    return _contentScrollView;
}

- (OrderTitleButton *)orderTitleButton{
    if (!_orderTitleButton) {
        _orderTitleButton = [[OrderTitleButton alloc] initWithFrame:CGRectMake(0, 0, 110, 20)];
        [[_orderTitleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            x.selected = !x.selected;
        }];
    }
    return _orderTitleButton;
}

- (YBLTextSegmentControl *)orderSegment{
    if (!_orderSegment) {
        _orderSegment = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)
                                                     TextSegmentType:TextSegmentTypeGoodsDetail];
        [_orderSegment updateTitleData:self.viewModel.titleArray[0]];
        _orderSegment.currentIndex = self.viewModel.currentFoundIndex;
        _orderSegment.delegate = self;
        [self.Vc.view addSubview:_orderSegment];
        UIView *lineView = [YBLMethodTools addLineView:CGRectMake(0, 0, _orderSegment.width, .5)];
        lineView.bottom = _orderSegment.height;
        [_orderSegment addSubview:lineView];
    }
    return _orderSegment;
}

- (YBLOrderTableView *)getOrderTableViewWithIndex:(NSInteger)index{
    YBLOrderTableView *orderTableView = [self.Vc.view viewWithTag:tag_order_table_view+index];
    if (!orderTableView) {
        orderTableView = [[YBLOrderTableView alloc] initWithFrame:[self.contentScrollView bounds]
                                                            style:UITableViewStylePlain
                                                      orderSource:self.viewModel.orderSource];
        orderTableView.ybl_delegate = self;
        orderTableView.tag = tag_order_table_view+index;
        orderTableView.left = self.contentScrollView.width*index;
        UIView *headerLittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, orderTableView.width, space)];
        headerLittleView.backgroundColor = YBLColor(247, 247, 247, 1);
        orderTableView.tableHeaderView = headerLittleView;
        [self.contentScrollView addSubview:orderTableView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:orderTableView completion:^{
            STRONG
            [self loadMoreDataIsReload:YES];
        }];
        orderTableView.prestrainBlock = ^{
            STRONG
            if ([self.viewModel isSatisfyRequestWithIndex:self.viewModel.currentFoundIndex]) {
                [self loadMoreDataIsReload:NO];
            }
        };
    }
    return orderTableView;
}

#pragma mark - delegate

- (void)textSegmentControlIndex:(NSInteger)index selectModel:(id)model{
    self.viewModel.currentFoundIndex = index;
    [self.contentScrollView setContentOffset:CGPointMake(YBLWindowWidth*index, 0) animated:YES];
    NSMutableArray *data = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
    if (data.count==0) {
        [self loadMoreDataIsReload:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/YBLWindowWidth;
    self.orderSegment.currentIndex = index;
}


- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    
    [self.viewModel dealWithSellerAndBuyerCellButtonActionEventWithModel:selectValue[0]
                                                               indexPath:selectValue[1]
                                                            currentTitle:selectValue[2]
                                                  orderPropertyItemModel:selectValue[3]
                                                                    cell:selectValue[4]
                                                                isSeller:[selectValue[5] boolValue]
                                                           isOrderDetail:[selectValue[6] boolValue]
                                                        orderDeleteBlock:nil
                                                       orderRequestBlock:nil
                                                        currentTableView:tableview];

}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
  
    [self pushDetailWithItemModel:selectValue indexps:indexPath];
}

- (void)pushDetailWithItemModel:(YBLOrderItemModel *)model indexps:(NSIndexPath *)indexps{
    
    YBLOrderDetailViewModel *detailVM = [YBLOrderDetailViewModel new];
    detailVM.itemDetailModel = model;
    detailVM.orderSource = self.viewModel.orderSource;
    WEAK
    detailVM.orderStateBlock = ^(YBLOrderItemModel *changeOrderModel) {
        STRONG
        YBLOrderTableView *orderTableView = [self getOrderTableViewWithIndex:self.viewModel.currentFoundIndex];
        [orderTableView.mj_header endRefreshing];
        NSMutableArray *cureentData = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
        [cureentData replaceObjectAtIndex:indexps.section withObject:changeOrderModel];
        orderTableView.dataArray = cureentData;
        [orderTableView reloadSections:[NSIndexSet indexSetWithIndex:indexps.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    YBLOrderDetailViewController *detailVC = [YBLOrderDetailViewController new];
    detailVC.viewModel = detailVM;
    [self.Vc.navigationController pushViewController:detailVC animated:YES];
    
}

/*
 
 - (void)uploadImageWithOrderId:(YBLOrderItemModel *)order{
 WEAK
 [YBLTakePhotoSheetPhotoView showPickerWithVC:self.Vc PikerDoneHandle:^(UIImage *image) {
 STRONG
 if (image) {
 //3.上传物流凭证
 [[self.viewModel signalForUpLoadShippingEvidence:image Ids:order.order_id] subscribeNext:^(id x) {
 STRONG
 NSMutableArray *item_select_image_array = self.viewModel.selectImageDict[order.order_id];
 if (!item_select_image_array) {
 NSMutableArray *photoArray = [NSMutableArray array];
 [self.viewModel.selectImageDict setObject:photoArray forKey:order.order_id];
 } else {
 item_select_image_array = self.viewModel.selectImageDict[order.order_id];
 }
 [item_select_image_array addObject:image];
 [self.viewModel.selectImageDict setObject:item_select_image_array forKey:order.order_id];
 
 } error:^(NSError *error) {
 
 }];
 }
 }];
 
 }
 
- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    NSInteger section = indexPath.section;
    WEAK
    YBLOrderItemModel *model = self.viewModel.allOrderDataArray[section];

    if ([cell isKindOfClass:[YBLBigBOrderItemCell class]]) {
        
        YBLBigBOrderItemCell *bigB_cell = (YBLBigBOrderItemCell *)cell;
        
        [bigB_cell updateModel:model];
     
        bigB_cell.bigBOrderItemCellDiDSelectBlock = ^{
            STRONG
            [self pushDetailWithItemModel:model];
        };
        
       
        bigB_cell.bigBOrderItemCellButtonClickBlock = ^(NSString *currentTitle,YBLOrderPropertyItemModel *clickButtonModel) {
            STRONG
            [self.viewModel dealWithSellerAndBuyerCellButtonActionEventWithModel:model
                                                                       indexPath:indexPath
                                                                    currentTitle:currentTitle
                                                          orderPropertyItemModel:clickButtonModel
                                                                            cell:cell
                                                                        isSeller:YES
                                                                   isOrderDetail:NO
                                                                orderDeleteBlock:nil
                                                               orderRequestBlock:nil];

        };

    } else {
   
        YBLLittlebOrderItemCell *littleb_cell = (YBLLittlebOrderItemCell *)cell;
        
        [littleb_cell updateOrderItemModel:model];
        
        littleb_cell.littlebOrderItemCellDiDSelectBlock = ^(YBLOrderItemModel *model,NSInteger index){
            STRONG
            [self pushDetailWithItemModel:model];
        };
        littleb_cell.littlebOrderItemCellButtonBlock = ^(NSString *orderButtonCurrentTitle,YBLOrderPropertyItemModel *clickButtonModel){
            STRONG
            [self.viewModel dealWithSellerAndBuyerCellButtonActionEventWithModel:model
                                                                       indexPath:indexPath
                                                                    currentTitle:orderButtonCurrentTitle
                                                          orderPropertyItemModel:clickButtonModel
                                                                            cell:cell
                                                                        isSeller:NO
                                                                   isOrderDetail:NO
                                                                orderDeleteBlock:nil
                                                               orderRequestBlock:nil];

        };
    } 
    if (section == self.viewModel.allOrderDataArray.count-PrestrainLessCount&&section>=PrestrainLessCount&&!self.viewModel.isNoMoreData) {
        [self loadMoreDataIsReload:NO];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    YBLOrderItemModel *model = self.viewModel.allOrderDataArray[section];
    [self pushDetailWithItemModel:model];
}
*/



@end
