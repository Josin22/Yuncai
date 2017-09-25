//
//  YBLOrderMMOutPriceRecordsCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMOutPriceRecordsCell.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLPurchaseShowIPayShipMentView.h"

typedef NS_ENUM(NSInteger,OutPriceCellType) {
    OutPriceCellTypeNoSelect = 0,
    OutPriceCellTypeSelect
};

@interface YBLOrderMMOutPriceRecordsCell ()

//@property (nonatomic, retain) UILabel *paymentLabel;
//@property (nonatomic, retain) UILabel *shihppingmentLabel;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *localLabel;

@property (nonatomic, strong) UIImageView *successImageView;

@property (nonatomic, assign) OutPriceCellType outPriceCellType;

@property (nonatomic, strong) YBLPurchaseOrderModel *bidModel;
@property (nonatomic, strong) YBLPurchaseOrderModel *purchaseGoodModel;

@property (nonatomic, strong) YBLPurchaseShowIPayShipMentView *allPayShipView;

@end

@implementation YBLOrderMMOutPriceRecordsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self createUI];
    }
    return self;
}

- (void)createUI{
    
//    CGFloat cell_height = [YBLOrderMMOutPriceRecordsCell getItemCellHeightWithModel:nil];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-space*2, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self.contentView addSubview:lineView];
    
    //40 100 100 xx
    _signLabel = [[YBLSignLabel alloc] initWithFrame:CGRectMake(space, lineView.bottom, 20, 30) SiginDirection:SiginDirectionTop];
    _signLabel.signText = @"1";
    _signLabel.textFont = YBLFont(13);
    _signLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_signLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_signLabel.right+space, space, 110, 15)];
    nameLabel.textColor = YBLTextColor;
    nameLabel.font = YBLFont(12);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+space+3, nameLabel.width, nameLabel.height)];
    timeLabel.textColor = YBLTextColor;
    timeLabel.font = YBLFont(10);
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;

    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.right+5, nameLabel.top, YBLWindowWidth-space-self.nameLabel.right-5, nameLabel.height)];
    priceLabel.textColor = YBLThemeColor;
    priceLabel.font = YBLFont(16);
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *localLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.right, timeLabel.top, priceLabel.width, priceLabel.height)];
    localLabel.textColor = YBLTextColor;
    localLabel.font = YBLFont(10);
    localLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:localLabel];
    self.localLabel = localLabel;
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(YBLWindowWidth-space-30, 0, 30, 30);
    self.selectButton.centerY = 50/2;
    self.selectButton.userInteractionEnabled = NO;
    [self.selectButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
    [self.selectButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.selectButton];
    
    self.successImageView = [[UIImageView alloc] init];
    self.successImageView.frame = CGRectMake(0, space, 110, 35);
    self.successImageView.centerX = YBLWindowWidth/2;
    [self.contentView addSubview:self.successImageView];
    
    YBLPurchaseShowIPayShipMentView *allPayShipView = [[YBLPurchaseShowIPayShipMentView alloc] initWithFrame:CGRectMake(0, self.timeLabel.bottom+space, YBLWindowWidth, 60)
                                                                                                showMentType:ShowMentTypeNoAspfit
                                                                                               textDataArray:nil];
    [self addSubview:allPayShipView];
    self.allPayShipView = allPayShipView;
}

- (void)setOutPriceCellType:(OutPriceCellType)outPriceCellType{
    _outPriceCellType = outPriceCellType;
    
    [self.allPayShipView updateTextDataArray:_bidModel.all_pay_ship_ment_titles];
    
    self.selectButton.hidden = YES;
    if (_purchaseGoodModel.isMyselfPurchaseOrder) {
        self.selectButton.hidden = NO;
    }
    switch (_outPriceCellType) {
        case OutPriceCellTypeNoSelect:
        {
            //不可选
            self.selectButton.hidden = YES;
            self.priceLabel.right = YBLWindowWidth-space;
            self.localLabel.right = self.priceLabel.right;
        }
            break;
        case OutPriceCellTypeSelect:
        {
            //可选
            self.selectButton.hidden = NO;
            self.priceLabel.right = YBLWindowWidth-space-self.selectButton.width-space;
            self.localLabel.right = self.priceLabel.right;
        }
            break;
            
        default:
            break;
    }
 
}
- (void)updateBiddingModel:(YBLPurchaseOrderModel *)bidModel purchaseGoodModel:(YBLPurchaseOrderModel *)purchaseGoodModel{
    
    _purchaseGoodModel = purchaseGoodModel;
    _bidModel = bidModel;
    self.timeLabel.text = _bidModel.created_at;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_bidModel.price.doubleValue];
    NSString *localString = [NSString stringWithFormat:@"%@ %@",_bidModel.address_info.province_name,_bidModel.address_info.city_name];
    self.localLabel.text = localString;
    self.selectButton.selected = _bidModel.isSelect;
    //竞标记录是否有自己记录
    if ([[YBLUserManageCenter shareInstance].userModel.userinfo_id isEqualToString:_bidModel.userinfo_id]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",_bidModel.userinfoname];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"***%@",[_bidModel.userinfoname substringFromIndex:_bidModel.userinfoname.length-1]];
    }
    //1.是否中标记录
    NSString *iconImageString = nil;
    if (_bidModel.spree_order&&[_bidModel.state isEqualToString:@"selected"]) {
        self.successImageView.hidden = NO;
        iconImageString = @"purchase_take_success_icon";
        //是自己中标
        if ([[YBLUserManageCenter shareInstance].userModel.userinfo_id isEqualToString:_bidModel.userinfo_id]) {
            iconImageString = @"purchase_take_success_icon";
        }
        //是自己的发的采购单
        if (_purchaseGoodModel.isMyselfPurchaseOrder) {
            iconImageString = @"purchase_success_icon";
        }
        self.successImageView.image = [UIImage imageNamed:iconImageString];
    } else {
        self.successImageView.hidden = YES;
    }
    //先判断是否自己发的采购订单
    if (_purchaseGoodModel.isMyselfPurchaseOrder) {
        PurchaseOrderType type = [YBLMethodTools getPurchaseOrderTypeWithAasmState:_purchaseGoodModel.aasm_state];
        if (type!=PurchaseOrderTypePurchaseing) {
            self.outPriceCellType = OutPriceCellTypeNoSelect;
        } else {
            self.outPriceCellType = OutPriceCellTypeSelect;
        }
    } else {
        self.outPriceCellType = OutPriceCellTypeNoSelect;
        self.signLabel.fillColor = YBLThemeColor;
        self.signLabel.textColor = [UIColor whiteColor];
    }

    //是否对标
    if ([_bidModel.bidstate isEqualToString:@"invalid"]) {
        //无效
        self.signLabel.fillColor = YBLColor(210, 210, 210, 1);
        self.signLabel.textColor = BlackTextColor;
    } else {
        //有效
        self.signLabel.fillColor = YBLThemeColor;
        self.signLabel.textColor = [UIColor whiteColor];
    }

}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 120;
}

@end
