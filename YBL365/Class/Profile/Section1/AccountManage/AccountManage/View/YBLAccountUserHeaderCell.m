//
//  YBLAccountUserHeaderCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAccountUserHeaderCell.h"
#import "YBLAccountManageItemModel.h"

@interface YBLAccountUserHeaderCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, retain) UILabel *nichengLabel;

@property (nonatomic, retain) UILabel *trueNameLabel;

@end

@implementation YBLAccountUserHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [YBLAccountUserHeaderCell getHi];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, hi-2*space, hi-2*space)];
    [self.contentView addSubview:iconImageView];
    iconImageView.layer.cornerRadius = iconImageView.width/2;
    iconImageView.layer.masksToBounds = YES;
    self.iconImageView = iconImageView;
    
    UILabel *nichengLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+space, iconImageView.top, YBLWindowWidth-iconImageView.right-space*3.5, 30)];
    nichengLabel.textColor = BlackTextColor;
    nichengLabel.font = YBLFont(16);
    nichengLabel.text = loadString;
    [self.contentView addSubview:nichengLabel];
    self.nichengLabel = nichengLabel;
    
    UILabel *trueNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nichengLabel.left, nichengLabel.bottom, nichengLabel.width, nichengLabel.height)];
    trueNameLabel.text = loadString;
    trueNameLabel.textColor = YBLTextColor;
    trueNameLabel.font = YBLFont(14);
    [self.contentView addSubview:trueNameLabel];
    self.trueNameLabel = trueNameLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(YBLWindowWidth-space-8, 0, 8, 16.5);
    arrowImageView.centerY = hi/2;
    [self.contentView addSubview:arrowImageView];
    
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(0, 0, YBLWindowWidth, hi);
    [self.contentView addSubview:clickButton];
    self.clickButton = clickButton;
}


- (void)updateModel:(YBLAccountManageItemModel *)model{
    
    if ([model.icon_url rangeOfString:@"http://"].location != NSNotFound) {
        [self.iconImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.icon_url] placeholderImage:smallImagePlaceholder];
    } else {
        self.iconImageView.image = [UIImage imageNamed:model.icon_url];
    }
    
    self.nichengLabel.text = model.title;
    
    self.trueNameLabel.text = model.value;
}


+ (CGFloat)getHi{
    
    return 80;
}

@end
