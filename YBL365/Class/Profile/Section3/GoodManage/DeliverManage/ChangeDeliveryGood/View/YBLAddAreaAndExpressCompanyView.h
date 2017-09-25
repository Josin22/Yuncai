//
//  YBLAddAreaAndExpressCompanyView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseView.h"

typedef void(^AddAreaAndExpressCompanyViewSelectBlock)(NSMutableDictionary *selectDict);

@interface YBLAddAreaAndExpressCompanyView : YBLBaseView

+ (void)showAddAreaAndExpressCompanyViewFromVC:(UIViewController *)Vc selectHandle:(AddAreaAndExpressCompanyViewSelectBlock)selectBlock;

@end
