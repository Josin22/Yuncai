//
//  YBLEvaluateBaseCell.h
//  YC168
//
//  Created by 乔同新 on 2017/6/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLGridView.h"
#import "YBLOrderCommentsItemModel.h"


@class YBLEvaluatePicCollection;

@interface YBLEvaluateBaseCell : UITableViewCell

@property (nonatomic, retain) UILabel *contentLabel;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *timeEvaluateLabel;

@property (nonatomic, retain) UILabel *specLabel;

@property (nonatomic, retain) UILabel *buyTimeLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) YBLGridView *gridView;

@property (nonatomic, strong) YBLEvaluatePicCollection *imageCollectionView;;

+(instancetype)initWithModel:(YBLOrderCommentsModel *)model;

@end
