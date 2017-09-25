//
//  YBLOrderMMGoodsDetailBar.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailBar.h"

@interface YBLOrderMMGoodsDetailBar ()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) PurchaseGoddDetailBarType purchaseGoddDetailBarType;

@end

@implementation YBLOrderMMGoodsDetailBar

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame purchaseGoddDetailBarType:PurchaseGoddDetailBarTypeNormal];
}

- (instancetype)initWithFrame:(CGRect)frame purchaseGoddDetailBarType:(PurchaseGoddDetailBarType)purchaseGoddDetailBarType{
    
    self = [super initWithFrame:frame];
    if (self) {
        _purchaseGoddDetailBarType = purchaseGoddDetailBarType;
        
        [self createUI];
    }
    return self;
}

-(void)updatePurchaseDetailModel:(YBLPurchaseOrderModel *)purchaseDetailModel {
    float baozhengjin = [YBLMethodTools getBaozhengJINWithCount:purchaseDetailModel.quantity.integerValue
                                                          Price:purchaseDetailModel.price.doubleValue];
    self.textLabel.text = [NSString stringWithFormat:@"配送保证金¥%.2f \n未抢到订单保证金全额退还", baozhengjin];
    if ([YBLUserManageCenter shareInstance].userType != UserTypeSeller) {
        [self.qiangButton setTitle:purchase_order_button_look_price forState:UIControlStateNormal];
        self.qiangButton.enabled = YES;
        return;
    }
    if ([[YBLUserManageCenter shareInstance].userModel.userinfo_id isEqualToString:purchaseDetailModel.userinfo_id]) {
        [self.qiangButton setTitle:purchase_order_button_look_price forState:UIControlStateNormal];
        self.qiangButton.enabled = YES;
    } else {
        if ([purchaseDetailModel.aasm_state isEqualToString:@"purchaseing"]) {
            [self.qiangButton setTitle:PurchaseBarButtonTitleGOGO forState:UIControlStateNormal];
            self.qiangButton.enabled = YES;
        } else {
            self.qiangButton.enabled = NO;
        }
    }
    
}

- (void)createUI{

    self.backgroundColor = [UIColor clearColor];
    
    CGFloat timeBottom = 0;
    NSString *buttonString = @"采购";
    NSString *textValue = nil;
    if (_purchaseGoddDetailBarType == PurchaseGoddDetailBarTypeNormal) {
    
        self.timeDown = [[YBLTimeDown alloc] initWithFrame:CGRectMake(0, 0, self.width, 20) WithType:TimeDownTypeText];
        self.timeDown.backgroundColor = [BlackTextColor colorWithAlphaComponent:0.5];
        self.timeDown.textTimerLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.timeDown];
        timeBottom = self.timeDown.bottom;
        textValue = [NSString stringWithFormat:@"配送保证金¥0 \n未成功接单配送保证金全额退还"];
    } else {
        buttonString = @"保存并发布";
        textValue = [NSString stringWithFormat:@"采购保证金¥0 \n采购未成功保证金全额退还"];
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, timeBottom, self.width, self.height-timeBottom)];
    bgView.backgroundColor = YBLColor(67, 68, 69, 1);
    [self addSubview:bgView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width*3/5, bgView.height)];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.text = textValue;
    self.textLabel.font = YBLFont(12);
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.numberOfLines = 2;
    [bgView addSubview:self.textLabel];
    
    UIButton *qiangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qiangButton setTitle:buttonString forState:UIControlStateNormal];
    [qiangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    qiangButton.titleLabel.font = YBLFont(16);
    [qiangButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [qiangButton setBackgroundColor:YBLTextLightColor forState:UIControlStateDisabled];
    [qiangButton setTitle:PurchaseBarButtonTitleEndBidding forState:UIControlStateDisabled];
    qiangButton.frame = CGRectMake(self.textLabel.right, self.textLabel.top, self.width*2/5-10, self.textLabel.height);
    [bgView addSubview:qiangButton];
    self.qiangButton = qiangButton;
}

- (void)setPriceValue:(float)priceValue{
    _priceValue = priceValue;
    self.textLabel.text = [NSString stringWithFormat:@"采购保证金¥%.2f \n采购未成功保证金全额退还",priceValue];
}

@end
