//
//  YBLFoundSegmentSPECView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FoundSegmentSPECViewSureBlock)(NSArray *value);

@interface YBLFoundSegmentSPECView : UIView

@property (nonatomic, copy) FoundSegmentSPECViewSureBlock foundSegmentSPECViewSureBlock;

- (void)updateSPECArray1:(NSMutableArray *)array1 array2:(NSMutableArray *)array2;

@end
