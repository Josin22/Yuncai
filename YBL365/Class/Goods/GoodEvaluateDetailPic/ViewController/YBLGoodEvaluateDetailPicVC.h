//
//  YBLGoodEvaluateDetailPicVC.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "KSPhotoBrowser.h"

@class YBLOrderCommentsModel;

@interface YBLGoodEvaluateDetailPicVC : KSPhotoBrowser

+ (void)pushFromVc:(UIViewController *)selfVc commentModel:(YBLOrderCommentsModel *)commentModel imageView:(UIImageView *)imageView;

@end
