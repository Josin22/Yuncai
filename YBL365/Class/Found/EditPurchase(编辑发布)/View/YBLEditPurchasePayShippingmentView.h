//
//  YBLEditPurchasePayShippingmentView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , MentType) {
    MentTypeAllMent = 0,
    MentTypePay, //支付
    MentTypeShipping //配送
};

typedef NS_ENUM(NSInteger,SelectionType) {
    SelectionTypeMultiple = 0, //多选
    SelectionTypeSingle        //单选
};
/**
 *  回调
 *
 *  @param selectValue   选定文字
 *  @param selectIDArray 选定的方式[ids]
 */
typedef void(^EditPurchasePayShippingmentViewSelectBlock)(NSString *selectValue,NSMutableArray *selectIDArray);

@interface YBLEditPurchasePayShippingmentView : UIView

+ (void)showEditPurchasePayShippingmentViewInVC:(UIViewController *)VC
                                   undefineData:(NSMutableArray *)undefineData
                                         Handle:(EditPurchasePayShippingmentViewSelectBlock)block;


- (instancetype)initWithFrame:(CGRect)frame
                     ViewInVC:(UIViewController *)VC
                 undefineData:(NSMutableArray *)undefineData
                         Type:(MentType)type
                SelectionType:(SelectionType)selectionType
                       Handle:(EditPurchasePayShippingmentViewSelectBlock)block;;
@end
