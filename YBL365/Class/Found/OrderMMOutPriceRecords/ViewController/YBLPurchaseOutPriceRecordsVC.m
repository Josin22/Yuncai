//
//  YBLPurchaseOutPriceRecordsVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseOutPriceRecordsVC.h"
#import "YBLPurchaseOutPriceRecordsService.h"
#import "YBLShareView.h"

@interface YBLPurchaseOutPriceRecordsVC ()

@property (nonatomic, strong) YBLPurchaseOutPriceRecordsService *service;

@end

@implementation YBLPurchaseOutPriceRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"出价列表";
    
    self.service = [[YBLPurchaseOutPriceRecordsService alloc] initWithVC:self ViewModel:self.viewModel];
    
    self.navigationItem.rightBarButtonItem = self.shareBarButtonItem;
}

- (void)shareClick:(UIBarButtonItem *)btn{
    if (!self.viewModel.purchaseDetailModel) {
        return;
    }
    if (self.viewModel.biddingRecordsModel.bidding.count==0) {
        return;
    }
    YBLPurchaseOrderModel *bidModel = self.viewModel.biddingRecordsModel.bidding[0];
    NSString *purchase_name = [NSString stringWithFormat:@"【采购】%@、有货的供应商来接单吧~~~",self.viewModel.purchaseDetailModel.title];
    NSInteger all_count = self.viewModel.purchaseDetailModel.quantity.integerValue;
    float all_price = self.viewModel.purchaseDetailModel.price.doubleValue*all_count;
    NSString *purchase_spec = [NSString stringWithFormat:@"%@ \n采购总金额:%.2f",self.viewModel.purchaseDetailModel.specification,all_price];
    [YBLShareView shareViewWithPublishContentText:purchase_spec
                                            title:purchase_name
                                        imagePath:self.viewModel.purchaseDetailModel.avatar
                                              url:bidModel.share_url
                                           Result:^(ShareType type, BOOL isSuccess) {
                                           }
                          ShareADGoodsClickHandle:^(){
                              
                          }];
}

@end
