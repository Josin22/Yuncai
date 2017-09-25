//
//  YBLAddressAreaModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLExpressCompanyItemModel.h"

@interface YBLAddressAreaModel : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSNumber *parent_id;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isArrowSelect;
@property (nonatomic, assign) BOOL isShowDeleteButton;
/**
 *  储存快递物流信息  [express_company_id:YBLExpressCompanyItemModel]
 */
//@property (nonatomic, strong) NSMutableDictionary *expressCompanyDataDict;

@end
