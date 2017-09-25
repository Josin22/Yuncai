//
//  YBLCompanyTypePricesParaModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PricesItemModel : NSObject

@property (nonatomic, copy)   NSString *id;

@property (nonatomic, strong) NSNumber *active;

@property (nonatomic, strong) NSNumber *min;

@property (nonatomic, strong) NSNumber *sale_price;

@end

@interface YBLCompanyTypePricesParaModel : NSObject

@property (nonatomic, strong) NSMutableArray *prices;

@property (nonatomic, strong) NSMutableArray *filter_prices;

@property (nonatomic, copy  ) NSString       *id;

@property (nonatomic, copy  ) NSString       * company_type_id;

@property (nonatomic, assign) BOOL           isNotShowRow;

@property (nonatomic, strong) NSString       *company_title;

@property (nonatomic, strong) NSString       *unit;

//@property (nonatomic, assign) BOOL           isSectionSwitchOn;
@property (nonatomic, strong) NSNumber       *active;

@property (nonatomic, assign) BOOL           isPiLiang;

@end
