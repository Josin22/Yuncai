//
//  YBLOrderMMGoodsDetailOtherInfoCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailOtherInfoCell.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLPurchaseShowIPayShipMentView.h"

@interface YBLOrderMMGoodsDetailOtherInfoCell ()

@property (nonatomic, retain) UILabel *joinLabel;

@property (nonatomic, strong) UIButton *locaButton;

@property (nonatomic, strong) YBLPurchaseShowIPayShipMentView *allPayShipView;

@end

@implementation YBLOrderMMGoodsDetailOtherInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createOtherInfoUI];
    }
    return self;
}

- (void)createOtherInfoUI{
    
    UILabel *joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth*2/3, 30)];
    joinLabel.textColor = BlackTextColor;
    joinLabel.font = YBLFont(14);
    [self.contentView addSubview:joinLabel];
    self.joinLabel = joinLabel;
    
    self.locaButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.locaButton.frame = CGRectMake(YBLWindowWidth/2, 0, 100, 30);
    [self.locaButton setImage:[UIImage imageNamed:@"orderMM_location"] forState:UIControlStateNormal];
    self.locaButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.locaButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    self.locaButton.titleLabel.font = YBLFont(12);
    [self.contentView addSubview:self.locaButton];

    UIView *section5View = [[UIView alloc] initWithFrame:CGRectMake(0, self.joinLabel.bottom, YBLWindowWidth, 90)];
    [self.contentView addSubview:section5View];
    
    UILabel *section5TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, section5View.width-2*space, 30)];
    section5TitleLabel.textColor = BlackTextColor;
    section5TitleLabel.font = YBLFont(13);
    section5TitleLabel.text = @"采购支付、配送、时效";
    [section5View addSubview:section5TitleLabel];
    
    YBLPurchaseShowIPayShipMentView *allPayShipView = [[YBLPurchaseShowIPayShipMentView alloc] initWithFrame:CGRectMake(0, section5TitleLabel.bottom, section5View.width, section5View.height-section5TitleLabel.bottom)
                                                                                                showMentType:ShowMentTypeNoAspfit
                                                                                               textDataArray:nil];
//    section5View.backgroundColor = allPayShipView.backgroundColor;
    [section5View addSubview:allPayShipView];
    self.allPayShipView = allPayShipView;
    
}

- (void)updateModel:(YBLPurchaseOrderModel *)model{
    
//    NSMutableAttributedString *att_joinRecordString = [YBLMethodTools getJoinVisitAttributedStringWithJoin:model.bidding_count
//                                                                                                 visitTime:model.visit_times
//                                                                                             componeString:@" "];
    self.joinLabel.attributedText = model.att_text;
    [self.allPayShipView updateTextDataArray:model.all_pay_ship_ment_titles];
    self.locaButton.hidden = YES;
    if (model.distance.doubleValue>0&&[YBLUserManageCenter shareInstance].userType == UserTypeSeller) {
        NSString *distance = [NSString stringWithFormat:@"%.2fkm",model.distance.doubleValue];
        CGSize dis_stance_size = [distance heightWithFont:YBLFont(12) MaxWidth:200];
        CGFloat imageWi = 9;
        CGFloat imageHi = 12;
        CGFloat dis_space = 3;
        CGFloat all_button_height = 30;
        self.locaButton.imageRect = CGRectMake(0, (all_button_height-imageHi)/2, imageWi, imageHi);
        self.locaButton.titleRect = CGRectMake(imageWi+dis_space, 0, dis_stance_size.width, all_button_height);
        self.locaButton.width = dis_stance_size.width+dis_space+imageWi;
        self.locaButton.right = YBLWindowWidth-space;
        [self.locaButton setTitle:distance forState:UIControlStateNormal];
        self.locaButton.hidden = NO;
    }
}

+ (CGFloat)getGoodsDetailOtherInfoCellHeight{
    
    return 120;
}

@end
