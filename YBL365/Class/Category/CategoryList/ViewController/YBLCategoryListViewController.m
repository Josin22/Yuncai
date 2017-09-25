//
//  YBLCategoryListViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryListViewController.h"
#import "YBLSearchNavView.h"
#import "YBLCategoryListService.h"
#import "YBLGoodSearchView.h"

@interface YBLCategoryListViewController ()

@property (nonatomic, strong) YBLSearchNavView *searchView;

@property (nonatomic, strong) UIButton *productButton;

@property (nonatomic, strong) YBLCategoryListService *listService;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YBLCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self starUIService];
    
}


//- (NSMutableArray *)dataArray {
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//        NSArray *array = [YBLShopCarModel shareInstance].tempGoods;
//        for (int i = 0; i < 0; i++) {
//            [_dataArray addObject:array[arc4random()%9]];
//        }
//    }
//    return  _dataArray;
//}



- (void)starUIService {
    self.listService = [[YBLCategoryListService alloc] init];
    self.listService.categoryListVC = self;
    [self.listService updateWithGoodArray:self.dataArray];
}

- (void)createNavigationBar {
    
    YBLSearchNavView *searchView = [[YBLSearchNavView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
    self.searchView = searchView;
    self.navigationItem.titleView = searchView;
    WEAK
    searchView.searchBlock = ^(){
        STRONG
        [YBLGoodSearchView showGoodSearchViewWithRightItemViewType:rightItemViewTypeNone
                                                      SearchHandle:^{
                                                          STRONG
                                                          
                                                      }
                                                      cancleHandle:^{

                                                      }
                                                animationEndHandle:^{
                                                    
                                                }];

    };

    
    self.productButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.productButton setImage:[UIImage imageNamed:@"product_list_top_list"] forState:UIControlStateNormal];
    [self.productButton setImage:[UIImage imageNamed:@"product_list_top_grid"] forState:UIControlStateSelected];
    self.productButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,[[UIBarButtonItem alloc] initWithCustomView:self.productButton]];
    
    __weak typeof (self)weakSelf = self;
    [[self.productButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.productButton.selected = !weakSelf.productButton.selected;
        weakSelf.listService.isList = weakSelf.productButton.selected;
    }];
}



@end
