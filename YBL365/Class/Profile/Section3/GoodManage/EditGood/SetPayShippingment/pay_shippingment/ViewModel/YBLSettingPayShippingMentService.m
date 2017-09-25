//
//  YBLSettingPayShippingMentService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSettingPayShippingMentService.h"
#import "YBLSettingPayShippingMentViewModel.h"
#import "YBLSettingPayShippingMentVC.h"
#import "YBLSettingShippingmentCell.h"
#import "YBLSettingPaymentHeaderView.h"
#import "YBLChooseAreaViewController.h"
#import "YBLOrderAddressViewController.h"
#import "YBLSelectAreaCollectionView.h"
#import "YBLSelectAddressView.h"
#import "YBLShowPayShippingsmentModel.h"
#import "YBLChooseGoodLogisticsCompanyCollectionView.h"
#import "YBLAreaRadiusViewController.h"
#import "YBLShowSelectAreaRadiusView.h"

@interface YBLSettingPayShippingMentService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YBLSettingPayShippingMentViewModel *viewModel;

@property (nonatomic, weak  ) YBLSettingPayShippingMentVC *Vc;

@property (nonatomic, strong) UITableView *payShippingTableView;

@property (nonatomic, strong) UIView *headerBgView;

@property (nonatomic, strong) YBLChooseGoodLogisticsCompanyCollectionView *allGoodCollectionView;

@end

@implementation YBLSettingPayShippingMentService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLSettingPayShippingMentVC *)VC;
        _viewModel = (YBLSettingPayShippingMentViewModel *)viewModel;
     
        [_Vc.view addSubview:self.payShippingTableView];
        if (self.viewModel.settingPayShippingMentVCType == SettingPayShippingMentVCTypeManyGoodChange) {
            self.payShippingTableView.tableHeaderView = self.headerBgView;
        }
        /* 保存 */
        UIButton *saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-buttonHeight-space-kNavigationbarHeight, YBLWindowWidth-2*space, buttonHeight)];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitle:@"保存" forState:UIControlStateDisabled];
        saveButton.enabled = NO;
        [_Vc.view addSubview:saveButton];
        WEAK
#pragma mark 保存
        [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            NSInteger isHasSelect = 0;
            NSArray *sameCity = [self.viewModel isHasChooseSameCityShipPayment:YES];
            NSInteger sameCity_defaultCount = [sameCity[0] integerValue];
            NSInteger sameCity_selectPayCount = [sameCity[1] integerValue];
            NSInteger sameCity_selectShipCount = [sameCity[2] integerValue];
            NSInteger sameCity_selectValueCount = [sameCity[3] integerValue];
            if ((sameCity_selectPayCount+sameCity_selectShipCount)>0) {
                if (sameCity_defaultCount!=2||(sameCity_selectValueCount!=sameCity_selectShipCount)) {
                    [SVProgressHUD showErrorWithStatus:@"当前选择的方式不完整哟~"];
                    return ;
                }
            } else {
                isHasSelect++;
            }
            NSArray *noSameCity = [self.viewModel isHasChooseSameCityShipPayment:NO];
            NSInteger no_sameCity_defaultCount = [noSameCity[0] integerValue];
            NSInteger no_sameCity_selectPayCount = [noSameCity[1] integerValue];
            NSInteger no_sameCity_selectShipCount = [noSameCity[2] integerValue];
            NSInteger no_sameCity_selectValueCount = [noSameCity[3] integerValue];
            if ((no_sameCity_selectPayCount+no_sameCity_selectShipCount)>0) {
                if (no_sameCity_defaultCount!=2||(no_sameCity_selectValueCount!=no_sameCity_selectShipCount)) {
                    [SVProgressHUD showErrorWithStatus:@"当前选择的方式不完整哟~"];
                    return ;
                }
            } else {
                isHasSelect++;
            }
            
            if (isHasSelect==2) {
                [SVProgressHUD showErrorWithStatus:@"您还没有选择哟~"];
                return;
            }
            
            [[self.viewModel siganlForSettingShippingPayment] subscribeError:^(NSError * _Nullable error) {
                
            } completed:^{
                STRONG
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.Vc.navigationController popViewControllerAnimated:YES];
                });
            }];

//            if ([self.viewModel isHasChooseSameCityShipPayment:YES]||[self.viewModel isHasChooseSameCityShipPayment:NO]) {
//                
//            } else {
//                [SVProgressHUD showErrorWithStatus:@"您还有其他的默认方式没有选哟~"];
//            }
//            if (selectCount>0) {
//                
//                return ;
//            }
//            if (defaultCount>0) {
//                [SVProgressHUD showErrorWithStatus:@"您还有其他的默认方式没有选哟~"];
//                return ;
//            }
//            
        }];
        /* 获取所有支付配送 */
        [[self.viewModel siganlForAllPayShippingMent] subscribeError:^(NSError * _Nullable error) {
        } completed:^{
            STRONG
            saveButton.enabled = YES;
            [self.payShippingTableView jsReloadData];
            //如果是单个商品
            if (self.viewModel.settingPayShippingMentVCType == SettingPayShippingMentVCTypeSingleGoodChange) {
                //显示已设置支付配送
                [[self.viewModel siganlForGetShippingPayment] subscribeError:^(NSError * _Nullable error) {
                } completed:^{
                    STRONG
                    [self.payShippingTableView jsReloadData];
                }];
            } else {
                [SVProgressHUD dismiss];
            }
        }];
        /**
         *  批量选择商品支付
         */
        if (self.viewModel.settingPayShippingMentVCType == SettingPayShippingMentVCTypeManyGoodChange) {
            /* 获取所有未设置商品 */
            [[self.viewModel siganlForNoPayShippingMentProduct] subscribeError:^(NSError * _Nullable error) {
                
            } completed:^{
                STRONG
                self.allGoodCollectionView.dataArray = self.viewModel.allNoPayshippingmentArray;
            }];
        
        }
        
    }
    return self;
}

- (UIView *)headerBgView{
    
    if (!_headerBgView) {
        _headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 140)];
        _headerBgView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth, 50)];
        titleLabel.textColor = BlackTextColor;
        titleLabel.text = @"选择商品";
        titleLabel.font = YBLFont(16);
        [_headerBgView addSubview:titleLabel];
        [titleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleLabel.height-.5, YBLWindowWidth, .5)]];
        [_headerBgView addSubview:self.allGoodCollectionView];
        self.allGoodCollectionView.top = titleLabel.bottom;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.allGoodCollectionView.bottom, _headerBgView.width, 10)];
        lineView.backgroundColor = YBLColor(237, 236, 242, 1);
        [_headerBgView addSubview:lineView];
    }
    return _headerBgView;
}

- (YBLChooseGoodLogisticsCompanyCollectionView *)allGoodCollectionView{

    if (!_allGoodCollectionView) {
        CGFloat itemHi = 80;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemHi, itemHi);
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _allGoodCollectionView = [[YBLChooseGoodLogisticsCompanyCollectionView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, itemHi) collectionViewLayout:layout];
        _allGoodCollectionView.backgroundColor = YBLColor(242, 242, 242, 1);
    }
    return _allGoodCollectionView;
}

- (UITableView *)payShippingTableView{
    
    if (!_payShippingTableView) {
        _payShippingTableView = [[UITableView alloc] initWithFrame:[_Vc.view bounds] style:UITableViewStyleGrouped];
        _payShippingTableView.dataSource = self;
        _payShippingTableView.delegate = self;
        _payShippingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight+kNavigationbarHeight)];
        _payShippingTableView.rowHeight = [YBLSettingShippingmentCell getItemCellHeightWithModel:nil];
        _payShippingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_payShippingTableView registerClass:NSClassFromString(@"YBLSettingShippingmentCell") forCellReuseIdentifier:@"YBLSettingShippingmentCell"];
        [_payShippingTableView registerClass:NSClassFromString(@"YBLSettingPaymentHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLSettingPaymentHeaderView"];
    }
    return _payShippingTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.allShippingmentDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.allShippingmentDataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [YBLSettingPaymentHeaderView getItemCellHeightWithModel:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YBLSettingPaymentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLSettingPaymentHeaderView"];
    
    NSMutableArray *head_array = self.viewModel.allPaymentDataArray[section];
    
    [headerView updateItemCellModel:head_array row:section];
    
    WEAK
    headerView.settingPaymentDependBlock = ^(YBLShowPayShippingsmentModel *selectPayModel,NSMutableArray *dependIDArray) {
        STRONG
        //检查
        NSMutableArray *sectionDataArray = self.viewModel.allShippingmentDataArray[section];
        if (dependIDArray.count==0) {
            for (YBLShowPayShippingsmentModel *shipping_mentModel in sectionDataArray) {
                if (shipping_mentModel.shipping_method.permit_payment_method_ids.count>0&&selectPayModel.is_default.boolValue) {
                    shipping_mentModel.is_default = @(NO);
                }
            }
            
        } else {
            for (NSString *permitID in dependIDArray) {
                for (YBLShowPayShippingsmentModel *shipping_mentModel in sectionDataArray) {
                    if (selectPayModel.is_default.boolValue) {
                        shipping_mentModel.is_default = @(NO);
                    }
                    if ([shipping_mentModel.shipping_method.id isEqualToString:permitID]) {
                        shipping_mentModel.is_select = selectPayModel.is_select;
                        shipping_mentModel.is_default = selectPayModel.is_default;
                    }
                }
            }
        }
        [self.payShippingTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLSettingShippingmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLSettingShippingmentCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLSettingShippingmentCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSMutableArray *sectionDataArray = self.viewModel.allShippingmentDataArray[section];
    YBLShowPayShippingsmentModel *shipping_mentModel = sectionDataArray[row];
    [cell updateItemCellModel:shipping_mentModel];
    
    //code
    NSString *sef_code = nil;
    if (shipping_mentModel.shipping_method) {
        sef_code = shipping_mentModel.shipping_method.code;
    }
    WEAK
#pragma mark 默认
    [[[cell.defaultButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if (shipping_mentModel.is_default.boolValue) {
            return ;
        }
        for (YBLShowPayShippingsmentModel *shippingMentModel in sectionDataArray) {
            shippingMentModel.is_default = @(NO);
            [shipping_mentModel setValue:@(NO) forKey:@"is_select"];
        }
        shipping_mentModel.is_default = @(YES);
        [shipping_mentModel setValue:@(YES) forKey:@"is_select"];
        //handle data
        NSMutableArray *head_array = self.viewModel.allPaymentDataArray[section];
        if (shipping_mentModel.shipping_method.permit_payment_method_ids.count==0) {
            //普通配送方式
            for (YBLShowPayShippingsmentModel *pay_mentModel in head_array) {
                if (pay_mentModel.payment_method.permit_shipping_method_ids.count>0&&pay_mentModel.is_default.boolValue) {
                    pay_mentModel.is_default = @(NO);
                }
            }
            
        } else {
            //相互配送方式
            for (NSString *permitID in shipping_mentModel.shipping_method.permit_payment_method_ids) {
                //遍历pay_data_array
                for (YBLShowPayShippingsmentModel *pay_mentModel in head_array) {
                    pay_mentModel.is_default = @(NO);
                    if ([pay_mentModel.payment_method.id isEqualToString:permitID]) {
                        pay_mentModel.is_select = shipping_mentModel.is_select;
                        pay_mentModel.is_default = shipping_mentModel.is_default;
                    }
                }
                
            }
            
        }
        [self.payShippingTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }];;
#pragma mark 箭头  -->>push vc
    [[[cell.arrowButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [shipping_mentModel setValue:@(YES) forKey:@"is_select"];
        [self.payShippingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([sef_code isEqualToString:@"tcps"]) {
            //同城配送  --->>当前城市
            YBLAreaRadiusViewModel *viewModel = [YBLAreaRadiusViewModel new];
            if (shipping_mentModel.radius_prices.count!=0) {
                viewModel.areaSelectDataArray = [shipping_mentModel.radius_prices mutableCopy];
            }
            viewModel.areaRadiusViewModelBlock = ^(NSMutableArray *selectArray) {
                STRONG
                [shipping_mentModel setValue:selectArray forKey:@"radius_prices"];
                [self.payShippingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            YBLAreaRadiusViewController *areaRadiusVC = [YBLAreaRadiusViewController new];
            areaRadiusVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:areaRadiusVC animated:YES];

        } else if ([sef_code isEqualToString:@"shsm"]){
            
            //送货上门  -->>全国
            YBLChooseAreaViewModel *viewModel = [YBLChooseAreaViewModel new];
            viewModel.chooseAreaVCType = ChooseAreaVCTypeGetAll;
            viewModel.selectAreaDataDict = shipping_mentModel.orgin_select_shipping_address_dict;
            viewModel.chooseAreaSaveBlock = ^(NSMutableDictionary *selectAreaDataDict) {
                STRONG
                [shipping_mentModel setValue:[[selectAreaDataDict allValues] mutableCopy] forKey:@"area_text"];
                [shipping_mentModel setValue:selectAreaDataDict forKey:@"orgin_select_shipping_address_dict"];
                [self.payShippingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            YBLChooseAreaViewController *chooseVC = [YBLChooseAreaViewController new];
            chooseVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:chooseVC animated:YES];

            
        } else if ([sef_code isEqualToString:@"smzt"]) {
            //上门自提  --->>自提地址库
            YBLAddressViewModel *viewModel = [YBLAddressViewModel new];
            viewModel.addressGenre = AddressGenreZiti;
            if (shipping_mentModel.addresses.count!=0) {
                viewModel.selectAddressArray = [shipping_mentModel.addresses mutableCopy];
            }
            viewModel.addressViewManySelectAddresBlock = ^(NSMutableArray *selectArray){
                STRONG
                [shipping_mentModel setValue:selectArray forKey:@"addresses"];
                [self.payShippingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            YBLOrderAddressViewController *addressVC = [[YBLOrderAddressViewController alloc] init];
            addressVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:addressVC animated:YES];
        }
//        else if ([shipping_mentModel.code isEqualToString:@"wlzt"]) {
//            //物流自提  -->>
//        }
    }];
#pragma mark 选中显示按钮  -->> show view
    [[[cell.textButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([sef_code isEqualToString:@"tcps"]) {
            //同城配送  --->>当前城市
            if (shipping_mentModel.radius_prices.count==0) {
                return ;
            }
            [YBLShowSelectAreaRadiusView showselectAreaRadiusViewFromVC:self.Vc.navigationController
                                                     distanceRadiusType:DistanceRadiusTypeEdit
                                                    areaRadiusDataArray:shipping_mentModel.radius_prices
                                                             doneHandle:^{
                                                                 STRONG
                                                                 [self.payShippingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                             }];
            
        } else if ([sef_code isEqualToString:@"shsm"]){
            //送货上门  -->>全国
            if (shipping_mentModel.area_text.count==0) {
                return ;
            }
            [YBLSelectAreaCollectionView showSelectAreaCollectionViewFromVC:self.Vc.navigationController areaData:shipping_mentModel.area_text doneHandle:^(NSMutableArray *new_array){
                STRONG
                [shipping_mentModel setValue:new_array forKey:@"area_text"];
                [self.payShippingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
        } else if ([sef_code isEqualToString:@"smzt"]) {
            //上门自提  --->>自提地址库
            if (shipping_mentModel.addresses.count==0) {
                return ;
            }
            [YBLSelectAddressView showSelectAddressViewFromVC:self.Vc.navigationController
                                                  addressData:shipping_mentModel.addresses
                                                 addressGenre:AddressGenreSelectZiti
                                                   doneHandle:^(YBLAddressModel *selectAddressModel){
                STRONG
                [self.payShippingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
//        else if ([shipping_mentModel.code isEqualToString:@"wlzt"]) {
//            //物流自提  -->>
//        }
    }];
#pragma mark itemButton  -->> select or  not select
    [[[cell.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        x.selected = !x.selected;
        [shipping_mentModel setValue:@(x.selected) forKey:@"is_select"];
        if (!x.selected) {
            shipping_mentModel.is_default = @(NO);
        }
        //handle data
        NSMutableArray *head_array = self.viewModel.allPaymentDataArray[section];
        if (shipping_mentModel.shipping_method.permit_payment_method_ids.count==0) {
//            //普通配送方式
//            for (YBLShowPayShippingsmentModel *pay_mentModel in head_array) {
//                if (pay_mentModel.payment_method.permit_shipping_method_ids.count>0&&pay_mentModel.is_default.boolValue) {
//                    pay_mentModel.is_default = @(NO);
//                }
//            }
//            
        } else {
            //相互配送方式
            for (NSString *permitID in shipping_mentModel.shipping_method.permit_payment_method_ids) {
                //遍历pay_data_array
                for (YBLShowPayShippingsmentModel *pay_mentModel in head_array) {
                    pay_mentModel.is_default = @(NO);
                    if ([pay_mentModel.payment_method.id isEqualToString:permitID]) {
                        pay_mentModel.is_select = shipping_mentModel.is_select;
                        pay_mentModel.is_default = shipping_mentModel.is_default;
                    }
                }
                
            }
            
        }
//        [self.payShippingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.payShippingTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }];

}



@end
