//
//  YBLMyBrowsingHistoryTableViewCell.h
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLMyBrowsingHistoryTableViewCell : UITableViewCell
/**
 是否是编辑模式
 */
@property (nonatomic, assign) BOOL isEditting;

/**
 cell是否是选中状态
 */
@property (nonatomic, assign) BOOL isSelected;

+(CGFloat)getMyBrowsingHistoryCellHeight;
@end
