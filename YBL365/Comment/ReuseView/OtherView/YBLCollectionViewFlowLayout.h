//
//  YBLCollectionViewFlowLayout.h
//  YBL365
//
//  Created by 乔同新 on 12/26/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic, assign) NSUInteger rowCount;

@property (nonatomic, strong) NSMutableArray *allAttributes;

@end
