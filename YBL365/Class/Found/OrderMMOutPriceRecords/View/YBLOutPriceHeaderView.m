//
//  YBLOutPriceHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOutPriceHeaderView.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLPurchaseShowIPayShipMentView.h"
#import "YBLPurchaseShowIPayShipMentView.h"

@interface YBLOutPriceHeaderView ()

@property (nonatomic, strong) TextImageButton *joinButton;

@property (nonatomic, strong) TextImageButton *visitButton;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *signLabel;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, retain) UILabel *countLabel;

@property (nonatomic, retain) UILabel *locationLabel;

@property (nonatomic, strong) YBLPurchaseShowIPayShipMentView *allPayShipView;

@end

@implementation YBLOutPriceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat imageWWWW = self.width/3.5-space*2;
    
    UIImageView *goodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(space, space, imageWWWW, imageWWWW)];
    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
//    goodImageView.layer.borderColor = YBLLineColor.CGColor;
//    goodImageView.layer.borderWidth = .8;
    [self addSubview:goodImageView];
    self.goodImageView = goodImageView;
    
    
    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, goodImageView.width, 16)];
    signLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];;
    signLabel.textColor = [UIColor whiteColor];
    signLabel.text = @"正在进行";
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.font = YBLFont(12);
    [goodImageView addSubview:signLabel];
    self.signLabel = signLabel;
    
    CGFloat imageWii = goodImageView.width/4;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.right+space, goodImageView.top, YBLWindowWidth-goodImageView.right-space*2, imageWii)];
    nameLabel.font = YBLFont(15);
    nameLabel.numberOfLines = 2;
    nameLabel.textColor = BlackTextColor;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, nameLabel.height)];
    priceLabel.textColor = BlackTextColor;
    priceLabel.text = @"¥0.00";
    priceLabel.font = YBLFont(14);
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom, priceLabel.width, priceLabel.height)];
    countLabel.textColor = BlackTextColor;
    countLabel.text = @"采购量:0箱";
    countLabel.font = YBLFont(14);
    [self addSubview:countLabel];
    self.countLabel = countLabel;
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.left, countLabel.bottom, countLabel.width, countLabel.height)];
//    self.locationLabel.bottom = goodImageView.bottom;
    self.locationLabel.text = @"地区";
    self.locationLabel.font = YBLFont(10);
    self.locationLabel.textAlignment = NSTextAlignmentRight;
    self.locationLabel.textColor = YBLTextColor;
    [self addSubview:self.locationLabel];
    
    YBLPurchaseShowIPayShipMentView *allPayShipView = [[YBLPurchaseShowIPayShipMentView alloc] initWithFrame:CGRectMake(0, goodImageView.bottom+space, self.width, 60)
                                                                                                showMentType:ShowMentTypeNoAspfit
                                                                                               textDataArray:nil];
    [self addSubview:allPayShipView];
    self.allPayShipView = allPayShipView;

    self.joinButton = [[TextImageButton alloc] initWithFrame:CGRectMake(0, self.allPayShipView.bottom+space/2, self.width/2, 40) Type:TypeText];
//    self.joinButton.bottom = self.height;
    self.joinButton.bottomLabel.textColor = YBLTextColor;
    self.joinButton.bottomLabel.text = @"参与";
    self.joinButton.bottomLabel.font = YBLFont(13);
//    self.joinButton.topLabel.top += 3;
    self.joinButton.topLabel.textColor = YBLThemeColor;
    self.joinButton.topLabel.font = YBLFont(16);
    [self addSubview:self.joinButton];
    
    self.visitButton = [[TextImageButton alloc] initWithFrame:CGRectMake(self.width/2, self.joinButton.top, self.width/2, 40) Type:TypeText];
    self.visitButton.bottom = self.joinButton.bottom;
    self.visitButton.bottomLabel.textColor = YBLTextColor;
    self.visitButton.bottomLabel.text = @"浏览";
    self.visitButton.bottomLabel.font = YBLFont(13);
    self.visitButton.topLabel.textColor = YBLThemeColor;
//    self.visitButton.topLabel.top += 3;
    self.visitButton.topLabel.font = YBLFont(16);
    [self addSubview:self.visitButton];

//    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, self.visitButton.bottom+space/2, self.width, space)];
//    spaceView.backgroundColor = YBLColor(247, 247, 247, 1);
//    [self addSubview:spaceView];
    
    self.height = self.visitButton.bottom+space/2+15;

}

- (void)updateModel:(YBLPurchaseOrderModel *)model{
    
    [self.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:smallImagePlaceholder];
    self.signLabel.text = model.purchase_state_for_purchaser.mypurchase_head;
    self.nameLabel.text = model.title;
    NSString *priceString  = [NSString stringWithFormat:@"采购价格: ¥%.2f",model.price.doubleValue];;
    self.priceLabel.attributedText = [NSString redPriceString:priceString color:YBLThemeColor font:14];
    self.countLabel.text = [NSString stringWithFormat:@"采购数量 : %d%@",model.quantity.intValue,model.unit];
    
    self.joinButton.topLabel.text = [NSString stringWithFormat:@"%ld 人",(long)model.bidding_count.integerValue];
    self.visitButton.topLabel.text = [NSString stringWithFormat:@"%ld 人",(long)model.visit_times.integerValue];
    
    NSString *locationString = [NSString stringWithFormat:@"%@ %@ %@",model.address_info.province_name,model.address_info.city_name,model.address_info.county_name];
    self.locationLabel.text = locationString;
    
    [self.allPayShipView updateTextDataArray:model.all_pay_ship_ment_titles];
}

@end
