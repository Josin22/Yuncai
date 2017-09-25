//
//  YBLStoreBaseInfoCell.h
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLStoreBaseInfoCell : UITableViewCell

@property (nonatomic, strong) UIButton *bgStoreButton;

@property (nonatomic, strong) UIButton *inStoreButton;

@property (nonatomic, strong) UIImageView *storeImageView;

@property (nonatomic, strong) UIImageView *creditStoreImageView;

@property (nonatomic, retain) UILabel *storeTitleLabel;

@property (nonatomic, retain) UILabel *foucsEvaluteLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *bgView;

@end
