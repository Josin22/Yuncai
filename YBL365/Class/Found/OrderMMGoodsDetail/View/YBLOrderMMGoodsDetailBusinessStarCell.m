//
//  YBLOrderMMGoodsDetailBusinessStarCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMGoodsDetailBusinessStarCell.h"

@implementation YBLOrderMMGoodsDetailBusinessStarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UILabel *caiShangLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, YBLWindowWidth/2-space, 20)];
    caiShangLabel.text = @"采购商家等级";
    caiShangLabel.font = YBLFont(12);
    caiShangLabel.textColor = YBLTextColor;
    [self addSubview:caiShangLabel];
    
    UILabel *caiShangStarLabel = [[UILabel alloc] initWithFrame:CGRectMake(YBLWindowWidth/2, space, YBLWindowWidth/2-space, 20)];
    caiShangStarLabel.text = @"综合评分9.9分";
    caiShangStarLabel.font = YBLFont(12);
    caiShangStarLabel.textAlignment = NSTextAlignmentRight;
    caiShangStarLabel.textColor = YBLTextColor;
    [self addSubview:caiShangStarLabel];
}

+ (CGFloat)getBusinessStarCellHeight{
    
    return 40;
}

@end
