//
//  YBLGoodsDetailViewController.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsDetailViewController.h"
#import "YBLGoodsDetailUIService.h"
#import "YBLShareView.h"
#import "YBLPopView.h"
#import "YBLSystemSocialShareView.h"
#import "YBLYunLongImageView.h"
#import "YBLSaveManyImageTools.h"
#import "YBLGoodSearchView.h"
#import "YBLWMarketViewModel.h"
#import "YBLWMarketGoodModel.h"
#import "YBLMarketGoodSettingViewController.h"
#import "YBLNavigationViewController.h"


@interface YBLGoodsDetailViewController ()

@property (nonatomic, assign) GoodsDetailType type;

@property (nonatomic, strong) YBLGoodsDetailUIService *service;

@end

@implementation YBLGoodsDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setMyTranslucent:NO];
    
    [self.service requestCartNumber];
    
    [self.service requestAddressData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = @[self.moreBarButtonItem,self.shareBarButtonItem];
    
    self.service = [[YBLGoodsDetailUIService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (instancetype)initWithType:(GoodsDetailType)type{
    
    if (self = [super init]) {
        _type = type;
        if (_type == GoodsDetailTypeSeckilling) {
            [self.viewModel.cellIDArray[0] removeObjectAtIndex:1];
            [self.viewModel.cellIDArray[0] insertObject:@{cell_identity_key:@"YBLSeckillGoodsPriceCell"} atIndex:0];
        } else if(_type == GoodsDetailTypeSeckillNotTime){
            
        }
    }
    return self;
}

- (void)goback1{
    
    [self.service gobackVC];
}

- (YBLGoodsDetailViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [YBLGoodsDetailViewModel new];
    }
    return _viewModel;
}


#pragma mark - bar item click

- (void)shareClick:(UIBarButtonItem *)btn{
    
    if (!self.viewModel.goodDetailModel) {
        return;
    }
    NSString *title = self.viewModel.goodDetailModel.title;
    NSString *imageUrl = self.viewModel.goodDetailModel.mains[0];
    NSString *shareUrl = self.viewModel.goodDetailModel.share_url;
//    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
//        NSString *userid = [YBLUserManageCenter shareInstance].userModel.userinfo_id;
//        shareUrl = [NSString stringWithFormat:@"%@&userid=%@",self.viewModel.goodDetailModel.share_url,userid];
//    }
    [YBLShareView shareViewWithPublishContentText:@"我的店铺有一个不错的商品,赶快来采购吧"
                                           title:title
                                       imagePath:imageUrl
                                             url:shareUrl
                                          Result:^(ShareType type, BOOL isSuccess) {
                                              if (type == ShareTypeYUNLONG) {
                                                  YBLSystemSocialModel *model = [YBLSystemSocialModel new];
                                              model.imageType = SaveImageTypeNormalGoods;
                                              model.imagesArray = [self.viewModel.goodDetailModel.mains mutableCopy];
                                              model.share_url = self.viewModel.goodDetailModel.share_url;
                                              model.text = self.viewModel.goodDetailModel.title;
                                              model.quantity = self.viewModel.goodDetailModel.sale_count;
                                              model.price  = self.viewModel.goodDetailModel.price;
                                              model.shopName = self.viewModel.goodDetailModel.shop.shopname;
                                              model.unit = self.viewModel.goodDetailModel.unit;
                                              [YBLYunLongImageView showYunLongImageViewWithModel:model];
                                              }
                                              
                                          }
                         ShareADGoodsClickHandle:^(){
                             YBLGoodsDetailViewController *goodsDetailVC = [[YBLGoodsDetailViewController alloc] init];
                             [self.navigationController pushViewController:goodsDetailVC animated:YES];
                         }];
    
}

- (void)moreClick:(UIBarButtonItem *)btn{
    
    NSString *new_title1 = MoreButton_ReportSellTitle;
    NSString *small_id = self.viewModel.goodDetailModel.small_marketing_id;
    if (small_id) {
        new_title1 = MoreButton_WMarketTitle;
    }
    NSMutableArray *titlesArray = @[MoreButton_DownloadImageTitle,new_title1,MoreButton_SearchTitle,MoreButton_HomeTitle].mutableCopy;
    NSMutableArray *imagesArray = @[@"xn_more_qrcode",@"xn_more_report",@"xn_more_search",@"xn_more_home"].mutableCopy;
    NSNumber *isCanLookStatus = [[NSUserDefaults standardUserDefaults] objectForKey:NO_CAN_LOOK_GOOD_STATUES];
    if (isCanLookStatus.boolValue) {
        [titlesArray addObject:MoreButton_GoodStateTitle];
        [imagesArray addObject:@"xn_more_good_state"];
    }
    YBLPopView *morePopView = [[YBLPopView alloc] initWithPoint:CGPointMake(YBLWindowWidth-30, kNavigationbarHeight)
                                                         titles:titlesArray
                                                         images:imagesArray];
    WEAK
    morePopView.selectRowAtIndexBlock = ^(NSInteger index){
        STRONG
        switch (index) {
            case 0:
            {
                if (!self.viewModel.goodDetailModel) {
                    return;
                }
                //二维码
                [self.service saveQRCodeIamge];
            }
                break;
            case 1:
            {
                if (!self.viewModel.goodDetailModel) {
                    return ;
                }
                if (small_id) {
                    [[YBLWMarketViewModel siganlForWmarketGoodID:small_id] subscribeNext:^(YBLWMarketGoodModel *  _Nullable x) {
                        STRONG
                        YBLMarketGoodSettingViewModel *viewModel = [YBLMarketGoodSettingViewModel new];
                        viewModel.marketGoodVcType = MarketGoodVCTypeChoose;
                        viewModel.marketGoodModel = x;
                        viewModel.changeBlock = ^(YBLWMarketGoodModel *changeModel) {
                            STRONG
                            [self pushSystemShareWithImageArray:changeModel.selectImageArray];
                        };
                        YBLMarketGoodSettingViewController *markVC = [YBLMarketGoodSettingViewController new];
                        markVC.viewModel = viewModel;
                        YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:markVC];
                        [self presentViewController:nav animated:YES completion:nil];
                        
                    } error:^(NSError * _Nullable error) {
                        
                    }];
                } else {
                    //转发售卖
                    [self pushSystemShareWithImageArray:[self.viewModel.goodDetailModel.mains mutableCopy]];
                }
            }
                break;
            case 2:
            {
                //搜索
                [YBLGoodSearchView showGoodSearchViewWithVC:self
                                          RightItemViewType:rightItemViewTypeCatgeoryNews
                                               SearchHandle:nil
                                               cancleHandle:nil
                                         animationEndHandle:nil
                                                currentText:nil];
                

            }
                break;
            case 3:
            {
                //首页
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
                break;
            case 4:
            {
                //检测
                NSString *descprition = [self.viewModel.goodDetailModel.no_permit_check_result yy_modelDescription];
                //初始化警告框
                UIAlertController*alert = [UIAlertController
                                           alertControllerWithTitle: @"商品状态"
                                           message:descprition
                                           preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction
                                  actionWithTitle:@"确定"
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                {
                }]];
                //弹出提示框
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    };
    [morePopView show];
}

- (void)pushSystemShareWithImageArray:(NSMutableArray *)images{
    YBLSystemSocialModel *model = [YBLSystemSocialModel new];
    model.text = MoreButton_ReportSellTitle;
    model.share_url = self.viewModel.goodDetailModel.share_url;
    model.spec = self.viewModel.goodDetailModel.specification;
    model.price = self.viewModel.goodDetailModel.price;
    model.imagesArray = images;
    model.imageType = SaveImageTypeNormalGoods;
    [YBLSaveManyImageTools pushSystemShareWithModel:model
                                                 VC:self
                                       Completetion:nil];
}

@end
