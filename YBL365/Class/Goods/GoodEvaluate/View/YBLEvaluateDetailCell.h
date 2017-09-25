//
//  YBLEvaluateDetailCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EvaluateDetailPicClickBlock)(NSInteger index);

@interface YBLEvaluateDetailCell : UITableViewCell

+ (YBLEvaluateDetailCell *)cellReusableWithTabelView:(UITableView *)tableView
                                      rowAtIndexPath:(NSIndexPath *)indexPath
                                        gridViewType:(GridViewType)gridViewType;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                 gridViewType:(GridViewType)gridViewType;

@property (nonatomic, copy  ) EvaluateDetailPicClickBlock evaluateDetailPicClickBlock;

@end
