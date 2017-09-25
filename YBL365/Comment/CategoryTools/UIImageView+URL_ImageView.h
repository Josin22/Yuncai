//
//  UIImageView+URL_ImageView.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JSCompletionBlock)(UIImage *image,NSURL *url);

@interface UIImageView (URL_ImageView)

- (void)js_alpha_setImageWithURL:(NSURL *)url placeholderImage:(NSString *)placeholder completed:(JSCompletionBlock)completedBlock;

- (void)js_scale_setImageWithURL:(NSURL *)url placeholderImage:(NSString *)placeholder;

- (void)js_alpha_setImageWithURL:(NSURL *)url placeholderImage:(NSString *)placeholder;

//给UIImageView动态添加一个属性cornerRadius
@property (nonatomic,assign) CGFloat cornerRadius;

@end
