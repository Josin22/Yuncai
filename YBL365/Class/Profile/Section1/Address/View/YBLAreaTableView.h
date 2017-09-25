//
//  YBLAreaTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLAddressAreaModel;

typedef void(^AreaTableViewCellDidSelectBlock)(YBLAddressAreaModel *areaModel);

@interface YBLAreaTableView : UITableView

@property (nonatomic, copy) AreaTableViewCellDidSelectBlock areaTableViewCellDidSelectBlock;

@end
