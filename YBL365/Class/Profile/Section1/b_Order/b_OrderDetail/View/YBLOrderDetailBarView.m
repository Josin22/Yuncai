//
//  YBLOrderDetailBarView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailBarView.h"
#import "YBLOrderItemModel.h"
#import "YBLTimeDown.h"

static NSInteger const tag_seller_button = 9999;

static NSInteger const tag_buyer_button = 99999;

@interface YBLOrderDetailBarView ()

@property (nonatomic, strong) YBLTimeDown *orderTimeDown;

@property (nonatomic, assign) OrderSource orderSource;

@end

@implementation YBLOrderDetailBarView

- (instancetype)initWithFrame:(CGRect)frame orderSource:(OrderSource)orderSource{
    
    if (self = [super initWithFrame:frame]) {
        
        _orderSource = orderSource;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor  clearColor];
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height-20)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self addSubview:buttonView];
    
    if (_orderSource == OrderSourceSeller) {

        CGFloat seller_button_wi = self.width/2;
        
        for (int i = 0; i < 2; i++) {
            
            UIButton *undefineButton = [UIButton buttonWithType:UIButtonTypeCustom];
            undefineButton.frame = CGRectMake(buttonView.width - (i+1)*seller_button_wi, 0, seller_button_wi, buttonView.height);
            [undefineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            undefineButton.tag = tag_seller_button+i;
            [undefineButton addTarget:self action:@selector(sellerOfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView addSubview:undefineButton];
            undefineButton.hidden = YES;
            if (i==0) {
                [undefineButton setBackgroundColor:YBL_RED forState:UIControlStateNormal];
            } else {
                [undefineButton setBackgroundColor:YBLColor(120, 120, 120, 1) forState:UIControlStateNormal];
            }
        }
    
    } else {
        
        self.orderTimeDown = [[YBLTimeDown alloc] initWithFrame:CGRectMake(0, 0, self.width, 20) WithType:TimeDownTypeText];
        self.orderTimeDown.backgroundColor = [BlackTextColor colorWithAlphaComponent:0.5];
        self.orderTimeDown.textTimerLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.orderTimeDown];
        self.orderTimeDown.hidden = YES;
        
        CGFloat buttonwi = 80;
        CGFloat buttonhi = buttonView.height-space*1.5;
        for (int i = 0; i < 3; i++) {
            UIButton *undefineButton = [UIButton buttonWithType:UIButtonTypeCustom];
            undefineButton.frame = CGRectMake(buttonView.width-(buttonwi+space)*(i+1), 0, buttonwi, buttonhi);
            undefineButton.centerY = buttonView.height/2;
            undefineButton.layer.cornerRadius = 3;
            undefineButton.layer.masksToBounds = YES;
            undefineButton.titleLabel.font = YBLFont(14);
            undefineButton.tag = tag_buyer_button+i;
            [undefineButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
            undefineButton.layer.borderColor = YBLThemeColor.CGColor;
            undefineButton.layer.borderWidth = .5;
            [undefineButton addTarget:self action:@selector(buyerOfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView addSubview:undefineButton];
            undefineButton.hidden = YES;
        }
    }
    [buttonView addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, buttonView.width, 0.5)]];
}

- (void)setItemModel:(YBLOrderItemModel *)itemModel{
    _itemModel = itemModel;
    NSInteger count = itemModel.property_order.orderStateCount.count;
    if (_orderSource == OrderSourceSeller) {
        //大b
        CGFloat seller_button_wi = self.width/2;
        for (int i = 0; i < 2; i++) {
            UIButton *undefineButton = (UIButton *)[self viewWithTag:tag_seller_button+i];
            undefineButton.frame = CGRectMake(self.width - (i+1)*seller_button_wi, 0, seller_button_wi, self.height-20);
            undefineButton.hidden = YES;
            if (i<count) {
                undefineButton.hidden = NO;
                YBLOrderPropertyItemModel *propertyItemModel = itemModel.property_order.orderStateCount[i];
                [undefineButton setTitle:propertyItemModel.order_button_title forState:UIControlStateNormal];
                
//                if (self.itemModel.purchase_order&&([propertyItemModel.order_button_title isEqualToString:yanchiTihuoString]||[propertyItemModel.order_button_title isEqualToString:delayShipString]||[propertyItemModel.order_button_title isEqualToString:buyAgainString])) {
//                    undefineButton.hidden = YES;
//                }
            }
            if (count == 1&&i==0) {
                undefineButton.frame = CGRectMake(0, 0, self.width, self.height-20);
            }
        }
    } else {
        //小b
        for (int i = 0; i < 3; i++) {
            UIButton *undefineButton = (UIButton *)[self viewWithTag:tag_buyer_button+i];
            undefineButton.hidden = YES;
            if (i<count) {
                undefineButton.hidden = NO;
                YBLOrderPropertyItemModel *propertyItemModel = itemModel.property_order.orderStateCount[i];
                [undefineButton setTitle:propertyItemModel.order_button_title forState:UIControlStateNormal];
//                if (self.itemModel.purchase_order&&([propertyItemModel.order_button_title isEqualToString:yanchiTihuoString]||[propertyItemModel.order_button_title isEqualToString:delayShipString]||[propertyItemModel.order_button_title isEqualToString:buyAgainString])) {
//                    undefineButton.hidden = YES;
//                }
            }
        }
        if (itemModel.current_state_expire_at.length!=0) {
            self.orderTimeDown.hidden = NO;
            [self.orderTimeDown setEndTime:itemModel.current_state_expire_at NowTime:itemModel.current_time begainText:@"距结束:"];
        } else {
            self.orderTimeDown.hidden = YES;
            [self.orderTimeDown destroyTimer];
        }
    }
    
}


- (void)sellerOfButtonClick:(UIButton *)sender {

    NSInteger index = sender.tag-tag_seller_button;
    YBLOrderPropertyItemModel *itemModel = self.itemModel.property_order.orderStateCount[index];
    
    BLOCK_EXEC(self.orderDetailBarViewClickBlock,sender.currentTitle,itemModel,YES);
    
}

- (void)buyerOfButtonClick:(UIButton *)sender {

    NSInteger index = sender.tag-tag_buyer_button;
    YBLOrderPropertyItemModel *itemModel = self.itemModel.property_order.orderStateCount[index];
    
    BLOCK_EXEC(self.orderDetailBarViewClickBlock,sender.currentTitle,itemModel,NO);
    
}

@end
