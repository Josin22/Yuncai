//
//  YBLOrderMoreMoreService.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMoreMoreService.h"
#import "YBLOrderMoreMoreHomeVC.h"
#import "YBLOrderMMCell.h"
#import "YBLOrderMMHeaderView.h"
#import "YBLOrderMMFilterContentView.h"
#import "YBLOrderMMTradeHeaderView.h"
#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLorderMMCollectionView.h"

@interface YBLOrderMoreMoreService ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) YBLOrderMoreMoreHomeVC *VC;

@property (nonatomic, strong) YBLOrderMoreMoreViewModel *viewModel;

@property (nonatomic, strong) YBLorderMMCollectionView *orderMMCollectionView;

@property (nonatomic, strong) YBLOrderMMHeaderView *headerView;

@end

@implementation YBLOrderMoreMoreService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{

    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLOrderMoreMoreHomeVC *)VC;
        _viewModel = (YBLOrderMoreMoreViewModel *)viewModel;
        
        [_VC.view addSubview:self.headerView];
        [_VC.view addSubview:self.orderMMCollectionView];

    }
    return self;
}

- (YBLOrderMMHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [[YBLOrderMMHeaderView alloc] initWithFrame:CGRectMake(0, 64, YBLWindowWidth, 40) ValueArray:@[@"综合",@"排序"]];
        WEAK
        _headerView.headerClickBlock = ^(NSInteger index){
            STRONG
            if (index == 0) {
                ///综合
                [YBLOrderMMFilterContentView showOrderMMFilterContentViewInVC:self.VC
                                                                   valueArray:@[
                                                                                @"白酒",
                                                                                @"啤酒牛奶",
                                                                                @"葡萄酒",
                                                                                @"葡萄牛奶酒",
                                                                                @"牛啤酒奶",
                                                                                @"啤酒",
                                                                                @"牛奶",
                                                                                @"啤啤酒酒",
                                                                                @"葡萄酒",
                                                                                @"牛奶"
                                                                                ]
                                                                  ContentType:ContentTypeComprehensive
                                                                  compeletion:^{
                                                                      
                                                                  }];
                
            } else {
                ///排序
                [YBLOrderMMFilterContentView showOrderMMFilterContentViewInVC:self.VC
                                                                   valueArray:@[
                                                                                @"默认顺序",
                                                                                @"价格由低到高",
                                                                                @"价格由高到低",
                                                                                @"出价由高到低",
                                                                                @"出价由低到高"
                                                                                ]
                                                                  ContentType:ContentTypeSequence
                                                                  compeletion:^{
                                                                      
                                                                  }];

            }
        };
    }
    return _headerView;
}

- (YBLorderMMCollectionView *)orderMMCollectionView{
    
    if (!_orderMMCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _orderMMCollectionView = [[YBLorderMMCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), YBLWindowWidth, YBLWindowHeight-CGRectGetMaxY(self.headerView.frame))
                                                            collectionViewLayout:layout
                                                                          MMType:MMTypeHeaderMM];
        WEAK
        _orderMMCollectionView.orderMMCollectionViewRowSelectblock = ^(YBLPurchaseOrderModel *model){
            STRONG
            YBLPurchaseGoodsDetailVC *detailVC = [[YBLPurchaseGoodsDetailVC alloc] init];
            [self.VC.navigationController pushViewController:detailVC animated:YES];
        };
    }
    return _orderMMCollectionView;
}



@end
