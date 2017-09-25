//
//  YBLYunLongImageView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLYunLongImageView.h"
#import <ShareSDK/ShareSDK.h>
#import "YYWebImage.h"

static NSInteger const tag_imageView = 164;

static NSInteger const tag_itembutton = 664;

static YBLYunLongImageView *yunLongView = nil;

@interface YBLYunLongImageView ()
{
    CGFloat lastHI;
}
@property (nonatomic, strong) YBLSystemSocialModel *socialModel;

@property (nonatomic, strong) UIScrollView *yunScrollView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *typeUIArray;

@property (nonatomic, assign) YunLongImageViewType imageViewType;

@end

@implementation YBLYunLongImageView

+ (void)showStoreYunLongImageViewWithModel:(YBLSystemSocialModel *)socialModel{
    
    [self showYunLongImageViewWithModel:socialModel imageViewType:YunLongImageViewTypeStore];
}

+ (void)showYunLongImageViewWithModel:(YBLSystemSocialModel *)socialModel{
    
    [self showYunLongImageViewWithModel:socialModel imageViewType:YunLongImageViewTypeGood];
}

+ (void)showYunLongImageViewWithModel:(YBLSystemSocialModel *)socialModel imageViewType:(YunLongImageViewType)imageViewType
{
    if (!yunLongView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        yunLongView = [[YBLYunLongImageView alloc] initWithFrame:[window bounds] Model:socialModel imageViewType:imageViewType];
        [window addSubview:yunLongView];
        yunLongView.alpha = 0;
        [UIView animateWithDuration:.34f
                         animations:^{
                             yunLongView.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame Model:(YBLSystemSocialModel *)socialModel imageViewType:(YunLongImageViewType)imageViewType
{
    self = [super initWithFrame:frame];
    if (self) {
        _socialModel = socialModel;
        _imageViewType = imageViewType;
        [self createUI];
    }
    return self;
}

- (void)createUI{

    CGFloat barHi = 120;
    
    self.yunScrollView = [[UIScrollView alloc] initWithFrame:[self bounds]];
    self.yunScrollView.backgroundColor = [UIColor whiteColor];
    self.yunScrollView.showsVerticalScrollIndicator = NO;
    self.yunScrollView.contentInset = UIEdgeInsetsMake(0, 0, barHi, 0);
    [self addSubview:self.yunScrollView];
    
    CGFloat itemWi = 50;
    CGFloat itemHi = 65;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.yunScrollView.width, self.yunScrollView.height)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.yunScrollView addSubview:contentView];
    self.contentView = contentView;
    
    NSString *logo_info_label = @"分享此图给好友吧";
    
    if (_imageViewType == YunLongImageViewTypeGood) {
        /***  title  ***/
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 230)];
        [self.contentView addSubview:titleView];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space*2, 30, 25, 50)];
        [titleView addSubview:iconImageView];
        /*
         UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*space, 50, self.contentView.width, 30)];
         titleLabel.font = YBLBFont(20);
         titleLabel.textColor = YBLThemeColor;
         [titleView addSubview:titleLabel];
         */
        
        UILabel *goodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.left, iconImageView.bottom, self.contentView.width-4*space, 40)];
        goodTitleLabel.text = _socialModel.text;
        goodTitleLabel.numberOfLines = 2;
        goodTitleLabel.font = YBLFont(17);
        goodTitleLabel.textColor = BlackTextColor;
        [titleView addSubview:goodTitleLabel];
        CGSize titleSize = [_socialModel.text heightWithFont:YBLFont(17) MaxWidth:goodTitleLabel.width];
        goodTitleLabel.height = titleSize.height;
        
        
        UILabel *quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodTitleLabel.left, goodTitleLabel.bottom, self.contentView.width, 30)];
        quantityLabel.textColor = BlackTextColor;
        quantityLabel.font = YBLFont(17);
        [titleView addSubview:quantityLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(quantityLabel.left, quantityLabel.bottom, self.contentView.width, 30)];
        priceLabel.textColor = YBLThemeColor;
        priceLabel.font = YBLBFont(20);
        [titleView addSubview:priceLabel];
        titleView.height = priceLabel.bottom;
        
        if (_socialModel.imageType == SaveImageTypeNormalGoods) {
            iconImageView.image = [UIImage imageNamed:@"share_yuncai_icon"];
            NSString *priceString = [NSString stringWithFormat:@"%.2f",_socialModel.price.floatValue];
            NSString *lastPrice = [priceString componentsSeparatedByString:@"."][1];
            priceLabel.text = [NSString stringWithFormat:@"¥**.%@",lastPrice];
            quantityLabel.text = [NSString stringWithFormat:@"成交%@%@",_socialModel.quantity,_socialModel.unit];
        } else {
            iconImageView.image = [UIImage imageNamed:@"share_caigou_icon"];
            priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_socialModel.price.floatValue*_socialModel.quantity.integerValue];
            quantityLabel.text = [NSString stringWithFormat:@"%@%@",_socialModel.quantity,_socialModel.unit];
        }
        
        /***  image ***/
        NSInteger index = 0;
        
        for (NSString *image_url in _socialModel.imagesArray) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleView.bottom+index*self.contentView.width, self.contentView.width, self.contentView.width)];
            imageView.tag = tag_imageView+index;
            [self.contentView addSubview:imageView];
            
            if ([image_url rangeOfString:@"http"].location!=NSNotFound) {
//                [imageView yy_setImageWithURL:[NSURL URLWithString:image_url] placeholder:[UIImage imageNamed:smallImagePlaceholder] options:YYWebImageOptionProgressive completion:nil];
                [imageView js_alpha_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:smallImagePlaceholder];
            } else {
                imageView.image = [UIImage imageNamed:image_url];
            }
            
            if (index == _socialModel.imagesArray.count-1) {
                self.yunScrollView.contentSize = CGSizeMake(self.contentView.width, self.contentView.width*(index+2));
                self.contentView.height = titleView.bottom+self.contentView.width*(index+1);
                //qrc code
                UIImage *qrcImage = [UIImage qrCodeImageWithContent:_socialModel.share_url
                                                      codeImageSize:YBLWindowWidth/3
                                                               logo:nil
                                                          logoFrame:CGRectZero
                                                                red:170
                                                              green:170
                                                               blue:170];
                UIImageView *qrcImageView = [[UIImageView alloc] initWithImage:qrcImage];
                qrcImageView.frame = CGRectMake(0, self.contentView.height+2*space, YBLWindowWidth/3, YBLWindowWidth/3);
                qrcImageView.centerX = self.contentView.width/2;
                [self.contentView addSubview:qrcImageView];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, qrcImageView.bottom+space, self.contentView.width, 20)];
                label1.text = @"长按识别二维码 打开即可查看";
                label1.textColor = BlackTextColor;
                label1.textAlignment = NSTextAlignmentCenter;
                label1.font = YBLFont(17);
                [self.contentView addSubview:label1];
                //采购商 河南 郑州
                UILabel *store_label = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom+space, self.contentView.width, 12)];
                if (_socialModel.imageType == SaveImageTypePurchaseGoods) {
                    store_label.text = [NSString stringWithFormat:@"采购商 %@",_socialModel.address];
                } else {
                    store_label.text = [NSString stringWithFormat:@"%@ 提供商品服务",_socialModel.shopName];
                }
                store_label.textColor = YBLTextColor;
                store_label.textAlignment = NSTextAlignmentCenter;
                store_label.font = YBLFont(13);
                [self.contentView addSubview:store_label];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, store_label.bottom+space, self.contentView.width, 12)];
                label2.text = Yuncai_Slog_string;
                label2.textColor = YBLTextColor;
                label2.textAlignment = NSTextAlignmentCenter;
                label2.font = YBLFont(13);
                [self.contentView addSubview:label2];
                
                UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yuncai_icon"]];
                iconImageView.frame = CGRectMake(0, label2.bottom+space*2, 100, 56);
                iconImageView.centerX = self.contentView.width/2;
                iconImageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.contentView addSubview:iconImageView];
                
                self.contentView.height = iconImageView.bottom+space;
                self.yunScrollView.contentSize = CGSizeMake(self.contentView.width, self.contentView.bottom);
            }
            
            index++;
        }

    } else if (_imageViewType == YunLongImageViewTypeStore){

        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage contentFileWithName:@"store_info_bg" Type:@"jpg"]];
        [self.contentView addSubview:bgImageView];
        CGFloat bgHeight = (double)bgImageView.image.size.height/bgImageView.image.size.width*YBLWindowWidth;
        bgImageView.frame = CGRectMake(0, 0, self.yunScrollView.width, bgHeight);
        self.contentView.height = bgHeight;
        self.yunScrollView.contentSize = CGSizeMake(self.width, bgHeight);
        
        CGFloat topSpace = 7*space;
        CGFloat lefSpace = 4*space;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(lefSpace, topSpace, self.contentView.width-lefSpace*2, self.contentView.height-topSpace*2)];
        whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
        whiteView.layer.cornerRadius = 8;
        whiteView.layer.masksToBounds = YES;
        [self.contentView addSubview:whiteView];
        
        CGFloat iconWi = whiteView.width/2.8;
        
        UILabel *info_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteView.width, 20)];
        info_1.centerX = whiteView.width/2;
        info_1.bottom = whiteView.height-space;
        info_1.text = @"长按识别二维码 进店逛逛有惊喜~";
        info_1.textColor = [UIColor whiteColor];
        info_1.textAlignment = NSTextAlignmentCenter;
        info_1.font = YBLFont(13);
        [whiteView addSubview:info_1];
        
        //二维码
        UIImageView *qrcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWi, iconWi)];
        qrcImageView.centerX = whiteView.width/2;
        qrcImageView.bottom = info_1.top-space;
        qrcImageView.backgroundColor = [UIColor whiteColor];
        qrcImageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat imageSize = qrcImageView.width-space;
        CGFloat logWi = imageSize/3.5;
        UIImage *qrcImage = [UIImage qrCodeImageWithContent:_socialModel.share_url
                                              codeImageSize:imageSize
                                                       logo:[UIImage imageNamed:@"yuncai_icon"]
                                                  logoFrame:CGRectMake((imageSize-logWi*2)/2, (imageSize-logWi)/2, logWi*2, logWi)
                                                        red:170
                                                      green:170
                                                       blue:170];
        qrcImageView.image = qrcImage;
        [whiteView addSubview:qrcImageView];
        
        //touxiang
        /*
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        iconImageView.centerX = whiteView.width/2;
        iconImageView.bottom = iconImageView.left;
        iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        iconImageView.layer.borderWidth = 1;
        [whiteView addSubview:iconImageView];
        [iconImageView yy_setImageWithURL:[NSURL URLWithString:_socialModel.logo_url] options:YYWebImageOptionProgressive];
        */
        
        UIImageView *storeHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWi, iconWi)];
        storeHeaderImageView.centerX = whiteView.width/2;
        storeHeaderImageView.top = storeHeaderImageView.left/3;
        storeHeaderImageView.layer.cornerRadius = 8;
        storeHeaderImageView.layer.masksToBounds = YES;
//        [storeHeaderImageView yy_setImageWithURL:[NSURL URLWithString:_socialModel.head_img] placeholder:[UIImage imageNamed:smallImagePlaceholder]];
        [storeHeaderImageView js_alpha_setImageWithURL:[NSURL URLWithString:_socialModel.head_img] placeholderImage:smallImagePlaceholder];
        [whiteView addSubview:storeHeaderImageView];
      
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*space, 0, self.contentView.width-10*space, 20)];
        infoLabel.bottom = self.contentView.height-1*space;
        infoLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.2];
        infoLabel.text = @"下载云采商城新用户送198";
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.layer.cornerRadius = infoLabel.height/2;
        infoLabel.layer.masksToBounds = YES;
        infoLabel.font = YBLFont(13);
        infoLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:infoLabel];
        
        UILabel *storeNamelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, storeHeaderImageView.bottom+storeHeaderImageView.top, whiteView.width, 20)];
        storeNamelLabel.textColor = YBLColor(130, 230, 228, 1);
        storeNamelLabel.font = YBLBFont(20);
        storeNamelLabel.textAlignment = NSTextAlignmentCenter;
        storeNamelLabel.text = _socialModel.shopName;
        [whiteView addSubview:storeNamelLabel];
        
        CGFloat lessTop = storeNamelLabel.top-storeHeaderImageView.bottom;
        
        CGFloat lessHeight = qrcImageView.top-storeNamelLabel.bottom-lessTop;
        UILabel *ciontentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*space, storeNamelLabel.bottom+lessTop/2, storeNamelLabel.width-6*space, lessHeight)];
        ciontentTitleLabel.textAlignment = NSTextAlignmentCenter;
        ciontentTitleLabel.textColor = [UIColor whiteColor];
        ciontentTitleLabel.font = YBLFont(15);
        ciontentTitleLabel.numberOfLines = 0;
//        ciontentTitleLabel.text =
        [whiteView addSubview:ciontentTitleLabel];
        NSString *quanString = [NSString stringWithFormat:@"%ld",_socialModel.quantity.integerValue];
        NSString *contentString = [NSString stringWithFormat:@"店铺共%@款商品,来看看就会有你中意的商品哟~",quanString];
        NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc] initWithString:contentString];
        [contentAtt addAttributes:@{NSFontAttributeName:YBLFont(30),NSForegroundColorAttributeName:YBLThemeColor} range:NSMakeRange(3, quanString.length)];
        ciontentTitleLabel.attributedText = contentAtt;
        
        logo_info_label = @"分享店铺给好友~";
    }
    
    //close
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(YBLWindowWidth-space-50, 40, 40, 40);
    [closeButton setImage:[UIImage imageNamed:@"close_withe"] forState:UIControlStateNormal];
    closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    closeButton.layer.cornerRadius = closeButton.height/2;
    closeButton.layer.masksToBounds = YES;
    [self addSubview:closeButton];
    WEAK
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [self dismiss];
    }];
    
    //BOTTOM
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-barHi, self.width, barHi)];
    bottomView.backgroundColor = [YBLColor(200, 200, 200, 1) colorWithAlphaComponent:.65];
    [self addSubview:bottomView];
    
    UILabel *share_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, space, bottomView.width, 20)];
    share_titleLabel.text = logo_info_label;
    share_titleLabel.textAlignment = NSTextAlignmentCenter;
    share_titleLabel.font = YBLFont(18);
    share_titleLabel.textColor = YBLThemeColor;
    [bottomView addSubview:share_titleLabel];
    
    NSArray *nameArray = @[@[@"微信好友",@"fang_weixin"],@[@"朋友圈",@"fang_pengyouquan"],@[@"QQ",@"fang_qq"],@[@"保存",@"fang_save"]];
    NSInteger payshiping_lie = nameArray.count>3?4:nameArray.count;
    
    int index_ii = 0;
    
    for (NSArray *itemArray in nameArray) {
        NSString *name = itemArray[0];
        NSString *image = itemArray[1];
        
        int row = index_ii/payshiping_lie;
        int col = index_ii%payshiping_lie;
        
        CGRect frame = CGRectMake(space+col*(itemWi+space), share_titleLabel.bottom+space+row*(itemHi+space), itemWi, itemHi);
        
        YBLButton *itemButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = frame;
        [itemButton setTitle:name forState:UIControlStateNormal];
        [itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [itemButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        itemButton.titleLabel.font = YBLFont(12);
        itemButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        itemButton.titleRect = CGRectMake(0, itemWi+3, itemWi, itemHi-itemWi);
        itemButton.imageRect = CGRectMake(0, 0, itemWi, itemWi);
        itemButton.centerX = itemHi/2+((YBLWindowWidth-itemHi)/(payshiping_lie*2))*(col*2+1);
        itemButton.tag = tag_itembutton+index_ii;
        [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:itemButton];
        
        index_ii++;
    }
}

- (NSMutableArray *)typeUIArray{
    
    if (!_typeUIArray) {
        _typeUIArray = [NSMutableArray arrayWithArray:@[@(SSDKPlatformSubTypeWechatSession),
                                                        @(SSDKPlatformSubTypeWechatTimeline),
                                                        @(SSDKPlatformSubTypeQQFriend)]];
    }
    return _typeUIArray;
}


- (void)itemClick:(YBLButton *)btn{
     
    NSInteger index = btn.tag-tag_itembutton;
    UIImage *contentImage = [UIImage imageWithUIView:self.contentView];
    
    if (index == 3) {
        [SVProgressHUD showWithStatus:@"保存图片中..."];
        UIImageWriteToSavedPhotosAlbum(contentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        NSUInteger typeUI = [self.typeUIArray[index] unsignedIntegerValue];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        switch (index) {
            case 0:
            {
                //微信
                [shareParams SSDKSetupWeChatParamsByText:nil
                                                   title:_socialModel.text
                                                     url:nil
                                              thumbImage:nil
                                                   image:contentImage
                                            musicFileURL:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil
                                                    type:SSDKContentTypeImage
                                      forPlatformSubType:typeUI];
            }
                break;
            case 1:
            {
                //朋友圈
                [shareParams SSDKSetupWeChatParamsByText:nil
                                                   title:_socialModel.text
                                                     url:nil
                                              thumbImage:nil
                                                   image:contentImage
                                            musicFileURL:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil
                                                    type:SSDKContentTypeImage
                                      forPlatformSubType:typeUI];
            }
                break;
            case 2:
            {
                //qq
                [shareParams SSDKSetupQQParamsByText:nil
                                               title:_socialModel.text
                                                 url:nil
                                          thumbImage:nil
                                               image:contentImage
                                                type:SSDKContentTypeImage
                                  forPlatformSubType:typeUI];
            }
                break;
                
            default:
                break;
        }
        
        [ShareSDK share:typeUI
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
         }];
        
        [self dismiss];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"保存失败~"];
    }

}

- (void)dismiss{
    
    [UIView animateWithDuration:.34f
                     animations:^{
                         yunLongView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [yunLongView removeFromSuperview];
                         yunLongView = nil;
                     }];
    
}

@end
