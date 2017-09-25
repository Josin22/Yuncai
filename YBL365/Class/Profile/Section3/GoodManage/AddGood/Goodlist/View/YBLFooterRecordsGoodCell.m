//
//  YBL.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFooterRecordsGoodCell.h"
#import "YBLGoodModel.h"

@implementation YBLFooterRecordsGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    
}

- (void)updateItemCellModel:(id)itemModel{
    
    [super updateItemCellModel:itemModel];
    
    YBLGoodModel *goodModel = (YBLGoodModel *)itemModel;
    self.addToStoreButton.hidden = YES;
    self.noStockImageView.hidden = YES;
    self.saleCountName.attributedText = [NSString price:[NSString stringWithFormat:@"%.2f",goodModel.price.doubleValue] color:YBLThemeColor font:20];
}

@end
