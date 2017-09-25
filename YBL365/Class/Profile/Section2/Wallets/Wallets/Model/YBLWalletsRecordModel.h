//
//  YBLWalletsRecordModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLWalletflowsItemModel : NSObject

@property (nonatomic, copy  ) NSString       *shopname;
@property (nonatomic, copy  ) NSString       *type;
@property (nonatomic, copy  ) NSNumber       *amount;
@property (nonatomic, copy  ) NSString       *desc;
@property (nonatomic, copy  ) NSString       *created_at;
@property (nonatomic, copy  ) NSString       *purchase_number;
@property (nonatomic, copy  ) NSString       *purchase_order_id;

@property (nonatomic, strong) NSString       *signlText;
@property (nonatomic, strong) UIColor        *textColor;

@end

@interface YBLWalletsRecordModel : NSObject

@property (nonatomic, strong) NSNumber       *gold;
@property (nonatomic, strong) NSNumber       *frozen_gold;
@property (nonatomic, strong) NSMutableArray *walletflows;
@property (nonatomic, strong) NSMutableArray *firter_walletflows;

@end
