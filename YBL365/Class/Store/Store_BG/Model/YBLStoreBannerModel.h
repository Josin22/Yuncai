//
//  YBLStoreBannerModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLStoreBannerModel : NSObject

@property (nonatomic, copy  ) NSString *_id;

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, copy  ) NSString *picture;

@property (nonatomic, strong) YBLStoreBannerModel *fixture_picture;

@end
