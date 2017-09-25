//
//  YBLHomeModuleCell.h
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ModuleClickblock)(NSInteger index);

@interface YBLHomeModuleCell : UICollectionViewCell

@property (nonatomic, copy) ModuleClickblock moduleClickblock;

- (void)updateFloorsModuleArray:(NSMutableArray *)array;

+ (CGFloat)getModuleCellHeight:(NSInteger)count;

@end
