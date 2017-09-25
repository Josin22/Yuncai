//
//  YBLProfileViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLProfileViewModel.h"
#import "YBLStoreViewController.h"
#import "YBLOrderViewController.h"
//#import "YBLFoundMyPurchaseViewController.h"
#import "YBLAddGoodViewController.h"
#import "YBLGoodsManageVC.h"
#import "YBLIndustryScaleViewController.h"
#import "YBLTheResultViewController.h"
#import "YBLOrderViewController.h"
#import "YBLFollowGoodsStoreListViewController.h"
#import "YBLRegionalAgentViewController.h"
#import "YBLDBManage.h"
#import "YBLMineMillionMessageViewController.h"

@implementation YBLProfileItemModel

+ (YBLProfileItemModel *)getItemModelWithText:(NSString *)text
                                        image:(id)image
                                        value:(NSNumber *)value
                                      self_vc:(NSString *)self_vc{
    
    YBLProfileItemModel *model = [YBLProfileItemModel new];
    model.profile_item_text = text;
    model.profile_item_image_or_value = image;
    model.profile_item_value = value;
    model.profile_item_self_vc = self_vc;
    return model;
}

@end

@interface YBLProfileViewModel ()

@property (nonatomic, strong) NSMutableArray *profile_section0_data_array;
@property (nonatomic, strong) NSMutableArray *profile_section1_data_array;
@property (nonatomic, strong) NSMutableArray *profile_section2_data_array;

@property (nonatomic, strong) NSMutableArray *section3_seller_data_array;
@property (nonatomic, strong) NSMutableArray *section3_buyer_data_array;

@end

@implementation YBLProfileViewModel

- (NSMutableArray *)profile_cell_data_array{
    if (!_profile_cell_data_array) {
        _profile_cell_data_array = [NSMutableArray array];
    }
    if (_profile_cell_data_array.count>0) {
        [_profile_cell_data_array removeAllObjects];
    }
    [_profile_cell_data_array addObject:self.profile_section0_data_array];
    [_profile_cell_data_array addObject:self.profile_section1_data_array];
    [_profile_cell_data_array addObject:self.profile_section2_data_array];
    
    return _profile_cell_data_array;
}

/**
 *  我的订单
 *
 */
- (NSMutableArray *)profile_section0_data_array{
    if (!_profile_section0_data_array) {
        _profile_section0_data_array = [NSMutableArray array];
        [_profile_section0_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"我的订单"
                                                                                    image:@"profile_order"
                                                                                    value:@(0)
                                                                                  self_vc:@"YBLOrderViewController"]];
        
        YBLProfileItemModel *dfModel = [YBLProfileItemModel getItemModelWithText:@"待付款"
                                                                           image:@"profile_money"
                                                                           value:@(1)
                                                                         self_vc:@"YBLOrderViewController"];
        [_profile_section0_data_array addObject:dfModel];
        
        YBLProfileItemModel *dsModel = [YBLProfileItemModel getItemModelWithText:@"待收货"
                                                                          image:@"profile_shouhuo"
                                                                          value:@(2)
                                                                        self_vc:@"YBLOrderViewController"];
        
        [_profile_section0_data_array addObject:dsModel];
        
        YBLProfileItemModel *pModel = [YBLProfileItemModel getItemModelWithText:@"待评价"
                                                                          image:@"profile_pingjia"
                                                                          value:@(3)
                                                                        self_vc:@"YBLOrderCommentsViewController"];
        [_profile_section0_data_array addObject:pModel];
    }

    [self handleNumberWithArray:_profile_section0_data_array index_section:0];
    
    return _profile_section0_data_array;
}

- (void)handleNumberWithArray:(NSMutableArray *)array index_section:(NSInteger)index_section
{
    NSInteger index = 0;
    NSArray *valueCountArray;
    NSInteger recordsCountOrNot = 0;
    YBLUserInfoModel *infoModel = [YBLUserManageCenter shareInstance].userInfoModel;
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
        switch (index_section) {
            case 0:
            {
                //待支付 待收货 待评价
                recordsCountOrNot = 0;
                valueCountArray = @[@(infoModel.not_payment_count.integerValue),@(infoModel.not_shipment_count.integerValue),@(infoModel.not_commented_count.integerValue)];
            }
                break;
            case 1:
            {
                //商品关注 店铺关注 浏览记录
                recordsCountOrNot = [YBLDBManage shareDB].getRecordsCount;
                valueCountArray = @[@(infoModel.product_follows_count.integerValue),@(infoModel.shop_follows_count.integerValue),@(recordsCountOrNot)];
            }
                break;
                
            default:
                break;
        }
    } else {
        valueCountArray = @[@(0),@(0),@(0)];
    }
    for (YBLProfileItemModel *pModel in array) {
        if (index!=0) {
            NSNumber *value = valueCountArray[index-1];
            switch (index_section) {
                case 0:
                {
                    //待支付 待收货 待评价
                    pModel.profile_orderBadgeValue = value;
                }
                    break;
                case 1:
                {
                    //商品关注 店铺关注 浏览记录
                    pModel.profile_item_image_or_value = value;
                }
                    break;
                    
                default:
                    break;
            }
        }
        index++;
    }
    
}

/**
 *  钱包
 *
 */
- (NSMutableArray *)profile_section1_data_array{
    if (!_profile_section1_data_array) {
        _profile_section1_data_array = [NSMutableArray array];
        [_profile_section1_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"我的钱包"
                                                                                    image:@"profile_money2"
                                                                                    value:nil
                                                                                  self_vc:@"YBLMyWalletsViewController"]];
        [_profile_section1_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"商品关注"
                                                                                    image:@(0)
                                                                                    value:@(0)
                                                                                  self_vc:@"YBLFollowGoodsStoreListViewController"]];
        [_profile_section1_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"店铺关注"
                                                                                    image:@(0)
                                                                                    value:@(1)
                                                                                  self_vc:@"YBLFollowGoodsStoreListViewController"]];
        [_profile_section1_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"浏览记录"
                                                                                    image:@(0)
                                                                                    value:nil
                                                                                  self_vc:@"YBLFooterPrintsViewController"]];
    }

    [self handleNumberWithArray:_profile_section1_data_array index_section:1];

    return _profile_section1_data_array;
}

/**
 *  功能区
 *
 */
- (NSMutableArray *)profile_section2_data_array{
    if (!_profile_section2_data_array) {
        _profile_section2_data_array = [NSMutableArray array];
    }
    if ([YBLUserManageCenter shareInstance].isLoginStatus&&[YBLUserManageCenter shareInstance].userType == UserTypeSeller&&[YBLUserManageCenter shareInstance].aasmState == AasmStateApproved) {
        //dab
        _profile_section2_data_array = self.section3_seller_data_array;
    } else {
        //xiaob
        _profile_section2_data_array = self.section3_buyer_data_array;
    }
    
    return _profile_section2_data_array;
}

- (NSMutableArray *)section3_seller_data_array{
    
    if (!_section3_seller_data_array) {
        _section3_seller_data_array = [NSMutableArray array];
        /**
         *  大b
         */
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"我要采购"
                                                                                    image:@"iwantcaigou"
                                                                                    value:nil
                                                                                  self_vc:@"YBLFoundPurchaseViewController"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"商品管理"
                                                                                    image:@"good_manage"
                                                                                    value:nil
                                                                                  self_vc:@"YBLGoodsManageVC"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"订单管理"
                                                                                    image:@"order_manage"
                                                                                    value:@(-1)
                                                                                  self_vc:@"YBLOrderViewController"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"商铺管理"
                                                                                    image:@"store_manage"
                                                                                    value:nil
                                                                                  self_vc:@"YBLStoreViewController"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"营销管理"
                                                                                    image:@"marketing_manage"
                                                                                    value:nil
                                                                                  self_vc:@"YBLMarketingManageVC"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"客户管理"
                                                                                    image:@"custom_manage"
                                                                                    value:nil
                                                                                  self_vc:@"YBLMineMillionMessageViewModel"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"员工管理"
                                                                                    image:@"yuangong_manage"
                                                                                    value:nil
                                                                                  self_vc:@"YBLStaffManageVC"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"分销管理"
                                                                                    image:@"fenxiao_manage"
                                                                                    value:nil
                                                                                  self_vc:@"YBLDistributionManageVC"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"区域代理"
                                                                                    image:@"profile_daili"
                                                                                    value:nil
                                                                                  self_vc:@"YBLRegionalAgentViewController"]];
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"信用通"
                                                                                    image:@"vip_profile"
                                                                                    value:nil
                                                                                  self_vc:@"YBLOpenCreditsViewController"]];
/*
        [_section3_seller_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"帮助"
                                                                                   image:@"my_help"
                                                                                   value:nil
                                                                                 self_vc:@"my_help"]];
*/
    }
    YBLProfileItemModel *orderManageModel = _section3_seller_data_array[2];
    YBLUserInfoModel *infoModel = [YBLUserManageCenter shareInstance].userInfoModel;
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
        orderManageModel.profile_orderBadgeValue = infoModel.not_approved_count;
    } else {
        orderManageModel.profile_orderBadgeValue = @(0);
    }
    return _section3_seller_data_array;
}

- (NSMutableArray *)section3_buyer_data_array{
    
    if (!_section3_buyer_data_array) {
        _section3_buyer_data_array = [NSMutableArray array];
    }
    if (_section3_buyer_data_array.count>0) {
        [_section3_buyer_data_array removeAllObjects];
    }
    /**
     *  小b
     */
    [_section3_buyer_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"我要赚钱"
                                                                              image:@"iwantmoney"
                                                                              value:nil
                                                                            self_vc:@"YBLIWantMoneyViewController"]];
    [_section3_buyer_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"区域代理"
                                                                              image:@"profile_daili"
                                                                              value:nil
                                                                            self_vc:@"YBLRegionalAgentViewController"]];
    
    if ([YBLUserManageCenter shareInstance].aasmState == AasmStateApproved) {
        
        [_section3_buyer_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"VIP"
                                                                                  image:@"vip_profile"
                                                                                  value:nil
                                                                                self_vc:@"YBLOpenCreditsViewController"]];
    } else {
        
        [_section3_buyer_data_array addObject:[YBLProfileItemModel getItemModelWithText:@"帮助"
                                                                                  image:@"my_help"
                                                                                  value:nil
                                                                                self_vc:@"my_help"]];
        
        if ((([YBLUserManageCenter shareInstance].aasmState == AasmStateRejected||[YBLUserManageCenter shareInstance].aasmState == AasmStateWaiteApproved)&&[YBLUserManageCenter shareInstance].userType == UserTypeSeller)||[YBLUserManageCenter shareInstance].userType == UserTypeGuest) {
            [_section3_buyer_data_array insertObject:[YBLProfileItemModel getItemModelWithText:@"我要开店"
                                                                                         image:@"store_renzheng"
                                                                                         value:nil
                                                                                       self_vc:@"YBLIndustryScaleViewController"]
                                             atIndex:0];
            
        }
        if ((([YBLUserManageCenter shareInstance].aasmState == AasmStateRejected||[YBLUserManageCenter shareInstance].aasmState == AasmStateWaiteApproved)&&[YBLUserManageCenter shareInstance].userType != UserTypeSeller)||[YBLUserManageCenter shareInstance].userType == UserTypeGuest) {
            [_section3_buyer_data_array insertObject:[YBLProfileItemModel getItemModelWithText:@"采购认证"
                                                                                         image:@"shimingrenzheng"
                                                                                         value:nil
                                                                                       self_vc:@"YBLCertificationVC"]
                                             atIndex:0];
        }
    }
    
    return _section3_buyer_data_array;
}

- (void)pushVCWithItemModel:(YBLProfileItemModel *)itemModel WithNavigationVC:(UIViewController *)profileVC{

    NSString *classname = itemModel.profile_item_self_vc;
    
    Class class = NSClassFromString(classname);
    
    if ([classname isEqualToString:@"my_help"]){
        
        [YBLMethodTools pushWebVcFrom:profileVC URL:H5_URL_UseHelp_image title:@"注册认证流程"];
        
        return;
        
    } else if ([classname isEqualToString:@"YBLRegionalAgentViewController"]){
        
        YBLRegionalAgentViewController *agenVC = [YBLRegionalAgentViewController new];
        [profileVC.navigationController pushViewController:agenVC animated:YES];
        
        return;
    }
    
    if (![YBLMethodTools checkLoginWithVc:profileVC]) {
        return ;
    }

//    if ([classname isEqualToString:@"YBLDistributionManageVC"]||
//        !classname){
//        [SVProgressHUD showInfoWithStatus:@"此功能即将上线 \n 敬请期待!"];
//        return;
//    }
    
    id classVC;
    
    if ([classname isEqualToString:@"YBLFoundPurchaseViewController"]) {
     
        YBLCategoryViewModel *wantPurchaseVC_viewModel = [YBLCategoryViewModel new];
        wantPurchaseVC_viewModel.goodCategoryType = GoodCategoryTypeForPurchaseWithOutTabbar;
        YBLAddGoodViewController *wantPurchaseVC = [[YBLAddGoodViewController alloc] init];
        wantPurchaseVC.viewModel = wantPurchaseVC_viewModel;
        classVC = wantPurchaseVC;
        
    }else if ([classname isEqualToString:@"YBLStoreViewController"]){
        
        YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
        viewModel.shopid = [YBLUserManageCenter shareInstance].userModel.userinfo_id;
        viewModel.storeType = StoreTypePersonal;
        YBLStoreViewController *storeVC = [[YBLStoreViewController alloc] init];
        storeVC.viewModel = viewModel;
        classVC = storeVC;
        
    }

    else if ([classname isEqualToString:@"YBLFollowGoodsStoreListViewController"]){
        
        YBLFollowGoodsStoreViewModel *viewModel = [YBLFollowGoodsStoreViewModel new];
        viewModel.currentFoundIndex  = itemModel.profile_item_value.integerValue;
        YBLFollowGoodsStoreListViewController *myVC = [YBLFollowGoodsStoreListViewController new];
        myVC.viewModel = viewModel;
        classVC = myVC;
    }
    
    else if ([classname isEqualToString:@"YBLGoodsManageVC"]){
      
        YBLGoodsManageViewModel *viewModel = [YBLGoodsManageViewModel new];
        YBLGoodsManageVC *goodManageVC = [YBLGoodsManageVC new];
        goodManageVC.viewModel = viewModel;
        
        classVC = goodManageVC;
        
    } else if ([classname isEqualToString:@"YBLIndustryScaleViewController"]||[classname isEqualToString:@"YBLCertificationVC"]){
      
        if ([YBLUserManageCenter shareInstance].aasmState == AasmStateUnknown||[YBLUserManageCenter shareInstance].aasmState == AasmStateInitial) {
            
            YBLIndustryScaleViewController *indusVC = [YBLIndustryScaleViewController new];
            if ([classname isEqualToString:@"YBLIndustryScaleViewController"]) {
                indusVC.currentType = user_type_seller_key;
            } else {
                indusVC.currentType = user_type_buyer_key;
            }
            classVC = indusVC;
            
        } else {
            
            YBLTheResultViewController *resultVC = [YBLTheResultViewController new];
            classVC = resultVC;
        }
        
    } else if ([classname isEqualToString:@"YBLOrderViewController"]){
      
        YBLOrderViewModel *viewModel = [YBLOrderViewModel new];
        OrderSource source;
        if (itemModel.profile_item_value.intValue == -1) {
            //dabi
            source = OrderSourceSeller;
            viewModel.currentFoundIndex = 0;
        } else {
            //xiaob
            source = OrderSourceBuyer;
            viewModel.currentFoundIndex = itemModel.profile_item_value.intValue;
        }
        viewModel.orderSource = source;
        YBLOrderViewController *orderVC = [YBLOrderViewController new];
        orderVC.viewModel = viewModel;
        classVC = orderVC;
        
    } else if ([classname isEqualToString:@"YBLMineMillionMessageViewModel"]) {
      
        YBLMineMillionMessageViewModel *viewModel = [YBLMineMillionMessageViewModel new];
        viewModel.millionType = MillionTypeMine;
        YBLMineMillionMessageViewController *millionVc = [YBLMineMillionMessageViewController new];
        millionVc.viewModel = viewModel;
        classVC = millionVc;
        
    } else {
        
        classVC = [[class alloc] init];
    }
    [profileVC.navigationController pushViewController:classVC animated:YES];
}

@end
