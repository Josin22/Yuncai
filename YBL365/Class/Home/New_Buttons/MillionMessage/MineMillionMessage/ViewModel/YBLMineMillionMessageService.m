//
//  YBLMineMillionMessageService.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMineMillionMessageService.h"
#import "YBLMineMillionMessageViewModel.h"
#import "YBLMineMillionMessageViewController.h"
#import "YBLMillionMessageTypeView.h"
#import "YBLMillionMessageTableView.h"
#import "YBLChooseCityView.h"
#import "YBLMineMillionMessageItemModel.h"
#import "YBLBriberyHudToCertificatedView.h"
#import "YBLIndustryScaleViewController.h"
#import "YBLTheResultViewController.h"
#import "YBLOpenCreditsViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLRechargeWalletsViewController.h"
#import "YBLMillionMessageSelectBar.h"
#import "YBLSendMessageViewController.h"
#import "YBLSendMessageTools.h"
#import "WXApi.h"
#import "YBLMessageDetailViewController.h"

@interface YBLMineMillionMessageService ()<YBLTableViewDelegate,YBLMillionMessageTypeDelegate>
{
    UIButton *_cityButton;
}
@property (nonatomic, weak  ) YBLMineMillionMessageViewModel *viewModel;

@property (nonatomic, weak  ) YBLMineMillionMessageViewController *selfVc;

@property (nonatomic, strong) YBLMillionMessageTypeView *headerTypeView;

@property (nonatomic, strong) YBLMillionMessageTableView *millionTabelView;

@property (nonatomic, strong) YBLMillionMessageSelectBar *messageBar;

@end

@implementation YBLMineMillionMessageService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        self.viewModel = (YBLMineMillionMessageViewModel *)viewModel;
        self.selfVc = (YBLMineMillionMessageViewController *)VC;
        
        [self requestDataIsReload:YES];
        
        if (self.viewModel.millionType != MillionTypeSelect) {
            _cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _cityButton.frame = CGRectMake(0, 0, 80, 30);
            [_cityButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
            [_cityButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            _cityButton.titleLabel.font = YBLFont(14);
            if (self.viewModel.millionType == MillionTypeMine) {
                [_cityButton setTitle:@"通知" forState:UIControlStateNormal];
            } else {
                [_cityButton setTitle:@"全部" forState:UIControlStateNormal];
            }
            WEAK
            [[_cityButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                STRONG
                if (self.viewModel.millionType == MillionTypeMine) {
                    //通知
                    [self pushSendMessageWithData:nil];
                } else {
                    //城市
                    [YBLChooseCityView chooseCityWithViewController:self.selfVc.navigationController
                                                          cityCount:2
                                                       cityViewType:ChooseCityViewTypeWithDismissButton
                                                       successBlock:^(YBLAddressAreaModel *model, NSMutableArray *selectArray) {
                                                           STRONG
                                                           [_cityButton setTitle:model.text forState:UIControlStateNormal];
                                                           self.viewModel.city = [NSString stringWithFormat:@"%@",model.id];
                                                           [self requestDataIsReload:YES];
                                                       }];

                }
            }];
            self.selfVc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cityButton];
        } else {
//            self.messageBar.hidden = NO;
        }
    
    }
    return self;
}

- (void)pushSendMessageWithData:(NSArray *)data{
    YBLSendMessageViewController *sendMessageVc = [YBLSendMessageViewController new];
    if (data.count!=0) {
        sendMessageVc.customers = data.mutableCopy;
    }
    [self.selfVc.navigationController pushViewController:sendMessageVc animated:YES];
}

- (void)reset{
    self.viewModel.city = nil;
    self.viewModel.genre = nil;
    if (self.viewModel.millionType == MillionTypeMine) {
        [_cityButton setTitle:@"通知" forState:UIControlStateNormal];
    } else {
        [_cityButton setTitle:@"全部" forState:UIControlStateNormal];
    }
}

- (YBLMillionMessageSelectBar *)messageBar{
    if (!_messageBar) {
        _messageBar = [[YBLMillionMessageSelectBar alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kBottomBarHeight)];
        _messageBar.bottom = YBLWindowHeight-kNavigationbarHeight;
        WEAK
        [[_messageBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            x.selected = !x.selected;
            __block NSInteger selectCount = 0;
            [self.viewModel.singleDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YBLMineMillionMessageItemModel *model = (YBLMineMillionMessageItemModel *)obj;
                if (idx<100) {
                    //100内
                    model.is_select = @(x.selected);
                } else {
                    model.is_select = @(NO);
                }
                if (model.is_select.boolValue) {
                    selectCount++;
                }
            }];
            [self.millionTabelView reloadData];
            self.messageBar.selectCount = selectCount;
        }];;
        [[_messageBar.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            NSInteger selectCount = [self.viewModel caculateSelectCount];
//            if (selectCount==0) {
//                [SVProgressHUD showErrorWithStatus:@"您还没有选择客户哟~"];
//                return ;
//            }
            BLOCK_EXEC(self.viewModel.selectBlock,[self.viewModel getSelectCustomerArray])
            [self.selfVc.navigationController popViewControllerAnimated:YES];
        }];
        _messageBar.selectCount = self.viewModel.selectCustomerArray.count;
    }
    return _messageBar;
}

- (YBLMillionMessageTableView *)millionTabelView{
    if (!_millionTabelView) {
        _millionTabelView = [[YBLMillionMessageTableView alloc] initWithFrame:[self.selfVc.view bounds]
                                                                            style:UITableViewStyleGrouped
                                                                      millionType:self.viewModel.millionType];
        _millionTabelView.ybl_delegate = self;
        _millionTabelView.dataArray = @[@"1"].mutableCopy;
        [self.selfVc.view addSubview:_millionTabelView];
        if (self.viewModel.millionType == MillionTypeSelect) {
            [self.selfVc.view addSubview:self.messageBar];
        }
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_millionTabelView  completion:^{
            STRONG
            [self reset];
            [self requestDataIsReload:YES];
        }];
        _millionTabelView.prestrainBlock = ^{
            STRONG
            if ([self.viewModel isSatisfyLoadMoreRequest]) {
                [self requestDataIsReload:NO];
            }
        };
        self.headerTypeView = [[YBLMillionMessageTypeView alloc] initWithFrame:CGRectMake(0, 0, self.millionTabelView.width, 200)];
        self.headerTypeView.delegate = self;
        _millionTabelView.tableHeaderView = self.headerTypeView;
    }
    return _millionTabelView;
}

- (void)requestDataIsReload:(BOOL)isReload{
    
    WEAK
    [[self.viewModel signalForMillionCoustomersIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.millionTabelView.mj_header endRefreshing];
        self.millionTabelView.milionDataArray = self.viewModel.singleDataArray;
        [self.millionTabelView jsInsertRowIndexps:x];
        
    } error:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)millionMessageItemClickModel:(YBLMillionMessageTypeItemModel *)clickModel{
    
    self.viewModel.genre = clickModel.itemImage;
    [self requestDataIsReload:YES];
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLMineMillionMessageItemModel *model = (YBLMineMillionMessageItemModel *)selectValue;
    if (self.viewModel.millionType == MillionTypeMine) {
        WEAK
        [YBLActionSheetView showActionSheetWithTitles:@[@"发送短信",
                                                        @"添加微信好友",
                                                        @"添加联系人",
                                                        @"拨打电话",]
                                          handleClick:^(NSInteger index) {
                                              STRONG
                                              switch (index) {
                                                  case 0:
                                                  {
                                                      [self pushSendMessageWithData:@[model]];
                                                  }
                                                      break;
                                                  case 1:
                                                  {
                                                      [YBLMethodTools copyString:model.mobile];
                                                      [SVProgressHUD showSuccessWithStatus:@"已复制手机号~"];
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          if ([WXApi isWXAppInstalled]) {
                                                              [WXApi openWXApp];
                                                          } else {
                                                              [SVProgressHUD showInfoWithStatus:@"您还没有安装微信哟~"];
                                                          }
                                                      });
                                                  }
                                                      break;
                                                  case 2:
                                                  {
                                                      NSString *fullName = [NSString stringWithFormat:@"%@-%@",model.shopname,model.name];
                                                      [YBLSendMessageTools creatContactName:fullName phone:model.mobile address:model.street_address];
                                                  }
                                                      break;
                                                  case 3:
                                                  {
                                                      [YBLMethodTools callWithNumber:model.mobile];
                                                  }
                                                      break;
                                                  case 4:
                                                  {
                                                      YBLMessageDetailViewModel *viewModel = [YBLMessageDetailViewModel new];
                                                      viewModel.model = model;
                                                      YBLMessageDetailViewController *messageVc = [YBLMessageDetailViewController new];
                                                      messageVc.viewModel = viewModel;
                                                      [self.selfVc.navigationController pushViewController:messageVc animated:YES];
                                                  }
                                                      break;
                                                  default:
                                                      break;
                                              }
                                          }];
        
    } else if (self.viewModel.millionType==MillionTypeSelect) {
        //选择
        [self resetModel:model currentIndexps:indexPath];
    }
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    WEAK
    YBLMineMillionMessageItemModel *model = (YBLMineMillionMessageItemModel *)selectValue;
    if (self.viewModel.millionType==MillionTypePublic) {
 
        if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller&&[YBLUserManageCenter shareInstance].aasmState == AasmStateApproved) {
            
            //
            [[self.viewModel signalForMillionCustomersId:model.id isFoucs:model.binded.boolValue] subscribeNext:^(id  _Nullable x) {
                STRONG
                if ([x isKindOfClass:[NSNumber class]]) {
                    //充值
                    [YBLBriberyHudToCertificatedView showRechargeYunMoneyHudViewWithBlock:^(NSInteger clickIndex) {
                        STRONG
                        switch (clickIndex) {
                            case 0:
                            {
                                YBLRechargeWalletsViewController *walletsVC = [YBLRechargeWalletsViewController new];
                                YBLNavigationViewController *bav = [[YBLNavigationViewController alloc] initWithRootViewController:walletsVC];
                                [self.selfVc presentViewController:bav animated:YES completion:nil];
                            }
                                break;
                            case 1:
                            {
                                YBLOpenCreditsViewController *creditsVC = [YBLOpenCreditsViewController new];
                                [self.selfVc.navigationController pushViewController:creditsVC animated:YES];
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }];
                } else {
                    model.binded = @(!model.binded.boolValue);
                    model.mobile = x[@"mobile"];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.millionTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            } error:^(NSError * _Nullable error) {
                
            }];
        } else {
            //认证
            [self.millionTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [YBLOrderActionView showTitle:@"您还不是认证的供应商无法参与关注商业伙伴\n请认证平台供应商后再来关注"
                                   cancle:@"返回"
                                     sure:@"我要认证"
                          WithSubmitBlock:^{
                              
                              id classVC;
                              if ([YBLUserManageCenter shareInstance].aasmState == AasmStateUnknown||[YBLUserManageCenter shareInstance].aasmState == AasmStateInitial) {
                                  
                                  YBLIndustryScaleViewController *indusVC = [YBLIndustryScaleViewController new];
                                  indusVC.currentType = user_type_seller_key;
                                  classVC = indusVC;
                                  
                              } else {
                                  
                                  YBLTheResultViewController *resultVC = [YBLTheResultViewController new];
                                  classVC = resultVC;
                              }
                              [self.selfVc.navigationController pushViewController:classVC animated:YES];
                          }
                              cancelBlock:^{
                                  [self.selfVc.navigationController popViewControllerAnimated:YES];
                              }];
        }
    } else if (self.viewModel.millionType==MillionTypeSelect) {
        //选择
        [self resetModel:model currentIndexps:indexPath];
    } else if (self.viewModel.millionType==MillionTypeMine) {
        YBLMessageDetailViewModel *viewModel = [YBLMessageDetailViewModel new];
        viewModel.model = model;
        YBLMessageDetailViewController *messageVc = [YBLMessageDetailViewController new];
        messageVc.viewModel = viewModel;
        [self.selfVc.navigationController pushViewController:messageVc animated:YES];
    }
}

- (void)resetModel:(YBLMineMillionMessageItemModel *)model currentIndexps:(NSIndexPath *)currentIndexps{
    model.is_select = @(!model.is_select.boolValue);
    NSInteger selectCount = [self.viewModel caculateSelectCount];
    if (selectCount>100) {
        [SVProgressHUD showWithStatus:@"最大选择数量为100哟~"];
        model.is_select = @(NO);
        return;
    }
    [self.millionTabelView reloadRowsAtIndexPaths:@[currentIndexps] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.messageBar.selectCount = selectCount;
}

@end
