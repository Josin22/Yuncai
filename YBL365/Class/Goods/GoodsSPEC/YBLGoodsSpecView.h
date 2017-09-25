//
//  YBLGoodsSpecView.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/30.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GoodsSpecType) {
    
    GoodsSpecTypeDefault = 0,//默认规格属性
    
    GoodsSpecTypePromotion//促销
    
};

typedef void(^SpecViewOneBuyClickBlock)(void);

typedef void(^SpecViewAddCartClickBlock)(void);

@interface YBLGoodsSpecView : UIView

+ (void)showGoodsSpecViewFormVC:(UIViewController *)vc
                       SpecType:(GoodsSpecType)type
                      goodModel:(id)goodModel
       specViewOneBuyClickBlock:(SpecViewOneBuyClickBlock)oneBuyBlock
       specViewAddCartClickBlock:(SpecViewAddCartClickBlock)AddCartClickBlock;

@end
