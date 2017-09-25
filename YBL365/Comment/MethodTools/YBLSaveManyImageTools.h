//
//  YBLSaveManyImageTools.h
//  YC168
//
//  Created by 乔同新 on 2017/4/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLSystemSocialModel.h"

typedef void(^SaveManyImageHandleBlock)(BOOL isSuccess);

@interface YBLSaveManyImageTools : NSObject

+ (void)saveImage:(UIImage *)image
     completetion:(SaveManyImageHandleBlock)saveManyImageHandleBlock;

+ (void)saveImageModel:(YBLSystemSocialModel *)shareImageModel
          Completetion:(SaveManyImageHandleBlock)saveManyImageHandleBlock;

+ (void)pushSystemShareWithModel:(YBLSystemSocialModel *)shareImageModel
                              VC:(UIViewController *)VC
                    Completetion:(SaveManyImageHandleBlock)saveManyImageHandleBlock;

@end
