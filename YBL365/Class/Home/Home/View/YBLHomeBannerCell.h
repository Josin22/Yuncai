//
//  YBLHomeBannerCell.h
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLOrderBarrageView.h"

@class YBLHomeViewController;

@interface YBLHomeBannerCell : UICollectionViewCell

@property (nonatomic, strong) YBLOrderBarrageView *barrageView;

@property (nonatomic, weak) YBLHomeViewController *homeVC;

@end
