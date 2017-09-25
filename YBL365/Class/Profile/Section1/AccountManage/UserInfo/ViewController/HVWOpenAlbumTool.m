//
//  HVWOpenAlbumTool.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "HVWOpenAlbumTool.h"
@interface HVWOpenAlbumTool() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, copy) void (^didPickImageBlock)(UIImage *);

@end

@implementation HVWOpenAlbumTool

- (void)openAlbumWithIsEdit:(BOOL)isEdit sourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImage *))completion{
    _didPickImageBlock = completion;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType              = sourceType;
    picker.allowsEditing           = isEdit;//默认是可以修改的
//    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_didPickImageBlock) {
        _didPickImageBlock(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

