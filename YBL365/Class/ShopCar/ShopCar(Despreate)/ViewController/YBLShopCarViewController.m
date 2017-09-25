//
//  YBLShopCarViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarViewController.h"
#import "UITabBar+BageValue.h"
#import "YBLShopCarUIService.h"
#import "YBLShopCarService.h"
#import "UIBarButtonItem+YBL.h"
#import "YBLShopCarBannerView.h"
#import "YBLShopCarTempGoodModel.h"
#import "YBLTakeOrderViewController.h"
#import "YBLNavigationViewController.h"
//#import "YBLLoginView.h"
#import "YBLLoginViewController.h"



@interface YBLShopCarViewController ()

@property (nonatomic, strong) YBLShopCarUIService *shopCarUIService; //UI Service
@property (nonatomic, strong) YBLShopCarService *shopCarService; // 数据 网络 等 Service

@property (nonatomic, strong) NSMutableArray *recommendGoodArray;
@property (nonatomic, strong) NSMutableArray *carGoodArray;


@property (nonatomic, strong) YBLShopCarBannerView *bannerView;

@property (nonatomic, assign) ShopCarType carType;

@end

@implementation YBLShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    self.carType = ShopCarTypeNormal;
    [self starUIService];
    [self notifaUserLogin];
    [self notifaCarNumber];
    [self notofaCarType];
    [self starService];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.carType == ShopCarTypeEdite) {
        [self changeEditType];
    }
}

- (YBLShopCarBannerView *)bannerView {
    if (!_bannerView) {
        CGFloat top = self.view.height - 49;
        NSArray *VSs = self.navigationController.childViewControllers;
        if (VSs[0] == self) {
            top = self.view.height - 49-49;
        }
        _bannerView = [[YBLShopCarBannerView alloc] initWithFrame:CGRectMake(0, top, YBLWindowWidth, 49)];
        __weak typeof (self)weakSelf = self;
//        //全选点击
        [[_bannerView.checkButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.carType == ShopCarTypeNormal) {
                for (NSDictionary *goodDic in weakSelf.carGoodArray) {
                    for (YBLShopCarTempGoodModel *good in goodDic[@"items"]) {
                        good.isCheck = !weakSelf.bannerView.checkButton.selected;
                    }
                }
                [weakSelf.shopCarService parseAllPriceAndIsSelectedAllWithGoodArray:weakSelf.carGoodArray];
                [weakSelf.shopCarUIService updateAllSections];
            }else if (weakSelf.carType == ShopCarTypeEdite){
                for (NSDictionary *goodDic in weakSelf.carGoodArray) {
                    for (YBLShopCarTempGoodModel *good in goodDic[@"items"]) {
                        good.isDelete = !weakSelf.bannerView.checkButton.selected;
                    }
                }
                [weakSelf.shopCarUIService updateAllSections];
                weakSelf.bannerView.checkButton.selected = !weakSelf.bannerView.checkButton.selected;
            }
        }];
        //结算点击
        WEAK
        [[_bannerView.buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf.shopCarService parseSelectedOrderGoodArray:weakSelf.carGoodArray block:^(NSArray *orderGoodArray) {
                if (orderGoodArray.count > 0) {
                    if (![YBLUserModel shareInstance].isLogin) {
                       STRONG
                        YBLLoginViewController *loginVC = [[YBLLoginViewController alloc] init];
                        YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:loginVC];
                        [self presentViewController:nav animated:YES completion:^{
                            
                        }];
                    }else {
                        [weakSelf gotoTakeOrder];
                    }
                }else {
                    SVPSHOWINFO(@"您还没有选择商品哦!");
                    NOSHOWSVP(1.0);
                }
            }];
        }];
        //删除
        [[_bannerView.deleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要删除选中的商品么" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf parseDeleteGoodArray];
            }];
            [alertVC addAction:okAction];
            [alertVC addAction:cancelAction];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }];
    }
    return _bannerView;
}

- (void)gotoTakeOrder {
    YBLTakeOrderViewController *takeOrderVC = [[YBLTakeOrderViewController alloc] init];
    takeOrderVC.isPresentView = YES;
    YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:takeOrderVC];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

//删除购物车
- (void)parseDeleteGoodArray {
    self.carType = ShopCarTypeEdite;
    NSMutableArray *deleArray = [NSMutableArray arrayWithArray:self.carGoodArray];
    NSMutableArray *deleShopArray = [NSMutableArray array];
    for (int i=0 ; i<deleArray.count;i++) {
        NSArray *items = deleArray[i][@"items"];
        NSMutableArray *carItems = self.carGoodArray[i][@"items"];
        NSMutableArray *d = [NSMutableArray array];
        for (int i = 0; i < [items count]; i++) {
            YBLShopCarTempGoodModel *good = items[i];
            if (good.isDelete) {
                [d addObject:carItems[i]];
            }
        }
        [carItems removeObjectsInArray:d];
        if (carItems.count == 0) {
            [deleShopArray addObject:self.carGoodArray[i]];
        }
    }
    [self.carGoodArray removeObjectsInArray:deleShopArray];
    [self changeEditType];
    if (self.carGoodArray.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.shopCarUIService changeTableViewHeight:self.view.height];
        [self.shopCarUIService changeUIWithIslogin:[YBLUserModel shareInstance].isLogin];
        [self.bannerView removeFromSuperview];
    }

}





- (NSMutableArray*)recommendGoodArray {
    if (!_recommendGoodArray) {
        NSArray *array = [YBLShopCarModel shareInstance].tempGoods;
        _recommendGoodArray = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [_recommendGoodArray addObject:array[arc4random()%9]];
        }
    }
    return _recommendGoodArray;
}


//观察用户是否登录
- (void)notifaUserLogin {
    __weak typeof (self)weakSelf = self;
    [RACObserve([YBLUserModel shareInstance], isLogin) subscribeNext:^(id x) {
        [weakSelf.shopCarUIService changeUIWithIslogin:[YBLUserModel shareInstance].isLogin];
    }];
}

//观察当前是否是编辑状态
- (void)notofaCarType {
    if ([YBLShopCarModel shareInstance].carGoodArray.count > 0) {
        if (self.bannerView.superview == self.view) {
            return;
        }
        [self.view addSubview:self.bannerView];
    }else {
        [self.bannerView removeFromSuperview];
    }
    
    __weak typeof (self)weakSelf = self;
    [RACObserve([YBLShopCarModel shareInstance], carGoodArray) subscribeNext:^(id x) {
        if ([YBLShopCarModel shareInstance].carGoodArray.count > 0) {
            if (weakSelf.bannerView.superview == weakSelf.view) {
                return;
            }
            [weakSelf.view addSubview:weakSelf.bannerView];
        }else {
            [weakSelf.bannerView removeFromSuperview];
        }
    }];
}

//编辑/完成按钮点击
- (void)changeEditType{
    NSString *itemStr;
    if (self.carType == ShopCarTypeNormal) {
        self.carType = ShopCarTypeEdite;
        itemStr = @"完成";
    }else if (self.carType == ShopCarTypeEdite) {
        self.carType = ShopCarTypeNormal;
        itemStr = @"编辑";
    }
    
    //从编辑状态到完成状态  取消之前的编辑状态
    if (self.carType == ShopCarTypeNormal) {
        for (NSDictionary *dic in self.carGoodArray) {
            for (YBLShopCarTempGoodModel *good in dic[@"items"]) {
                good.isDelete = NO;
            }
        }
    }
    //编辑状态修改
    [self.bannerView updateWithType:self.carType];
    [self.shopCarUIService updateWithCarType:self.carType];
    if (self.carType == ShopCarTypeNormal) {
        [self.shopCarService parseAllPriceAndIsSelectedAllWithGoodArray:self.carGoodArray];
    }
    __weak typeof (self)weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:itemStr color:YBLColor(120, 120, 120, 1.0) font:YBLFont(15) block:^{
        [weakSelf changeEditType];
    }];
}


//观察购物车单例
- (void)notifaCarNumber {
    [self changeNavigationItem];
    __weak typeof (self)weakSelf = self;
    [RACObserve([YBLShopCarModel shareInstance], carGoodArray) subscribeNext:^(id x) {
        //解析购物车数据
        [weakSelf.shopCarService starParseCarGoods:weakSelf.carGoodArray];
        //解析价格和是否全选
        [weakSelf.shopCarService parseAllPriceAndIsSelectedAllWithGoodArray:weakSelf.carGoodArray];
        //修改编辑按钮
        [weakSelf changeNavigationItem];
        
    }];
}
//修改navigationItem
- (void)changeNavigationItem {
    if ([YBLShopCarModel shareInstance].carGoodArray.count > 0) {
        if (self.navigationItem.rightBarButtonItem == nil) {
            __weak typeof (self)weakSelf = self;
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"编辑" color:YBLColor(120, 120, 120, 1.0) font:YBLFont(15) block:^{
                [weakSelf changeEditType];
            }];
            [self.shopCarUIService changeTableViewHeight:self.view.height - 49];
        }
    }else {
        self.navigationItem.rightBarButtonItem = nil;
        [self.shopCarUIService changeTableViewHeight:self.view.height];
    }
}


- (void)starService {
    self.shopCarService = [[YBLShopCarService alloc] init];
    __weak typeof (self)weakSelf = self;
    self.shopCarService.parseDataBlock = ^(NSArray *carGoodArray) {
        //解析完数据 更新UI
        weakSelf.carGoodArray = [NSMutableArray arrayWithArray:carGoodArray];
        [weakSelf.shopCarUIService updateWithCarGoodArray:weakSelf.carGoodArray recommendArray:weakSelf.recommendGoodArray];
    };
    self.shopCarService.parsePriceBlock = ^(CGFloat totalPrice, CGFloat subPrice, BOOL isCheckAll,NSInteger goodNumber){
        weakSelf.bannerView.checkButton.selected = isCheckAll;
        weakSelf.bannerView.realPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",totalPrice-subPrice<0?0:totalPrice-subPrice];
        weakSelf.bannerView.goodNumber = goodNumber;
        if (totalPrice <= 0) {
           weakSelf.bannerView.subPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",totalPrice];
        }else{

            weakSelf.bannerView.subPriceLabel.text = [NSString stringWithFormat:@"总额:¥%.2f 立减¥%.2f",totalPrice,subPrice];

            weakSelf.bannerView.subPriceLabel.text = [NSString stringWithFormat:@"优惠:¥%.2f   运费¥%.2f",subPrice,subPrice];

        }
    };
    //解析数据
    [self.shopCarService starParseCarGoods:self.carGoodArray];
    [self.shopCarService parseAllPriceAndIsSelectedAllWithGoodArray:self.carGoodArray];
    
}


- (void)starUIService {
    self.shopCarUIService = [[YBLShopCarUIService alloc] init];
    self.shopCarUIService.shopCarVC = self;
    [self.shopCarUIService changeUIWithIslogin:[YBLUserModel shareInstance].isLogin];
    //选中
    __weak typeof (self)weakSelf = self;
    self.shopCarUIService.checkGoodBlock = ^(YBLShopCarTempGoodModel *good, BOOL isSelected, NSIndexPath *indexPath){
        if (weakSelf.carType == ShopCarTypeNormal) {
            good.isCheck = isSelected;
        }else if (weakSelf.carType == ShopCarTypeEdite){
            good.isDelete = isSelected;
        }
        [weakSelf.shopCarUIService updateCellInSection:indexPath.section];
        if (weakSelf.carType == ShopCarTypeNormal) {
            [weakSelf.shopCarService parseAllPriceAndIsSelectedAllWithGoodArray:weakSelf.carGoodArray];
        }else if (weakSelf.carType == ShopCarTypeEdite){
            [weakSelf.shopCarService parseDeleteAll:weakSelf.carGoodArray block:^(BOOL isCheckAll) {
                weakSelf.bannerView.checkButton.selected = isCheckAll;
            }];
        }
        
    };

    //选中店铺
    self.shopCarUIService.checkShopBlock = ^(id shop, BOOL isSelected, NSInteger section){
        NSArray *items = shop[@"items"];
        for (YBLShopCarTempGoodModel *good in items) {
            if (weakSelf.carType == ShopCarTypeNormal) {
                good.isCheck = isSelected;
            }else if (weakSelf.carType == ShopCarTypeEdite){
                good.isDelete = isSelected;
            }
        }
        [weakSelf.shopCarUIService updateCellInSection:section];
        if (weakSelf.carType == ShopCarTypeNormal) {
            [weakSelf.shopCarService parseAllPriceAndIsSelectedAllWithGoodArray:weakSelf.carGoodArray];
        }else if (weakSelf.carType == ShopCarTypeEdite){
            [weakSelf.shopCarService parseDeleteAll:weakSelf.carGoodArray block:^(BOOL isCheckAll) {
                weakSelf.bannerView.checkButton.selected = isCheckAll;
            }];
        }
    };
    //删除
    self.shopCarUIService.deleteGoodBlock = ^(YBLShopCarTempGoodModel *good, NSInteger section){
        good.isDelete = YES;
        [weakSelf parseDeleteGoodArray];
    };
    //修改商品数量
    self.shopCarUIService.changeGoodNumberBlock = ^(){
        [weakSelf.shopCarService parseAllPriceAndIsSelectedAllWithGoodArray:weakSelf.carGoodArray];
    };
    
    
    
}


- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}



@end
