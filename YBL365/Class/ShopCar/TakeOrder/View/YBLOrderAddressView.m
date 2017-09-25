//
//  YBLOrderAddressView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLOrderAddressView.h"
#import "YBLAddressModel.h"

@interface YBLOrderAddressView ()

@property (nonatomic, strong) UIView *nullAddressView;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *nullAddressImageView;

@end

@implementation YBLOrderAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addressButton.frame = [self bounds];
    [self addSubview:self.addressButton];

    UILabel *namePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, self.width-2*space, 20)];
    namePhoneLabel.textColor = BlackTextColor;
    namePhoneLabel.font = YBLBFont(17);
    [self.addressButton addSubview:namePhoneLabel];
    self.namePhoneLabel = namePhoneLabel;
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.namePhoneLabel.left, self.namePhoneLabel.bottom+space, namePhoneLabel.width, 20)];
    addressLabel.textColor = YBLTextColor;
    addressLabel.font = YBLFont(14);
    addressLabel.numberOfLines = 0;
    [self.addressButton addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 2)];
    lineImageView.image = [UIImage imageNamed:@"order_homepage_address_frame_375x2_"];
    [self.addressButton addSubview:lineImageView];
    self.lineImageView = lineImageView;
    
    self.height = addressLabel.bottom+space;
    self.addressButton.frame = [self bounds];
    lineImageView.bottom = self.height;
    
    UIView *nullAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-2)];
    nullAddressView.backgroundColor = [UIColor whiteColor];
    nullAddressView.userInteractionEnabled = NO;
    [self addSubview:nullAddressView];
    self.nullAddressView = nullAddressView;
    self.nullAddressView.hidden = YES;
    
    self.nullAddressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_address"]];
    self.nullAddressImageView.frame = CGRectMake(0, 0, 40, 40);
    self.nullAddressImageView.center = self.nullAddressView.center;
    self.nullAddressImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.nullAddressView addSubview:self.nullAddressImageView];
  
}

- (void)updateAdressModel:(YBLAddressModel *)model{

    if (model.id&&model.full_address) {
        self.nullAddressView.hidden = YES;
        self.namePhoneLabel.text = [NSString stringWithFormat:@"%@   %@",model.consignee_name,model.consignee_phone];
        self.addressLabel.text = model.full_address;
        CGSize addressSize = [model.full_address heightWithFont:YBLFont(14) MaxWidth:YBLWindowWidth-2*space];
        self.addressLabel.height = addressSize.height;
        self.height = self.addressLabel.bottom+space;
        self.lineImageView.bottom = self.height;
        if ([model.genre isEqualToString:@"ziti"]) {
            self.arrowImageView.hidden = NO;
        } else {
            self.arrowImageView.hidden = YES;
        }
    } else {
        self.nullAddressView.hidden = NO;
    }
    self.nullAddressView.height = self.height-2;
}

@end
