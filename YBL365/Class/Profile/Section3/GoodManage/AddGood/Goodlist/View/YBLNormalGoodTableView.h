//
//  YBLNormalGoodTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NormalTableViewType) {
    /**
     *  商品展示列表
     */
    NormalTableViewTypeGood = 0,
    /**
     *  关注商品列表
     */
    NormalTableViewTypeFollowGood,
    /**
     *  未评论商品列表
     */
    NormalTableViewTypeNotCommentsGood,
    /**
     *  已评论商品列表
     */
    NormalTableViewTypeCommentedGood,
    /**
     *  商品浏览记录
     */
    NormalTableViewTypeFooterRecordsGood,
    /**
     *  商品分享赏金
     */
    NormalTableViewTypeRewardToShareGood
};

@interface YBLNormalGoodTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                tableViewType:(NormalTableViewType)tableViewType;

@end
