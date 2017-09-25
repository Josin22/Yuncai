//
//  YBLPurchaseGoodsDetailVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLPurchaseGoodsDetailService.h"
#import "YBLFoundViewModel.h"
#import "YBLShareView.h"
#import "YBLPopView.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLSystemSocialShareView.h"
#import "YBLSaveManyImageTools.h"
#import "YBLYunLongImageView.h"

@interface YBLPurchaseGoodsDetailVC ()

@property (nonatomic, strong) YBLPurchaseGoodsDetailService *service;

@end

@implementation YBLPurchaseGoodsDetailVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.service.orderMMGoodsDetailTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    //
    [self.service requestSingleRecords];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"采购详情";
    
    self.navigationItem.rightBarButtonItems = @[self.moreBarButtonItem,self.shareBarButtonItem];
    
    self.service = [[YBLPurchaseGoodsDetailService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)goback1{
    
    if ((![YBLMethodTools popToFoundVCFrom:self])) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if((self.viewModel.purchaseDetailPushType == PurchaseDetailPushTypeSepacial)){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - item click

- (void)shareClick:(UIBarButtonItem *)btn{
    if (!self.viewModel.purchaseDetailModel) {
        return;
    }
    NSString *purchase_name = [NSString stringWithFormat:@"【采购】%@、有货的供应商来接单吧~~~",self.viewModel.purchaseDetailModel.title];
    NSInteger all_count = self.viewModel.purchaseDetailModel.quantity.integerValue;
    float all_price = self.viewModel.purchaseDetailModel.price.doubleValue*all_count;
    NSString *purchase_spec = [NSString stringWithFormat:@"%@ \n采购总金额:%.2f",self.viewModel.purchaseDetailModel.specification,all_price];
    [YBLShareView shareViewWithPublishContentText:purchase_spec
                                           title:purchase_name
                                        imagePath:self.viewModel.purchaseDetailModel.avatar
                                             url:self.viewModel.purchaseDetailModel.share_url
                                          Result:^(ShareType type, BOOL isSuccess) {
                                              //长图
                                              if (type == ShareTypeYUNLONG) {
                                                  YBLSystemSocialModel *model = [YBLSystemSocialModel new];
                                              model.imageType = SaveImageTypePurchaseGoods;
                                              model.imagesArray = [self.viewModel.purchaseDetailModel.mains mutableCopy];
                                              model.share_url = self.viewModel.purchaseDetailModel.share_url;
                                              model.text = self.viewModel.purchaseDetailModel.title;
                                              model.quantity = self.viewModel.purchaseDetailModel.quantity;
                                              model.price  = self.viewModel.purchaseDetailModel.price;
                                              model.address = [self.viewModel.purchaseDetailModel.address_info.province_name stringByAppendingString:self.viewModel.purchaseDetailModel.address_info.city_name];
                                              model.unit = self.viewModel.purchaseDetailModel.unit;
                                              [YBLYunLongImageView showYunLongImageViewWithModel:model];
                                              }
                                              
                                          }
                         ShareADGoodsClickHandle:^(){
                             
                         }];
}

- (void)moreClick:(UIBarButtonItem *)btn{
    
    YBLPopView *morePopView = [[YBLPopView alloc] initWithPoint:CGPointMake(YBLWindowWidth-30, kNavigationbarHeight)
                                                         titles:@[MoreButton_DownloadImageTitle,MoreButton_ReportPurchaseTitle,MoreButton_HomeTitle]
                                                         images:@[@"xn_more_qrcode",@"xn_more_report",@"xn_more_home"]];
    WEAK
    
    morePopView.selectRowAtIndexBlock = ^(NSInteger index){
        STRONG
        
        switch (index) {
            case 0:
            {//二维码
                if (!self.viewModel.purchaseDetailModel) {
                    return ;
                }
                [self.service saveQRCodeIamge];
            }
                break;
            case 1:
            {//转发采购
                if (!self.viewModel.purchaseDetailModel) {
                    return ;
                }
                YBLSystemSocialModel *model = [YBLSystemSocialModel  new];
                model.text = MoreButton_ReportSellTitle;
                model.share_url = self.viewModel.purchaseDetailModel.share_url;
                model.imagesArray = [self.viewModel.purchaseDetailModel.mains mutableCopy];
                model.spec = self.viewModel.purchaseDetailModel.specification;
                model.quantity = self.viewModel.purchaseDetailModel.quantity;
                model.price = self.viewModel.purchaseDetailModel.price;
                model.imageType = SaveImageTypePurchaseGoods;
                model.local = [self.viewModel.purchaseDetailModel.address_info.province stringByAppendingString:self.viewModel.purchaseDetailModel.address_info.city_name];
            
                [YBLSaveManyImageTools pushSystemShareWithModel:model
                                                             VC:self
                                                   Completetion:^(BOOL isSuccess) {
                                                       
                                                   }];
            }
                break;
            case 2:
            {//首页
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
    };
    [morePopView show];
}



@end
