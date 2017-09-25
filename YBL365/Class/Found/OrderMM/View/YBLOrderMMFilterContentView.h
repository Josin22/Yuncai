//
//  YBLOrderMMFilterContentView.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ContentType) {
    ContentTypeComprehensive = 0,//综合
    ContentTypeSequence//顺序
};

typedef void(^ContentSelectblock)();

@interface YBLOrderMMFilterContentView : UIView

+ (void)showOrderMMFilterContentViewInVC:(UIViewController *)vc
                              valueArray:(NSArray *)array
                             ContentType:(ContentType)type
                             compeletion:(ContentSelectblock)block;

@end
