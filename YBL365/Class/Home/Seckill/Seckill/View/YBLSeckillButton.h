//
//  YBLSeckillButton.h
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SeckillType) {
    SeckillTypeGoBuy = 0,//去抢购
    SeckillTypeNoCount,//已抢完
    SeckillTypeRecomandNoraml,//提醒我
    SeckillTypeRecomandSelect//取消提醒
};

@interface YBLSeckillButton : UIButton

@property(nonatomic, assign) SeckillType seckillType;

@end
