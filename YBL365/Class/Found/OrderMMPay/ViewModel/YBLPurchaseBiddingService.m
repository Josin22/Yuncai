//
//  YBLPurchaseBiddingService.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseBiddingService.h"
#import "YBLPurchaseBiddingVC.h"
#import "YBLPayWayViewController.h"
#import "YBLOrderAddressView.h"
#import "YBLOrderAddressViewController.h"
#import "YBLGoodParameterView.h"
#import "YBLEdictPurchaseViewModel.h"
#import "YBLPurchaseBiddingViewModel.h"
#import "YBLAddressModel.h"
#import "YBLPurchaseOutPriceRecordsViewModel.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLFoundTabBarViewController.h"
#import "YBLRechargeWalletsViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLPurchaseShowIPayShipMentView.h"
#import "YBLOpenCreditsViewController.h"
#import "YBLAllPayShipButtonView.h"
#import "YBLAddressViewModel.h"

@interface YBLPurchaseBiddingService ()

@property (nonatomic, weak  ) YBLPurchaseBiddingVC        *VC;
@property (nonatomic, strong) YBLPurchaseBiddingViewModel *viewModel;
@property (nonatomic, strong) YBLOrderAddressView         *addressView;
@property (nonatomic, retain) UILabel                     *paymentValueLabel;
@property (nonatomic, retain) UILabel                     *shippingmentValueLabel;
@property (nonatomic, strong) UIButton                    *saveButton;
@property (nonatomic, strong) UITextField                 *baojiaTextFeild;
@property (nonatomic, strong) UIScrollView                *scrollView;
@property (nonatomic, strong) UIView                      *section5View;
@property (nonatomic, strong) YBLAllPayShipButtonView     *allPayShipButtonsView;

@end

@implementation YBLPurchaseBiddingService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {

        _VC = (YBLPurchaseBiddingVC *)VC;
        _viewModel = (YBLPurchaseBiddingViewModel *)viewModel;
        
        [self createUI];
        
        self.baojiaTextFeild.placeholder = [NSString stringWithFormat:@"不得高于采购价 : ¥%.2f",self.viewModel.paraModel.price.doubleValue];
        
        WEAK
        //查询最低报价
        [[YBLPurchaseOutPriceRecordsViewModel signalForSearchCheapestWithOrderid:self.viewModel.paraModel._id] subscribeNext:^(YBLBidingRecordsModel *model) {
            STRONG
            [SVProgressHUD dismiss];
            self.viewModel.bidModel = model;
            
            if (model.bidding.count==0) {
                [self handleNewsPrice:self.viewModel.paraModel.price.doubleValue-0.01];
            } else {
                YBLPurchaseOrderModel *x = model.bidding[0];
                [self handleNewsPrice:x.price.doubleValue-0.01];
            }
            
            /**
             *  判断地址
             */
            self.viewModel.bidOrDefaultAddress = model.address;
            if (kStringIsEmpty(self.viewModel.bidOrDefaultAddress.id)) {
                //为空,请求默认地址
                [[YBLAddressViewModel siganlForAllAddress] subscribeNext:^(NSArray*  _Nullable x) {
                    if (x.count!=0) {
                        //驱魔人
                        self.viewModel.bidOrDefaultAddress = x[0];
                    }
                } error:^(NSError * _Nullable error) {
                    
                }];
                
            } else {
                [self updateAddress:self.viewModel.bidOrDefaultAddress isHidden:NO];
            }
            
        }];
        
        /*获取全部支付配送方式*/
        [[self.viewModel siganlForAllPurchaseInfos] subscribeError:^(NSError * _Nullable error) {
        } completed:^{
            STRONG
            [self createButtonsView];
        }];
    }
    return self;
}

- (void)updateAddress:(YBLAddressModel *)address isHidden:(BOOL)isHidden{
    
    YBLAddressModel *newAddress = [YBLAddressModel new];
    if (isHidden) {
        self.viewModel.paraModel.address_id = nil;
        newAddress.id = address.id;
        NSString *newName = [address.consignee_name substringFromIndex:address.consignee_name.length-1];
        newAddress.consignee_name  = [NSString stringWithFormat:@"***%@",newName];
        NSString *newPhone_left = [address.consignee_phone substringToIndex:2];
        NSString *newPhone_right = [address.consignee_phone substringFromIndex:address.consignee_phone.length-2];
        newAddress.consignee_phone  = [NSString stringWithFormat:@"%@***%@",newPhone_left,newPhone_right];
        newAddress.full_address = [NSString stringWithFormat:@"%@%@%@***",address.province_name,address.city_name,address.county_name];
        
    } else {
        self.viewModel.paraModel.address_id = address.id;
        newAddress = address;
    }
    [self.addressView updateAdressModel:newAddress];
    self.scrollView.top = self.addressView.bottom;
    self.scrollView.height = YBLWindowHeight-kNavigationbarHeight-self.addressView.bottom;
}


- (void)createUI{
    
    /*姓名地址*/
    YBLOrderAddressView *addressView = [[YBLOrderAddressView alloc] initWithFrame:CGRectMake(0, 0, self.VC.view.width, 75)];
    WEAK
    [[addressView.addressButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        YBLAddressViewModel *viewModel = [YBLAddressViewModel new];
        viewModel.addressViewBlock = ^(YBLAddressModel *selectModel){
            STRONG
            if (selectModel) {
                self.viewModel.isChooseFromAddressVC = YES;
                [self updateAddress:selectModel isHidden:NO];
                self.viewModel.purchaseDetailModel.address_info = selectModel;
            }
        };
        YBLOrderAddressViewController *addressVC = [[YBLOrderAddressViewController alloc] init];
        addressVC.viewModel = viewModel;
        [self.VC.navigationController pushViewController:addressVC animated:YES];
    }];
    [self.VC.view addSubview:addressView];
    self.addressView = addressView;

    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addressView.bottom, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight-self.addressView.bottom)];
    scrollView.backgroundColor = YBLViewBGColor;
    scrollView.showsVerticalScrollIndicator = NO;
    [_VC.view addSubview:scrollView];
    self.scrollView = scrollView;

    [scrollView addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, addressView.width, 4)]];
    
    /* 我的报价 */
    UIView *section3View = [[UIView alloc]initWithFrame:CGRectMake(0, 4, addressView.width, 45)];
    section3View.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:section3View];
    
    UILabel *baojiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 70, section3View.height)];
    [section3View addSubview:baojiaLabel];
    baojiaLabel.text = @"我的报价 :";
    baojiaLabel.textColor = BlackTextColor;
    baojiaLabel.font = YBLFont(14);
    
    UITextField *baojiaTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(baojiaLabel.right+3, 0, section3View.width-baojiaLabel.right-space, section3View.height)];
    baojiaTextFeild.borderStyle  = UITextBorderStyleNone;
    baojiaTextFeild.font = YBLFont(14);
    baojiaTextFeild.keyboardType = UIKeyboardTypeDecimalPad;
    baojiaTextFeild.textColor = YBLThemeColor;
    [section3View addSubview:baojiaTextFeild];
    [baojiaTextFeild.rac_textSignal subscribeNext:^(NSString *x) {
       STRONG
        self.viewModel.paraModel.out_price = @(x.doubleValue);
        [self.saveButton setTitle:[NSString stringWithFormat:@"同意并开始报价(%.2f)",x.doubleValue] forState:UIControlStateNormal];
    }];
    self.baojiaTextFeild = baojiaTextFeild;
    
    [section3View addSubview:[YBLMethodTools addLineView:CGRectMake(space, section3View.height-0.5, section3View.width-space, 0.5)]];
    
    /* 发货保证 */
    UIView *section4View = [[UIView alloc] initWithFrame:CGRectMake(0, section3View.bottom, section3View.width, section3View.height)];
    section4View.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:section4View];
    UILabel *fabaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, section4View.width, section4View.height)];
    [section4View addSubview:fabaoLabel];
    NSString *fabaoString =  [NSString stringWithFormat:@"发货保证金 : ¥%.2f元 总采购金额的5％",self.viewModel.paraModel.baozhengjinprice.doubleValue];;
    fabaoLabel.text = fabaoString;
    fabaoLabel.textColor = BlackTextColor;
    fabaoLabel.font = YBLFont(14);
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(YBLWindowWidth-30-space, 5, 30,20);
    moreButton.centerY = section4View.height/2;
    [moreButton setImage:[UIImage imageNamed:@"more_sandian"] forState:UIControlStateNormal];
    [section4View addSubview:moreButton];
    [[moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [YBLGoodParameterView showGoodParameterViewInViewController:self.VC.navigationController paraViewType:ParaViewTypePayRule withData:nil completetion:^{
            
        }];
    }];
    fabaoLabel.width = section4View.width-moreButton.width-space;
    [section4View addSubview:[YBLMethodTools addLineView:CGRectMake(space, section4View.height-0.5, section4View.width-space, 0.5)]];
    
    
    UIView *section5View = [[UIView alloc] initWithFrame:CGRectMake(0, section4View.bottom, section4View.width, 87)];
    section5View.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:section5View];
    
    UILabel *section5TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, section5View.width-2*space, 15)];
    section5TitleLabel.textColor = BlackTextColor;
    section5TitleLabel.font = YBLFont(13);
    section5TitleLabel.text = @"采购商支付、配送、时效范围";
    [section5View addSubview:section5TitleLabel];
    
    YBLPurchaseShowIPayShipMentView *allPayShipView = [[YBLPurchaseShowIPayShipMentView alloc] initWithFrame:CGRectMake(0, section5TitleLabel.bottom, section5View.width, section5View.height-section5TitleLabel.bottom)
                                                                                                showMentType:ShowMentTypeNoAspfit
                                                                                               textDataArray:self.viewModel.purchaseDetailModel.all_pay_ship_ment_titles];
    section5View.backgroundColor = scrollView.backgroundColor;
    allPayShipView.backgroundColor = scrollView.backgroundColor;
    [section5View addSubview:allPayShipView];
    self.section5View = section5View;

    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"同意并开始报价" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    saveButton.frame = CGRectMake(space, YBLWindowHeight-space-kNavigationbarHeight-buttonHeight, YBLWindowWidth-2*space, buttonHeight);
    [saveButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [saveButton setBackgroundColor:YBLThemeColorAlp(.5) forState:UIControlStateDisabled];
    saveButton.layer.cornerRadius = 3;
    saveButton.layer.masksToBounds = YES;
    [_VC.view addSubview:saveButton];
    self.saveButton = saveButton;
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        //0.判断是否选择
        if (self.allPayShipButtonsView.selectDataDict.count==0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有选择呢~~"];
            return ;
        }
        //1.判断是否开通VIP 信用通
        if ([YBLUserManageCenter shareInstance].userOpenedCreditType == UserOpenedCreditTypeNone) {
            
            NSString *titleShow = @"错误信息!";
            if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller) {
                
                titleShow = @"您还不是信用通用户,只有开通信用通才能参与报价 \n 前往开通?";
            } else {
                
                titleShow = @"您还不是VIP用户,只有开通VIP才能参与报价 \n 前往开通?";
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
        //2.
        [self.allPayShipButtonsView getFinalData];
        
        NSArray *idsArray = self.allPayShipButtonsView.paraPayShipIdsArray;
        self.viewModel.paraModel.paytype_id = idsArray[0];
        self.viewModel.paraModel.distribution_id = idsArray[1];;
        [SVProgressHUD showWithStatus:@"竞标中..."];
        
        [self requestBidding];

    }];
    
    /** rac **/
    RAC(saveButton,enabled) = [RACSignal combineLatest:@[
//                                                         RACObserve(self.viewModel.paraModel, address_id),
                                                         RACObserve(self.viewModel.paraModel, out_price),
                                                         RACObserve(self.viewModel.paraModel, price),
//                                                         RACObserve(self.viewModel.paraModel, paytype_id),
//                                                         RACObserve(self.viewModel,distribution_id),
                                                         ]
                                                reduce:^id(NSNumber *outPrice,NSNumber *price){
                                                    return @(outPrice.doubleValue>0&outPrice.doubleValue<price.doubleValue);
                                                }];

    
    
}

- (void)requestBidding{
    
    WEAK
    ///检查云币
    [[YBLEdictPurchaseViewModel signalBiddingForCheckGoldWith:self.viewModel.paraModel.baozhengjinprice.doubleValue] subscribeNext:^(YBLCheckGoldModel *checkModel) {
       STRONG
        if (checkModel.flag.boolValue) {
            //1云币足够
            [[self.viewModel purhcaseBiddingSignal] subscribeNext:^(id x) {
                STRONG
                [SVProgressHUD showSuccessWithStatus:@"竞标成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (![YBLMethodTools popToFoundVCFrom:self.VC]) {
                        [self.VC.navigationController popViewControllerAnimated:YES];
                    }
                });
            } error:^(NSError *error) {
            }];
        
        } else {
            [SVProgressHUD dismiss];
            
            [YBLOrderActionView showTitle:checkModel.less_show_text
                                   cancle:@"我再想想"
                                     sure:@"前往充值"
                          WithSubmitBlock:^{
                              YBLRechargeWalletsViewController *walletsVC = [YBLRechargeWalletsViewController new];
                              YBLNavigationViewController *bav = [[YBLNavigationViewController alloc] initWithRootViewController:walletsVC];
                              [self.VC presentViewController:bav animated:YES completion:nil];

                          }    cancelBlock:^{}];
        }
    }];
}

- (void)handleNewsPrice:(float)price{

    self.viewModel.paraModel.out_price = @(price);
    self.baojiaTextFeild.text = [NSString stringWithFormat:@"%.2f",self.viewModel.paraModel.out_price.doubleValue];
    [self.saveButton setTitle:[NSString stringWithFormat:@"同意并开始报价(%.2f)",price] forState:UIControlStateNormal];
}

- (void)createButtonsView {
    
    WEAK
    self.allPayShipButtonsView = [[YBLAllPayShipButtonView alloc] initWithFrame:CGRectMake(0, self.section5View.bottom, self.scrollView.width, 100)
                                                                      dataArray:self.viewModel.allPurchaseModel.filter_infos_data_array
                                                                     selectType:SelectTypeOneOfAll];
    /**
     *  回调调整高度
     */
    self.allPayShipButtonsView.allPayShipButtonViewUpdateHeightBlock = ^{
        STRONG
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.allPayShipButtonsView.bottom+space*2+buttonHeight);
    };
    /**
     *  支付方式按钮点击
     */
    self.allPayShipButtonsView.allPayShipButtonViewClickBlock = ^(YBLPurchaseInfosModel *infoModel) {
        STRONG
        //非点击状态  ==>>显示xiaob
        if (!infoModel) {
            self.addressView.userInteractionEnabled = YES;
            [self updateAddress:self.viewModel.bidModel.address isHidden:NO];
        } else {
            //点击
            if ([infoModel.code isEqualToString:@"fkzt"]&&!self.viewModel.isChooseFromAddressVC) {
                [self updateAddress:self.viewModel.bidOrDefaultAddress isHidden:NO];
                self.addressView.userInteractionEnabled = YES;
            } else {
                self.addressView.userInteractionEnabled = NO;
                self.viewModel.isChooseFromAddressVC = NO;
                [self updateAddress:self.viewModel.bidModel.purchase_order.address_info isHidden:YES];
            }
        }
    };
    
    [self.scrollView addSubview:self.allPayShipButtonsView];
}

@end
