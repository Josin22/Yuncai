//
//  YBLOrderMMGoodsDetailAddressCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailAddressCell.h"
#import "YBLPurchaseOrderModel.h"

@interface YBLOrderMMGoodsDetailAddressCell ()

@property (nonatomic, strong) YBLButton *addressButton;

@property (nonatomic, retain) UILabel *addressInfoLabel;

@property (nonatomic, retain) UILabel *yunLabel;


@end

@implementation YBLOrderMMGoodsDetailAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    NSString *labelText = @"送至";
    
    CGSize labelSize = [labelText heightWithFont:YBLFont(14) MaxWidth:200];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space, space, labelSize.width, labelSize.height)];
    label.text  = labelText;
    label.textColor = YBLTextColor;
    label.font = YBLFont(13);
    [self addSubview:label];
    
    _addressButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    _addressButton.frame = CGRectMake(label.right+5, CGRectGetMinY(label.frame), YBLWindowWidth-label.right-space, label.height);
    _addressButton.titleRect = CGRectMake(label.height+3, 0, YBLWindowWidth-CGRectGetMaxX(label.frame)-5-5-30-label.height-3, label.height);
    [_addressButton setImage:[UIImage imageNamed:@"orderMM_location"] forState:UIControlStateNormal];
    [_addressButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    _addressButton.imageRect = CGRectMake(0, 0, labelSize.height-3, labelSize.height);
    _addressButton.titleRect = CGRectMake(labelSize.height+3, 0, YBLWindowWidth-CGRectGetMaxX(label.frame)-5-5-30-label.height*2-3-3, label.height);
    _addressButton.titleLabel.font = YBLFont(15);
    [self addSubview:_addressButton];
    
    /*
    _addressInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_addressButton.frame), CGRectGetMaxY(_addressButton.frame)+5, _addressButton.width, 40)];
    _addressInfoLabel.numberOfLines = 2;
    _addressInfoLabel.text = @"现货,保税区发货预计5-10个工作日到货,直邮预计5-20个工作日到货";
    _addressInfoLabel.font = YBLFont(13);
    _addressInfoLabel.textColor = YBLThemeColor;
    [self addSubview:_addressInfoLabel];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame),90-5-labelSize.height,label.width,label.height)];
    label1.text  = @"运费";
    label1.textColor = YBLTextColor;
    label1.font = YBLFont(13);
    [self addSubview:label1];
    
    _yunLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+5, CGRectGetMinY(label1.frame), 200, label1.height)];
    _yunLabel.text = @"免运费";
    _yunLabel.font = YBLFont(13);
    [self addSubview:_yunLabel];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(YBLWindowWidth-10-30, 5, 30,20);
    [moreButton setImage:[UIImage imageNamed:@"more_sandian"] forState:UIControlStateNormal];
    moreButton.enabled = NO;
    [self addSubview:moreButton];
    
    YBLButton *songButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    [songButton setBackgroundColor:YBLViewBGColor];
    songButton.titleLabel.font = YBLFont(10);
    [songButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [songButton setTitle:@"72小时配送完成" forState:UIControlStateNormal];
    songButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [songButton setImage:[UIImage imageNamed:@"orderMM_select"] forState:UIControlStateNormal];
    songButton.frame = CGRectMake(0, label1.bottom+space, YBLWindowWidth, 30);
    songButton.titleRect = CGRectMake(30, 0, YBLWindowWidth-2*space-30, 30);
    songButton.imageRect = CGRectMake(10, 7.5, 15, 15);
    [self addSubview:songButton];
    */
    
}

//[_addressButton setTitle:@"" forState:UIControlStateNormal];

- (void)updateModel:(YBLPurchaseOrderModel *)model{
    
    [self.addressButton setTitle:[[model.address_info.province_name stringByAppendingString:model.address_info.city_name] stringByAppendingString:model.address_info.county_name] forState:UIControlStateNormal];
}

+ (CGFloat)getGoodsDetailAddressCellHeight{
    
    return 40;
}

@end
