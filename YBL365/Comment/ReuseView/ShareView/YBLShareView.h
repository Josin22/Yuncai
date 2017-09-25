//
//  XNShareView.h
//  51XiaoNiu
//
//  Created by 乔同新 on 16/4/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ShareType) {
    ShareTypeSocial = 0, //社交分享
    ShareTypeSysterm,     //系统
    ShareTypeYUNLONG
};

typedef void(^ShareResultBlock)(ShareType type,BOOL isSuccess);

typedef void(^ShareADGoodsClickBlock)(void);

@interface YBLShareView : UIView

+ (void)shareViewWithPublishContentText:(NSString *)text
                                  title:(NSString *)title
                              imagePath:(NSString *)path
                                    url:(NSString *)url
                                 Result:(ShareResultBlock)resultBlock
                ShareADGoodsClickHandle:(ShareADGoodsClickBlock)clickBlock;


@end
