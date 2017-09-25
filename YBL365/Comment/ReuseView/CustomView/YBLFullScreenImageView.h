//
//  YBLFullScreenImageView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^currentIndexBlock)(NSInteger currentIndex);

typedef NS_ENUM(NSInteger, FullScreenImageViewType) {
    ///商品详情banner
    FullScreenImageViewTypeGoodDetailBanner = 0,
    ///
    FullScreenImageViewTypeOrderExpressPic
};

@interface YBLFullScreenImageView : UIView

+ (void)showFullScreenIamgeViewWithModel:(YBLSystemSocialModel *)socialModel
                            currentIndex:(NSInteger)index
                               orginRect:(CGRect)orginRect
                       currentIndexBlock:(currentIndexBlock)block;

- (instancetype)initWithGoodDetailBannerFrame:(CGRect)frame
                                   imageModel:(YBLSystemSocialModel *)imageModel
                            currentIndexBlock:(currentIndexBlock)block;

- (instancetype)initWithFrame:(CGRect)frame
              shareImageModel:(YBLSystemSocialModel *)socialModel
                 currentIndex:(NSInteger)index
                    orginRect:(CGRect)orginRect
               fullScreenType:(FullScreenImageViewType)fullScreenType
            currentIndexBlock:(currentIndexBlock)block;

@end
