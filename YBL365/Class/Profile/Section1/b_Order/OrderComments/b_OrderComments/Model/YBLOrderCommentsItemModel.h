//
//  YBLOrderCommentsModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLOrderCommentsModel : NSObject

@property (nonatomic, copy  ) NSString *credit;
@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, copy  ) NSString *product_id;
@property (nonatomic, copy  ) NSString *user_name;
@property (nonatomic, copy  ) NSString *k_user_name;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *anonymity;
@property (nonatomic, copy  ) NSString *created_at;
@property (nonatomic, copy  ) NSString *buy_at;
@property (nonatomic, copy  ) NSString *specification;
@property (nonatomic, copy  ) NSString *head_img;
@property (nonatomic, copy  ) NSString *content;
/**
 *  文本高度
 */
@property (nonatomic, strong) NSNumber *content_height;
/**
 *  九宫格高
 */
@property (nonatomic, strong) NSNumber *gridView_height;
/**
 *  item 间距
 */
@property (nonatomic, strong) NSNumber *gridView_item_space;
/**
 *  item 宽
 */
@property (nonatomic, strong) NSNumber *gridView_item_width;

@property (nonatomic, copy  ) NSString *cell_name;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@interface YBLOrderCommentsItemModel : NSObject

@property (nonatomic, copy  ) NSString *line_item_id;
@property (nonatomic, copy  ) NSString *product_id;
@property (nonatomic, copy  ) NSString *product_thumb;
@property (nonatomic, copy  ) NSString *product_title;
@property (nonatomic, strong) YBLOrderCommentsModel *comment;

@end
