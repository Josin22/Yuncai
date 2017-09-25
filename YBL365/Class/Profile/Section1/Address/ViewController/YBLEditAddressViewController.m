//
//  YBLEditAddressViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLEditAddressViewController.h"
#import "YBLChooseCityView.h"
#import "IQKeyboardManager.h"
#import "YBLFoundationMethod.h"
#import "YBLBMLocationViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLUserInfosParaModel.h"

#define BASE_HEIGHT 50

@interface YBLEditAddressViewController ()<UIScrollViewDelegate>
/**
 *  保存
 */
@property (nonatomic, strong) UIButton *saveBtton;

@property (nonatomic, strong) UISwitch *defaultSwitch;

@end

@implementation YBLEditAddressViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)goback1 {
    
    WEAK
    [YBLOrderActionView showTitle:@"当前您正在编辑地址,确定要放弃编辑吗?" cancle:@"我再想想" sure:@"确定" WithSubmitBlock:^{
        STRONG
        [self.navigationController popViewControllerAnimated:YES];
        
    }cancelBlock:^{
        
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *navTitle;
    switch (self.viewModel.addressType) {
        case AddressTypeOrderEdit:
            navTitle = @"编辑地址";
            break;
        case AddressTypeOrderAdd:
            navTitle = @"新建地址";
            break;
        default:
            break;
    }
    self.navigationItem.title = navTitle;
    if ( self.viewModel.addressType == AddressTypeOrderEdit) {
        UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAdress)];
        edit.tintColor = YBLColor(150, 150, 150, 1.0);
        self.navigationItem.rightBarButtonItem = edit;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
//contact_pick_btn_n
    
    [self createSubUI];
}

- (void)deleteAdress {
    WEAK
    [[self.viewModel signalForDeleteAddressWithID:self.viewModel.addressInfoModel.id] subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            STRONG
            [self.navigationController popViewControllerAnimated:YES];
        }
    } error:^(NSError *error) {
        
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)createSubUI {
    
    self.storeNameLabel.text = @"收  货  人:";
    self.storeNameTextFeild.placeholder = @"请输入收货人";
    self.storeNameTextFeild.maxLength = limit_for_name;
    self.contactLabel.text = @"联系方式:";
    self.contactTextFeild.placeholder = @"请输入联系方式";
    self.contactTextFeild.maxLength = maxLength_for_phone;
    self.contactTextFeild.keyboardType = UIKeyboardTypePhonePad;
    
    UIButton *personButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentScrollView addSubview:personButton];
    personButton.backgroundColor = [UIColor whiteColor];
    personButton.frame = CGRectMake(self.contentScrollView.width - self.storeNameLabel.height*2, 0.5, self.storeNameLabel.height*2, self.storeNameLabel.height*2-1);
    WEAK
    [[personButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [[YBLFoundationMethod shareInstance] showAddressBookWithVc:self handleSelectBlock:^(NSString *name, NSString *phone) {
            STRONG
            self.storeNameTextFeild.text = name;
            self.contactTextFeild.text = phone;
        }];    
    }];
    
    UIImageView *personImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_pick_btn_n"]];
    [personButton addSubview:personImageView];
    personImageView.frame = CGRectMake(0, 0, 30, 30);
    personImageView.centerX = personButton.width/2;
    personImageView.bottom = personButton.height/2-3;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"选联系人";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = YBLColor(70, 70, 70, 1.0);
    label.font = YBLFont(14);
    [personButton addSubview:label];
    label.frame = CGRectMake(0, personButton.height/2, personButton.width, 20);
    
    [personButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, .5, personButton.height)]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.menpaihaolView.bottom, YBLWindowWidth, self.menpaihaolView.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:bgView];
    
    UILabel *defaultAddressLabel = [[UILabel alloc] init];
    defaultAddressLabel.textColor = YBLColor(70, 70, 70, 1.0);
    defaultAddressLabel.text = @"设为默认地址";
    defaultAddressLabel.font = YBLFont(14);
    [bgView addSubview:defaultAddressLabel];
    defaultAddressLabel.frame = CGRectMake(space, 0, YBLWindowWidth*2/3, 15);
    defaultAddressLabel.bottom = bgView.height/2;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textColor = YBLColor(150, 150, 150, 1.0);
    if (self.viewModel.addressGenre == AddressGenreZiti) {
        descLabel.text = @"注:每次选择自提地址时会使用该地址";
    } else {
        descLabel.text = @"注:每次下单时会使用该地址";
    }
    descLabel.font = YBLFont(12);
    [bgView addSubview:descLabel];
    descLabel.frame = CGRectMake(space, bgView.height/2+3, defaultAddressLabel.width, defaultAddressLabel.height);
    
    
    self.defaultSwitch = [[UISwitch alloc] init];
    [bgView addSubview:self.defaultSwitch];
    self.defaultSwitch.onTintColor = YBLThemeColor;
    self.defaultSwitch.frame = CGRectMake(0, 0, 40, 30);
    self.defaultSwitch.right = YBLWindowWidth-space;
    self.defaultSwitch.centerY = bgView.height/2;
    
    [bgView addSubview:[YBLMethodTools addLineView:CGRectMake(0, bgView.height-.5, bgView.width, .5)]];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight+space)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.bottom = YBLWindowHeight-kNavigationbarHeight;
    [self.view addSubview:bottomView];
    
    self.saveBtton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(0, 0, bottomView.width*2/3, buttonHeight-space)];
    [self.saveBtton setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtton.centerX = bottomView.width/2;
    self.saveBtton.centerY = bottomView.height/2;
    [bottomView addSubview:self.saveBtton];
    
    [[self.saveBtton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        self.viewModel.addressInfoModel.consignee_name = self.storeNameTextFeild.text;
        self.viewModel.addressInfoModel.consignee_phone = self.contactTextFeild.text;
        self.viewModel.addressInfoModel.desc_address = self.menpaihaoTextFeild.text;
        self.viewModel.addressInfoModel._default = @(self.defaultSwitch.isOn);
        self.viewModel.addressInfoModel.district = [NSString stringWithFormat:@"%@",self.addressModel.id];
        self.viewModel.addressInfoModel.street_address = self.jieadao_addressButton.currentTitle;
        self.viewModel.addressInfoModel.lng = @(self.local_pt.longitude);
        self.viewModel.addressInfoModel.lat = @(self.local_pt.latitude);
        
        if (self.viewModel.addressInfoModel.consignee_name.length==0||self.viewModel.addressInfoModel.consignee_phone.length==0||self.viewModel.addressInfoModel.street_address.length==0||self.viewModel.addressInfoModel.district.length==0||self.viewModel.addressInfoModel.lat.doubleValue==0||self.viewModel.addressInfoModel.lng.doubleValue==0.0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有填写完整哟~"];
            return ;
        }
        self.viewModel.addressInfoModel.location = [@[@(self.local_pt.latitude),@(self.local_pt.longitude)] mutableCopy];
        BOOL isPhoneVaild = [YBLMethodTools checkPhone:self.viewModel.addressInfoModel.consignee_phone];
        if (!isPhoneVaild) {
            [SVProgressHUD showErrorWithStatus:@"手机号错误~"];
            return ;
        }
        if (self.viewModel.addressInfoModel.consignee_name.length>limit_for_name) {
            [SVProgressHUD showErrorWithStatus:@"联系人字数不能超过10个哟~"];
            return;
        }
        switch (self.viewModel.addressType) {
            case AddressTypeOrderEdit:
            {
                [[self.viewModel signalForChangeAddress] subscribeNext:^(NSNumber *x) {
                    STRONG
                    if (x.boolValue) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } error:^(NSError *error) {
                    
                }];
            }
                break;
            case AddressTypeOrderAdd:
            {
                [[self.viewModel signalForAddAddress] subscribeNext:^(NSNumber *x) {
                    STRONG
                    if (x.boolValue) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } error:^(NSError *error) {
                    
                }];
            }
                break;
           
            default:
                break;
        }
    }];

    if (self.viewModel.addressInfoModel) {
        self.storeNameTextFeild.text = self.viewModel.addressInfoModel.consignee_name;
        self.contactTextFeild.text = self.viewModel.addressInfoModel.consignee_phone;
        if (self.viewModel.addressInfoModel.province_name) {
            NSString *areaString  = [NSString stringWithFormat:@"%@%@%@%@",self.viewModel.addressInfoModel.province_name,self.viewModel.addressInfoModel.city_name,self.viewModel.addressInfoModel.county_name,self.viewModel.addressInfoModel.district_name];
            [self.addressButton setTitle:areaString forState:UIControlStateNormal];
        }
        [self.jieadao_addressButton setTitle:self.viewModel.addressInfoModel.street_address forState:UIControlStateNormal];
        self.menpaihaoTextFeild.text = self.viewModel.addressInfoModel.desc_address;
        self.defaultSwitch.on = self.viewModel.addressInfoModel._default.boolValue;
        CLLocationDegrees lat = [self.viewModel.addressInfoModel.location[0] doubleValue];
        CLLocationDegrees lng = [self.viewModel.addressInfoModel.location[1] doubleValue];
        CLLocationCoordinate2D ptt ;
        ptt.latitude = lat;
        ptt.longitude = lng;
        self.local_pt = ptt;
        if (!self.addressModel) {
            self.addressModel = [YBLAddressAreaModel new];
        }
        self.addressModel.id = @(self.viewModel.addressInfoModel.district.intValue);
    }
}


@end
