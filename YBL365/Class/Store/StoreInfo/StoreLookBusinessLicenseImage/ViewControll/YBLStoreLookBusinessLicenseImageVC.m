//
//  YBLStoreLookBusinessLicenseImageVC.m
//  YC168
//
//  Created by 乔同新 on 2017/5/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreLookBusinessLicenseImageVC.h"
#import "YBLPicVeriticateView.h"
#import "YBLShopInfoModel.h"
#import "YYWebImage.h"

@interface YBLStoreLookBusinessLicenseImageVC ()

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIImageView *licenseImageView;

@property (nonatomic, strong) UIImageView *waterInImageView;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation YBLStoreLookBusinessLicenseImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"证照信息";

    self.contentScrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
    self.contentScrollView.height -= kNavigationbarHeight;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.contentScrollView];
    
    self.licenseImageView = [[UIImageView alloc] initWithFrame:[self.contentScrollView bounds]];
    [self.contentScrollView addSubview:self.licenseImageView];
    
    if (self.licenseURL.length>0) {
//        [self.licenseImageView yy_setImageWithURL:[NSURL URLWithString:self.licenseURL] options:YYWebImageOptionProgressive];
        WEAK
        [self.licenseImageView js_alpha_setImageWithURL:[NSURL URLWithString:self.licenseURL] placeholderImage:smallImagePlaceholder completed:^(UIImage *image, NSURL *url) {
            STRONG
            CGFloat sacle = 1;
            if (image.size.width==0||image.size.height==0) {
                sacle = 1;
            } else {
                sacle = image.size.height/image.size.width;
            }
            self.licenseImageView.image = image;
            self.licenseImageView.height = (double)self.licenseImageView.width*sacle;
            self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.licenseImageView.bottom);

        }];
        /*
        [self.licenseImageView yy_setImageWithURL:[NSURL URLWithString:self.licenseURL] placeholder:[UIImage imageNamed:smallImagePlaceholder] options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            STRONG
            CGFloat sacle = image.size.height/image.size.width;
            if (sacle==0) {
                sacle = 1;
            }
            self.licenseImageView.image = image;
            self.licenseImageView.height = (double)self.licenseImageView.width*sacle;
            self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.licenseImageView.bottom);
        } ];
         */
    } else {
        [self createBaseUI];
    }
    
    if (self.isSelfStore) {
        return;
    }
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight)];
    self.maskView.backgroundColor = YBLViewBGColor;
    [self.view addSubview:self.maskView];
    
    UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 3*space, self.maskView.width, 20)];
    labelInfo.textAlignment = NSTextAlignmentCenter;
    labelInfo.font = YBLFont(16);
    labelInfo.textColor = BlackTextColor;
    [self.maskView addSubview:labelInfo];
    
    UIView *veriticateView = [[UIView alloc] initWithFrame:CGRectMake(0, labelInfo.bottom+space, self.maskView.width, 45)];
    veriticateView.backgroundColor = YBLViewBGColor;
    veriticateView.layer.cornerRadius = 3;
    veriticateView.layer.masksToBounds = YES;
    veriticateView.clipsToBounds = YES;
    [self.maskView addSubview:veriticateView];
    
    XXTextField *veriticateTextFeild = [[XXTextField alloc] initWithFrame:CGRectMake(space, 0, veriticateView.width-space*3-80, veriticateView.height)];
    veriticateTextFeild.placeholder = @"请输入验证码";
    veriticateTextFeild.maxLength  = 4;
    veriticateTextFeild.isAutoSpaceInLeft = YES;
    veriticateTextFeild.borderStyle = UITextBorderStyleNone;
    veriticateTextFeild.backgroundColor = [UIColor whiteColor];
    veriticateTextFeild.layer.cornerRadius =  3;
    veriticateTextFeild.layer.masksToBounds = YES;
    veriticateTextFeild.keyboardType = UIKeyboardTypePhonePad;
    veriticateTextFeild.font = YBLFont(16);
    veriticateTextFeild.textColor = YBLColor(40, 40, 40, 1);;
    veriticateTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    [veriticateView addSubview:veriticateTextFeild];
    
    YBLPicVeriticateView *picVeriticateView = [[YBLPicVeriticateView alloc] initWithFrame:CGRectMake(veriticateTextFeild.right+space, -1, 80, veriticateView.height)];
    picVeriticateView.layer.cornerRadius = 3;
    picVeriticateView.layer.masksToBounds = YES;
    [veriticateView addSubview:picVeriticateView];
    
    UIButton *nextButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, veriticateView.bottom+space*2, self.maskView.width-space*2, buttonHeight)];
    [self.maskView addSubview:nextButton];
    WEAK
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        if (![veriticateTextFeild.text isEqualToString:picVeriticateView.changeString]) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误~"];
            return ;
        }
        [self.maskView removeFromSuperview];
    }];
    
}

#pragma mark - 基本信息
- (void)createBaseUI {
    
    //企业文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 50)];
    titleLabel.text = @"云采商城网店经营者营业执照信息";
    titleLabel.textColor = BlackTextColor;
    titleLabel.font = YBLFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentScrollView addSubview:titleLabel];
    [titleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(space, titleLabel.height-.5, titleLabel.width-2*space, .5)]];
    
    NSString *full_fanwei = [YBLMethodTools getAppendingStringWithArray:self.shopInfoModel.range appendingKey:@"、"];
    NSArray *AllTextArray = @[[NSString stringWithFormat:@"企业名称: %@",self.shopInfoModel.company_name],
                              [NSString stringWithFormat:@"企业类型: %@",self.shopInfoModel.company_type],
                              [NSString stringWithFormat:@"统一社会信用代码: %@",self.shopInfoModel.registration_numbe],
                              [NSString stringWithFormat:@"法人代表人姓名: %@",self.shopInfoModel.leal_person],
                              [NSString stringWithFormat:@"营业执照所在地: %@",self.shopInfoModel.seat],
                              [NSString stringWithFormat:@"企业注册资金: %@",self.shopInfoModel.capital],
                              [NSString stringWithFormat:@"营业执照有效期: %@-%@",self.shopInfoModel.useful_life_from,self.shopInfoModel.useful_life_end],
                              [NSString stringWithFormat:@"公司地址: %@",self.shopInfoModel.full_address],
                              [NSString stringWithFormat:@"营业执照经营范围: %@",full_fanwei],
                              ];
    
    NSInteger index = 0;
    CGFloat item_height = 0;
    for (NSString *text in AllTextArray) {
        
        UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, titleLabel.bottom+space+item_height, YBLWindowWidth-2*space, item_height)];
        showLabel.textColor = BlackTextColor;
        NSString *allValue = [NSString stringWithFormat:@"%@",text];
        showLabel.text = allValue;
        showLabel.font = YBLFont(13);
        showLabel.numberOfLines = 0;
        [self.contentScrollView addSubview:showLabel];
        
        CGSize texztSize = [allValue heightWithFont:YBLFont(13) MaxWidth:showLabel.width];
        showLabel.height = texztSize.height;
        item_height += texztSize.height+space;
        
        if (index == AllTextArray.count-1) {
            
            NSString *full_warning = @"注: 以上营业执照信息,根据国家工商总局《网络交易管理办法》要求对入驻商家营业执照信息进行公示，除企业名称通过认证之外,其余信息由卖家自行申报填写。如需进一步核实，请联系当地工商行政管理部门。";
            CGSize full_size = [full_warning heightWithFont:YBLBFont(13) MaxWidth:YBLWindowWidth-2*space];
            UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, showLabel.bottom+20, YBLWindowWidth-2*space, full_size.height)];
            warningLabel.text = full_warning;
            warningLabel.numberOfLines = 0;
            warningLabel.textColor = [UIColor blackColor];
            warningLabel.font = YBLBFont(13);
            [self.contentScrollView addSubview:warningLabel];
            
            UIView *line_bottom = [YBLMethodTools addLineView:CGRectMake(space, warningLabel.bottom+space, YBLWindowWidth-2*space, .5)];
            [self.contentScrollView addSubview:line_bottom];
            
            self.licenseImageView.top = line_bottom.bottom+space;
            WEAK
            [self.licenseImageView js_alpha_setImageWithURL:[NSURL URLWithString:self.shopInfoModel.liutong] placeholderImage:smallImagePlaceholder completed:^(UIImage *image, NSURL *url) {
                STRONG
                CGFloat sacle = 1;
                BOOL isHiden = NO;
                if (image.size.width==0||image.size.height==0) {
                    sacle = 1;
                    isHiden = YES;
                } else {
                    sacle = image.size.height/image.size.width;
                }
                self.licenseImageView.image = image;
                self.licenseImageView.height = (double)self.licenseImageView.width*sacle;
                if (!isHiden) {
                    self.waterInImageView.frame = self.licenseImageView.bounds;
                }
                self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.licenseImageView.bottom);
                
            }];
            /*
            [self.licenseImageView yy_setImageWithURL:[NSURL URLWithString:self.shopInfoModel.liutong] placeholder:[UIImage imageNamed:smallImagePlaceholder] options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                STRONG
                CGFloat sacle = image.size.height/image.size.width;
                BOOL isHiden = NO;
                if (sacle==0) {
                    sacle = 1;
                    isHiden = YES;
                }
                self.licenseImageView.image = image;
                self.licenseImageView.height = (double)self.licenseImageView.width*sacle;
                if (!isHiden) {
                    self.waterInImageView.frame = self.licenseImageView.bounds;
                }
                self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.licenseImageView.bottom);
            } ];
             */
//            self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.licenseImageView.bottom);
        }
        
        index++;
    }
}

- (UIImageView *)waterInImageView{
    if (!_waterInImageView) {
        _waterInImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"water_yin_icon"]];
        _waterInImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.licenseImageView addSubview:_waterInImageView];
    }
    return _waterInImageView;
}

@end
