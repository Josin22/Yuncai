//
//  YBLPhotoHeplerViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//
#import "YBLActionSheetView.h"
#import "YBLPhotoHeplerViewController.h"
#import "HVWOpenAlbumTool.h"

@interface YBLPhotoDelegateHelper: NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy) YBLPhotoHelperBlock selectImageBlock;

@end

@interface YBLPhotoHeplerViewController ()
@property (nonatomic, strong) HVWOpenAlbumTool *helper;

@end

static YBLPhotoHeplerViewController *picker = nil;
@implementation YBLPhotoHeplerViewController


+ (instancetype)shareHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[YBLPhotoHeplerViewController alloc] init];
    });
    return picker;
}

- (void)showImageViewSelcteWithResultBlock:(YBLPhotoHelperBlock)selectImageBlock isEdit:(BOOL)isEdit isJustPhoto:(BOOL)isJustPhoto{
    if (isJustPhoto) {
         [self creatWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum block:selectImageBlock isEdit:isEdit];
    } else {
        WEAK
        [YBLActionSheetView showActionSheetWithTitles:@[@"相机",@"相册"]
                                          handleClick:^(NSInteger index) {
                                              STRONG
                                              switch (index) {
                                                  case 0:
                                                  {
                                                      if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                                                          [self creatWithSourceType:UIImagePickerControllerSourceTypeCamera block:selectImageBlock isEdit:isEdit];
                                                      }else{
                                                          //            [MBProgressHUD showError:@"相机功能暂不能使用"];
                                                      }
                                                  }
                                                      break;
                                                  case 1:
                                                  {
                                                      [self creatWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary block:selectImageBlock isEdit:isEdit];
                                                  }
                                                      break;
                                                      
                                                  default:
                                                      break;
                                              }
                                          }];

    }

}



- (void)creatWithSourceType:(UIImagePickerControllerSourceType)sourceType block:(YBLPhotoHelperBlock)selectImageBlock isEdit:(BOOL)isEdit{
//    picker.helper                  = [[YBLPhotoDelegateHelper alloc] init];
//    picker.delegate                = picker.helper;
//    picker.sourceType              = sourceType;
//    picker.allowsEditing           = isEdit;//默认是可以修改的
//    
//    picker.helper.selectImageBlock = selectImageBlock;
    HVWOpenAlbumTool *tool = [[HVWOpenAlbumTool alloc] init];
    [tool   openAlbumWithIsEdit:isEdit
               sourceType:sourceType
               completion:^(UIImage *image) {
                   BLOCK_EXEC(selectImageBlock,image)
               }];
    self.helper = tool;
}

@end


@implementation YBLPhotoDelegateHelper

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *theImage = nil;
    // 判断，图片是否允许修改。默认是可以的
    if ([picker allowsEditing]){
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    if (_selectImageBlock) {
        _selectImageBlock(theImage);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
