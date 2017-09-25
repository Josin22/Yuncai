//
//  YBLShowCouponsView.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShowCouponsView.h"
#import "YBLCouponsTableView.h"
#import "YBLCouponsManageViewModel.h"
#import "YBLCouponsModel.h"
#import "YBLCouponsCenterViewModel.h"

static CGFloat Top = 120;

static YBLShowCouponsView *_couponsView = nil;

@interface YBLShowCouponsView ()<YBLTableViewDelegate>

@property (nonatomic, copy  ) NSString *productID;

@property (nonatomic, strong) YBLCouponsTableView *couponsTableView;

@property (nonatomic, weak  ) UIViewController *vc;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) YBLCouponsManageViewModel *viewModel;

@end

@implementation YBLShowCouponsView

+ (void)showCouponsViewFromVc:(UIViewController *)Vc productID:(NSString *)productID{
    
    if (!_couponsView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _couponsView = [[YBLShowCouponsView alloc] initWithFrame:[window bounds]
                                                          fromVc:Vc
                                                       productID:productID];
    }
    [YBLMethodTools transformOpenView:_couponsView.contentView
                            SuperView:_couponsView
                              fromeVC:Vc
                                  Top:Top];
}

- (instancetype)initWithFrame:(CGRect)frame
                       fromVc:(UIViewController *)fromVc
                    productID:(NSString *)productID{

    self = [super initWithFrame:frame];
    if (self) {
        
        _vc = fromVc;
        _productID = productID;
        
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.viewModel = [[YBLCouponsManageViewModel alloc] initWithCouponsListType:CouponsListTypeGoodDetail];
    
    UIView *bg = [[UIView alloc] initWithFrame:[self bounds]];
    bg.backgroundColor = [UIColor clearColor];
    [self addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bg addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight+space, self.width, self.height-Top)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [YBLMethodTools addTopShadowToView:contentView];
    self.contentView = contentView;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    [self.contentView addSubview:titleView];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLable.text = @"领取优惠券";
    titleLable.textColor = YBLTextColor;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = YBLFont(16);
    titleLable.centerX = titleView.width/2;
    titleLable.centerY = titleView.height/2;
    [titleView addSubview:titleLable];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:[UIImage imageNamed:@"address_close"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:dismissButton];
    dismissButton.frame = CGRectMake(titleView.width - 50, 0, 50, 50);
    
    [titleView addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleView.height-0.5, titleView.width, 0.5)]];


    self.couponsTableView = [[YBLCouponsTableView alloc] initWithFrame:CGRectMake(0, titleView.bottom, self.contentView.width, self.contentView.height-titleView.bottom)
                                                                 style:UITableViewStylePlain
                                                          couponsStyle:CouponsStyleGot];
    self.couponsTableView.ybl_delegate = self;
    [self.contentView addSubview:self.couponsTableView];
    WEAK
    [self.couponsTableView headerReloadBlock:^{
        STRONG
        [self requestCouponsIsReload:YES];
    }];
    self.couponsTableView.prestrainBlock = ^{
        STRONG
        [self requestCouponsIsReload:NO];
    };
    
    [self requestCouponsIsReload:YES];
}

- (void)requestCouponsIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForCouponsWithProductID:_productID isReload:isReload] subscribeError:^(NSError * _Nullable error) {
        
    } completed:^{
        STRONG
        NSMutableArray *couponsDataArray = [self.viewModel getCurrentDataArrayWithIndex:0];
        self.couponsTableView.dataArray = couponsDataArray;
        [self.couponsTableView reloadData];
    }];
}

#pragma mark - delegate

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLCouponsModel *model = (YBLCouponsModel *)selectValue;
    WEAK
    [[YBLCouponsCenterViewModel siganlForTakeCouponsWithID:model.id] subscribeNext:^(id  _Nullable x) {
        STRONG
        model.binded = @(YES);
        [self.couponsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } error:^(NSError * _Nullable error) {
        
    }];
    
}

#pragma mark - method

- (void)dismiss{
    
    [YBLMethodTools transformCloseView:self.contentView
                             SuperView:_couponsView
                               fromeVC:self.vc
                                   Top:YBLWindowHeight
                            completion:^(BOOL finished) {
                                [_couponsView removeFromSuperview];
                                _couponsView = nil;
                            }];
}


@end
