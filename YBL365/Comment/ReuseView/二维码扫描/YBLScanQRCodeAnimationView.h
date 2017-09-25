//
//  YBLScanQRCodeAnimationView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScanW (YBLWindowWidth*3.8)/5.5

#define Scan_Width self.frame.size.width
#define Scan_Height self.frame.size.height
#define Scan_Angle_Width 15

@interface YBLScanQRCodeAnimationView : UIView

@property (nonatomic, strong) UIButton *histoyButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, strong) YBLButton *sureButton;
@property (nonatomic, strong) YBLButton *writeMButton;
@property (nonatomic, strong) YBLButton *changeMButton;

@property (nonatomic, strong) SMTextField *textFeild;

/** 开始扫描动画*/
- (void)startScanAnimation;
/** 结束扫描动画*/
- (void)endScanAnimation;

- (void)isShowTextField:(BOOL)isShow;

@end
