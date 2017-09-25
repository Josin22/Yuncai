//
//  YBLProfileWaveHeaderView.h
//  YC168
//
//  Created by 乔同新 on 2017/7/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWave.h"

@interface YBLProfileWaveHeaderView : UICollectionReusableView

@property (nonatomic, strong) JSWave   *waveView;

@property (nonatomic, strong) UIButton *setButton;

@property (nonatomic, strong) UIButton *bgButton;

@property (nonatomic, strong) UITapGestureRecognizer *userTap;

@property (nonatomic, strong) UIImageView *userImageView;

- (void)reloadHeaderData;

@end
