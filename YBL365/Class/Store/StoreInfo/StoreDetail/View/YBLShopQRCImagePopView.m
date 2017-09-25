//
//  YBLShopQRCImagePopView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShopQRCImagePopView.h"
#import "YBLSaveManyImageTools.h"

static YBLShopQRCImagePopView *qrcImagePopView  =nil;

@interface YBLShopQRCImagePopView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy ) NSString *contentURL;

@property (nonatomic, copy ) NSString *storeName;

@property (nonatomic, strong) UIImageView *qrcImageView;

@end

@implementation YBLShopQRCImagePopView

+ (void)showShopQRCImageWithContentURL:(NSString *)url storeName:(NSString *)storeName{
    if (!qrcImagePopView) {
        qrcImagePopView = [[YBLShopQRCImagePopView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                             contentURL:url
                                                              storeName:storeName];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:qrcImagePopView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame contentURL:(NSString *)contentURL storeName:(NSString *)storeName
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentURL = contentURL;
        _storeName = storeName;
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.clipsToBounds = YES;
    
    self.bgView = [[UIView alloc] initWithFrame:[self bounds]];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    [self addSubview:self.bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self.bgView addGestureRecognizer:tap];
    
    CGFloat itemWi = self.width-2*space;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWi, itemWi)];
    self.contentView.backgroundColor = YBLColor(248, 248, 248, 1);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    
    UILabel *storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, buttonHeight)];
    storeNameLabel.text = self.storeName;
    storeNameLabel.textAlignment = NSTextAlignmentCenter;
    storeNameLabel.font = YBLFont(15);
    storeNameLabel.textColor = BlackTextColor;
    [self.contentView addSubview:storeNameLabel];
    
    [storeNameLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, storeNameLabel.height-.5, storeNameLabel.width, .5)]];
    
    UIButton *saveButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, 0, self.contentView.width, buttonHeight)];
    saveButton.bottom = self.contentView.height;
    [saveButton setTitle:@"保存图片" forState:UIControlStateNormal];
    [self.contentView addSubview:saveButton];
    WEAK
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        YBLSystemSocialModel *socialModel = [YBLSystemSocialModel new];
        socialModel.imagesArray = @[].mutableCopy;
        [YBLSaveManyImageTools saveImage:self.qrcImageView.image
                            completetion:^(BOOL isSuccess) {
//                                STRONG
                                [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
                            }];
    }];
    
    UIImageView *qrcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, storeNameLabel.bottom, self.contentView.width, self.contentView.height-storeNameLabel.bottom-saveButton.height)];
    qrcImageView.backgroundColor = [UIColor whiteColor];
    qrcImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat imageSize = self.contentView.width-space;
    CGFloat logWi = imageSize/3.5;
    UIImage *qrcImage = [UIImage qrCodeImageWithContent:self.contentURL
                                          codeImageSize:imageSize
                                                   logo:[UIImage imageNamed:@"yuncai_icon"]
                                              logoFrame:CGRectMake((qrcImageView.width-logWi*2)/2, (qrcImageView.height/2), logWi*2, logWi)
                                                    red:170
                                                  green:170
                                                   blue:170];
    qrcImageView.image = qrcImage;
    [self.contentView addSubview:qrcImageView];
    self.qrcImageView = qrcImageView;
}

- (void)dismissView {

    [qrcImagePopView removeFromSuperview];
    qrcImagePopView = nil;
}

@end
