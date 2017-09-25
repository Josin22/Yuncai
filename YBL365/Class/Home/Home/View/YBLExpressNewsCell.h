//
//  YBLExpressNewsCell.h
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLPushPurchaseInfoModel.h"

typedef void(^ExpressNewsCellScrollClickBlock)(YBLPushPurchaseInfoModel *infoModel);

@interface YBLExpressNewsCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ExpressNewsCellScrollClickBlock expressNewsCellScrollClickBlock;

+ (CGFloat)getButtonsCellHeight;

@end
