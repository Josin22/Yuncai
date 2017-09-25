
//
//  YBLLabelsCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLLabelsCell.h"

@implementation YBLLabelsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createLabelsCellUI];
    }
    return self;
}

- (void)createLabelsCellUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;;
    
    CGFloat hi = [YBLLabelsCell getItemCellHeightWithModel:nil];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 5, 20, 20)];
    titleLabel.centerY = hi/2;
    titleLabel.textColor = YBLTextColor;
    titleLabel.font = YBLFont(13);
    [self.contentView addSubview:titleLabel];
    self.ttLabel = titleLabel;
    
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(YBLWindowWidth-10-30, 5, 30,20);
    moreButton.centerY = hi/2;
    [moreButton setImage:[UIImage imageNamed:@"more_sandian"] forState:UIControlStateNormal];
    moreButton.enabled = NO;
    [self.contentView addSubview:moreButton];
    self.moreButton = moreButton;
}

- (void)handleTextLabel:(NSString *)text{
    NSString *labelText = text;
    CGFloat centerY = self.ttLabel.centerY;
    CGSize labelSize = [labelText heightWithFont:YBLFont(14) MaxWidth:200];
    self.ttLabel.text = text;
    self.ttLabel.size = labelSize;
    self.ttLabel.centerY = centerY;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return 50;
}

@end
