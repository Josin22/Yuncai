//
//  YBLStoreLogoView.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreLogoView.h"
#import "YBLStoreCollectView.h"

@interface YBLStoreLogoView ()
{
    UIButton * backgroundBtn;
    UIImageView * rightArrowImg;
}
@property (nonatomic, strong) UIImageView * iconImage;
@property (nonatomic, strong) UILabel * storeLab;
@property (nonatomic, strong) UILabel * scoreLab;
@property (nonatomic, strong) UIImageView * collectBackgoundImg;
@property (nonatomic, strong) UIButton * collectNumBtn;
@property (nonatomic, strong) YBLStoreCollectView* collectView;
@end

@implementation YBLStoreLogoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self createrUI];
    }
    return self;
}

- (void)createrUI {
    backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundBtn.frame = CGRectMake(0, self.height-50, YBLWindowWidth-100, 50);
    backgroundBtn.backgroundColor = [UIColor clearColor];
    [backgroundBtn addTarget:self action:@selector(gotoStoreDetail) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundBtn];
    
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 100, 40)];
    _iconImage.layer.borderWidth = 0.3;
    _iconImage.layer.borderColor = YBLLineColor.CGColor;
    _iconImage.image = [UIImage imageNamed:@"store_store_logo"];
    [backgroundBtn addSubview:_iconImage];
    
    _storeLab = [[UILabel alloc]init];
    _storeLab.text = @"云采旗舰店";
    _storeLab.textColor = [UIColor whiteColor];
    _storeLab.font = YBLFont(14);
    CGFloat width = [_storeLab.text widthWithStringAttribute:@{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}];
    _storeLab.frame = CGRectMake(105, 5, width, 20);
    [backgroundBtn addSubview:_storeLab];
    
    rightArrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(_storeLab.right+5, 8, 15, 15)];
    rightArrowImg.image = [UIImage imageNamed:@"store_right_arrow"];
    [backgroundBtn addSubview:rightArrowImg];
    
    _scoreLab = [[UILabel alloc]init];
    _scoreLab.text = @"9.9分";
    _scoreLab.textColor = [UIColor whiteColor];
    _scoreLab.font = YBLFont(12);
    _scoreLab.frame = CGRectMake(105, 25, width, 20);
    [backgroundBtn addSubview:_scoreLab];
    
    _collectBackgoundImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-60, 15, 60, 40)];
    _collectBackgoundImg.image = [UIImage imageNamed:@"store_storebg_normal"];
    _collectBackgoundImg.userInteractionEnabled = YES;
    [self addSubview:_collectBackgoundImg];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setFrame:CGRectMake(0, 0, self.collectBackgoundImg.width, 25)];
    [_collectBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_collectBtn setTitle:@"已关注" forState:UIControlStateSelected];
    _collectBtn.titleLabel.font = YBLFont(11);
    [_collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_collectBtn setTitleColor:YBLThemeColor forState:UIControlStateSelected];
    [_collectBtn addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_collectBackgoundImg addSubview:_collectBtn];
    UIImage *collectImage       = [UIImage newImageWithNamed:@"store_collect_white" size:(CGSize){15,15}];
    [_collectBtn setImage:collectImage forState:UIControlStateNormal];
    UIImage *collectImageSelectImage       = [UIImage newImageWithNamed:@"store_collect_red" size:(CGSize){12,12}];
    [_collectBtn setImage:collectImageSelectImage forState:UIControlStateSelected];
    
    
    _collectNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectNumBtn setFrame:CGRectMake(0, 25, self.collectBackgoundImg.width, 15)];
    [_collectNumBtn setTitle:@"2999人" forState:UIControlStateNormal];
    [_collectNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_collectNumBtn addTarget:self action:@selector(gotoStoreDetail)forControlEvents:UIControlEventTouchUpInside];
    _collectNumBtn.titleLabel.font = YBLFont(11);
    [_collectBackgoundImg addSubview:_collectNumBtn];
}

#pragma mark  关注按钮
- (void)collectButtonClicked:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        _collectBackgoundImg.image = [UIImage imageNamed:@"store_storebg_select"];
        
    }else {
        _collectBackgoundImg.image = [UIImage imageNamed:@"store_storebg_normal"];
    }
    button.userInteractionEnabled = NO;

    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    _collectView = [[YBLStoreCollectView alloc]initWithFrame:CGRectMake(YBLWindowWidth/2, YBLWindowHeight/2,0, 0)];
    [keyWindow addSubview:self.collectView];
    [self.collectView showWithCollect:button.selected];
    
    self.collectView.dismissBlock = ^() {
        button.userInteractionEnabled = YES;
    };
    //    if (self.storeCollectBlock) {
    //        self.storeCollectBlock(button.selected);
    //    }
}

- (void)gotoStoreDetail {
    //店铺详情
    if (self.storeDetailBlock) {
        self.storeDetailBlock();
    }
}

- (void)changeFrame {
    backgroundBtn.frame =  CGRectMake(0, (self.height-50)/2, YBLWindowWidth-100, 50);
    _collectBackgoundImg.frame = CGRectMake(self.width-80, (self.height-50)/2, 80, 55);
    rightArrowImg.hidden = YES;
    _storeLab.textColor = BlackTextColor;
    _scoreLab.textColor = [UIColor lightGrayColor];
    _iconImage.image = [UIImage imageNamed:@"store_icon"];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
