//
//  YBLGoodParameterView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodParaModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *value;

+ (GoodParaModel *)getModelWithTitle:(NSString *)title value:(NSString *)value;

@end


typedef NS_ENUM(NSInteger,ParaViewType) {
    ParaViewTypePara = 0,       //参数
    ParaViewTypePayShippingment, //配送支付
    ParaViewTypePayRule,          //规则
    ParaViewTypeEditPayRule,          //支付配送方式
};

typedef void(^GoodParameterBlock)();

@interface YBLGoodParameterView : UIView

+ (void)showGoodParameterViewInViewController:(UIViewController *)VC
                                 paraViewType:(ParaViewType)paraViewType
                                     withData:(NSMutableArray *)dataArray
                                 completetion:(GoodParameterBlock)Block;

@end
