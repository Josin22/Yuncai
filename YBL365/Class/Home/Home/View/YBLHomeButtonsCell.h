//
//  YBLHomeButtonsCell.h
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonsClickBlock)(NSInteger index);

@interface YBLHomeButtonsCell : UICollectionViewCell

@property (nonatomic, copy) buttonsClickBlock buttonsClickBlock;

+ (CGFloat)getButtonsCellHeight;

@end
