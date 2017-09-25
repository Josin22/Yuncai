//
//  YBLFootePrintsCollectionView.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLGoodModel;

typedef void(^PrintsCollectionViewScollToIndexBlock)(NSInteger index);

typedef void(^PrintsCollectionViewDidSelectItemBlock)(YBLGoodModel *selectModel,NSIndexPath *indexps);

#define ItemHeight  ItemWidth+70
#define ItemWidth   (YBLWindowWidth-4*space)/2

@interface YBLFootePrintsCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy  ) PrintsCollectionViewScollToIndexBlock footerPrintsScollToIndexBlock;;

@property (nonatomic, copy  ) PrintsCollectionViewDidSelectItemBlock didSelectItemBlock;

- (void)checkNull;

@end
