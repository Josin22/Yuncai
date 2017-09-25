//
//  YBLCouponsSelectCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsSelectCell.h"

@implementation YBLCouponsSelectCell

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
    
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return [super getItemCellHeightWithModel:itemModel];
}

@end
