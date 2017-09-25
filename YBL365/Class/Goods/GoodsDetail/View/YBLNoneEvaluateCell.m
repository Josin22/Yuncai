//
//  YBLNoneEvaluateCell.m
//  YC168
//
//  Created by 乔同新 on 2017/6/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLNoneEvaluateCell.h"

@implementation YBLNoneEvaluateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat height = [YBLNoneEvaluateCell getItemCellHeightWithModel:nil];
    
    YBLButton *goodEvaluateButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    goodEvaluateButton.frame = CGRectMake(0, 0, YBLWindowWidth, height);
    goodEvaluateButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [goodEvaluateButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    goodEvaluateButton.titleLabel.font = YBLFont(14);
    [goodEvaluateButton setImage:[UIImage imageNamed:@"goods_list_arrow"] forState:UIControlStateNormal];
    [goodEvaluateButton setTitle:@"评价(暂无评价，购买后快来发表评价)" forState:UIControlStateNormal];
    goodEvaluateButton.titleRect = CGRectMake(space, 0,  YBLWindowWidth-space-20, height);
    goodEvaluateButton.imageRect = CGRectMake( YBLWindowWidth-16, (height-12)/2,  6, 12);
    [self.contentView addSubview:goodEvaluateButton];
    self.goodEvaluateButton = goodEvaluateButton;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return 50;
}

@end
