//
//  YBLEditPurchaseTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLEditPurchaseCell,YBLGoodModel,YBLEditItemGoodParaModel;

typedef void(^EditPurchaseTableViewCellBlock)(YBLEditPurchaseCell *cell,YBLEditItemGoodParaModel *paraModel,NSIndexPath *indexPath);

typedef NS_ENUM(NSInteger,EditType) {
    EditTypePurchase = 0,
    EditTypeNormal
};

@interface YBLEditPurchaseTableView : UITableView

@property (nonatomic, copy) EditPurchaseTableViewCellBlock editPurchaseTableViewCellBlock;

@property (nonatomic, weak) NSMutableArray *cellDataArray;

- (void)updateCellDataArray:(NSMutableArray *)cellArray goodModel:(YBLGoodModel *)goodModel;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                     editType:(EditType)editType;

@end
