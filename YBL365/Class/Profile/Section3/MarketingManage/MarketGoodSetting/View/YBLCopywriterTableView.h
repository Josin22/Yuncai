//
//  YBLCopywriterTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBLCopywriterTableViewDelegate <NSObject>

- (void)copywriterCellDidSelectIndexPath:(NSIndexPath *)indexPath selectValue:(NSString *)selectValue;

- (void)copywriterCellButtonClickIndexPath:(NSIndexPath *)indexPath selectValue:(NSString *)selectValue;

@end

typedef NS_ENUM(NSInteger,CopywriterTableViewType) {
    /**
     *  编辑模式
     */
    CopywriterTableViewTypeEdit = 0,
    /**
     *  选择模式
     */
    CopywriterTableViewTypeChoose
};

@interface YBLCopywriterTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                tableViewType:(CopywriterTableViewType)tableViewType;

@property (nonatomic, weak ) id<YBLCopywriterTableViewDelegate> cp_delegate;

@end
