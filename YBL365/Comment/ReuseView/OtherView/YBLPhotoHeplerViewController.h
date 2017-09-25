//
//  YBLPhotoHeplerViewController.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YBLPhotoHelperBlock) (UIImage *selectImage);

@interface YBLPhotoHeplerViewController : UIImagePickerController

+ (instancetype)shareHelper;

- (void)showImageViewSelcteWithResultBlock:(YBLPhotoHelperBlock)selectImageBlock
                                    isEdit:(BOOL)isEdit
                               isJustPhoto:(BOOL)isJustPhoto;

@end
