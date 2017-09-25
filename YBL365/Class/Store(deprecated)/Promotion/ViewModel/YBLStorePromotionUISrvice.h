//
//  YBLStorePromotionUISrvice.h
//  YBL365
//
//  Created by 陶 on 2016/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^scrollYBlock)(CGFloat alpha,
                            UIScrollView * scrollView);

@interface YBLStorePromotionUISrvice : NSObject<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, copy) scrollYBlock scrollYBlock;

@end
