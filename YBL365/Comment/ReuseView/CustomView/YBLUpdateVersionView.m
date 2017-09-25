//
//  YBLUpdateVersionView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLUpdateVersionView.h"

@implementation YBLUpdateReaseNotModel

@end

static YBLUpdateVersionView *updateVersionView = nil;

#define BGIMAGE_SCALE  (double)740/565

#define HEADER_SCALE  (double)330/740

@interface YBLUpdateVersionView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) YBLUpdateReaseNotModel *releaseModel;

@property (nonatomic, strong) UIImageView *versionView;

@property (nonatomic, copy  ) UpdateVersionGoBlock doneBlock;

@end

@implementation YBLUpdateVersionView

+ (void)showUpdateVersionViewWithModel:(YBLUpdateReaseNotModel *)releaseModel
                             doneBlock:(UpdateVersionGoBlock)doneBlock{
    
    if (!updateVersionView) {
        updateVersionView = [[YBLUpdateVersionView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                              withModel:releaseModel
                                                              doneBlock:doneBlock];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:updateVersionView];
        //
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:.9
              initialSpringVelocity:0
                            options:UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
                             updateVersionView.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                             updateVersionView.versionView.center = updateVersionView.center;
                         }
                         completion:^(BOOL finished) {
                         }];

    }
}

- (instancetype)initWithFrame:(CGRect)frame
                    withModel:(YBLUpdateReaseNotModel *)releaseModel
                    doneBlock:(UpdateVersionGoBlock)doneBlock{

    self = [super initWithFrame:frame];
    if (self) {
        
        _releaseModel = releaseModel;
        _doneBlock = doneBlock;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:bgView];
    self.bgView = bgView;
    
//    UITapGestureRecognizer *tap_bg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap)];
//    [self addGestureRecognizer:tap_bg];
    
    CGFloat ImageW = YBLWindowWidth-46.5*2;
    CGFloat IamgeH = ImageW*BGIMAGE_SCALE;
    
    UIImageView *versionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageW, IamgeH)];
    versionView.userInteractionEnabled = YES;
    versionView.image = [UIImage imageNamed:@"update_verson"];
    versionView.center = CGPointMake(self.center.x, self.height+IamgeH/2);
    [self addSubview:versionView];
    self.versionView = versionView;
    
    //
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:[UIImage imageNamed:@"address_close"] forState:UIControlStateNormal];
    dismissButton.frame = CGRectMake(ImageW-20, -20, 40, 40);
    dismissButton.clipsToBounds = YES;
    [dismissButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [versionView addSubview:dismissButton];
    
    CGFloat HeaderY = IamgeH*HEADER_SCALE;
    CGFloat ContenH = IamgeH-HeaderY-20-40-10;
    
    //
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HeaderY, ImageW, 20)];
    newLabel.text = [NSString stringWithFormat:@"有新版本啦(%@)",self.releaseModel.version];
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.font = YBLFont(18);
    [versionView addSubview:newLabel];
    
    //
    UITextView *contentView = [[UITextView  alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(newLabel.frame)+10, ImageW-40, ContenH-30)];
    contentView.text = self.releaseModel.releaseNot;
    contentView.font = YBLFont(15);
    [contentView setEditable:NO];
    [versionView addSubview:contentView];

    //
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updateButton.frame  = CGRectMake(20, HeaderY+ContenH+10, contentView.width, 40);
    [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
    updateButton.backgroundColor = YBLColor(238, 69, 59, 1);
    updateButton.titleLabel.font = YBLFont(17);
    updateButton.layer.cornerRadius = 3;
    [updateButton addTarget:self action:@selector(gotoUpdate) forControlEvents:UIControlEventTouchUpInside];
    [versionView addSubview:updateButton];
    
    
}

- (void)dismissTap{
    
    [self dismissView];
}

- (void)dismissView{
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         self.versionView.top = YBLWindowHeight;
                     }
                     completion:^(BOOL finished) {
                         [updateVersionView removeFromSuperview];
                         updateVersionView = nil;
                     }];
}

- (void)gotoUpdate {

    BLOCK_EXEC(self.doneBlock,)
    [self dismissView];
}

@end
