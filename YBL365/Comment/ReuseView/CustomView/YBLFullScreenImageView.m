//
//  YBLFullScreenImageView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFullScreenImageView.h"
#import "YBLSaveManyImageTools.h"
#import "YYWebImage.h"
#import "YBLEditPicItemModel.h"

static NSInteger const tag_imageView = 11544;

static YBLFullScreenImageView *fullScreenImageView = nil;

@interface YBLFullScreenImageView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGRect orginRect;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, retain) UILabel *indexLabel;
@property (nonatomic, strong) YBLSystemSocialModel *shareImageModel;
@property (nonatomic, copy  ) currentIndexBlock block;
@property (nonatomic, assign) FullScreenImageViewType fullScreenType;

@end

@implementation YBLFullScreenImageView

+ (void)showFullScreenIamgeViewWithModel:(YBLSystemSocialModel *)socialModel
                            currentIndex:(NSInteger)index
                               orginRect:(CGRect)orginRect
                       currentIndexBlock:(currentIndexBlock)block{
    
    if (!fullScreenImageView) {
        fullScreenImageView = [[YBLFullScreenImageView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                               
                                                            shareImageModel:socialModel
                                                               currentIndex:index
                                                                  orginRect:orginRect
                                                             fullScreenType:FullScreenImageViewTypeGoodDetailBanner
                                                          currentIndexBlock:block];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:fullScreenImageView];
        [UIView animateWithDuration:.3f animations:^{
            fullScreenImageView.bgView.alpha = 1;
            fullScreenImageView.contentScrollView.center = keyWindow.center;
        }];
    }
}


- (instancetype)initWithGoodDetailBannerFrame:(CGRect)frame
                                   imageModel:(YBLSystemSocialModel *)imageModel
                            currentIndexBlock:(currentIndexBlock)block{
    
    return [self initWithFrame:frame
               shareImageModel:imageModel
                  currentIndex:0
                     orginRect:CGRectZero
                fullScreenType:FullScreenImageViewTypeGoodDetailBanner
             currentIndexBlock:block];
}

- (instancetype)initWithFrame:(CGRect)frame
              shareImageModel:(YBLSystemSocialModel *)socialModel
                 currentIndex:(NSInteger)index
                    orginRect:(CGRect)orginRect
               fullScreenType:(FullScreenImageViewType)fullScreenType
            currentIndexBlock:(currentIndexBlock)block{
    
    if (self = [super initWithFrame:frame]) {
        
        _fullScreenType = fullScreenType;
        _shareImageModel = socialModel;
        if (_shareImageModel.imageType == SaveImageTypeAnyPic) {
            _orginRect = frame;
        } else {
            orginRect.size.height = YBLWindowWidth;
            _orginRect = orginRect;
        }
        _currentIndex = index;
        _block = block;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    /* 背景 文字 */
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0;
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tap];
    self.bgView = bgView;
    
    /* scrollview  */
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (self.fullScreenType == FullScreenImageViewTypeOrderExpressPic) {
        contentScrollView.backgroundColor = [UIColor blackColor];
        self.orginRect = [self bounds];
    }
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.directionalLockEnabled = YES;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    //设置最大伸缩比例
    contentScrollView.maximumZoomScale=2.0;
    //设置最小伸缩比例
    contentScrollView.minimumZoomScale=0.5;
    [self addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.width, 20)];
    indexLabel.text = @"0/0";
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.font = YBLFont(20);
    indexLabel.textColor = BlackTextColor;
    [self.bgView addSubview:indexLabel];
    self.indexLabel = indexLabel;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    saveButton.titleLabel.font = YBLFont(18);
    CGFloat buttonWi = 60;
    CGFloat buttonHi = 30;
    saveButton.frame = CGRectMake(self.width-space-buttonWi, self.height-space-buttonHi, buttonWi, buttonHi);
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:saveButton];
    if (self.fullScreenType == FullScreenImageViewTypeGoodDetailBanner) {
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    } else {
        [saveButton setTitle:@"设置" forState:UIControlStateNormal];
    }
    
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(_currentIndex+1),@(self.shareImageModel.imagesArray.count)];
    self.contentScrollView.frame = self.orginRect;
    NSInteger i = 0;
    for (id obj in self.shareImageModel.imagesArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        ;
        imageView.width = self.contentScrollView.width;
        NSString *image_unfi = nil;
        if ([obj isKindOfClass:[YBLEditPicItemModel class]]) {
            YBLEditPicItemModel *model = (YBLEditPicItemModel *)obj;
            image_unfi = model.good_Image_url;
            [imageView js_alpha_setImageWithURL:[NSURL URLWithString:image_unfi] placeholderImage:smallImagePlaceholder completed:^(UIImage *image, NSURL *url) {
                imageView.image = image;
                [self resizeImage:imageView index:i];
            }];
            /*
            [imageView yy_setImageWithURL:[NSURL URLWithString:image_unfi] placeholder:nil options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                imageView.image = image;
//                imageView.height = (double)imageView.width/image.size.width*imageView.height;
//                imageView.centerX = self.contentScrollView.width*(i+.5);
//                imageView.centerY = self.contentScrollView.height/2;
                [self resizeImage:imageView index:i];
            }];
             */
        } else if([obj isKindOfClass:[NSString class]]){
            image_unfi = (NSString *)obj;
            if ([image_unfi rangeOfString:@"http"].location != NSNotFound) {
                [imageView js_alpha_setImageWithURL:[NSURL URLWithString:image_unfi] placeholderImage:smallImagePlaceholder completed:^(UIImage *image, NSURL *url) {
                    imageView.image = image;
                    [self resizeImage:imageView index:i];
                }];
                /*
                [imageView yy_setImageWithURL:[NSURL URLWithString:image_unfi] placeholder:nil options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    imageView.image = image;
//                    imageView.height = (double)imageView.width/image.size.width*imageView.height;
//                    imageView.centerX = self.contentScrollView.width*(i+.5);
//                    imageView.centerY = self.contentScrollView.height/2;
                    [self resizeImage:imageView index:i];
                }];
                 */
            } else {
                UIImage *image = [UIImage imageNamed:image_unfi];
                imageView.image = image;
            }
        } else if ([obj isKindOfClass:[UIImage class]] ){
            UIImage *image = (UIImage *)obj;
            imageView.image = image;
        }
        [self resizeImage:imageView index:i];
        imageView.tag = tag_imageView+i;
        [self.contentScrollView addSubview:imageView];
        if (self.fullScreenType == FullScreenImageViewTypeOrderExpressPic) {
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        if (self.fullScreenType == FullScreenImageViewTypeGoodDetailBanner) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)];
            [imageView addGestureRecognizer:tap];
        }
        i++;
    }
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width*self.shareImageModel.imagesArray.count, self.contentScrollView.height);
    [self.contentScrollView setContentOffset:CGPointMake(_contentScrollView.width*_currentIndex, 0) animated:NO];

}

- (void)resizeImage:(UIImageView *)imageView index:(NSInteger)index{
    if (imageView.image) {
        imageView.height = (double)imageView.width/imageView.image.size.width*imageView.image.size.height;
    }
    imageView.centerX = self.contentScrollView.width*(index+.5);
    imageView.centerY = self.contentScrollView.height/2;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / self.contentScrollView.width;
    self.currentIndex = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(index+1),@(self.shareImageModel.imagesArray.count)];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    if (self.fullScreenType == FullScreenImageViewTypeOrderExpressPic) {
        UIImageView *currentImageView = (UIImageView *)[self viewWithTag:tag_imageView+self.currentIndex];
        return currentImageView;
    } else {
        return 0;
    }
}



- (void)saveButtonClick:(UIButton *)btn{
    
    if (self.fullScreenType == FullScreenImageViewTypeGoodDetailBanner) {
        
        UIImageView *currentImageView = (UIImageView *)[self viewWithTag:tag_imageView+self.currentIndex];
        YBLSystemSocialModel *model = [YBLSystemSocialModel new];
        model = self.shareImageModel;
        model.imagesArray = [@[currentImageView.image] mutableCopy];
        [YBLSaveManyImageTools saveImageModel:model
                                 Completetion:^(BOOL isSuccess) {}];
    } else {
        
        BLOCK_EXEC(self.block,self.currentIndex);
    }
}

- (void)dismissTap:(UIGestureRecognizer *)tap{
    
    [self dismiss];
}


- (void)dismiss{
    
    if (self.contentScrollView.isDecelerating) {
        return;
    }
    
    self.block(self.currentIndex);
    
    [UIView animateWithDuration:.3f animations:^{
        
        self.bgView.alpha = 0;
        self.contentScrollView.frame = self.orginRect;
        
    } completion:^(BOOL finished) {
        
        [fullScreenImageView removeFromSuperview];
        fullScreenImageView = nil;
    }];
    
}

@end
