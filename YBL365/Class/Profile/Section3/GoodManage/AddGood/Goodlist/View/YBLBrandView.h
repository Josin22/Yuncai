//
//  YBLBrandView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BrandSureBlock)(void);

@interface YBLBrandView : UIView

+ (void)showBrandViewWithData:(NSMutableArray *)data BrandSureHandle:(BrandSureBlock)sureBlock;

@end
