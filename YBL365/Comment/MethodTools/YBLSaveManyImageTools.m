//
//  YBLSaveManyImageTools.m
//  YC168
//
//  Created by 乔同新 on 2017/4/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSaveManyImageTools.h"
#import "UIImage+MultiFormat.h"

typedef NS_ENUM(NSInteger,ActionType) {
    ActionTypeSaveImage = 0,
    ActionTypeSaveImageThenPushSystemShare,
    ActionTypeSaveCustomImage
};

static YBLSaveManyImageTools * saveManyImageTools = nil;

@interface YBLSaveManyImageTools (){
    NSInteger imageIndex;
}

@property (nonatomic, strong) NSMutableArray *listOfImages;

@property (nonatomic, copy) SaveManyImageHandleBlock saveManyImageHandleBlock;

@property (nonatomic, strong) YBLSystemSocialModel *shareImageModel;

@property (nonatomic, assign) ActionType actionType;

@property (nonatomic, weak) UIViewController *Vc;

@property (nonatomic, strong) UIImage *image;

@end

@implementation YBLSaveManyImageTools

+ (void)saveImage:(UIImage *)image
     completetion:(SaveManyImageHandleBlock)saveManyImageHandleBlock{
    
    [self saveImage:image
              model:nil
                 VC:nil
         ActionType:ActionTypeSaveCustomImage
       Completetion:saveManyImageHandleBlock];
}

+ (void)pushSystemShareWithModel:(YBLSystemSocialModel *)shareImageModel
                              VC:(UIViewController *)VC
                    Completetion:(SaveManyImageHandleBlock)saveManyImageHandleBlock{
    [self saveImage:nil
              model:shareImageModel
                 VC:VC
         ActionType:ActionTypeSaveImageThenPushSystemShare
       Completetion:saveManyImageHandleBlock];
}

+ (void)saveImageModel:(YBLSystemSocialModel *)shareImageModel
          Completetion:(SaveManyImageHandleBlock)saveManyImageHandleBlock{
    [self saveImage:nil
              model:shareImageModel
                 VC:nil
         ActionType:ActionTypeSaveImage
       Completetion:saveManyImageHandleBlock];
}

+ (void)saveImage:(UIImage *)image
            model:(YBLSystemSocialModel *)shareImageModel
               VC:(UIViewController *)VC
       ActionType:(ActionType)actionType
     Completetion:(SaveManyImageHandleBlock)saveManyImageHandleBlock{
 
    if (!saveManyImageTools) {
        saveManyImageTools = [[YBLSaveManyImageTools alloc] initWithImage:image
                                                                    model:shareImageModel
                                                                       VC:VC
                                                               ActionType:actionType
                                                             Completetion:saveManyImageHandleBlock];
    }
}

- (instancetype)initWithImage:(UIImage *)image
                        model:(YBLSystemSocialModel *)shareImageModel
                           VC:(UIViewController *)VC
                   ActionType:(ActionType)actionType
                 Completetion:(SaveManyImageHandleBlock)saveManyImageHandleBlock{

    self = [super init];
    if (self) {
        _image = image;
        _shareImageModel = shareImageModel;
        _saveManyImageHandleBlock = saveManyImageHandleBlock;
        _actionType = actionType;
        _Vc = VC;
        if (_actionType == ActionTypeSaveCustomImage) {
            self.listOfImages = @[image].mutableCopy;
            [self saveImage];
        } else {
            if (_actionType == ActionTypeSaveImage) {
                [SVProgressHUD showWithStatus:@"正在为您保存图片..."];
                imageIndex = 0;
            } else {
                [SVProgressHUD showWithStatus:@"正在为您生成图片..."];
            }
            [self handleImageArray:shareImageModel.imagesArray];
        }
        
    }
    return self;
}

#pragma mark - save image

- (void)handleImageArray:(NSMutableArray *)array{
   
    __block NSInteger index = 0;
    NSMutableArray *imagesArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (id name in array) {
            UIImage *image = nil;
            if ([name isKindOfClass:[UIImage class]]){
                image = (UIImage *)name;
            } else if ([name isKindOfClass:[NSString class]]){
                if ([name rangeOfString:@"http"].location != NSNotFound) {
                    image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:name]]];
                } else{
                    image = [UIImage imageNamed:name];
                }
            }
            if (index == 0 && _shareImageModel.imageType != SaveImageTypeAnyPic) {
                UIImage *finalImage = nil;
                UIImage *qrcImage = [UIImage qrCodeImageWithContent:_shareImageModel.share_url
                                                      codeImageSize:120
                                                               logo:nil
                                                          logoFrame:CGRectZero
                                                                red:170
                                                              green:170
                                                               blue:170];
                if (_shareImageModel.imageType == SaveImageTypeNormalGoods) {
                    finalImage = [YBLMethodTools addQRCImage:qrcImage ToImage:image];
                } else {
                    //采购商品
                    finalImage = [YBLMethodTools addLabelWithModel:self.shareImageModel AndQRCImage:qrcImage ToGoodImage:image];
                }
                [imagesArray addObject:finalImage];
            } else {
                [imagesArray addObject:image];
            }
            index++;
        }
        self.listOfImages = imagesArray;

        dispatch_async(dispatch_get_main_queue(), ^{
            if (_actionType == ActionTypeSaveImage) {
                [self saveImage];
            } else {
                UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:self.listOfImages applicationActivities:nil];
                activityVC.modalInPopover = true;
                activityVC.restorationIdentifier = @"activity";
                if ([activityVC respondsToSelector:@selector(popoverPresentationController)]) {
                    activityVC.popoverPresentationController.sourceView = [UIApplication sharedApplication].keyWindow;
                }
                [_Vc presentViewController:activityVC animated:YES completion:^{
                    [SVProgressHUD dismiss];
                    BLOCK_EXEC(self.saveManyImageHandleBlock,YES);
                    saveManyImageTools = nil;
                }];
            }
        });
    });

}


- (void)saveImage{

    UIImage* img = self.listOfImages[imageIndex];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    imageIndex ++;
    
    if (imageIndex >= self.listOfImages.count) {
        
        [self allDone];
        
    } else {
        UIImage* img = self.listOfImages[imageIndex];
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)allDone{
    [SVProgressHUD showSuccessWithStatus:@"保存成功到相册"];
    BLOCK_EXEC(self.saveManyImageHandleBlock,YES);
    saveManyImageTools = nil;
    
}

@end
