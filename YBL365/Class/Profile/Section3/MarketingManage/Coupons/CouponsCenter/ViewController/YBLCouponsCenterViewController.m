//
//  YBLCouponsCenterViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsCenterViewController.h"
#import "YBLCouponsTableView.h"
#import "YBLCouponsCenterViewModel.h"
#import "YBLCouponsModel.h"
#import "YBLGoodsDetailViewController.h"

@interface YBLCouponsCenterViewController ()<YBLTableViewDelegate>

@property (nonatomic, strong) YBLCouponsTableView *couponsTableView;

@property (nonatomic, strong) YBLCouponsCenterViewModel *viewModel;

@end

@implementation YBLCouponsCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"领券中心";
    
    self.viewModel = [YBLCouponsCenterViewModel new];
    
    [self requestCounponsCenterIsReload:YES];
}

- (void)requestCounponsCenterIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel singalForCounponsCenterIsReload:isReload]subscribeError:^(NSError * _Nullable error) {
        
    } completed:^{
        STRONG
        self.couponsTableView.dataArray = self.viewModel.dataArray;
        [self.couponsTableView jsReloadData];
        [self.couponsTableView endReload];
    }];
    
}

- (YBLCouponsTableView *)couponsTableView{
    if (!_couponsTableView) {
        _couponsTableView = [[YBLCouponsTableView alloc] initWithFrame:[self.view bounds]
                                                                 style:UITableViewStylePlain
                                                          couponsStyle:CouponsStyleSnap];
        _couponsTableView.ybl_delegate = self;
        [self.view addSubview:_couponsTableView];
        
        WEAK
        _couponsTableView.prestrainBlock = ^{
            STRONG
            [self requestCounponsCenterIsReload:NO];
        };
        [_couponsTableView headerReloadBlock:^{
            STRONG
            [self requestCounponsCenterIsReload:YES];
        }];
    }
    return _couponsTableView;
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLCouponsModel *model = (YBLCouponsModel *)selectValue;
    WEAK
    [[self.viewModel siganlForTakeCouponsWithID:model.id] subscribeNext:^(id  _Nullable x) {
        STRONG
        model.couponsState = CouponsCenterStateUsed;
        [self.couponsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLCouponsModel *model = (YBLCouponsModel *)selectValue;
    NSString *url_id = model.product.id;
    YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
    viewModel.goodID = url_id;
    YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    goodDetailVC.viewModel = viewModel;
    [self.navigationController pushViewController:goodDetailVC animated:YES];
}

@end
