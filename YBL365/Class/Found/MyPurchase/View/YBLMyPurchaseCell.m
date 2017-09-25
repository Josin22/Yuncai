//
//  YBLMyPurchaseCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyPurchaseCell.h"
#import "YBLTimeDown.h"
#import "YBLPurchaseOrderModel.h"

typedef NS_ENUM(NSInteger,CellType) {
    CellTypeMyPurchase = 0,  //我的采购
    CellTypeOutPriceRecords  //报价记录
};

static NSInteger const tag_undefine_button = 21135465;

@interface YBLMyPurchaseCell ()

@property (nonatomic, retain) UILabel *signlLabel;

@property (nonatomic, retain) UILabel *goodTitleLabel;

@property (nonatomic, retain) UILabel *goodDepositMoneyLabel;

@property (nonatomic, retain) UILabel *goodJoinRecordLabel;

@property (nonatomic, strong) YBLTimeDown *timeDown;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *undefineLabel;

@property (nonatomic, assign) CellType cellType;

@property (nonatomic, strong) YBLPurchaseOrderModel *orderModel;

@end

@implementation YBLMyPurchaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, 80, 80)];
    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    [self.contentView addSubview:goodImageView];
    self.goodImageView = goodImageView;

    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, goodImageView.width, 16)];
    signLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];;
    signLabel.textColor = [UIColor whiteColor];
    signLabel.text = @"正在进行";
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.font = YBLFont(12);
    [goodImageView addSubview:signLabel];
    self.signlLabel = signLabel;
    
//    self.signlButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.signlButton.frame = CGRectMake(0, 0, goodImageView.width, 18);
//    [self.signlButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.5] forState:UIControlStateNormal];
//    [self.signlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.signlButton.titleLabel.font = YBLFont(12);
//    [goodImageView addSubview:self.signlButton];
    
    UIButton *clickPurchaseGoodButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    clickPurchaseGoodButton.frame = self.goodImageView.frame;
    [self.contentView addSubview:clickPurchaseGoodButton];
    self.clickPurchaseGoodButton = clickPurchaseGoodButton;
    
    self.goodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.right+space, goodImageView.top, YBLWindowWidth-goodImageView.right-space*2, 37)];
    self.goodTitleLabel.numberOfLines = 0;
    self.goodTitleLabel.font = YBLFont(14);
    self.goodTitleLabel.textColor = BlackTextColor;
    [self.contentView addSubview:self.goodTitleLabel];
    
    self.goodDepositMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodTitleLabel.left, self.goodTitleLabel.bottom, self.goodTitleLabel.width, 20)];
    self.goodDepositMoneyLabel.text = @"当前价格: ¥220.03";
    self.goodDepositMoneyLabel.font = YBLFont(13);
    self.goodDepositMoneyLabel.textColor = BlackTextColor;
    [self.contentView addSubview:self.goodDepositMoneyLabel];
    
    self.goodJoinRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodDepositMoneyLabel.left, self.goodDepositMoneyLabel.bottom, self.goodDepositMoneyLabel.width, 20)];
    self.goodJoinRecordLabel.font = YBLFont(13);
    self.goodJoinRecordLabel.text = @"10人参与/100人浏览";
    self.goodJoinRecordLabel.textColor = BlackTextColor;
    [self.contentView addSubview:self.goodJoinRecordLabel];
    
    self.undefineLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodImageView.left, goodImageView.bottom+space, YBLWindowWidth/2, 15)];
    self.undefineLabel.font = YBLFont(12);
    self.undefineLabel.textColor = BlackTextColor;
    [self.contentView addSubview:self.undefineLabel];
    
    self.timeDown = [[YBLTimeDown alloc] initWithFrame:CGRectMake(goodImageView.left, goodImageView.bottom+space, YBLWindowWidth/2+space, 15)
                                              WithType:TimeDownTypeText];
    self.timeDown.textTimerLabel.textColor = YBLTextColor;
    self.timeDown.textTimerLabel.textAlignment = NSTextAlignmentLeft;
    self.timeDown.textTimerLabel.font = YBLFont(12);
    [self.contentView addSubview:self.timeDown];
    
    
    CGFloat buttonwi = 70;
    CGFloat buttonhi = 28;
    for (int i = 0; i < 2; i++) {
        UIButton *undefineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        undefineButton.frame = CGRectMake(YBLWindowWidth-(buttonwi+space)*(i+1), self.timeDown.bottom-buttonhi, buttonwi, buttonhi);
        undefineButton.layer.cornerRadius = 3;
        undefineButton.layer.masksToBounds = YES;
        undefineButton.titleLabel.font = YBLFont(14);
        undefineButton.tag = tag_undefine_button+i;
        if (i == 0) {
            [undefineButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
            undefineButton.layer.borderColor = YBLThemeColor.CGColor;
        } else {
            [undefineButton setTitleColor:YBLColor(0, 121, 0, 1) forState:UIControlStateNormal];
            undefineButton.layer.borderColor = YBLColor(0, 121, 0, 1).CGColor;
        }
        undefineButton.layer.borderWidth = .5;
        [undefineButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:undefineButton];
        undefineButton.hidden = YES;
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, self.timeDown.bottom+space-0.5, YBLWindowWidth-space, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self.contentView addSubview:lineView];
    
}

- (void)updateItemCellModel:(id)itemModel{
    
    _orderModel = (YBLPurchaseOrderModel *)itemModel;
    
    [self.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:_orderModel.thumb] placeholderImage:smallImagePlaceholder];
    
    self.goodTitleLabel.text = _orderModel.title;
    self.goodTitleLabel.font = _orderModel.text_font;
    self.goodTitleLabel.height = _orderModel.text_height>37?37:_orderModel.text_height;
    
    self.goodJoinRecordLabel.attributedText = _orderModel.att_text;
    
    [self.timeDown setEndTime:_orderModel.enddated_at NowTime:_orderModel.system_time begainText:@"距结束:"];
    if (_orderModel.lowest_price.doubleValue<=0) {
        self.goodDepositMoneyLabel.text = [NSString stringWithFormat:@"当前价格: %.2f",_orderModel.price.doubleValue];
    } else {
        self.goodDepositMoneyLabel.text = [NSString stringWithFormat:@"当前价格: %.2f-%.2f",_orderModel.price.doubleValue,_orderModel.lowest_price.doubleValue];
    }
    
    NSString *heade_title = nil;
    /* 按钮 */
    NSMutableArray *titleArray = nil;
    //        BOOL isActive = NO;
    if (_orderModel.myPurchaseType == MyPurchaseTypePurchaseOrder) {
        
        heade_title = _orderModel.purchase_state_for_purchaser.mypurchase_head;
        titleArray = _orderModel.purchase_state_for_purchaser.mypurchase_button;
        //            isActive = YES;
        
    } else if (_orderModel.myPurchaseType == MyPurchaseTypePurchaseRecords) {
        
        heade_title = _orderModel.purchase_state_for_bidder.mypurchase_head;
        titleArray = _orderModel.purchase_state_for_bidder.mypurchase_button;
        //            isActive = _orderModel.purchase_state_for_bidder.disabled.boolValue;
    }
    NSInteger count = titleArray.count;
    
    for (int i = 0; i < 2; i++) {
        UIButton *undefineButton = (UIButton *)[self viewWithTag:tag_undefine_button+i];
        undefineButton.hidden = YES;
        if (i<count) {
            undefineButton.hidden = NO;
            NSString *buttonTitle = titleArray[i];
            [undefineButton setTitle:buttonTitle forState:UIControlStateNormal];
            //                undefineButton.enabled = isActive;
        }
    }
    self.signlLabel.text = heade_title;
    /*
    if (_orderModel.myPurchaseType == MyPurchaseTypePurchaseAllRecords) {
        
        heade_title = _orderModel.purchase_state_for_purchaser.mypurchase_head;
        UIButton *undefineButton = (UIButton *)[self viewWithTag:tag_undefine_button];
        undefineButton.hidden = NO;
        [undefineButton setTitle:_orderModel.purchase_state_for_purchaser.histroy forState:UIControlStateNormal];

    } else {
        // 按钮
        NSMutableArray *titleArray = nil;
//        BOOL isActive = NO;
        if (_orderModel.myPurchaseType == MyPurchaseTypePurchaseOrder) {
            
            heade_title = _orderModel.purchase_state_for_purchaser.mypurchase_head;
            titleArray = _orderModel.purchase_state_for_purchaser.mypurchase_button;
//            isActive = YES;
            
        } else if (_orderModel.myPurchaseType == MyPurchaseTypePurchaseRecords) {
            
            heade_title = _orderModel.purchase_state_for_bidder.mypurchase_head;
            titleArray = _orderModel.purchase_state_for_bidder.mypurchase_button;
//            isActive = _orderModel.purchase_state_for_bidder.disabled.boolValue;
        }
        NSInteger count = titleArray.count;
        
        for (int i = 0; i < 2; i++) {
            UIButton *undefineButton = (UIButton *)[self viewWithTag:tag_undefine_button+i];
            undefineButton.hidden = YES;
            if (i<count) {
                undefineButton.hidden = NO;
                NSString *buttonTitle = titleArray[i];
                [undefineButton setTitle:buttonTitle forState:UIControlStateNormal];
//                undefineButton.enabled = isActive;
            }
        }
    }
    */
    
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return 125;
}


- (void)buttonClick:(UIButton *)btn {

    BLOCK_EXEC(self.myPurchaseCellButtonBlock,self.orderModel,btn.currentTitle)
}

@end
