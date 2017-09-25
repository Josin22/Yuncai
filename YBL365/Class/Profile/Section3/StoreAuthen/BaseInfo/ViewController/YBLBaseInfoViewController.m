//
//  YBLBaseInfoViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseInfoViewController.h"
#import "YBLTheResultViewController.h"
#import "YBLAddBankCardViewController.h"
#import "YBLChooseCityView.h"
#import "YBLUserInfosParaModel.h"
#import "YBLBMLocationViewController.h"
#import "YBLNavigationViewController.h"

@interface YBLBaseInfoViewController ()<UIScrollViewDelegate>

@end

@implementation YBLBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基本信息";
    
    self.navigationItem.rightBarButtonItem = self.nextButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
}

- (void)createUI{
    
    CGFloat itemHi = 44;
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.alwaysBounceVertical = YES;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    [self.view addSubview:self.contentScrollView];
    
    /* 店铺名称 */
    UIView *storeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentScrollView.width, itemHi)];
    [self.contentScrollView addSubview:storeBgView];
    UILabel *storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 70, itemHi)];
    storeNameLabel.text = @"店铺名称:";
    storeNameLabel.textColor = BlackTextColor;
    storeNameLabel.font = YBLFont(14);
    [storeBgView addSubview:storeNameLabel];
    self.storeNameLabel = storeNameLabel;
    
    XXTextField *storeNameTextFeild = [[XXTextField alloc] initWithFrame:CGRectMake(storeNameLabel.right, storeNameLabel.top, storeBgView.width-storeNameLabel.right, storeNameLabel.height)];
    storeNameTextFeild.borderStyle = UITextBorderStyleNone;
    storeNameTextFeild.placeholder = @"请输入店铺名称";
    storeNameTextFeild.maxLength = maxLength_for_storename;
    storeNameTextFeild.textColor = BlackTextColor;
    storeNameTextFeild.font = YBLFont(14);
    [storeBgView addSubview:storeNameTextFeild];
    self.storeNameTextFeild = storeNameTextFeild;
    
    [storeBgView addSubview:[YBLMethodTools addLineView:CGRectMake(0, storeBgView.height-0.5, storeBgView.width, 0.5)]];;
    [storeBgView addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, storeBgView.width, 0.5)]];;
    
    /* 联系人 */
    UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(storeBgView.left, storeBgView.bottom, storeBgView.width, storeBgView.height)];
    [self.contentScrollView addSubview:contactView];
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, storeNameLabel.width, contactView.height)];
    contactLabel.text = @"联  系  人:";
    contactLabel.textColor = BlackTextColor;
    contactLabel.font = YBLFont(14);
    [contactView addSubview:contactLabel];
    self.contactLabel = contactLabel;
    
    XXTextField *contactTextFeild = [[XXTextField alloc] initWithFrame:CGRectMake(contactLabel.right, contactLabel.top, contactView.width-contactLabel.right, contactLabel.height)];
    contactTextFeild.borderStyle = UITextBorderStyleNone;
    contactTextFeild.placeholder = @"请输入联系人";
    contactTextFeild.textColor = BlackTextColor;
    contactTextFeild.maxLength = limit_for_name;
    contactTextFeild.font = YBLFont(14);
    [contactView addSubview:contactTextFeild];
    self.contactTextFeild = contactTextFeild;
    
    [contactView addSubview:[YBLMethodTools addLineView:CGRectMake(0, contactView.height-0.5, contactView.width, 0.5)]];;
  
    ///地址
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(contactView.left,contactView.bottom,contactView.width,contactView.height)];
    [self.contentScrollView addSubview:addressView];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, storeNameLabel.width, addressView.height)];
    addressLabel.text = @"所在地区:";
    addressLabel.textColor = BlackTextColor;
    addressLabel.font = YBLFont(14);
    [addressView addSubview:addressLabel];
    
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addressButton.frame = CGRectMake(addressLabel.right, addressLabel.top, addressView.width-addressLabel.right, addressLabel.height);
    [addressButton setTitle:@"请选择地址" forState:UIControlStateNormal];
    [addressButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    addressButton.titleLabel.font = YBLFont(14);
    [addressButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [addressButton setImage:[UIImage imageNamed:@"found_arrow"] forState:UIControlStateNormal];
    [addressButton setTitleRect:CGRectMake(0, 0, self.contentScrollView.width-addressLabel.right-8-space-5, addressLabel.height)];
    [addressButton setImageRect:CGRectMake(self.contentScrollView.width-addressLabel.right-8-space, 17, 8, 16)];
    [addressButton addTarget:self action:@selector(showAdrressView:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:addressButton];
    self.addressButton = addressButton;
    
    [addressView addSubview:[YBLMethodTools addLineView:CGRectMake(0, addressView.height-0.5, addressView.width, 0.5)]];
   
#pragma mark  街道地址
    
    UIView *jiedao_addressView = [[UIView alloc] initWithFrame:CGRectMake(addressView.left,addressView.bottom,addressView.width,addressView.height)];
    [self.contentScrollView addSubview:jiedao_addressView];
    UILabel *jiedao_addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, storeNameLabel.width, jiedao_addressView.height)];
    jiedao_addressLabel.text = @"街道地址:";
    jiedao_addressLabel.textColor = BlackTextColor;
    jiedao_addressLabel.font = YBLFont(14);
    [jiedao_addressView addSubview:jiedao_addressLabel];
    
    UIButton *jiedao_addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jiedao_addressButton.frame = CGRectMake(jiedao_addressLabel.right, jiedao_addressLabel.top, jiedao_addressView.width-jiedao_addressLabel.right, jiedao_addressLabel.height);
    [jiedao_addressButton setTitle:@"请选择街道地址" forState:UIControlStateNormal];
    [jiedao_addressButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    jiedao_addressButton.titleLabel.font = YBLFont(14);
    [jiedao_addressButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [jiedao_addressButton setImage:[UIImage imageNamed:@"found_arrow"] forState:UIControlStateNormal];
    [jiedao_addressButton setTitleRect:CGRectMake(0, 0, self.contentScrollView.width-jiedao_addressLabel.right-8-space-5, jiedao_addressLabel.height)];
    [jiedao_addressButton setImageRect:CGRectMake(self.contentScrollView.width-jiedao_addressLabel.right-8-space, 17, 8, 16)];
    [jiedao_addressView addSubview:jiedao_addressButton];
    self.jieadao_addressButton = jiedao_addressButton;
    WEAK
    [[jiedao_addressButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        YBLBMLocationViewModel *viewModel = [YBLBMLocationViewModel new];
        if (self.userInfosParModel.lat.doubleValue!=0&&self.userInfosParModel.lng.doubleValue!=0) {
            BMKPoiInfo *model = [BMKPoiInfo new];
//            model.name = self.userInfosParModel.address;
            CLLocationDegrees lat = self.userInfosParModel.lat.doubleValue;
            CLLocationDegrees lng = self.userInfosParModel.lng.doubleValue;
            CLLocationCoordinate2D ptt ;
            ptt.latitude = lat;
            ptt.longitude = lng;
            model.pt = ptt;
            viewModel.currentModel = model;
        }
        viewModel.mapSelectBlock = ^(BMKPoiInfo *model) {
            STRONG
            if (model.pt.latitude==0||model.pt.longitude==0) {
                [SVProgressHUD showErrorWithStatus:@"定位地址经纬度错误!"];
                return ;
            }
            CLLocationDegrees lat = model.pt.latitude;
            CLLocationDegrees lng = model.pt.longitude;
            CLLocationCoordinate2D ptt ;
            ptt.latitude = lat;
            ptt.longitude = lng;
            self.local_pt = ptt;
            
            self.userInfosParModel.lat = @(model.pt.latitude);
            self.userInfosParModel.lng = @(model.pt.longitude);
            self.userInfosParModel.address = model.address;
            [jiedao_addressButton setTitle:model.address forState:UIControlStateNormal];
        };
        YBLBMLocationViewController *locationVC = [YBLBMLocationViewController new];
        locationVC.viewModel = viewModel;
        YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:locationVC];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
        
    }];;
    
    
    [jiedao_addressView addSubview:[YBLMethodTools addLineView:CGRectMake(0, jiedao_addressView.height-0.5, jiedao_addressView.width, 0.5)]];
    
    /* 门牌号 */
    UIView *menpaihaolView = [[UIView alloc] initWithFrame:CGRectMake(jiedao_addressView.left, jiedao_addressView.bottom, jiedao_addressView.width, jiedao_addressView.height)];
    [self.contentScrollView addSubview:menpaihaolView];
    UILabel *menpaihaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, storeNameLabel.width, menpaihaolView.height)];
    menpaihaoLabel.text = @"详细地址:";
    menpaihaoLabel.textColor = BlackTextColor;
    menpaihaoLabel.font = YBLFont(14);
    [menpaihaolView addSubview:menpaihaoLabel];
    self.menpaihaolView = menpaihaolView;
    
    XXTextField *menpaihaoTextFeild = [[XXTextField alloc] initWithFrame:CGRectMake(menpaihaoLabel.right, menpaihaoLabel.top, menpaihaolView.width-menpaihaoLabel.right, menpaihaoLabel.height)];
    menpaihaoTextFeild.borderStyle = UITextBorderStyleNone;
    menpaihaoTextFeild.placeholder = @"请输入门牌号";
    menpaihaoTextFeild.textColor = BlackTextColor;
    menpaihaoTextFeild.font = YBLFont(14);
    menpaihaoTextFeild.maxLength = limit_for_name;
    [menpaihaolView addSubview:menpaihaoTextFeild];
    self.menpaihaoTextFeild = menpaihaoTextFeild;
    
    [menpaihaolView addSubview:[YBLMethodTools addLineView:CGRectMake(0, menpaihaolView.height-0.5, menpaihaolView.width, 0.5)]];
    
    if ([YBLUserManageCenter shareInstance].aasmState == AasmStateRejected) {
        YBLUserInfoModel *userInfoModel = [YBLUserManageCenter shareInstance].userInfoModel;
        self.storeNameTextFeild.text = userInfoModel.shopname;
        self.contactTextFeild.text = userInfoModel.name;
        self.menpaihaoTextFeild.text = userInfoModel.desc_address;
        self.userInfosParModel.address = userInfoModel.street_address;
        self.userInfosParModel.lat = userInfoModel.location[0];
        self.userInfosParModel.lng = userInfoModel.location[1];
        [jiedao_addressButton setTitle:userInfoModel.street_address forState:UIControlStateNormal];
        [self.addressButton setTitle:userInfoModel.area_name forState:UIControlStateNormal];
        self.userInfosParModel.usertype = userInfoModel.user_type;
        self.addressModel.id = @(userInfoModel.district.integerValue);
        self.userInfosParModel.companytype = userInfoModel.company_type_id;
    }
    
}



- (void)showAdrressView:(UIButton *)btn{
    
    [self.contentScrollView endEditing:YES];
    [YBLChooseCityView chooseCityWithViewController:self.navigationController
                                          cityCount:4
                                       cityViewType:ChooseCityViewTypeWithDismissButton
                                       successBlock:^(YBLAddressAreaModel *model,NSMutableArray *selectArray) {
                                           self.addressModel = model;
                                           NSString *string = @"";
                                           for (YBLAddressAreaModel *select_model in selectArray) {
                                               string = [string stringByAppendingString:select_model.text];
                                           }
                                           [self.addressButton setTitle:string forState:UIControlStateNormal];
                                       }];
}

- (void)nextClick:(UIBarButtonItem *)btn{
    
    NSString *storeName = self.storeNameTextFeild.text;
    NSString *contact = self.contactTextFeild.text;
    NSString *desc_address = self.menpaihaoTextFeild.text;
    NSString *street_address = self.userInfosParModel.address;
    
    if (storeName.length==0||contact.length==0||desc_address.length==0||street_address.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请填写完整哟~"];
        return;
    }
    self.userInfosParModel.realname = contact;
    self.userInfosParModel.companyname = storeName;
    self.userInfosParModel.addressfour = [NSString stringWithFormat:@"%@",self.addressModel.id];
    self.userInfosParModel.desc_address = desc_address;
    
    ///
    [self requestUserAddress];
    
}

- (void)requestUserAddress{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"name"] = self.userInfosParModel.realname;
    para[@"company_type_id"] = self.userInfosParModel.companytype;
    para[@"shopname"] = self.userInfosParModel.companyname;
    para[@"district"] = self.userInfosParModel.addressfour;
    para[@"street_address"] = self.userInfosParModel.address;
    para[@"lat"] = self.userInfosParModel.lat;
    para[@"lng"] = self.userInfosParModel.lng;
    para[@"desc_address"] = self.userInfosParModel.desc_address;
    para[@"user_type"] = self.userInfosParModel.usertype;
    
    [YBLRequstTools HTTPPostWithUrl:url_setuseraddress
                            Parames:para
                          commplete:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"注册申请成功"];
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  YBLTheResultViewController *vc = [YBLTheResultViewController new];
                                  vc.isAgain = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                              });

                              /*
                              if (self.userInfosParModel.usertype == 1) {
                                  //我要开店
                                  YBLAddBankCardViewController *vc = [YBLAddBankCardViewController new];
                                  vc.userInfosParModel = self.userInfosParModel;
                                  [self.navigationController pushViewController:vc animated:YES];
                              } else if (self.userInfosParModel.usertype == 2) {
                                  //我要采购
                                  [SVProgressHUD showSuccessWithStatus:@"注册申请成功"];
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      YBLTheResultViewController *vc = [YBLTheResultViewController new];
                                      [self.navigationController pushViewController:vc animated:YES];
                                  });
                              }
                            */
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                
                            }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
