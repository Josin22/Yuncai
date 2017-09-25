//
//  YBLSeckillCell.h
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YBLSeckillCellGoSeckillBlock)(void);

@interface YBLSeckillCell : UITableViewCell

@property (nonatomic, copy) YBLSeckillCellGoSeckillBlock seckillCellGoSeckillBlock;

- (void)updateSeckillData:(NSInteger)test;

+ (CGFloat)getSeckillCellHeight;

@end
