//
//  HMAlbum.m
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/26.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMAlbum.h"

@implementation HMAlbum {
    /// 当前相册资源集合
    PHAssetCollection *_assetCollection;
    /// 当前相册内的资源查询结果
    PHFetchResult *_fetchResult;
}
@synthesize desc = _desc;

#pragma mark - 构造函数
+ (instancetype)albumWithAssetCollection:(PHAssetCollection *)assetCollection {
    return [[self alloc] initWithAssetCollection:assetCollection];
}

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection {
    self = [super init];
    if (self) {
        // 设置查询选项
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        // 仅搜索照片
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
        // 按照创建日期降序排列照片
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        _assetCollection = assetCollection;
        _fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    }
    return self;
}

#pragma mark - 只读属性
- (NSString *)title {
    return _assetCollection.localizedTitle;
}

- (NSInteger)count {
    return _fetchResult.count;
}

- (NSAttributedString *)desc {
    if (_desc == nil) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        
        [attributedString appendAttributedString:
         [[NSAttributedString alloc] initWithString:_assetCollection.localizedTitle]
         ];
        [attributedString appendAttributedString:
         [[NSAttributedString alloc]
          initWithString:[NSString stringWithFormat:@"\n%zd", _fetchResult.count]
          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}]
         ];
        
        _desc = attributedString.copy;
    }
    return _desc;
}

#pragma mark - 相册列表调用方法
- (UIImage *)emptyImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    [[UIColor whiteColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (void)requestThumbnailWithSize:(CGSize)size completion:(void (^)(UIImage * _Nonnull))completion {
    
    dispatch_group_t group = dispatch_group_create();
    
    // 加载 3 张图像，生成缩略图
    NSMutableArray *images = [NSMutableArray array];
    CGSize imageSize = [self sizeWithScale:size];
    PHImageRequestOptions *options = [self imageRequestOptions];
    
    for (NSInteger i = 0; i < 3 && i <= (_fetchResult.count - 1); i++) {
        PHAsset *asset = _fetchResult[i];
        
        dispatch_group_enter(group);
        
        [[PHImageManager defaultManager]
         requestImageForAsset:asset
         targetSize:imageSize
         contentMode:PHImageContentModeAspectFill
         options:options
         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
             [images addObject:result];
             
             dispatch_group_leave(group);
         }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        UIImage *result = [self thumbnailWithImages:images size:imageSize];
        
        dispatch_async(dispatch_get_main_queue(), ^ { completion(result); });
    });
}

- (void)requestThumbnailWithAssetIndex:(NSInteger)index Size:(CGSize)size completion:(void (^)(UIImage * _Nonnull))completion {
    
    PHAsset *asset = _fetchResult[index];
    
    [[PHImageManager defaultManager]
     requestImageForAsset:asset
     targetSize:[self sizeWithScale:size]
     contentMode:PHImageContentModeAspectFill
     options:[self imageRequestOptions]
     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
         completion(result);
     }];
}

/// 使用图像数组生成层叠的缩略图
///
/// @param images 图像数组
/// @param size   图像尺寸
///
/// @return 层叠缩略图
- (UIImage *)thumbnailWithImages:(NSArray <UIImage *> *)images size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat margin = 3.0 * [UIScreen mainScreen].scale;
    NSInteger index = 0;
    for (UIImage *image in images.reverseObjectEnumerator) {
        CGContextSaveGState(ctx);
        
        CGFloat top = index * margin;
        index++;
        CGFloat left = (images.count - index) * margin;
        UIRectClip(CGRectMake(left, top, size.width - left * 2, size.height - top));
        
        CGFloat x = (size.width - image.size.width) * 0.5;
        CGFloat y = (size.height - image.size.height) * 0.5;
        
        CGRect rect = CGRectMake(x, y, image.size.width, image.size.height);
        
        [image drawInRect:rect];
        
        CGContextRestoreGState(ctx);
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (PHAsset *)assetWithIndex:(NSInteger)index {
    if (index >= _fetchResult.count || index < 0) {
        return nil;
    }
    return _fetchResult[index];
}

- (NSUInteger)indexWithAsset:(PHAsset *)asset {
    return [_fetchResult indexOfObject:asset];
}

- (CGSize)sizeWithScale:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    return CGSizeMake(size.width * scale, size.height * scale);
}

/// 图像请求选项
- (PHImageRequestOptions *)imageRequestOptions {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 设置 resizeMode 可以按照指定大小缩放图像
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 只回调一次缩放之后的照片，否则会调用多次
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    return options;
}

@end
