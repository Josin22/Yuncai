//
//  YBLScanQRCodeView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLScanQRCodeAnimationView.h"

@protocol YBLScanQRCodeViewDelegate <NSObject>

/** 返回识别的二维码内容*/
- (void)sendQRCodeContent:(NSString *)content;

@end

@interface YBLScanQRCodeView : UIView

@property (nonatomic, weak) id<YBLScanQRCodeViewDelegate> delegate;

/** 开始扫描二维码*/
- (void)startReadQRCode;
/** 结束扫描二维码*/
- (void)endReadQRCode;
/** 暂停扫描二维码*/
- (void)pauseCode;

/** 进入相册，识别图片中的二维码*/
- (void)recognizeQRcodeFromAlbum;

@end
