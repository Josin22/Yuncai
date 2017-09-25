//
//  YBLSystemSocialShareView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSystemSocialShareView.h"
#import <Social/Social.h>
#import "YBLSaveManyImageTools.h"
#import "UIImage+MultiFormat.h"

static NSInteger const tag_itembutton = 55444;

static YBLSystemSocialShareView *systemSocialShareView = nil;

@interface YBLSystemSocialShareView()

@property (nonatomic, strong) YBLSystemSocialModel *socialModel;
@property (nonatomic, weak) UIViewController *Vc;

@end

@implementation YBLSystemSocialShareView

+ (void)showSystemSocialShareViewWithInViewConcontroller:(UIViewController *)Vc
                                                   Model:(YBLSystemSocialModel *)model{

    if (!systemSocialShareView) {
        systemSocialShareView = [[YBLSystemSocialShareView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
        systemSocialShareView.socialModel = model;
        systemSocialShareView.Vc = Vc;
        UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
        [keywindow addSubview:systemSocialShareView];
    }
}

- (void)addSubvieToContentView{

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, space*2, self.contentView.width, 20)];
    titleLabel.text = @"-----  发送到  ------";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YBLFont(16);
    titleLabel.textColor = BlackTextColor;
    [self.contentView addSubview:titleLabel];
    
    //按钮
    NSArray *nameArray = @[@[@"微信",@"sys_weixin"],@[@"QQ",@"sys_QQ"],@[@"支付宝",@"sys_weibo"]];
    NSInteger payshiping_lie = nameArray.count>2?3:nameArray.count;
    
    CGFloat itemWi = 60;
    CGFloat itemHi = 80;
    
    int index = 0;

    for (NSArray *itemArray in nameArray) {
        NSString *name = itemArray[0];
        NSString *image = itemArray[1];

        int row = index/payshiping_lie;
        int col = index%payshiping_lie;
        
        CGRect frame = CGRectMake(space+col*(itemWi+space), titleLabel.bottom+space*4+row*(itemHi+space), itemWi, itemHi);
        
        YBLButton *itemButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = frame;
        [itemButton setTitle:name forState:UIControlStateNormal];
        [itemButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
        [itemButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        itemButton.titleLabel.font = YBLFont(13);
        itemButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        itemButton.titleRect = CGRectMake(0, itemWi, itemWi, itemHi-itemWi);
        itemButton.imageRect = CGRectMake(0, 0, itemWi, itemWi);
        itemButton.centerX = (YBLWindowWidth/(payshiping_lie*2))*(col*2+1);
        itemButton.centerY = self.contentView.height/2;
        itemButton.tag = tag_itembutton+index;
        [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemButton];

        index++;
    }
   
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, self.contentView.height-50, self.contentView.width, 50);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = YBLFont(17);
    [cancelButton setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelButton];
    [cancelButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, 0, cancelButton.width, .5)]];
}

- (void)dismiss{
    
    [UIView animateWithDuration:.4
                     animations:^{
                         self.bgView.alpha = 0;
                         self.contentView.top = YBLWindowHeight+space;
                     }
                     completion:^(BOOL finished) {
                         [systemSocialShareView removeFromSuperview];
                         systemSocialShareView = nil;
                     }];
    
}

- (void)itemClick:(YBLButton *)btn{

    [SVProgressHUD showWithStatus:@"请求中..."];
    
    [self dismiss];
    
    NSMutableArray *activityItems = [NSMutableArray array];
    UIViewController *currentVC = systemSocialShareView.Vc;
    NSString *url = systemSocialShareView.socialModel.share_url;
    SaveImageType saveImageType = systemSocialShareView.socialModel.imageType;
    YBLSystemSocialModel *social_model = systemSocialShareView.socialModel;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSInteger index = 0;
        for (NSString *image_url in systemSocialShareView.socialModel.imagesArray) {
            UIImage *image = nil;
            if ([image_url hasPrefix:@"http://"]) {
                image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]];
            } else {
                image = [UIImage imageNamed:image_url];
            }
            if (index == 0) {
                
                UIImage *qrcImage = [UIImage qrCodeImageWithContent:url
                                                      codeImageSize:120
                                                               logo:nil
                                                          logoFrame:CGRectZero
                                                                red:170
                                                              green:170
                                                               blue:170];
                UIImage *finalImage = nil;
                if (saveImageType == SaveImageTypeNormalGoods) {
                    finalImage = [YBLMethodTools addQRCImage:qrcImage ToImage:image];
                } else {
                    //采购商品
                    finalImage = [YBLMethodTools addLabelWithModel:social_model AndQRCImage:qrcImage ToGoodImage:image];
                }
                
                [activityItems addObject:finalImage];
                
            } else {
                
                [activityItems addObject:image];
            }
            index++;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
            activityVC.modalInPopover = true;
            activityVC.restorationIdentifier = @"activity";
            [currentVC presentViewController:activityVC animated:YES completion:^{
                
            }];
        });
    });
    

}

@end
