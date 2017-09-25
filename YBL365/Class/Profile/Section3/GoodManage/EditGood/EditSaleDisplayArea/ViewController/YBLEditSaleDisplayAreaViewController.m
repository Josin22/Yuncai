//
//  YBLEditSaleDisplayAreaViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditSaleDisplayAreaViewController.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLEditPurchaseCell.h"
#import "YBLChooseAreaViewController.h"
#import "YBLSelectAreaCollectionView.h"

static NSInteger const tag_value_button = 3212;

static NSInteger const tag_value_cell = 1212;

@interface YBLEditSaleDisplayAreaViewController ()

@end

@implementation YBLEditSaleDisplayAreaViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[self.viewModel siganlForGetAreaInfo] subscribeError:^(NSError * _Nullable error) {
        
    } completed:^{
        YBLEditPurchaseCell *cell = (YBLEditPurchaseCell *)[self.view viewWithTag:tag_value_cell];
        cell.good_switch.on = self.viewModel.getSaleDisplayPriceModel.enable_sales_area.boolValue;
        YBLEditPurchaseCell *cell1 = (YBLEditPurchaseCell *)[self.view viewWithTag:tag_value_cell+1];
        cell1.good_switch.on = self.viewModel.getSaleDisplayPriceModel.enable_display_price_area.boolValue;
        
        UIButton *selectValueButton = (UIButton *)[self.view viewWithTag:tag_value_button];
        [selectValueButton setTitle:[NSString stringWithFormat:@"%ld个区域",(unsigned long)self.viewModel.getSaleDisplayPriceModel.sales_area.count] forState:UIControlStateNormal];
        UIButton *selectValueButton1 = (UIButton *)[self.view viewWithTag:tag_value_button+1];
        [selectValueButton1 setTitle:[NSString stringWithFormat:@"%ld个区域",(unsigned long)self.viewModel.getSaleDisplayPriceModel.display_price_area.count] forState:UIControlStateNormal];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"销售区域设置";
    
    self.navigationItem.rightBarButtonItem = self.explainButtonItem;
    
    [self createUI];
}

- (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                isRequired:(BOOL)isRequired
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString{
    
    YBLEditItemGoodParaModel *model = [YBLEditItemGoodParaModel new];
    model.title = title;
    model.value = value;
    model.editTypeCell = type;
    model.isRequired = isRequired;
    model.paraString = paraString;
    return model;
}

- (void)createUI{

    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:[self getModelWith:@"销售区域设置"
                                      value:nil
                                 isRequired:YES
                                       type:EditTypeCellOnlySwith
                                 paraString:nil]];
    [dataArray addObject:[self getModelWith:@"关闭销售区域价格显示"
                                      value:nil
                                 isRequired:YES
                                       type:EditTypeCellOnlySwith
                                 paraString:nil]];
    
    for (int i = 0; i < dataArray.count; i++) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, i*(50+50+space), YBLWindowWidth, 50+50)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        YBLEditPurchaseCell *cell = [[YBLEditPurchaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.frame = CGRectMake(0, 0, YBLWindowWidth, 50);
        cell.tag = tag_value_cell+i;
        [cell updateItemCellModel:dataArray[i]];
        WEAK
        [[cell.good_switch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISwitch * _Nullable x) {
            STRONG
            if (i == 0) {
                [self.viewModel siganlForSalesAreaStatus:x.isOn];
            } else {
                [self.viewModel siganlForDisplayPriceAreaStatus:x.isOn];
            }
        }];
        [bgView addSubview:cell];
        
        UIButton *selectValueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectValueButton.frame = CGRectMake(space, 50, YBLWindowWidth/2-space, 50);
        selectValueButton.titleLabel.font = YBLFont(13);
        [selectValueButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        selectValueButton.tag = tag_value_button+i;
        selectValueButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [bgView addSubview:selectValueButton];
        [[selectValueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            NSMutableArray *dataArray = nil;
            if (i == 0) {
                dataArray = self.viewModel.getSaleDisplayPriceModel.sales_area;
            } else {
                dataArray = self.viewModel.getSaleDisplayPriceModel.display_price_area;
            }
            [YBLSelectAreaCollectionView showSelectAreaCollectionViewFromVC:self.navigationController
                                                             selectAreaType:SelectAreaTypeSave
                                                                   areaData:[dataArray mutableCopy]
                                                                 doneHandle:^(NSMutableArray *renew_array){
                STRONG
                if (i == 0) {
                    self.viewModel.getSaleDisplayPriceModel.sales_area = renew_array;
                    [self.viewModel siganlForSaveSaleArea];
                } else {
                     self.viewModel.getSaleDisplayPriceModel.display_price_area = renew_array;
                    [self.viewModel siganlForSaveDisplayPriceArea];
                }
                UIButton *selectValueButton = (UIButton *)[self.view viewWithTag:tag_value_button+i];
                [selectValueButton setTitle:[NSString stringWithFormat:@"%ld个区域",(unsigned long)renew_array.count] forState:UIControlStateNormal];
            }];
        }];
        
        CGFloat lessWi = YBLWindowWidth-selectValueButton.right-space;
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        changeButton.frame = CGRectMake(selectValueButton.right, selectValueButton.top, lessWi, selectValueButton.height);
        [changeButton setTitle:@"添加修改" forState:UIControlStateNormal];
        [changeButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
        changeButton.titleLabel.font = YBLFont(14);
        [changeButton setImage:[UIImage imageNamed:@"found_arrow"] forState:UIControlStateNormal];
        changeButton.imageRect = CGRectMake(lessWi-8, (selectValueButton.height-15)/2, 8, 15);
        changeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        changeButton.titleRect = CGRectMake(0, 0, lessWi-8-5, selectValueButton.height);
        [bgView addSubview:changeButton];
        [[changeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            AreaType AreaType = AreaTypeSalesArea;
            NSMutableDictionary *seletDict = nil;
            if (i==0) {
                AreaType = AreaTypeSalesArea;
                seletDict = self.viewModel.getSalesPriceDict;
            } else {
                AreaType = AreaTypeDisplayPriceArea;
                seletDict = self.viewModel.getDisplayPriceDict;
            }
            YBLChooseAreaViewModel *viewModel = [YBLChooseAreaViewModel new];
            viewModel._id = self.viewModel._id;
            viewModel.areaType = AreaType;
            viewModel.chooseAreaVCType = ChooseAreaVCTypeSetAll;
            viewModel.selectAreaDataDict = seletDict;
            YBLChooseAreaViewController *chooseVC = [YBLChooseAreaViewController new];
            chooseVC.viewModel = viewModel;
            [self.navigationController pushViewController:chooseVC animated:YES];
        }];
        
    }
    
}

- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
    
    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_SaleAreaSettingDeclare title:@"销售区域设置说明"];
}

@end
