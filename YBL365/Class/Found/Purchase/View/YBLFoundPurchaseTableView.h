//
//  YBLFoundPurchaseTableView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FoundPurchaseTableViewCellSelectBlock)(void);

@interface YBLFoundPurchaseTableView : UITableView

@property (nonatomic, copy) FoundPurchaseTableViewCellSelectBlock foundPurchaseTableViewCellSelectBlock;

@end
