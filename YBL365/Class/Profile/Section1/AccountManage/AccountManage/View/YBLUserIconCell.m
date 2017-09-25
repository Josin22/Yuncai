//
//  YBLUserIconCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLUserIconCell.h"
#import "YBLAccountManageItemModel.h"

@interface YBLUserIconCell ()

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation YBLUserIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hi = [YBLUserIconCell getHi];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 80, hi)];
    titleLabel.textColor = BlackTextColor;
    titleLabel.font = YBLFont(15);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YBLWindowWidth-space-8-4-(hi-2*space), space, hi-2*space, hi-2*space)];
    [self.contentView addSubview:iconImageView];
    iconImageView.layer.cornerRadius = iconImageView.width/2;
    iconImageView.layer.masksToBounds = YES;
    self.iconImageView = iconImageView;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(YBLWindowWidth-space-8, 0, 8, 16.5);
    arrowImageView.centerY = hi/2;
    [self.contentView addSubview:arrowImageView];
    
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(0, 0, YBLWindowWidth, hi);
    [self.contentView addSubview:clickButton];
    self.clickButton = clickButton;
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, hi-.5, YBLWindowWidth, .5)]];
    
}

- (void)updateModel:(YBLAccountManageItemModel *)model{
    
    self.titleLabel.text = model.title;
    
    if ([model.icon_url isKindOfClass:[NSString class]]) {
        if ([model.icon_url hasPrefix:@"http"]) {
            [self.iconImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.icon_url] placeholderImage:smallImagePlaceholder];
        } else {
            self.iconImageView.image = [UIImage imageNamed:model.icon_url];
        }
    } else if ([model.icon_url isKindOfClass:[UIImage class]]){
        
        self.iconImageView.image = model.icon_url;
    }
}

+ (CGFloat)getHi{
    
    return 70;
}

@end
