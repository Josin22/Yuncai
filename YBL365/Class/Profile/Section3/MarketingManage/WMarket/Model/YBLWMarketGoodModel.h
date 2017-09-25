//
//  YBLWMarketModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLWMarketGoodModel : NSObject

@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, copy  ) NSString *share_url;
@property (nonatomic, strong) NSMutableArray *mains;
@property (nonatomic, strong) NSMutableArray *copywritings;
@property (nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, copy  ) NSString *product_id;
@property (nonatomic, copy  ) NSString *product_avatar;
@property (nonatomic, copy  ) NSString *product_title;

@property (nonatomic, strong) NSMutableArray *selectImageArray;

@end
