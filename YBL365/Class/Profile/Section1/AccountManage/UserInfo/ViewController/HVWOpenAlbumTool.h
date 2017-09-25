//
//  HVWOpenAlbumTool.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HVWOpenAlbumTool : NSObject
- (void)openAlbumWithIsEdit:(BOOL)isEdit sourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImage *))completion;
@end
