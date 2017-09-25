
//
//  YBLFoucsStoreView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoucsStoreView.h"

static YBLFoucsStoreView *foucsStoreView = nil;

@interface YBLFoucsStoreView ()

@property (nonatomic, copy) FoucsClickBlock block;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, retain) UILabel *foucsLabel;

@property (nonatomic, strong) UIButton *foucsButton;
@property (nonatomic, strong) UIButton *foucsCountButton;

@end

@implementation YBLFoucsStoreView

+ (void)showFoucsStoreViewWithFrame:(CGRect)frame
                          addToView:(UIView *)view
                    foucsClickBlock:(FoucsClickBlock)block
{
    
    if (foucsStoreView) {
        [foucsStoreView removeFromSuperview];
        foucsStoreView = nil;
    }
    foucsStoreView = [[YBLFoucsStoreView alloc] initWithFrame:frame];
    foucsStoreView.block = block;
    [view addSubview:foucsStoreView];
    
    foucsStoreView.contentView.left = foucsStoreView.width;
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         foucsStoreView.contentView.left = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.clipsToBounds = YES;
    
    CGFloat fontValue = 0;
    if (IS_IPHONE_6PLUS) {
        fontValue = ValueNummber;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissFoucsView)];
    [bgView addGestureRecognizer:tap];
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(self.width, self.width-30, self.width, self.height-self.width+30)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIButton *foucsCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foucsCountButton.frame = CGRectMake(0, 0, contentView.width/2, 30);
    foucsCountButton.backgroundColor = YBLColor(240,93,34,1);
    [foucsCountButton setTitle:@"188人/浏览" forState:UIControlStateNormal];
    [foucsCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    foucsCountButton.titleLabel.font = YBLFont(12+fontValue);
    [contentView addSubview:foucsCountButton];
    self.foucsCountButton = foucsCountButton;
    
    UIButton *foucsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foucsButton.frame = CGRectMake(foucsCountButton.width, 0, contentView.width/2, 30);
    foucsButton.backgroundColor = YBLThemeColor;
    [foucsButton setTitle:@"关注店铺" forState:UIControlStateNormal];
    [foucsButton setTitle:@"关注成功" forState:UIControlStateDisabled];
    [foucsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    foucsButton.titleLabel.font = YBLFont(12+fontValue);
    WEAK
    [[foucsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        self.foucsButton.enabled = NO;
        self.foucsLabel.hidden = NO;
        self.foucsLabel.alpha = 1;
        [UIView animateWithDuration:2.f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.foucsLabel.alpha = 0;
                             self.foucsLabel.top = -self.contentView.height/2;
                         }
                         completion:^(BOOL finished) {
                             [self.foucsLabel removeFromSuperview];
                             [self.foucsCountButton setTitle:@"189人/浏览" forState:UIControlStateNormal];
                         }];
    }];
    [contentView addSubview:foucsButton];
    self.foucsButton = foucsButton;
    
    UILabel *foucsLabel = [[UILabel alloc]initWithFrame:[foucsButton frame]];
    foucsLabel.text = @"+1";
    foucsLabel.font = YBLFont(16+fontValue);
    foucsLabel.textAlignment = NSTextAlignmentRight;
    foucsLabel.textColor = YBLThemeColor;
    [contentView addSubview:foucsLabel];
    foucsLabel.hidden = YES;
    self.foucsLabel = foucsLabel;
    
    CGFloat newSpace = (self.height-self.width-40-20-20)/4;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, foucsCountButton.bottom+newSpace, contentView.width-10, 40)];
    titleLabel.text = @"贵州茅台镇酱香型白酒接待专用酒53度";
    titleLabel.numberOfLines = 2;
    titleLabel.font = YBLFont(13+fontValue);
    titleLabel.textColor = BlackTextColor;
    [contentView addSubview:titleLabel];
    
    YBLButton *xinyongtongButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    xinyongtongButton.frame = CGRectMake(titleLabel.left, titleLabel.bottom+newSpace, 50, 20);
    [xinyongtongButton setImage:[UIImage imageNamed:@"xinyongtong"] forState:UIControlStateNormal];
    [xinyongtongButton setTitle:@"2年" forState:UIControlStateNormal];
    [xinyongtongButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    xinyongtongButton.titleLabel.font = YBLFont(11+fontValue);
    xinyongtongButton.imageRect = CGRectMake(0, (20-(15+fontValue))/2, 15+fontValue, 15+fontValue);
    xinyongtongButton.titleRect = CGRectMake(17+fontValue, 0, 40, 20);
    [contentView addSubview:xinyongtongButton];
    
    NSArray *signelValueArray = @[@"48小时发货",@"破损补寄",@"假一赔十"];
    CGFloat signelSpace = 2.5;
    CGFloat sigenlWi = (contentView.width-10-signelSpace*2)/signelValueArray.count;
    
    for (int i = 0; i<signelValueArray.count; i++) {
        
        NSString *text = signelValueArray[i];
        
        CGSize textSize = [text heightWithFont:YBLFont(8+fontValue) MaxWidth:200];
        
        UIButton *signel = [UIButton buttonWithType:UIButtonTypeCustom];
        signel.layer.cornerRadius = 2;
        signel.layer.masksToBounds = YES;
        signel.layer.borderColor = YBLThemeColor.CGColor;
        signel.layer.borderWidth = 0.5;
        signel.frame = CGRectMake(xinyongtongButton.left+i*(sigenlWi+signelSpace), xinyongtongButton.bottom+newSpace, sigenlWi, textSize.height+5);
        [signel setTitle:text forState:UIControlStateNormal];
        [signel setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        signel.titleLabel.font = YBLFont(8+fontValue);
        [contentView addSubview:signel];
    }
    

    
}

+ (void)dismissFoucsView{
    
    [foucsStoreView dismissFoucsView];
}

- (void)dismissFoucsView{
    
    if (foucsStoreView) {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.contentView.left = self.width;
                         }
                         completion:^(BOOL finished) {
                             [foucsStoreView removeFromSuperview];
                             foucsStoreView = nil;
                         }];

    }
}

@end
