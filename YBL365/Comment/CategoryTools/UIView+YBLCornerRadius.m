//
//  UIView+YBLCornerRadius.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/31.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "UIView+YBLCornerRadius.h"
#import <objc/runtime.h>

@implementation UIView (YBLCornerRadius)

- (void)dd_quadrateCornerWithRadius:(CGFloat)radius
                        cornerColor:(UIColor *)color
{
    if (!color) {
        color = [self cornerColor];
    }
    
    [self.layer dd_cornerWithRadius:radius cornerColor:color];
}

- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
                    corners:(UIRectCorner)corners
{
    if (!color) {
        color = [self cornerColor];
    }
    
    [self.layer dd_cornerWithRadius:radius cornerColor:color corners:corners];
}

- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
                    corners:(UIRectCorner)corners
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth
{
    if (!color) {
        color = [self cornerColor];
    }
    
    [self.layer dd_cornerWithRadius:radius cornerColor:color corners:corners borderColor:borderColor borderWidth:borderWidth];
}

- (void)dd_quadrateCornerWithRadius:(CGFloat)radius
                        cornerColor:(UIColor *)color
                        borderColor:(UIColor *)borderColor
                        borderWidth:(CGFloat)borderWidth
{
    [self dd_cornerWithRadius:radius cornerColor:color corners:UIRectCornerAllCorners borderColor:borderColor borderWidth:borderWidth];
}

- (UIColor *)cornerColor
{
    UIView *superview = self.superview;
    while (superview.backgroundColor == nil || CGColorGetAlpha(superview.backgroundColor.CGColor) == 0 || superview.alpha == 0 || superview.opaque == 0) {
        if (!superview) {
            break;
        }
        superview = [superview superview];
    }
    
    return superview.backgroundColor;
}

@end

static void *const _DDMaskCornerRadiusLayerKey = "_DDMaskCornerRadiusLayerKey";
static NSMutableSet<UIImage *> *maskCornerRaidusImageSet;

@implementation NSObject (DDCornerRadius)

- (void)dd_setCornerRadiusAttribute:(id)value
                            withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dd_getCornerRadiusAttributeForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)dd_removeCornerRadiusAttributeWithKey:(void *)key
{
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIImage (DDCornerRadius)

+ (UIImage *)dd_maskRoundCornerRadiusImageWithColor:(UIColor *)color
                                        cornerRadii:(CGSize)cornerRadii
                                               size:(CGSize)size
                                            corners:(UIRectCorner)corners
                                        borderColor:(UIColor *)borderColor
                                        borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0);
    [color set];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    [rectPath appendPath:roundPath];
    CGContextAddPath(context, rectPath.CGPath);
    CGContextEOFillPath(context);
    if (borderColor && borderWidth) {
        [borderColor set];
        UIBezierPath *borderOutterPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
        UIBezierPath *borderInnerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:cornerRadii];
        [borderOutterPath appendPath:borderInnerPath];
        CGContextAddPath(context, borderOutterPath.CGPath);
    }
    CGContextEOFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation CALayer (DDCornerRadius)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(layoutSublayers));
    Method newMethod = class_getInstanceMethod(self, @selector(_dd_layoutSublayers));
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (UIImage *)contentImage
{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)self.contents];
}

- (void)setContentImage:(UIImage *)contentImage
{
    self.contents = (__bridge id)contentImage.CGImage;
}

- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
{
    [self dd_cornerWithRadius:radius cornerColor:color corners:UIRectCornerAllCorners];
}

- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
                    corners:(UIRectCorner)corners
{
    [self dd_cornerWithRadius:radius cornerColor:color corners:corners borderColor:nil borderWidth:0];
}

- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
                    corners:(UIRectCorner)corners
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth
{
    if (!color) return;
    CALayer *cornerRadiusLayer = [self dd_getCornerRadiusAttributeForKey:_DDMaskCornerRadiusLayerKey];
    if (!cornerRadiusLayer) {
        cornerRadiusLayer = [CALayer new];
        cornerRadiusLayer.opaque = YES;
        [self dd_setCornerRadiusAttribute:cornerRadiusLayer withKey:_DDMaskCornerRadiusLayerKey];
    }
    if (color) {
        [cornerRadiusLayer dd_setCornerRadiusAttribute:color withKey:"_dd_cornerRadiusImageColor"];
    } else {
        [cornerRadiusLayer dd_removeCornerRadiusAttributeWithKey:"_dd_cornerRadiusImageColor"];
    }
    [cornerRadiusLayer dd_setCornerRadiusAttribute:[NSValue valueWithCGSize:CGSizeMake(radius, radius)] withKey:"_dd_cornerRadiusImageRadius"];
    [cornerRadiusLayer dd_setCornerRadiusAttribute:@(corners) withKey:"_dd_cornerRadiusImageCorners"];
    if (borderColor) {
        [cornerRadiusLayer dd_setCornerRadiusAttribute:borderColor withKey:"_dd_cornerRadiusImageBorderColor"];
    } else {
        [cornerRadiusLayer dd_removeCornerRadiusAttributeWithKey:"_dd_cornerRadiusImageBorderColor"];
    }
    [cornerRadiusLayer dd_setCornerRadiusAttribute:@(borderWidth) withKey:"_dd_cornerRadiusImageBorderWidth"];
    UIImage *image = [self _dd_getCornerRadiusImageFromSet];
    if (image) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = image;
        [CATransaction commit];
    }
}

- (UIImage *)_dd_getCornerRadiusImageFromSet
{
    if (!self.bounds.size.width || !self.bounds.size.height) return nil;
    CALayer *cornerRadiusLayer = [self dd_getCornerRadiusAttributeForKey:_DDMaskCornerRadiusLayerKey];
    UIColor *color = [cornerRadiusLayer dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageColor"];
    if (!color) return nil;
    CGSize radius = [[cornerRadiusLayer dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageRadius"] CGSizeValue];
    NSUInteger corners = [[cornerRadiusLayer dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageCorners"] unsignedIntegerValue];
    CGFloat borderWidth = [[cornerRadiusLayer dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageBorderWidth"] floatValue];
    UIColor *borderColor = [cornerRadiusLayer dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageBorderColor"];
    if (!maskCornerRaidusImageSet) {
        maskCornerRaidusImageSet = [NSMutableSet new];
    }
    __block UIImage *image = nil;
    [maskCornerRaidusImageSet enumerateObjectsUsingBlock:^(UIImage *_Nonnull obj, BOOL *_Nonnull stop) {
        CGSize imageSize = [[obj dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageSize"] CGSizeValue];
        UIColor *imageColor = [obj dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageColor"];
        CGSize imageRadius = [[obj dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageRadius"] CGSizeValue];
        NSUInteger imageCorners = [[obj dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageCorners"] unsignedIntegerValue];
        CGFloat imageBorderWidth = [[obj dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageBorderWidth"] floatValue];
        UIColor *imageBorderColor = [obj dd_getCornerRadiusAttributeForKey:"_dd_cornerRadiusImageBorderColor"];
        BOOL isBorderSame = (CGColorEqualToColor(borderColor.CGColor, imageBorderColor.CGColor) && borderWidth == imageBorderWidth) || (!borderColor && !imageBorderColor) || (!borderWidth && !imageBorderWidth);
        BOOL canReuse = CGSizeEqualToSize(self.bounds.size, imageSize) && CGColorEqualToColor(imageColor.CGColor, color.CGColor) && imageCorners == corners && CGSizeEqualToSize(radius, imageRadius) && isBorderSame;
        if (canReuse) {
            image = obj;
            *stop = YES;
        }
    }];
    if (!image) {
        image = [UIImage dd_maskRoundCornerRadiusImageWithColor:color cornerRadii:radius size:self.bounds.size corners:corners borderColor:borderColor borderWidth:borderWidth];
        [image dd_setCornerRadiusAttribute:[NSValue valueWithCGSize:self.bounds.size] withKey:"_dd_cornerRadiusImageSize"];
        [image dd_setCornerRadiusAttribute:color withKey:"_dd_cornerRadiusImageColor"];
        [image dd_setCornerRadiusAttribute:[NSValue valueWithCGSize:radius] withKey:"_dd_cornerRadiusImageRadius"];
        [image dd_setCornerRadiusAttribute:@(corners) withKey:"_dd_cornerRadiusImageCorners"];
        if (borderColor) {
            [image dd_setCornerRadiusAttribute:color withKey:"_dd_cornerRadiusImageBorderColor"];
        }
        [image dd_setCornerRadiusAttribute:@(borderWidth) withKey:"_dd_cornerRadiusImageBorderWidth"];
        [maskCornerRaidusImageSet addObject:image];
    }
    return image;
}

#pragma mark - exchage Methods

- (void)_dd_layoutSublayers
{
    [self _dd_layoutSublayers];
    
    CALayer *cornerRadiusLayer = [self dd_getCornerRadiusAttributeForKey:_DDMaskCornerRadiusLayerKey];
    if (cornerRadiusLayer) {
        UIImage *aImage = [self _dd_getCornerRadiusImageFromSet];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = aImage;
        cornerRadiusLayer.frame = self.bounds;
        [CATransaction commit];
        [self addSublayer:cornerRadiusLayer];
    }
}

@end
