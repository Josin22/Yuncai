//
//  YBLEvaluatePicCollection.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EvaluatePicCollectionDidSelectBlock)(NSInteger index,UIImageView *currentImageView);

@interface YBLEvaluatePicCollection : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) EvaluatePicCollectionDidSelectBlock evaluatePicCollectionDidSelectBlock;

@end
