//
//  YBLHomeSeckillCell.h
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YBLHomeSeckillClickBlock)(NSInteger index);

@interface YBLHomeSeckillCell : UICollectionViewCell
///秒杀商品
@property (nonatomic, copy ) YBLHomeSeckillClickBlock homeSeckillClickBlock;

+ (CGFloat)getSeckillCellHeight;

@end
