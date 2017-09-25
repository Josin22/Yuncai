//
//  YBLShopFixtrueModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fixture_picture : NSObject

@property (nonatomic, copy  ) NSString *picture;
@property (nonatomic, copy  ) NSString *_id;

@end

@interface YBLShopFixtrueModel : NSObject

@property (nonatomic, copy  ) NSString        *_id;
@property (nonatomic, copy  ) NSString        *model;
@property (nonatomic, strong) fixture_picture *fixture_picture;

@end
