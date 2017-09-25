//
//  YBLEditPurchaseService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPurchaseService.h"
#import "YBLEditPurchaseViewController.h"
#import "YBLEditPurchaseCell.h"
#import "YBLEditPurchaseHeaderView.h"
#import "ZJUsefulPickerView.h"
#import "YBLEditPurchaseSingleView.h"
#import "YBLEditPurchaseTableView.h"
#import "YBLRechargeWalletsViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLOpenCreditsViewController.h"
#import "YBLOrderMMGoodsDetailBar.h"
#import "YBLpurchaseInfosModel.h"
#import "ZJUsefulPickerView.h"
#import "YBLChooseCityView.h"
#import "YBLEditPurchaseViewController.h"
#import "YBLEditPurchaseSingleView.h"
#import "YBLEditPurchasePayShippingmentView.h"
#import "YBLOrderAddressViewController.h"
#import "YBLGoodParameterView.h"
#import "YBLEditPurchaseCell.h"

@interface YBLEditPurchaseService ()

@property (nonatomic, weak) YBLEditPurchaseViewController *VC;

@property (nonatomic, strong) YBLEdictPurchaseViewModel *viewModel;

@property (nonatomic, strong) YBLEditPurchaseTableView *editPurchaseTableView;

@property (nonatomic, strong) YBLOrderMMGoodsDetailBar *editBar;

@end

@implementation YBLEditPurchaseService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLEditPurchaseViewController *)VC;
        _viewModel = (YBLEdictPurchaseViewModel *)viewModel;
        
        [_VC.view addSubview:self.editPurchaseTableView];
        
        /* 保存 */
        /*
        UIButton *saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-kNavigationbarHeight-buttonHeight-space, YBLWindowWidth-space*2, buttonHeight)];
        [saveButton setTitle:@"保存并发布" forState:UIControlStateDisabled];
        [saveButton setTitle:@"保存并发布" forState:UIControlStateNormal];
        WEAK
        [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            
            if ([self.viewModel isDoneAction]) {
                //发布保存
                //1.判断是否开通VIP 信用通
                if ([YBLUserManageCenter shareInstance].userOpenedCreditType == UserOpenedCreditTypeNone) {
                    
                    NSString *titleShow = @"错误信息!";
                    if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller) {
                        
                        titleShow = @"您还不是信用通用户,只有开通信用通才能发布采购订单 \n 前往开通?";
                    } else {
                        
                        titleShow = @"您还不是VIP用户,只有开通VIP才能发布采购订单 \n 前往开通?";
                    }
                    [YBLOrderActionView showTitle:titleShow
                                           cancle:@"我再想想"
                                             sure:@"立即开通"
                                  WithSubmitBlock:^{

                                      YBLOpenCreditsViewController *creditsVC = [YBLOpenCreditsViewController new];
                                      [self.VC.navigationController pushViewController:creditsVC animated:YES];
                                  }
                                      cancelBlock:^{
                                          
                                      }];
                    return ;
                }
                self.saveButton.enabled = NO;
                //2.判断云币是否足够
                [[self.viewModel signalForCheckGold] subscribeNext:^(YBLCheckGoldModel *checkModel) {
                    STRONG
                    self.saveButton.enabled = YES;
                    //3.发布
                    if (checkModel.flag.boolValue) {
                        [[self.viewModel signalForSavePurchaseOrder] subscribeNext:^(id x) {
                            [SVProgressHUD dismiss];
                            STRONG
                            [YBLOrderActionView showTitle:@"采购订单发布成功~"
                                                   cancle:@"继续编辑采购"
                                                     sure:@"查看采购详情"
                                          WithSubmitBlock:^{
                                              //采购详情
                                              YBLPurchaseGoodDetailViewModel *found_viewModel = [YBLPurchaseGoodDetailViewModel new];
                                              found_viewModel.purchaseDetailModel = (YBLPurchaseOrderModel *)x;
                                              found_viewModel.purchaseDetailPushType = PurchaseDetailPushTypeSepacial;
                                              YBLPurchaseGoodsDetailVC *detailvc = [YBLPurchaseGoodsDetailVC new];
                                              detailvc.viewModel = found_viewModel;
                                              [self.VC.navigationController pushViewController:detailvc animated:YES];
                                              
                                          } cancelBlock:^{
                                              //继续采购
                                              [self.VC.navigationController popViewControllerAnimated:YES];
                                              
                                          }];
                        } error:^(NSError *error) {
                        }];
                    } else {
                        //2.云币不足,去充值
                        //2.云币不足,去充值
                        [YBLOrderActionView showTitle:checkModel.less_show_text
                                               cancle:@"我再想想"
                                                 sure:@"立即充值"
                                      WithSubmitBlock:^{
                                          YBLRechargeWalletsViewController *walletsVC = [YBLRechargeWalletsViewController new];
                                          YBLNavigationViewController *bav = [[YBLNavigationViewController alloc] initWithRootViewController:walletsVC];
                                          [self.VC presentViewController:bav animated:YES completion:nil];
                                      }
                                          cancelBlock:^{}];
               
                    }
                    
                } error:^(NSError *error) {
                    self.saveButton.enabled = YES;
                }];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"您还没有填写完整哟~"];
            }
        }];
        */
        [_VC.view addSubview:self.editBar];
        self.editBar.userInteractionEnabled = NO;
        /*rac*/
        [[self.viewModel signalForPurchaseProduct] subscribeError:^(NSError *error) {
        } completed:^{
            self.editBar.userInteractionEnabled = YES;
            [self.editPurchaseTableView updateCellDataArray:self.viewModel.cellDataArray goodModel:self.viewModel.goodModel];
        }];
    }
    return self;
}

- (YBLOrderMMGoodsDetailBar *)editBar{
    if (!_editBar) {
        _editBar = [[YBLOrderMMGoodsDetailBar alloc] initWithFrame:CGRectMake(0, YBLWindowHeight-kNavigationbarHeight-buttonHeight, YBLWindowWidth, buttonHeight)
                                         purchaseGoddDetailBarType:PurchaseGoddDetailBarTypeEdit];
        WEAK
        [[_editBar.qiangButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            if ([self.viewModel isDoneAction]) {
                //发布保存
                //0.判断是否认证
                if ([YBLUserManageCenter shareInstance].aasmState != AasmStateApproved) {
                    
                    [YBLOrderActionView showTitle:@"您还是不认证用户,需要您去认证才能继续发布 \n 前往认证?"
                                           cancle:@"我想想"
                                             sure:@"立即认证"
                                  WithSubmitBlock:^{
                                      [YBLMethodTools popToHomeBarFromEditPurchaseVC:self.VC];
                                  }
                                      cancelBlock:^{}];
                    
                    return ;
                }
                
                //1.判断是否开通VIP 信用通
                if ([YBLUserManageCenter shareInstance].userOpenedCreditType == UserOpenedCreditTypeNone) {
                    NSString *titleShow = @"错误信息!";
                    if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller) {
                        
                        titleShow = @"您还不是信用通用户,只有开通信用通\n才能发布采购 前往开通?";
                    } else {
                        
                        titleShow = @"您还不是VIP用户,只有开通VIP\n才能发布采购 前往开通?";
                    }
                    [YBLOrderActionView showTitle:titleShow
                                           cancle:@"我再想想"
                                             sure:@"立即开通"
                                  WithSubmitBlock:^{
                                      
                                      YBLOpenCreditsViewController *creditsVC = [YBLOpenCreditsViewController new];
                                      [self.VC.navigationController pushViewController:creditsVC animated:YES];
                                  }
                                      cancelBlock:^{
                                          
                                      }];
                    return ;
                }
                self.editBar.userInteractionEnabled = NO;
                //2.判断云币是否足够
                [[self.viewModel signalForCheckGold] subscribeNext:^(YBLCheckGoldModel *checkModel) {
                    STRONG
                    self.editBar.userInteractionEnabled = YES;
                    //3.发布
                    if (checkModel.flag.boolValue) {
                        [[self.viewModel signalForSavePurchaseOrder] subscribeNext:^(id x) {
                            [SVProgressHUD dismiss];
                            STRONG
                            [YBLOrderActionView showTitle:@"发布采购成功~"
                                                   cancle:@"返回"
                                                     sure:@"查看采购详情"
                                          WithSubmitBlock:^{
                                              //采购详情
                                              YBLPurchaseGoodDetailViewModel *found_viewModel = [YBLPurchaseGoodDetailViewModel new];
                                              found_viewModel.purchaseDetailModel = (YBLPurchaseOrderModel *)x;
                                              found_viewModel.purchaseDetailPushType = PurchaseDetailPushTypeSepacial;
                                              YBLPurchaseGoodsDetailVC *detailvc = [YBLPurchaseGoodsDetailVC new];
                                              detailvc.viewModel = found_viewModel;
                                              [self.VC.navigationController pushViewController:detailvc animated:YES];
                                              
                                          } cancelBlock:^{
                                              //继续采购
                                              [self.VC.navigationController popViewControllerAnimated:YES];
                                              
                                          }];
                        } error:^(NSError *error) {
                        }];
                    } else {
                        //2.云币不足,去充值
                        //2.云币不足,去充值
                        [YBLOrderActionView showTitle:checkModel.less_show_text
                                               cancle:@"我再想想"
                                                 sure:@"立即充值"
                                      WithSubmitBlock:^{
                                          YBLRechargeWalletsViewController *walletsVC = [YBLRechargeWalletsViewController new];
                                          YBLNavigationViewController *bav = [[YBLNavigationViewController alloc] initWithRootViewController:walletsVC];
                                          [self.VC presentViewController:bav animated:YES completion:nil];
                                      }
                                          cancelBlock:^{}];
                        
                    }
                    
                } error:^(NSError *error) {
                    self.editBar.userInteractionEnabled = YES;
                }];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"您还没有填写完整哟~"];
            }
        }];

    }
    return _editBar;
}

#pragma mark - lazy load view

- (YBLEditPurchaseTableView *)editPurchaseTableView{
    
    if (!_editPurchaseTableView) {
        _editPurchaseTableView = [[YBLEditPurchaseTableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) style:UITableViewStylePlain];
        WEAK
        
        _editPurchaseTableView.editPurchaseTableViewCellBlock = ^(YBLEditPurchaseCell *cell, YBLEditItemGoodParaModel *paraModel,NSIndexPath *indexPath) {
            STRONG
            NSInteger row = indexPath.row;
            if (row == 3||row == 4) {
                cell.valueTextFeild.keyboardType = UIKeyboardTypeDecimalPad;
            }
            [[cell.valueTextFeild.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
                NSArray *chooseArray = @[@"price",@"quantity"];
                for (NSString *chooseKey in chooseArray) {
                    if ([paraModel.paraString isEqualToString:chooseKey]) {
                        [paraModel setValue:x forKey:@"value"];
                        [paraModel setValue:x forKey:@"paraValueString"];
                    }
                }
                //计算保证金
                float deposit =  [self.viewModel calculateFinalDepositMoney];
                self.editBar.priceValue = deposit;
            }];
            [[[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                STRONG
                [self.editPurchaseTableView endEditing:YES];
                
                NSArray *chooseArray = @[@"purchase_time_id",@"sell_shelf_lifes_id"];
                for (NSString *chooseKey in chooseArray) {
                    if ([paraModel.paraString isEqualToString:chooseKey]) {
                        NSInteger type = 1;
                        if ([chooseKey isEqualToString:@"purchase_time_id"]) {
                            type = 1;
                        } else if ([chooseKey isEqualToString:@"sell_shelf_lifes_id"]) {
                            type = 4;
                        }
                        [[self.viewModel signalForPurchaseinfosWithType:type] subscribeNext:^(NSArray *x) {
                            NSMutableArray *nameArray = [NSMutableArray array];
                            for (YBLPurchaseInfosModel *model in x) {
                                [nameArray addObject:model.title];
                            }
                            [ZJUsefulPickerView showSingleColPickerWithToolBarText:paraModel.title
                                                                          withData:nameArray
                                                                  withDefaultIndex:0
                                                                 withCancelHandler:^{
                                                                 }
                                                                   withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                                                                       STRONG
                                                                       [paraModel setValue:selectedValue forKey:@"value"];
                                                                       YBLPurchaseInfosModel *selectModel = x[selectedIndex];
                                                                       [paraModel setValue:selectModel._id forKey:@"paraValueString"];
                                                                       [self.editPurchaseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                   }];
                        } error:^(NSError *error) {
                        }];
                    }
                }
                NSArray *choose_1Array = @[@"title",@"specification",@"qrcode"];
                for (NSString *chooseKey1 in choose_1Array) {
                    if ([paraModel.paraString isEqualToString:chooseKey1]) {
                        WEAK
                        [[self.viewModel signalForPurchaseOtherInfoWithType:(row)] subscribeNext:^(NSMutableArray *x) {
                            STRONG
                            [x addObject:paraModel.value];
                            [YBLEditPurchaseSingleView showEditPurchaseSingleViewInVC:self.VC.navigationController
                                                                                 Data:x
                                                                                 Type:row
                                                                               Handle:^(NSString *selectValue) {
                                                                                   [paraModel setValue:selectValue forKey:@"value"];
                                                                                   [paraModel setValue:selectValue forKey:@"paraValueString"];
                                                                                   [self.editPurchaseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                               }];
                            
                        } error:^(NSError *error) {
                            
                        }];
                        
                    }
                    
                }
                if ([paraModel.paraString isEqualToString:@"paytype"]) {
                    //5.支付方式  6.配送方式
                    [[self.viewModel siganlForAllPayShipingMent] subscribeError:^(NSError * _Nullable error) {
                    } completed:^{
                        STRONG
                        [YBLEditPurchasePayShippingmentView showEditPurchasePayShippingmentViewInVC:self.VC.navigationController
                                                                                       undefineData:self.viewModel.allPayShipModel.filter_infos_data_array
                                                                                             Handle:^(NSString *selectValue,NSMutableArray *selectIDArray) {
                                                                                                 STRONG
                                                                                                 [paraModel setValue:selectValue forKey:@"value"];
                                                                                                 [paraModel setValue:selectIDArray forKey:@"undefineValue"];
                                                                                                 [self.editPurchaseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                                             }];
                        
                    }];
                }
                if ([paraModel.paraString isEqualToString:@"address_id"]) {
                    //地址
                    YBLAddressViewModel *viewModel = [YBLAddressViewModel new];
                    viewModel.addressViewBlock = ^(YBLAddressModel *selectModel){
                        STRONG
                        [paraModel setValue:selectModel.full_address forKey:@"value"];
                        [paraModel setValue:selectModel.id forKey:@"paraValueString"];
                        [self.editPurchaseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    };
                    YBLOrderAddressViewController *addressVC = [[YBLOrderAddressViewController alloc] init];
                    addressVC.viewModel = viewModel;
                    [self.VC.navigationController pushViewController:addressVC animated:YES];
                    
                }
                
                if ([paraModel.paraString isEqualToString:@"unit"]) {
                    
                    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"单位"
                                                                  withData:@[@"箱",@"桶",@"袋",@"盒",@"瓶",@"坛",@"包",@"件",@"台",@"筐",@"罐",@"饼",@"听",@"支",@"个",@"双",@"部",@"架",@"本",@"条",@"捆",@"卷",@"批",@"块",@"套",@"头",@"只",@"碗",@"片",@"斤",@"公斤",@"克",@"千克",@"提"]
                                                          withDefaultIndex:0
                                                         withCancelHandler:^{
                                                             
                                                         }
                                                           withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                                                               STRONG
                                                               [paraModel setValue:selectedValue forKey:@"value"];
                                                               [paraModel setValue:selectedValue forKey:@"paraValueString"];
                                                               [self.editPurchaseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                           }];
                    
                    
                }
                
                if ([paraModel.paraString isEqualToString:@"rule_id"]) {
                    [YBLGoodParameterView showGoodParameterViewInViewController:self.VC.navigationController
                                                                   paraViewType:ParaViewTypeEditPayRule
                                                                       withData:nil
                                                                   completetion:^{}];
                }
            }];
            cell.arrowButton.enabled = NO;
        };
        
    }
    return _editPurchaseTableView;
}

@end
