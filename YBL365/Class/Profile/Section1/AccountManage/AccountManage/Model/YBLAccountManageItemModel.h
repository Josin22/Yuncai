//
//  YBLAccountManageItemModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CellItemType) {
    CellItemTypeNoCanWriteClick = 0,
    CellItemTypeJustClick,
    CellItemTypeClickWrite
};

@interface YBLAccountManageItemModel : NSObject

@property (nonatomic, strong) NSString     *title;

@property (nonatomic, strong) NSString     *value;

@property (nonatomic, assign) CellItemType cellItemType;

@property (nonatomic) id                   icon_url;

@property (nonatomic, strong) NSString     *paraValue;

@end
