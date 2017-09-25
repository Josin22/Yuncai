//
//  HMImageSelectButton.h
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/30.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 选择图像按钮
@interface HMImageSelectButton : UIButton
- (instancetype)initWithImageName:(NSString *)imageName selectedName:(NSString *)selectedName;
@end
