//
//  YBLCouponsSetViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsSetViewController.h"
#import "YBLEditPurchaseTableView.h"
#import "YBLCouponsSetViewModel.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLEditPurchaseCell.h"
#import "ZJUsefulPickerView.h"
#import "YBLSingletonMethodTools.h"
#import "YBLLogisticsCompanyAndGoodListViewController.h"

@interface YBLCouponsSetViewController ()

@property (nonatomic, strong) YBLCouponsSetViewModel *viewModel;

@property (nonatomic, strong) YBLEditPurchaseTableView *couponsTableView;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation YBLCouponsSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"优惠券编辑";
    
    self.viewModel = [YBLCouponsSetViewModel new];
 
    self.couponsTableView.cellDataArray = self.viewModel.cellDataArray;
    
    [self.view addSubview:self.saveButton];
}

- (YBLEditPurchaseTableView *)couponsTableView{
    if (!_couponsTableView) {
        _couponsTableView  = [[YBLEditPurchaseTableView alloc] initWithFrame:[self.view bounds]
                                                                       style:UITableViewStylePlain
                                                                    editType:EditTypeNormal];
        
        WEAK
        _couponsTableView.editPurchaseTableViewCellBlock = ^(YBLEditPurchaseCell *cell, YBLEditItemGoodParaModel *paraModel, NSIndexPath *indexPath) {
            STRONG
            [[cell.valueTextFeild.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
//                STRONG
                NSArray *chooseArray = @[@"gmjem",@"yhjej",@"yhqsl"];
                for (NSString *chooseKey in chooseArray) {
                    if ([paraModel.initial_text isEqualToString:chooseKey]) {
                        [paraModel setValue:x forKey:@"value"];
                        [paraModel setValue:x forKey:@"paraValueString"];
                    }
                }
            }];
            
            [[[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                STRONG
                [self.couponsTableView endEditing:YES];
                if ([paraModel.initial_text isEqualToString:@"yhsp"]) {
                    //商品
                    YBLLogisticsCompanyAndGoodListViewModel *viewModel = [YBLLogisticsCompanyAndGoodListViewModel new];
                    viewModel.listVCType = ListVCTypeStoreGoodSingleSelect;
                    viewModel.openedExpressCompanyGoodListDataArray = @[paraModel.undefineValue].mutableCopy;
                    viewModel.logisticsCompanyAndGoodListBlock = ^(NSMutableArray *selectArray) {
                        STRONG
                        if (selectArray.count>0) {
                            YBLGoodModel *goodModel = selectArray[0];
                            paraModel.undefineValue = goodModel;
                            paraModel.paraValueString = goodModel.id;
                            paraModel.value = goodModel.title;
                            [self.couponsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];;
                        }
                    
                    };
                    YBLLogisticsCompanyAndGoodListViewController *listVc = [YBLLogisticsCompanyAndGoodListViewController new];
                    listVc.viewModel = viewModel;
                    [self.navigationController pushViewController:listVc animated:YES];
                    
                } else if ([paraModel.initial_text isEqualToString:@"yhsxz"]||[paraModel.initial_text isEqualToString:@"yhsxq"]) {
                    //日期
                    ZJDatePickerStyle *style = [ZJDatePickerStyle new];
                    style.datePickerMode = UIDatePickerModeDate;
                    [ZJUsefulPickerView showDatePickerWithToolBarText:@"选择优惠时效"
                                                            withStyle:style
                                                    withCancelHandler:^{}
                                                      withDoneHandler:^(NSDate *selectedDate) {
                                                          
                                                          NSDateFormatter *dateFormatter = [YBLSingletonMethodTools shareMethodTools].cachedDateFormatter;
                                                          [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                          NSString *strDate = [dateFormatter stringFromDate:selectedDate];
                                                          paraModel.value = strDate;
                                                          paraModel.paraValueString = strDate;
                                                          [self.couponsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];;
                                                      }];

                }
            }];

        };
        [self.view addSubview:_couponsTableView];
    }
    return _couponsTableView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton  =[YBLMethodTools getFangButtonWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)];
        _saveButton.bottom = YBLWindowHeight-kNavigationbarHeight;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        WEAK
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [[self.viewModel siganlForSaveCoupons] subscribeNext:^(id  _Nullable x) {
                STRONG
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } error:^(NSError * _Nullable error) {
                
            }];
        }];
    }
    return _saveButton;
}

@end
