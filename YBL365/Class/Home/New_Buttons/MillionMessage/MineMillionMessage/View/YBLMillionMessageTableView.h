//
//  YBLMillionMessageTableView.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MillionType) {
    /**
     *  公海客户
     */
    MillionTypePublic,
    /**
     *  已关注客户
     */
    MillionTypeMine,
    /**
     *  选择客户
     */
    MillionTypeSelect
};

@interface YBLMillionMessageTableView : UITableView

@property (nonatomic, weak) NSMutableArray *milionDataArray;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                  millionType:(MillionType)millionType;

@end
