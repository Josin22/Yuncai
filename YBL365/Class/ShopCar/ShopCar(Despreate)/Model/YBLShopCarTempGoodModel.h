//
//  YBLShopCarTempGoodModel.h
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLShopCarTempGoodModel : NSObject



@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *shop;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) NSInteger expressMoney;//快递费
@property (nonatomic, copy) NSString *express;//物流描述


@property (nonatomic, copy) NSString *gid;

//是否选中删除
@property (nonatomic, assign) BOOL isDelete;

//是否选中购买
@property (nonatomic, assign) BOOL isCheck;



@end
