//
//  YBLStoreBaseInfoCell.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreBaseInfoCell.h"
#import "shop.h"

@implementation YBLStoreBaseInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createssUIss];
    }
    return self;
}

- (void)createssUIss{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 70)];
    [self.contentView addSubview:bgView];
    self.bgView = bgView;

    self.storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, 0, 80, 30)];
    self.storeImageView.layer.borderColor = YBLLineColor.CGColor;
    self.storeImageView.layer.borderWidth = .5;
    self.storeImageView.centerY = self.bgView.height/2;
    self.storeImageView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.storeImageView];
    
    self.creditStoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"creadit_arrow"]];
    self.creditStoreImageView.frame = CGRectMake(0, 0, 50, 18);
    self.creditStoreImageView.centerX = self.storeImageView.centerX;
    [self.bgView addSubview:self.creditStoreImageView];
    
    CGFloat buttonWi = 50;

    self.storeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.storeImageView.right+space, self.storeImageView.top, self.bgView.width-self.storeImageView.right-space*3-buttonWi, self.storeImageView.height/2)];
    self.storeTitleLabel.textColor = BlackTextColor;
    self.storeTitleLabel.font = YBLFont(15);
    [self.bgView addSubview:self.storeTitleLabel];
    
    self.foucsEvaluteLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.storeTitleLabel.left, self.storeTitleLabel.bottom, self.storeTitleLabel.width, self.storeTitleLabel.height)];
    self.foucsEvaluteLabel.textColor = YBLTextColor;
    self.foucsEvaluteLabel.font = YBLFont(12);
    self.foucsEvaluteLabel.text = @"0人关注  综合评分9.9";
    [self.bgView addSubview:self.foucsEvaluteLabel];
    
    self.inStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.inStoreButton.frame = CGRectMake(0, 0, 26, 26);
    [self.inStoreButton setImage:[UIImage imageNamed:@"goods_list_arrow"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.inStoreButton];
    self.inStoreButton.userInteractionEnabled = NO;
    self.inStoreButton.right = YBLWindowWidth;
    self.inStoreButton.centerY = 35;
    
//    [self.inStoreButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, self.bgStoreButton.height-.5, self.bgStoreButton.width, .5)]];
    
    self.lineView = [YBLMethodTools addLineView:CGRectMake(0, 0, YBLWindowWidth, .5)];
    [self.contentView addSubview:self.lineView];
    self.lineView.bottom = 70;
    
    self.bgStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bgStoreButton.frame = CGRectMake(0, 0, YBLWindowWidth, 70);
    [self.contentView addSubview:self.bgStoreButton];
    self.bgStoreButton.hidden = YES;
}

- (void)updateItemCellModel:(id)itemModel{
    NSString *logo_url = nil;
    NSString *store_name = nil;
    NSInteger fous_count = 0;
    float rating = .0;
    BOOL isCredit = NO;
    if ([itemModel isKindOfClass:[shop class]]) {
        shop *model = (shop *)itemModel;
        logo_url = model.logo_url;
        store_name = model.shopname;
        fous_count = model.followers_count.integerValue;
        rating = model.comment_rate.doubleValue;
        isCredit = [model.credit isEqualToString:@"china"]? YES:NO;
    } else if ([itemModel isKindOfClass:[YBLUserInfoModel class]]){
        YBLUserInfoModel *model = (YBLUserInfoModel *)itemModel;
        logo_url = model.logo_url;
        store_name = model.shopname;
        fous_count = model.followers_count.integerValue;
        rating = model.comment_rate.doubleValue;
        isCredit = [model.credit isEqualToString:@"china"]? YES:NO;
    }
    self.creditStoreImageView.hidden = !isCredit;
    [self.storeImageView js_alpha_setImageWithURL:[NSURL URLWithString:logo_url] placeholderImage:smallImagePlaceholder];
    self.storeTitleLabel.text = store_name;
    self.foucsEvaluteLabel.text = [NSString stringWithFormat:@"%ld人关注 综合评分%.1f",fous_count,rating];
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return 70;
}

@end
