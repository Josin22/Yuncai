//
//  ZZYPhotoHelper.h
//  OC_FunctionDemo
//
//  Created by 周智勇 on 16/9/9.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZZYPhotoHelperBlock) (id data);

@interface ZZYPhotoHelper : UIImagePickerController


+ (instancetype)shareHelper;

- (void)showImageViewSelcteWithResultBlock:(ZZYPhotoHelperBlock)selectImageBlock;

@end
