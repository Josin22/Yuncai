//
//  YBLStoreFollowersCell.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreFollowersCell.h"
#import "YBLGoodSharersModel.h"

@interface YBLStoreFollowersCell ()

@property (nonatomic, retain) UILabel *timeLabel;

@end

@implementation YBLStoreFollowersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createssUI];
    }
    return self;
}

- (void)createssUI{

    self.goodImageView.userInteractionEnabled = YES;
    self.goodImageView.clipsToBounds = YES;
    self.goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconTap = [[UITapGestureRecognizer alloc] init];
    [self.goodImageView addGestureRecognizer:self.iconTap];
    
    CGFloat height = [YBLStoreFollowersCell getItemCellHeightWithModel:nil];
    CGFloat imageWi = height-space*2;
    self.goodImageView.frame = CGRectMake(space, space, imageWi, imageWi);
    
    CGFloat buttonWi = 80;
    CGFloat buttonHi = 27;
    
    self.goodNameLabel.left = self.goodImageView.right+space/2;
    self.goodNameLabel.top = self.goodImageView.top;
    self.goodNameLabel.height = 17;
    self.saleCountName.width = YBLWindowWidth-self.goodNameLabel.left-buttonWi-space;
    self.goodNameLabel.font = YBLFont(15);
    
    self.saleCountName.top = self.goodNameLabel.bottom+space/2;
    self.saleCountName.left = self.goodNameLabel.left;
    self.saleCountName.width = self.goodNameLabel.width;
    self.saleCountName.font = YBLFont(12);
    self.saleCountName.text = @"关注了您的店铺";

    self.addToStoreButton.size = CGSizeMake(buttonWi, buttonHi);
    [self.addToStoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addToStoreButton setTitleColor:YBLColor(180, 180, 180, 1) forState:UIControlStateDisabled];   
    [self.addToStoreButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self.addToStoreButton setBackgroundColor:YBLColor(230, 230, 230, 1) forState:UIControlStateDisabled];
    [self.addToStoreButton setTitle:@"＋粉丝" forState:UIControlStateNormal];
    [self.addToStoreButton setTitle:@"已关注" forState:UIControlStateDisabled];
    self.addToStoreButton.centerY = height/2;
    self.addToStoreButton.right = YBLWindowWidth-space;
    
    self.lineView.left = self.goodNameLabel.left;
    self.lineView.width = YBLWindowWidth-self.lineView.left;
    self.lineView.bottom = height;
 
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.saleCountName.left, 0, self.goodNameLabel.width, 15)];
    timeLabel.bottom = self.goodImageView.bottom;
    timeLabel.textColor = YBLTextLightColor;
    timeLabel.font = YBLFont(12);
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
}

- (void)updateItemCellModel:(id)itemModel{
    NSString *head_image = nil;
    NSString *shop_name = nil;
    NSString *time = nil;
    if ([itemModel isKindOfClass:[YBLUserInfoModel class]]) {
        YBLUserInfoModel *model = (YBLUserInfoModel *)itemModel;
        head_image = model.head_img;
        shop_name = model.shopname;
        time = model.follow_date;
        //已支付 -->>已关注
        if (model.follow_state.integerValue==1) {
            self.addToStoreButton.enabled = NO;
        } else {
            //未支付-->>关注
            self.addToStoreButton.enabled = YES;
        }
    } else if ([itemModel isKindOfClass:[YBLGoodSharersModel class]]){
        YBLGoodSharersModel *model = (YBLGoodSharersModel *)itemModel;
        head_image = model.head_img;
        shop_name = model.nickname;
        time = model.created_at;
        self.addToStoreButton.hidden = YES;
        self.saleCountName.text = @"分享了您的商品";
    }
    self.timeLabel.text = time;
    self.goodNameLabel.text = shop_name;
    if (head_image.length>0) {
        [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:head_image] placeholderImage:smallImagePlaceholder];
    } else {
        self.goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    }
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    return 90;
}

@end
