//
//  YBLGoodsHotListCell.h
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLHotCollectionView.h"

typedef NS_ENUM(NSInteger, hotType) {
    hotTypeNormal = 0,
    hotTypeCaiGou
};

@interface YBLGoodsHotListCell : UITableViewCell

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, assign) hotType type;

@property (nonatomic, strong) YBLHotCollectionView *hotListCollectionView;

+ (CGFloat)getGoodsHotListCellHeight;

@end
