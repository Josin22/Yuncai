//
//  YBLOutPriceBar.m
//  YC168
//
//  Created by 乔同新 on 2017/4/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOutPriceBar.h"
#import "YBLPurchaseOrderModel.h"

@interface YBLOutPriceBar ()

@property (nonatomic, retain) UILabel *timeLabel;

@property (nonatomic, retain) UILabel *orderNoLabel;

@property (nonatomic, strong) UIButton *undefineButton1;

@property (nonatomic, strong) UIButton *undefineButton2;

@end

@implementation YBLOutPriceBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat buttonwi = 70;
    CGFloat buttonhi = 28;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth-2*space-buttonwi, self.height/2)];
    self.timeLabel.textColor = YBLTextColor;
    self.timeLabel.font = YBLFont(13);
    [self addSubview:self.timeLabel];
    self.timeLabel.hidden = YES;
    
    self.orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, self.timeLabel.bottom, self.timeLabel.width, self.timeLabel.height)];
    self.orderNoLabel.textColor = BlackTextColor;
    self.orderNoLabel.font = YBLFont(13);
    [self addSubview:self.orderNoLabel];
    self.orderNoLabel.hidden = YES;
    ///最右侧
    self.undefineButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.undefineButton1.frame = CGRectMake(self.width-space-buttonwi, 0, buttonwi, buttonhi);
    self.undefineButton1.centerY = self.height/2;
    self.undefineButton1.layer.cornerRadius = 3;
    self.undefineButton1.layer.masksToBounds = YES;
    self.undefineButton1.titleLabel.font = YBLFont(14);
    [self.undefineButton1 setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    self.undefineButton1.layer.borderColor = YBLThemeColor.CGColor;
    self.undefineButton1.layer.borderWidth = .5;
    [self.undefineButton1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.undefineButton1];
    self.undefineButton1.hidden = YES;
    
    self.undefineButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.undefineButton2.frame = CGRectMake(self.width-space-buttonwi-space-space-buttonwi, 0, buttonwi, buttonhi);
    self.undefineButton2.centerY = self.height/2;
    self.undefineButton2.layer.cornerRadius = 3;
    self.undefineButton2.layer.masksToBounds = YES;
    self.undefineButton2.titleLabel.font = YBLFont(14);
    self.undefineButton2.layer.borderColor = YBLThemeColor.CGColor;
    self.undefineButton2.layer.borderWidth = .5;
    [self.undefineButton2 setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    [self.undefineButton2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.undefineButton2];
    self.undefineButton2.hidden = YES;
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, .5, self.width, .5)]];
}

- (void)updateDataModel:(YBLPurchaseOrderModel *)dataModel{
    
    if ([YBLUserManageCenter shareInstance].userType != UserTypeSeller&&!dataModel.isMyselfPurchaseOrder) {
        self.undefineButton1.hidden = YES;
        self.undefineButton2.hidden = YES;
        return;
    }
    
    if (![[YBLUserManageCenter shareInstance].userModel.userinfo_id isEqualToString:dataModel.userinfo_id]) {
        self.undefineButton1.hidden = YES;
        self.undefineButton2.hidden = YES;
        if ([dataModel.aasm_state isEqualToString:@"purchaseing"]) {
            [self.undefineButton1 setTitle:PurchaseBarButtonTitleGOGO forState:UIControlStateNormal];
            self.undefineButton1.hidden = NO;
        }
        return;
    }
    
    PurchaseOrderType type = [YBLMethodTools getPurchaseOrderTypeWithAasmState:dataModel.aasm_state];
    if (type == PurchaseOrderTypePurchaseing) {
        self.undefineButton1.hidden = NO;
        self.undefineButton2.hidden = NO;
        [self.undefineButton2 setTitle:purchase_order_button_cancel forState:UIControlStateNormal];
        [self.undefineButton1 setTitle:PurchaseBarButtonConfirmPurchase forState:UIControlStateNormal];

    } else if (type == PurchaseOrderTypeBidded) {
        self.undefineButton2.hidden = YES;
        self.undefineButton1.hidden = NO;
        self.timeLabel.hidden = NO;
        self.orderNoLabel.hidden = NO;
        self.timeLabel.text = dataModel.spree_order_created_at;
        self.orderNoLabel.text = [NSString stringWithFormat:@"订单号:%@",dataModel.spree_order_number];
        [self.undefineButton1 setTitle:purchase_order_button_lookOrderString forState:UIControlStateNormal];
    } else if (type == PurchaseOrderTypeFullComplete) {
        self.undefineButton2.hidden = YES;
        self.undefineButton1.hidden = NO;
        self.timeLabel.hidden = NO;
        self.orderNoLabel.hidden = NO;
        self.timeLabel.text = dataModel.spree_order_created_at;
        self.orderNoLabel.text = [NSString stringWithFormat:@"订单号:%@",dataModel.spree_order_number];
        [self.undefineButton1 setTitle:purchase_order_button_lookOrderString forState:UIControlStateNormal];

    } else {
        self.undefineButton1.hidden = YES;
        self.undefineButton2.hidden = YES;
    }
   
    
}

- (void)buttonClick:(UIButton *)btn{
    
    CurrentButtonType type = CurrentButtonTypeCancle;
    
    if ([btn.currentTitle isEqualToString:purchase_order_button_cancel]) {
        
        type = CurrentButtonTypeCancle;
        
    } else if ([btn.currentTitle isEqualToString:PurchaseBarButtonConfirmPurchase]) {
        
        type = CurrentButtonTypeSurePurchase;
        
    } else if ([btn.currentTitle isEqualToString:purchase_order_button_lookOrderString]) {
    
        type = CurrentButtonTypeLookOrder;
        
    } else if ([btn.currentTitle isEqualToString:purchase_order_button_release_again2]) {
        
        type = CurrentButtonTypeReleaseAgain;
        
    } else if ([btn.currentTitle isEqualToString:PurchaseBarButtonTitleGOGO]){
        type = CurrentButtonTypeIwantOutPrice;
    }
    
    BLOCK_EXEC(self.outPriceBarButtonClickBlock,type);
}

@end
