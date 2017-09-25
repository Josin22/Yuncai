//
//  YBLStoreHeaderView.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreHeaderView.h"


@interface YBLFoucsAnimationView ()

@end

@implementation YBLFoucsAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    YBLButton *fousButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    fousButton.frame = CGRectMake(0, 0, self.width, self.height*3/5);
    CGFloat imageWi = fousButton.height*2/3;
    [fousButton setImage:[UIImage newImageWithNamed:@"store_collect_white" size:CGSizeMake(imageWi, imageWi)] forState:UIControlStateNormal];
    [fousButton setImage:[UIImage newImageWithNamed:@"store_collect_red" size:CGSizeMake(imageWi, imageWi)] forState:UIControlStateSelected];
    [fousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fousButton setTitleColor:YBLThemeColor forState:UIControlStateSelected];
    [fousButton setTitle:@"关注" forState:UIControlStateNormal];
    [fousButton setTitle:@"已关注" forState:UIControlStateSelected];
    [fousButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [fousButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    fousButton.titleLabel.font = YBLFont(14);
    fousButton.imageRect = CGRectMake(3, (self.height*3/5-imageWi)/2, imageWi, imageWi);
    fousButton.titleRect = CGRectMake(3+3+imageWi, 0, self.width-(3+3+imageWi), self.height*3/5);
    fousButton.left = self.width;
    [self addSubview:fousButton];
    [fousButton addCornerRadius:5 rectCorner:UIRectCornerTopLeft];
    self.fousButton = fousButton;
    
    UILabel *foucsNummberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fousButton.bottom, fousButton.width, self.height*2/5)];
    foucsNummberLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.25f];
    foucsNummberLabel.textColor = YBLColor(191, 191, 191, 1);
    foucsNummberLabel.text = @"0.0人";
    foucsNummberLabel.textAlignment = NSTextAlignmentCenter;
    foucsNummberLabel.font = YBLFont(12);
    [self addSubview:foucsNummberLabel];
    foucsNummberLabel.left = self.width;
    [foucsNummberLabel addCornerRadius:5 rectCorner:UIRectCornerBottomLeft];
    self.foucsNummberLabel = foucsNummberLabel;
}

- (void)setChangevalue:(NSInteger)changevalue{
    _changevalue = changevalue;
    self.foucsNummberLabel.text = [NSString stringWithFormat:@"%ld人",_changevalue];
//    [self.foucsNummberLabel fn_setNumber:[NSNumber numberWithFloat:_changevalue] format:[@"%@" stringByAppendingString:@"人"] formatter:nil];
}

- (void)showFoucsAnimationWithValue:(float )value{
    
    [UIView animateWithDuration:.6f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.fousButton.left = 0;
                     }
                     completion:^(BOOL finished) {
                         [YBLMethodTools popAnimationWithView:self.fousButton.imageView];
                     }];
    [UIView animateWithDuration:.6
                          delay:.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.foucsNummberLabel.left = 0;
                     }
                     completion:^(BOOL finished) {
                         self.changevalue = value;
                     }];
    
}


@end


@interface YBLStoreHeaderView ()

@end

@implementation YBLStoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"store_bg"];
    CGFloat hi =  (double)image.size.height/image.size.width *YBLWindowWidth;
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, hi)];
    bgImageView.image = image;
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UIImageView *storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, hi-30-space, 80, 30)];
    storeImageView.image = [UIImage imageNamed:middleImagePlaceholder];
    storeImageView.userInteractionEnabled = YES;
    storeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    storeImageView.layer.borderWidth = 1;
    [bgImageView addSubview:storeImageView];
    self.storeImageView = storeImageView;
    
    CGFloat foucsWi = 70;
    
    YBLButton *storeNameButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    storeNameButton.frame = CGRectMake( storeImageView.right+5,storeImageView.top, self.width-storeImageView.right-5-foucsWi-5, 15);
    [storeNameButton setTitle:@"商城" forState:UIControlStateNormal];
    [storeNameButton setImage:[UIImage imageNamed:@"store_right_arrow"] forState:UIControlStateNormal];
    [storeNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    storeNameButton.titleLabel.font = YBLFont(15);
    storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    storeNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageView addSubview:storeNameButton];
    self.storeNameButton = storeNameButton;

    self.creaditStoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"credit_round"]];
    self.creaditStoreImageView.frame = CGRectMake(storeNameButton.left, storeNameButton.bottom+1.5, 45, 13);
    [bgImageView addSubview:self.creaditStoreImageView];
    self.creaditStoreImageView.hidden = YES;
    
    UILabel *signalLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeNameButton.left, storeNameButton.bottom, 55, 15)];
    signalLabel.bottom = storeImageView.bottom;
    signalLabel.text = @"综合 9.5";
    signalLabel.textColor = [UIColor whiteColor];
    signalLabel.font = YBLFont(10);
    [bgImageView addSubview:signalLabel];
    self.signalLabel = signalLabel;

    /*
    UILabel *signalLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeNameButton.left, storeNameButton.bottom+2, 55, 16)];
    signalLabel.backgroundColor = YBLThemeColor;
    signalLabel.text = @"云采自营";
    signalLabel.layer.cornerRadius = 3;
    signalLabel.layer.masksToBounds = YES;
    signalLabel.textColor = [UIColor whiteColor];
    signalLabel.font = YBLFont(11);
    signalLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:signalLabel];
    self.signalLabel = signalLabel;
    
    for (int i = 0; i < 5; i++) {
        UIButton *xingjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xingjiButton setImage:[UIImage imageNamed:@"store_xinji_normal"] forState:UIControlStateNormal];
        [xingjiButton setImage:[UIImage imageNamed:@"store_xinji_select"] forState:UIControlStateSelected];
        xingjiButton.frame = CGRectMake(storeNameButton.left+i*14, storeNameButton.bottom+3, 12, 12);
        xingjiButton.selected = YES;
        [self addSubview:xingjiButton];
    }
    */
    
    YBLFoucsAnimationView *foucsAnimationView = [[YBLFoucsAnimationView alloc] initWithFrame:CGRectMake(bgImageView.width-foucsWi, 0, foucsWi, 40)];
    foucsAnimationView.bottom = storeImageView.bottom;
    [bgImageView addSubview:foucsAnimationView];
    self.foucsAnimationView = foucsAnimationView;
    
    self.scaleTextSegment = [[YBLScaleTextSegmentView alloc]initWithFrame:CGRectMake(0, bgImageView.bottom+space, self.width, 45)
                                                                  UpValue:@[@"0",@"0",@"0"]
                                                              BottomValue:@[@"全部商品",@"热销商品",@"上新商品"]];
    [self addSubview:self.scaleTextSegment];
    
    
    self.height = self.scaleTextSegment.bottom;
}

@end
