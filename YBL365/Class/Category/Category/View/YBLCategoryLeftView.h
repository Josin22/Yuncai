//
//  YBLCategoryLeftView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^cellClickBlock)(NSInteger index,NSString *_id);

@interface YBLCategoryLeftView : UITableView

@property (nonatomic, copy) cellClickBlock cellClickBlock;

@property (nonatomic, strong) NSMutableArray *leftDataArray;

- (void)updateWithIndex:(NSInteger )index;


@end
