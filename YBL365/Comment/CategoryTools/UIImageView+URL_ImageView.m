//
//  UIImageView+URL_ImageView.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "UIImageView+URL_ImageView.h"
#import "YYWebImage.h"
#import "UIImageView+WebCache.h"

static NSString *CornerLayerName = @"CornerShapeLayer";

@interface UIImageView ()
//是否存在观察者
@property (assign, nonatomic) BOOL addObserver;
//是否已经渲染
@property (assign, nonatomic) BOOL rendering;
@end

@implementation UIImageView (URL_ImageView)

- (void)js_alpha_setImageWithURL:(NSURL *)url placeholderImage:(NSString *)placeholder completed:(JSCompletionBlock)completedBlock{
    [self setImageWithURL:url placeholderImage:placeholder isScaleImageView:NO completed:completedBlock];
}
- (void)js_scale_setImageWithURL:(NSURL *)url placeholderImage:(NSString *)placeholder{
    [self setImageWithURL:url placeholderImage:placeholder isScaleImageView:YES completed:nil];
}

- (void)js_alpha_setImageWithURL:(NSURL *)url placeholderImage:(NSString *)placeholder{
    [self setImageWithURL:url placeholderImage:placeholder isScaleImageView:NO completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(NSString *)placeholder
       isScaleImageView:(BOOL)isScale
              completed:(JSCompletionBlock)completedBlock{
    
//    [self yy_setImageWithURL:url
//                 placeholder:[UIImage imageNamed:placeholder]
//                     options:YYWebImageOptionShowNetworkActivity
//                  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//                      self.image = image;
//                      self.alpha = 0;
//                      if (isScale) {
//                          self.scale = 1.25f;
//                      }
//                      [UIView animateWithDuration:0.3f animations:^{
//                          self.alpha = 1.f;
//                          if (isScale) {
//                              self.scale = 1.f;
//                          }
//                      }];
//                      BLOCK_EXEC(completedBlock,image,url)
//                  }];

    [self sd_setImageWithURL:url
            placeholderImage:[UIImage imageNamed:placeholder]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk) {
                           self.image = image;
                           self.alpha = 0;
                           if (isScale) {
                               self.scale = 1.25f;
                           }
                           [UIView animateWithDuration:0.3f animations:^{
                               self.alpha = 1.f;
                               if (isScale) {
                                   self.scale = 1.f;
                               }
                           }];
                       } else {
                           self.image = image;
                           self.alpha = 1.f;
                           if (isScale) {
                               self.scale = 1.f;
                           }
                       }
                       BLOCK_EXEC(completedBlock,image,imageURL)
//                       if (completedBlock) {
//                           completedBlock(image,error,cacheType,imageURL);
//                       }
                   }];
 
}
#pragma mark - 绘制圆角方法接口
-(void)addCorner:(CGFloat)radius andImage:(UIImage *)image
{
    if (self.rendering) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    self.image = [self imageAddCornerWithRadius:radius andSize:self.bounds.size andImage:image];
    [self layoutIfNeeded];
}

#pragma mark - 绘制圆角核心方法
- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size andImage:(UIImage *)image{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [image drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma mark - 动态添加属性cornerRadius
- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    objc_setAssociatedObject(self, @selector(cornerRadius), @(cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.image == nil) {
        self.rendering = NO;
        if (!self.addObserver) {
            [[self class] swizzleDealloc];
            // 给动态的属性赋值时kvo观察image的变化
            [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
            self.addObserver = YES;
        }
    }else{
        self.rendering = NO;
        //调用绘制圆角方法接口
        [self addCorner:cornerRadius andImage:self.image];
    }
}


- (BOOL)addObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setAddObserver:(BOOL)addObserver {
    objc_setAssociatedObject(self, @selector(addObserver), @(addObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rendering {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRendering:(BOOL)rendering {
    objc_setAssociatedObject(self, @selector(rendering), @(rendering), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        }
        if (self.rendering) {
            return;
        }
        if (newImage) {
            self.rendering = YES;
            [self addCorner:self.cornerRadius andImage:newImage];
        }
    }
}


#pragma mark - 交换方法
+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(zh_dealloc)];
    });
}
- (void)zh_dealloc {
    if (self.addObserver) {
        [self removeObserver:self forKeyPath:@"image"];
        NSLog(@"dealloc");
    }
    [self zh_dealloc];
}

@end
