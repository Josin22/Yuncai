//
//  YBLSeckillTableView.h
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBLSeckillViewModel,YBLSeckillViewController;

typedef NS_ENUM(NSInteger,SeckillTableViewType) {
    SeckillTableViewTypeDefault = 0,//默认
    SeckillTableViewTypeCategoty
};

@interface YBLSeckillTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style Type:(SeckillTableViewType)type;

@property (nonatomic, weak) YBLSeckillViewController *seckillVC;

@property (nonatomic, assign) NSInteger test;

@end
