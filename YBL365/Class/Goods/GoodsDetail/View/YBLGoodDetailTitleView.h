//
//  YBLGoodDetailTitleView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLTextSegmentControl.h"

@interface YBLGoodDetailTitleView : UIView

@property (nonatomic, strong) YBLTextSegmentControl *goodsDetailSegment;

@property (nonatomic, retain) UILabel *picDetailLabel;

- (void)sliderTop;

- (void)sliderBottom;

@end
