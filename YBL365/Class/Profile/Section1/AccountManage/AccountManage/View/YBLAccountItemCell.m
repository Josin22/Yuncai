//
//  YBLAccountItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAccountItemCell.h"
#import "YBLAccountManageItemModel.h"

@interface YBLAccountItemCell ()

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *valueLabel;

@end

@implementation YBLAccountItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [YBLAccountItemCell getHi];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 80, hi)];
    titleLabel.textColor = BlackTextColor;
    titleLabel.font = YBLFont(15);
    titleLabel.text = loadString;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;

    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(YBLWindowWidth-space-8, 0, 8, 16.5);
    arrowImageView.centerY = hi/2;
    [self.contentView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, 0, YBLWindowWidth-titleLabel.right-arrowImageView.width-space-4, titleLabel.height)];
    valueLabel.text = loadString;
    valueLabel.textColor = YBLTextColor;
    valueLabel.font = YBLFont(13);
    valueLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:valueLabel];
    self.valueLabel = valueLabel;

    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(0, 0, YBLWindowWidth, hi);
    [self.contentView addSubview:clickButton];
    self.clickButton = clickButton;
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-.5, YBLWindowWidth, .5)]];
}

- (void)updateModel:(YBLAccountManageItemModel *)model{
    
    self.titleLabel.text = model.title;
    self.valueLabel.text = model.value;
    if (model.cellItemType == CellItemTypeNoCanWriteClick) {
        self.clickButton.enabled = NO;
        self.arrowImageView.hidden = YES;
    } else if (model.cellItemType == CellItemTypeJustClick) {
        self.clickButton.enabled = YES;
        self.arrowImageView.hidden = NO;
    } else if (model.cellItemType == CellItemTypeClickWrite) {
        self.clickButton.enabled = YES;
        self.arrowImageView.hidden = NO;
    }

}

+ (CGFloat)getHi{
    
    return 50;
}

@end
