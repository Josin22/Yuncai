//
//  YBLWKGoodListTableView.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WKType) {
    /**
     *  微营销
     */
    WKTypeMarket = 0,
    /**
     *  赏金
     */
    WKTypeReward
};

@interface YBLWKGoodListTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                         type:(WKType)type;

@end
