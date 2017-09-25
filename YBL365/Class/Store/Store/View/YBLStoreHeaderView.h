//
//  YBLStoreHeaderView.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLScaleTextSegmentView.h"

@interface YBLFoucsAnimationView : UIView

@property (nonatomic, retain) UILabel *foucsNummberLabel;

@property (nonatomic, strong) YBLButton *fousButton;

@property (nonatomic, assign) NSInteger changevalue;

- (void)showFoucsAnimationWithValue:(float)value;

@end;

@interface YBLStoreHeaderView : UIView

@property (nonatomic, strong) YBLFoucsAnimationView *foucsAnimationView;

@property (nonatomic, strong) YBLScaleTextSegmentView *scaleTextSegment;

@property (nonatomic, strong) YBLButton *storeNameButton;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *signalLabel;

@property (nonatomic, strong) UIImageView *storeImageView;

@property (nonatomic, strong) UIImageView *creaditStoreImageView;

@end
