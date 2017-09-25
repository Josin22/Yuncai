//
//  YBLAgentViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgentParaModel : NSObject

@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *e_mail;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *agent_price_range_id;

@end

@interface PriceRangeModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *create_at;
@property (nonatomic, copy) NSMutableArray *price_range;
@property (nonatomic, copy) NSString *update_at;

@end

@interface YBLAgentViewModel : NSObject

@property (nonatomic, strong) AgentParaModel *agentParaModel;

@property (nonatomic, strong) NSMutableArray *priceRangeArray;

@property (nonatomic, strong) NSMutableArray *titeArray;

- (RACSignal *)siganlForAgentPrice;

- (RACSignal *)siganlForAgent;

@end
