//
//  YBLChangeDeliveryGoodService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChangeDeliveryGoodService.h"
#import "YBLChangeDeliveryGoodViewController.h"
#import "YBLTextSegmentControl.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLExpressPriceTableView.h"
#import "YBLGetProductShippPricesModel.h"
#import "YBLAddAreaAndExpressCompanyView.h"

static NSInteger const tag_shippingprice = 2144;

@interface YBLChangeDeliveryGoodService ()<YBLTextSegmentControlDelegate,UIScrollViewDelegate>

@property (nonatomic, weak  ) YBLChangeDeliveryGoodViewController *Vc;

@property (nonatomic, strong) YBLChangeDeliveryGoodViewModel *viewModel;

@property (nonatomic, strong) YBLTextSegmentControl *textSegment;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YBLChangeDeliveryGoodService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLChangeDeliveryGoodViewModel *)viewModel;
        _Vc = (YBLChangeDeliveryGoodViewController *)VC;
        
        [_Vc.view addSubview:self.scrollView];
        [_Vc.view addSubview:self.textSegment];
        /* 添加 */
        UIButton *addButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, self.scrollView.bottom+space, self.scrollView.width-2*space, buttonHeight)];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_Vc.view addSubview:addButton];
        WEAK
        [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            /* 添加 */
            [YBLAddAreaAndExpressCompanyView showAddAreaAndExpressCompanyViewFromVC:self.Vc.navigationController selectHandle:^(NSMutableDictionary *selectDict){
                STRONG
                for (NSString *key in [selectDict allKeys]) {
                    NSMutableArray *selectArray = selectDict[key];
                    YBLExpressCompanyItemModel *getExpressModel = self.viewModel.getExpressCompanyDataDict[key];
                    NSMutableArray *getAreaArray = self.viewModel.getAreaPriceDataDict[key];
                    if (!getExpressModel) {
                        //新添加快递
                        //1.处理title
                        for (area_prices *noAreaPriceModel in selectArray) {
                            YBLExpressCompanyItemModel *noModel = [YBLExpressCompanyItemModel new];
                            noModel.id = key;
                            noModel.title = noAreaPriceModel.expressCompanyName;
                            [self.viewModel.getExpressCompanyDataDict setObject:noModel forKey:key];
                        }
                        //2.处理快递物流
                        [self.viewModel.getAreaPriceDataDict setObject:selectArray forKey:key];

                        [self jsReloadDataWithIndex:0];
                        
                    } else {
                        //已存在快递物流
                        //遍历选中
                        for (area_prices *selectModel in selectArray) {
                            BOOL isNewItem = YES;
                            //判断所有
                            for (area_prices *itemModel in getAreaArray) {
                                if ([selectModel.area_id isEqualToString:itemModel.area_id]) {
                                    //存在
                                    isNewItem = NO;
                                    itemModel.price = selectModel.price;
                                }
                            }
                            if (isNewItem) {
                                //不存在
                                [getAreaArray insertObject:selectModel atIndex:0];
                            }
                        }
                        //reload
                        //
                        YBLExpressCompanyItemModel *titleItemModel = self.textSegment.dataArray[self.viewModel.currentIndex];
                        [self checkTableViewIsExsitWithIndex:self.viewModel.currentIndex selectModel:titleItemModel.id];
                        
                    }
                }
                
            }];
        }];
        /* 保存 */
        self.Vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveGoodShippingPrice)];
        
        /* rac */
        [[self.viewModel getShippingPricesSiganl] subscribeError:^(NSError * _Nullable error) {
            
        } completed:^{
            STRONG
            [self jsReloadDataWithIndex:0];
        }];
    }
    return self;
}

- (void)jsReloadDataWithIndex:(NSInteger)index{
    
    NSMutableArray *dataArray = [[self.viewModel.getExpressCompanyDataDict allValues] mutableCopy];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*dataArray.count, self.scrollView.height);
    [self.textSegment updateTitleData:dataArray];
    id value = nil;
    if (dataArray.count!=0) {
        value = dataArray[0];
    }
    [self checkTableViewIsExsitWithIndex:index selectModel:value];
}

/**
 *  保存商品配送修改
 */
- (void)saveGoodShippingPrice {
    
    [self.Vc.view endEditing:YES];
    
    [[self.viewModel settingGoodShippingPriceSiganl] subscribeError:^(NSError * _Nullable error) {
    } completed:^{
        [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.Vc.navigationController popViewControllerAnimated:YES];
//        });
    }];
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.textSegment.bottom,YBLWindowWidth, YBLWindowHeight-self.textSegment.bottom-kNavigationbarHeight-buttonHeight-space*2)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}


- (YBLExpressPriceTableView *)getShippingPriceTableViewWithIndex:(NSInteger)index{
    
    YBLExpressPriceTableView *priceTableView = [[YBLExpressPriceTableView alloc] initWithFrame:[self.Vc.view bounds]
                                                                                         style:UITableViewStylePlain
                                                                            distanceRadiusType:DistanceRadiusTypeSingleGoodExpressPriceEdit];
    priceTableView.left = index*self.scrollView.width;
    priceTableView.tag = tag_shippingprice+index;
    priceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight+space*2+buttonHeight)];
    return priceTableView;
}

- (YBLTextSegmentControl *)textSegment{
    
    if (!_textSegment) {
        _textSegment = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40) TextSegmentType:TextSegmentTypeNoArrow];
        _textSegment.delegate = self;
    }
    return _textSegment;
}

- (void)checkTableViewIsExsitWithIndex:(NSInteger)index selectModel:(id)model{

    YBLExpressPriceTableView *currentPriceTableView = (YBLExpressPriceTableView *)[self.Vc.view viewWithTag:tag_shippingprice+index];
    NSString *key = nil;
    if ([model isKindOfClass:[YBLExpressCompanyItemModel class]]) {
        YBLExpressCompanyItemModel *itemModel = (YBLExpressCompanyItemModel *)model;
        key = itemModel.id;
    } else if ([model isKindOfClass:[NSString class]]){
        key = (NSString *)model;
    }
    NSMutableArray *currentDataArray = self.viewModel.getAreaPriceDataDict[key];
    if (!currentPriceTableView) {
        currentPriceTableView = [self getShippingPriceTableViewWithIndex:index];
        currentPriceTableView.dataArray = currentDataArray;
        [self.scrollView addSubview:currentPriceTableView];
    } else {
        currentPriceTableView.dataArray = currentDataArray;
        //scroll to top
        [currentPriceTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
}


- (void)textSegmentControlIndex:(NSInteger)index selectModel:(id)model{
    
    self.viewModel.currentIndex = index;
    [self checkTableViewIsExsitWithIndex:index selectModel:model];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*index, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / self.scrollView.width;
    self.textSegment.currentIndex = index;
    
}

@end
