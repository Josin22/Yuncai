//
//  YBLOrderBulletModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLOrderBulletModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *content;
@property (nonatomic, copy  ) NSString *avatar;
@property (nonatomic, copy  ) NSString *product_id;
@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, assign) CGSize   contentSize;
@property (nonatomic, assign) CGFloat  iconWidth;
@property (nonatomic, assign) CGFloat  maxContentWidth;

@end
