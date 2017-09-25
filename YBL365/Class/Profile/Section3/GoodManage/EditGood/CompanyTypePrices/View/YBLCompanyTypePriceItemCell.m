//
//  YBLCompanyTypePriceItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCompanyTypePriceItemCell.h"
#import "YBLCompanyTypePricesParaModel.h"

@interface YBLCompanyTypePriceItemCell ()

@end

@implementation YBLCompanyTypePriceItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                               placeholder:(NSString *)placeholder
                                isSwitchOn:(BOOL)isSwitchOn
                                      type:(EditTypeCell)type{
    YBLEditItemGoodParaModel *model = [YBLEditItemGoodParaModel new];
    model.title = title;
    model.placeholder = placeholder;
    model.editTypeCell = type;
    model.isSwitchOn = isSwitchOn;
    
    return model;
}

- (void)createUI{
    
    CGFloat height = [YBLCompanyTypePriceItemCell getItemCellHeightWithModel:nil];
    
    YBLEditItemGoodParaModel *numModel = [self getModelWith:@"起批数量 : " placeholder:@"请输入起批数量" isSwitchOn:NO type:EditTypeCellSwithWrite];
    YBLEditPurchaseCell *numCell = [[YBLEditPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    numCell.frame = CGRectMake(0, 0, YBLWindowWidth, height/2);
    [numCell updateItemCellModel:numModel];
    [self.contentView addSubview:numCell];
    self.numCell = numCell;
    
    YBLEditItemGoodParaModel *priceModel = [self getModelWith:@"价格 : " placeholder:@"请输入起批价格" isSwitchOn:NO type:EditTypeCellOnlyWrite];
    YBLEditPurchaseCell *priceCell = [[YBLEditPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    priceCell.frame = CGRectMake(0, height/2, YBLWindowWidth, height/2);
    [priceCell updateItemCellModel:priceModel];
    [self.contentView addSubview:priceCell];
    self.priceCell = priceCell;
    
//    RACSignal * deallocSignal = [self rac_signalForSelector:@selector(dealloc)];
    
    WEAK
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.numCell.valueTextFeild] subscribeNext:^(NSNotification *x) {
        STRONG
        UITextField *t1 = [x object];
        NSString *text = t1.text;
        BLOCK_EXEC(self.companyTypePriceItemCellNumTextfieldBlock,text);
        
    }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.priceCell.valueTextFeild] subscribeNext:^(NSNotification *x) {
        STRONG
        UITextField *t1 = [x object];
        NSString *text = t1.text;
        BLOCK_EXEC(self.companyTypePriceItemCellPriceTextfieldBlock,text);
        
    }];
}

- (void)updateItemCellModel:(id)itemModel{
    
    PricesItemModel *priceModel = (PricesItemModel *)itemModel;
    self.numCell.good_switch.on = priceModel.active.boolValue;
    if (priceModel.min.integerValue==0) {
        self.numCell.valueTextFeild.text = nil;
    } else {
        self.numCell.valueTextFeild.text = [NSString stringWithFormat:@"%ld",(long)priceModel.min.integerValue];
    }
    if (priceModel.sale_price.doubleValue==0) {
        self.priceCell.valueTextFeild.text = nil;
    } else {
        self.priceCell.valueTextFeild.text = [NSString stringWithFormat:@"%.2f",priceModel.sale_price.doubleValue];
    }
    self.numCell.valueTextFeild.keyboardType = UIKeyboardTypePhonePad;
    self.priceCell.valueTextFeild.keyboardType = UIKeyboardTypeDecimalPad;
}
- (void)dealloc
{
    
}
+(CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 100;
}

@end
