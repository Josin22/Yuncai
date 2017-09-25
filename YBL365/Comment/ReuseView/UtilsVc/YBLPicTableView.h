//
//  YBLPicTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLGoodsBannerView.h"
#import "YBLGoodsManageItemButton.h"

@class YBLOrderCommentsModel;

typedef void(^PicDetailScrollPullBlock)(void);

typedef NS_ENUM(NSInteger,PicTableViewType) {
    PicTableViewTypeNoHeader = 0,
    PicTableViewTypeHasCustomHeader,
    PicTableViewTypeCommentsHeader
};

@interface YBLPicTableView : UITableView

@property (nonatomic, strong) YBLGoodsBannerView *goodBannerView;

@property (nonatomic, strong) YBLGoodsManageItemButton *itemButton;

@property (nonatomic, copy  ) PicDetailScrollPullBlock picDetailScrollPullBlock;

@property (nonatomic, weak  ) YBLOrderCommentsModel *commentModel;

@property (nonatomic, strong) NSMutableArray *imageURLsArray;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
             picTableViewType:(PicTableViewType)picTableViewType;

@end
