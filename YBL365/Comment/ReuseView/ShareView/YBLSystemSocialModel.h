//
//  YBLSystemSocialModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLSystemSocialModel : NSObject

@property (nonatomic, assign) SaveImageType imageType;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSString *share_url;

@property (nonatomic, strong) NSNumber *quantity;

@property (nonatomic, strong) NSString *unit;

@property (nonatomic, strong) NSString *spec;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSString *local;

@property (nonatomic, strong) NSString *shopName;

@property (nonatomic, strong) NSString *head_img;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString  *logo_url;

@end
