//
//  YBLOrderActionView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLOrderActionView : UIView

+ (void)showTitle:(NSString *)title
           cancle:(NSString *)cancle
             sure:(NSString *)sure
  WithSubmitBlock:(void(^)())block
      cancelBlock:(void(^)())block1;


@end
