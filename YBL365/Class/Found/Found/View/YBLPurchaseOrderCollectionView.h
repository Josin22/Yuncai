//
//  YBLPurchaseOrderCollectionView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLPayResultViewController,YBLPurchaseOrderModel;

typedef NS_ENUM(NSInteger,MMType) {
    MMTypeNoneHeader = 0,//无header
    MMTypeHeaderMM,     //youheader
};

typedef void(^OrderMMCollectionViewRowSelectblock)(YBLPurchaseOrderModel *model);

typedef void(^OrderMMCollectionViewScrollBlock)(UIScrollView *scrollView);

@interface YBLPurchaseOrderCollectionView : UICollectionView

@property (nonatomic, weak) YBLPayResultViewController *VC;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) OrderMMCollectionViewRowSelectblock orderMMCollectionViewRowSelectblock;

@property (nonatomic, copy) OrderMMCollectionViewScrollBlock orderMMCollectionViewScrollBlock;

@property (nonatomic, copy) ViewPrestrainBlock viewPrestrainBlock;


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout MMType:(MMType)type;

@end
