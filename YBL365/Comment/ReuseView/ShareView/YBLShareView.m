//
//  XNShareView.m
//  51XiaoNiu
//
//  Created by 乔同新 on 16/4/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShareView.h"
#import "XNShareButton.h"
#import <ShareSDK/ShareSDK.h>

#define SHARE_BG_COLOR                           YBLColor(248, 248, 248, 1)

static NSInteger const lie_count                      = 2;

#define SHARE_BG_HEIGHT                           YBLWindowHeight/(lie_count+1)

#define SHARE_SCROLLVIEW_HEIGHT                  (SHARE_BG_HEIGHT-40)/lie_count

#define SHARE_ITEM_WIDTH                          YBLWindowWidth*0.15

#define SHARE_ITEM_SPACE_LEFT                       15

#define SHARE_ITEM_SPACE                            15

#define ROW1BUTTON_TAG                              11000

#define ROW2BUTTON_TAG                              111600

#define BUTTON_TAG                                  11700

#define BG_TAG                                      111111

#define BG_TAG1                                     211111


static YBLShareView *shareView = nil;

@interface YBLShareView ()

@property (nonatomic, strong) NSArray                *typeArray1;
@property (nonatomic, strong) NSArray                *typeArray2;
@property (nonatomic, strong) NSMutableArray         *ButtonTypeShareArray1;
@property (nonatomic, strong) NSMutableArray         *ButtonTypeShareArray2;
@property (nonatomic, strong) NSArray                *DataArray;

@property (nonatomic, copy  ) NSString               *text;
@property (nonatomic, copy  ) NSString               *imagePath;
@property (nonatomic, copy  ) NSString               *url;
@property (nonatomic, copy  ) NSString               *title;
@property (nonatomic, copy  ) ShareResultBlock       resultBlock;
@property (nonatomic, copy  ) ShareADGoodsClickBlock clickBlock;

@end

@implementation YBLShareView

+ (void)shareViewWithPublishContentText:(NSString *)text
                                  title:(NSString *)title
                              imagePath:(NSString *)path
                                    url:(NSString *)url
                                 Result:(ShareResultBlock)resultBlock
                ShareADGoodsClickHandle:(ShareADGoodsClickBlock)clickBlock{
    
    [[self alloc] initPublishContentText:text
                                   title:title
                               imagePath:path
                                     url:url
                                  Result:resultBlock
                 ShareADGoodsClickHandle:clickBlock];
}

- (void)initPublishContentText:(NSString *)text
                         title:(NSString *)title
                     imagePath:(NSString *)path
                           url:(NSString *)url
                    Result:(ShareResultBlock)resultBlock
       ShareADGoodsClickHandle:(ShareADGoodsClickBlock)clickBlock{
    
    if (!shareView) {
        shareView = [[YBLShareView alloc] init];
        shareView.text = text;
        shareView.imagePath = path;
        shareView.url = url;
        shareView.title = title;
        shareView.resultBlock = resultBlock;
        shareView.clickBlock = clickBlock;
        [self initData];
        [self initShareUI];
    }
}

- (void)initData{
    
    shareView.DataArray = @[@{@(0):@[@{@"朋友圈":@"xn_share_wx1"}
                                    ,@{@"微信好友":@"xn_share_wx"}
                                    ,@{@"手机QQ":@"xn_share_qq"}
                                    ,@{@"QQ空间":@"xn_share_qqzone"}
//                                    ,@{@"支付宝":@"xn_share_ap"}
//                                    ,@{@"生活圈":@"xn_share_apzone"}
                                     ]}
                           ,@{@(1):@[@{@"云图":@"xn_share_changtu"},
                                     @{@"短信":@"xn_share_text"},
                                     @{@"邮件":@"xn_share_email"},
                                     @{@"复制链接":@"xn_share_copy"}]}];
    
    
    shareView.typeArray1 = @[@(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformSubTypeQZone),
//                            @(SSDKPlatformTypeAliPaySocial),
//                            @(SSDKPlatformTypeAliPaySocialTimeline)
                             ];
    
    shareView.typeArray2 = @[@(SSDKPlatformTypeSMS),
                             @(SSDKPlatformTypeSMS),
                             @(SSDKPlatformTypeMail),
                             @(SSDKPlatformTypeCopy)];
    
    shareView.ButtonTypeShareArray1 = [NSMutableArray array];
    shareView.ButtonTypeShareArray2 = [NSMutableArray array];
}

/**
 *  初始化视图
 */
- (void)initShareUI{
    
    CGRect orginRect = CGRectMake(0, YBLWindowHeight+SHARE_ITEM_SPACE_LEFT, YBLWindowWidth, SHARE_BG_HEIGHT);
    
    CGRect finaRect = orginRect;
    finaRect.origin.y =  YBLWindowHeight-SHARE_BG_HEIGHT;
    
    /**************************************************************************/
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bgView.userInteractionEnabled = YES;
    bgView.tag = BG_TAG;
    [window addSubview:bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(dismissShareView)];
    [bgView addGestureRecognizer:tap1];

    UIView *shareBGView = [[UIView alloc] initWithFrame:orginRect];
    shareBGView.backgroundColor = SHARE_BG_COLOR;
    shareBGView.tag = BG_TAG1;
    [window addSubview:shareBGView];
    [YBLMethodTools addTopShadowToView:shareBGView];
    
    /*广告*/
    /*
    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shareBGView.width, SHARE_SCROLLVIEW_HEIGHT)];
    [shareBGView addSubview:adView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(GoodClick:)];
    [adView addGestureRecognizer:tap2];
    
    CGFloat imageWi = adView.height;
    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SHARE_ITEM_SPACE_LEFT, -SHARE_ITEM_SPACE_LEFT, imageWi, imageWi)];
    goodsImageView.image = [UIImage imageNamed:@"569ca61daf48435e20003b7a.jpg@!thumb.jpeg"];
    goodsImageView.layer.cornerRadius = 3;
    goodsImageView.layer.masksToBounds = YES;
    goodsImageView.layer.borderColor = YBLLineColor.CGColor;
    goodsImageView.layer.borderWidth = 0.5;
    [adView addSubview:goodsImageView];
    [YBLMethodTools addTopShadowToView:goodsImageView];
    
    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodsImageView.right+SHARE_ITEM_SPACE_LEFT,0,adView.width-SHARE_ITEM_SPACE_LEFT*3-goodsImageView.right,40)];
    goodsNameLabel.text = @"剑南春38度 500ml 剑南春 38度 500ml南春 38度 500ml";
    goodsNameLabel.numberOfLines = 2;
    goodsNameLabel.textColor = YBLColor(70, 70, 70, 1);
    goodsNameLabel.font = YBLFont(15);
    [adView addSubview:goodsNameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(goodsNameLabel.frame), CGRectGetMaxY(goodsNameLabel.frame), goodsNameLabel.width, (imageWi-space)*1/2)];
    priceLabel.attributedText = [NSString stringPrice:@"¥ 930.00" color:YBLThemeColor font:20 isBoldFont:NO appendingString:nil];
    [adView addSubview:priceLabel];

    UILabel *adLabel = [[UILabel alloc] initWithFrame:CGRectMake(adView.width-100, adView.height-35, 80, 15)];
    adLabel.text = @"广告";
    adLabel.textColor = YBLColor(210, 210, 210, 1);
    adLabel.font = YBLFont(12);
    adLabel.textAlignment = NSTextAlignmentRight;
    [adView addSubview:adLabel];
    
    [adView addSubview:[YBLMethodTools addLineView:CGRectMake(0, adView.height-0.5, adView.width, 0.5)]];
    */
     
    /**************************************************************************/
    for (int i = 0; i<shareView.DataArray.count; i++) {
        UIScrollView *rowScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0+i*(SHARE_SCROLLVIEW_HEIGHT+0.5), shareBGView.width, SHARE_SCROLLVIEW_HEIGHT)];
        rowScrollView.directionalLockEnabled = YES;
        rowScrollView.showsVerticalScrollIndicator = NO;
        rowScrollView.showsHorizontalScrollIndicator = NO;
        rowScrollView.backgroundColor = [UIColor clearColor];
        rowScrollView.alwaysBounceHorizontal = YES;
        [shareBGView addSubview:rowScrollView];
        
        /* add item */
        NSArray *itemArray = shareView.DataArray[i][@(i)];
        rowScrollView.contentSize = CGSizeMake(((SHARE_ITEM_WIDTH+5)+SHARE_ITEM_SPACE_LEFT)*itemArray.count, SHARE_SCROLLVIEW_HEIGHT);
        //按钮数组
        for (NSDictionary *itemDict in itemArray) {
            NSInteger index = [itemArray indexOfObject:itemDict];
            XNShareButton *button = [XNShareButton shareButton];
            CGFloat itemHeight = SHARE_ITEM_WIDTH+15;
            CGFloat itemY = (SHARE_SCROLLVIEW_HEIGHT-itemHeight)/2;
            
            NSInteger imageTag = 0;
            if (i == 0) {
                [shareView.ButtonTypeShareArray1 addObject:button];
                imageTag = ROW1BUTTON_TAG+index;
            } else {
                imageTag = ROW2BUTTON_TAG+index;
                [shareView.ButtonTypeShareArray2 addObject:button];
            }
            button = [[XNShareButton alloc] initWithFrame:CGRectMake(SHARE_ITEM_SPACE_LEFT+index*(SHARE_ITEM_WIDTH+SHARE_ITEM_SPACE), itemY+SHARE_ITEM_WIDTH*2, SHARE_ITEM_WIDTH, itemHeight)
                                                ImageName:[itemDict allValues][0]
                                                 imageTag:imageTag
                                                    title:[itemDict allKeys][0]
                                                titleFont:10
                                               titleColor:[UIColor blackColor]];
            button.tag = BUTTON_TAG+imageTag;
            [button addTarget:shareView
                       action:@selector(shareTypeClickIndex:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [rowScrollView addSubview:button];
            if (i == 0) {
                [shareView.ButtonTypeShareArray1 addObject:button];
            } else {
                [shareView.ButtonTypeShareArray2 addObject:button];
            }

        }
    
        /*line*/
        UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(SHARE_ITEM_SPACE_LEFT, rowScrollView.height-0.5, rowScrollView.width-SHARE_ITEM_SPACE_LEFT*2, 0.5)];
        lineView.backgroundColor = YBLLineColor;
        [rowScrollView addSubview:lineView];
    }
    /**************************************************************************/
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, shareBGView.height-40, shareBGView.width, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = YBLFont(17);
    [cancelButton setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:shareView action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
    [shareBGView addSubview:cancelButton];
    
    /**************************************************************************/

    [UIView animateWithDuration:0.35
                     animations:^{
                         shareBGView.frame = finaRect;
                         bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    } completion:^(BOOL finished) {
    
    }];
    

    for (XNShareButton *button in shareView.ButtonTypeShareArray1) {
        NSInteger idx = [shareView.ButtonTypeShareArray1 indexOfObject:button];
        
        [UIView animateWithDuration:0.8 delay:idx*0.04 usingSpringWithDamping:0.6 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGFloat itemHeight = SHARE_ITEM_WIDTH+15;
            CGFloat itemY = (SHARE_SCROLLVIEW_HEIGHT-itemHeight)/2;
            CGRect buttonFrame = [button frame];
            buttonFrame.origin.y = itemY;
            button.frame = buttonFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    for (XNShareButton *button in shareView.ButtonTypeShareArray2) {
        NSInteger idx = [shareView.ButtonTypeShareArray2 indexOfObject:button];
        
        [UIView animateWithDuration:0.8 delay:idx*0.04 usingSpringWithDamping:0.6 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGFloat itemHeight = SHARE_ITEM_WIDTH+15;
            CGFloat itemY = (SHARE_SCROLLVIEW_HEIGHT-itemHeight)/2;
            CGRect buttonFrame = [button frame];
            buttonFrame.origin.y = itemY;
            button.frame = buttonFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
  
}

- (void)shareTypeClickIndex:(UIButton *)btn{
    
    NSInteger tag = btn.tag-BUTTON_TAG;
    NSInteger row1_index = tag % ROW1BUTTON_TAG;
    NSInteger row2_index = tag % ROW2BUTTON_TAG;
    NSInteger countRow1 = shareView.typeArray1.count;
    NSInteger countRow2 = shareView.typeArray2.count;

    //云图
    if (row2_index == 0) {
        
        BLOCK_EXEC(shareView.resultBlock,ShareTypeYUNLONG,YES);
        [self dismissShareView:YES];
        return;
    }
    
    //type
    NSUInteger typeUI = 0;
    if (row1_index>=0&&row1_index<=countRow1) {
        typeUI = [shareView.typeArray1[row1_index] unsignedIntegerValue];
        
    } else if (row2_index>=0&&row2_index<=countRow2){
        typeUI = [shareView.typeArray2[row2_index] unsignedIntegerValue];
    }
    //创建分享参数
    id images;
    if ([shareView.imagePath rangeOfString:@"http:"].location!=NSNotFound) {
        images = [NSURL URLWithString:shareView.imagePath];
    } else {
        images = [UIImage imageNamed:shareView.imagePath];
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareView.text
                                     images:images
                                        url:[NSURL URLWithString:shareView.url]
                                      title:shareView.title
                                       type:SSDKContentTypeAuto];
    WEAK
    [ShareSDK share:typeUI
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         STRONG
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 if (typeUI == SSDKPlatformTypeCopy) {
                     [SVProgressHUD showSuccessWithStatus:@"复制成功~"];
                     BLOCK_EXEC(self.resultBlock,ShareTypeSysterm,YES)
                 } else {
                     [SVProgressHUD showSuccessWithStatus:@"分享成功~"];
                     BLOCK_EXEC(self.resultBlock,ShareTypeSocial,YES)
                 }
             }
                 break;
             case SSDKResponseStateFail:
             {
                 NSString *errorString = error.userInfo[@"error_message"];
                 [SVProgressHUD showErrorWithStatus:errorString];
                 BLOCK_EXEC(self.resultBlock,ShareTypeSocial,NO)
                 
             }
                 break;

             default:
                 break;
         }
         [self dismissShareView];
     }];
    
}

- (void)dismissShareView{
    [self dismissShareView:YES];
}

- (void)dismissShareView:(BOOL)isNill{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *bgView = [window viewWithTag:BG_TAG];
    UIView *blackView = [window viewWithTag:BG_TAG1];
    [UIView animateWithDuration:0.3
                     animations:^{
                         bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         CGRect blackFrame = [blackView frame];
                         blackFrame.origin.y = YBLWindowHeight+SHARE_ITEM_SPACE_LEFT;
                         blackView.frame = blackFrame;
                     }
                     completion:^(BOOL finished) {

                         [bgView removeFromSuperview];
                         [blackView removeFromSuperview];
                         if (isNill) {
                             shareView = nil;
                         }
                     }];

}


- (void)GoodClick:(UITapGestureRecognizer *)tap{
    
    [self dismissShareView:YES];
    
    BLOCK_EXEC(shareView.clickBlock,);
    
}

@end
