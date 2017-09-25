//
//  YBLGoodPicViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodPicViewController.h"
#import "YBLPicTableView.h"
#import "YBLAddGoodListViewModel.h"
#import "YBLGoodModel.h"
#import "YBLEditPurchaseViewController.h"

@interface YBLGoodPicViewController ()

@property (nonatomic, strong) YBLPicTableView *goodDetailView;

@end

@implementation YBLGoodPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"图文详情";
    
    [self.view addSubview:self.goodDetailView];
}

- (void)setPModel:(YBLGoodModel *)pModel{
    _pModel = pModel;
    self.goodDetailView.imageURLsArray = _pModel.descs.mutableCopy;
    self.goodDetailView.goodBannerView.imageURLArray = _pModel.mains.mutableCopy;
}

- (void)setGoodCategoryType:(GoodCategoryType)goodCategoryType{
    _goodCategoryType = goodCategoryType;
    self.goodDetailView.itemButton.backgroundColor = YBLColor(247, 247, 247, 1);
    if (_goodCategoryType == GoodCategoryTypeForHomeCategory||_goodCategoryType == GoodCategoryTypeForCommodityPoolCategory) {
        self.goodDetailView.itemButton.titleArray = @[@"添加到店铺"];
    } else {
        self.goodDetailView.itemButton.titleArray = @[@"编辑发布"];
    }
}


- (YBLPicTableView *)goodDetailView{
    if (!_goodDetailView) {
        _goodDetailView = [[YBLPicTableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight)
                                                           style:UITableViewStyleGrouped
                                                picTableViewType:PicTableViewTypeHasCustomHeader];
        WEAK
        _goodDetailView.itemButton.goodsManageItemButtonClickBlock = ^(NSInteger index) {
            STRONG
            if (self.goodCategoryType == GoodCategoryTypeForHomeCategory||self.goodCategoryType == GoodCategoryTypeForCommodityPoolCategory) {
                //添加店铺
                [[YBLAddGoodListViewModel singalForSaveToStoreWithId:self.pModel.id] subscribeNext:^(NSNumber *  _Nullable x) {
                } error:^(NSError * _Nullable error) {
                }];
            } else {
                //编辑采购
                YBLEdictPurchaseViewModel *viewModel = [YBLEdictPurchaseViewModel new];
                viewModel.goodModel = self.pModel;
                YBLEditPurchaseViewController *editPurchaseVC = [YBLEditPurchaseViewController new];
                editPurchaseVC.viewModel = viewModel;
                [self.navigationController pushViewController:editPurchaseVC animated:YES];
            }
        };
    }
    return _goodDetailView;
}

@end
