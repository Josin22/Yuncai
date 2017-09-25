//
//  KSWebImage.m
//  KSPhotoBrowserDemo
//
//  Created by Kyle Sun on 22/05/2017.
//  Copyright © 2017 Kyle Sun. All rights reserved.
//

#import "KSYYImageManager.h"

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImage.h>
#else
#import "YYWebImage.h"

#endif

#import <SDWebImage/UIImageView+WebCache.h>

@implementation KSYYImageManager

- (void)setImageForImageView:(UIImageView *)imageView
                     withURL:(NSURL *)imageURL
                 placeholder:(UIImage *)placeholder
                    progress:(KSImageManagerProgressBlock)progress
                  completion:(KSImageManagerCompletionBlock)completion
{
    /*
    YYWebImageProgressBlock progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progress) {
            progress(receivedSize, expectedSize);
        }
    };
    YYWebImageCompletionBlock completionBlock = ^(UIImage *image,  NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        if (completion) {
            BOOL success = (stage == YYWebImageStageFinished) && !error;
            completion(image, url, success, error);
        }
    };
    [imageView yy_setImageWithURL:imageURL placeholder:placeholder options:kNilOptions progress:progressBlock transform:nil completion:completionBlock];
    */
    SDWebImageDownloaderProgressBlock progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progress) {
            progress(receivedSize, expectedSize);
        }
    };
    SDWebImageCompletionBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completion) {
            completion(image, imageURL, YES, error);
        }
    };
    [imageView sd_setImageWithURL:imageURL
                 placeholderImage:[UIImage imageNamed:smallImagePlaceholder]
                          options:kNilOptions
                         progress:progressBlock
                        completed:completionBlock];
}

- (void)cancelImageRequestForImageView:(UIImageView *)imageView {
//    [imageView yy_cancelCurrentImageRequest];
    [imageView sd_cancelCurrentImageLoad];
}

- (UIImage *)imageFromMemoryForURL:(NSURL *)url {
    /*
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.cache getImageForKey:key withType:YYImageCacheTypeMemory];
     */
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.imageCache imageFromMemoryCacheForKey:key];
}

@end
