//
//  YBLModuleTitleView.h
//  YBL365
//
//  Created by 乔同新 on 12/21/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLModuleTitleView : UICollectionReusableView

@property (nonatomic, strong) UIButton *moduleTitleButton;

- (void)updateModuleTitleImageValue:(id )value;

+ (CGFloat)getModuleHeight;

@end
