//
//  YBLListItemBaseModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLListCellItemModel : NSObject

@property (nonatomic, copy  ) NSString *identifyOfRowItemCell;

@property (nonatomic) id valueOfRowItemCellData;

@property (nonatomic) id orginValueOfRowItemCellData;

@end

/**
 *  section of list model
 */
@interface YBLListBaseModel : NSObject

@property (nonatomic, strong) NSMutableArray<YBLListCellItemModel *> *identifyOfSectionCellItemArray;

@property (nonatomic) id valueOfSectionItemCellViewData;

@property (nonatomic, copy  ) NSString *identifyOfSectionItemHeaderView;

@property (nonatomic) id valueOfSectionItemHeaderViewData;

@property (nonatomic, copy  ) NSString *identifyOfSectionItemFooterView;

@property (nonatomic) id valueOfSectionItemFooterViewData;

@end
