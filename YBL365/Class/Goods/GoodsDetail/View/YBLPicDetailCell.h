//
//  YBLPicDetailCell.h
//  YC168
//
//  Created by 乔同新 on 2017/5/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PICModel : NSObject

@property (nonatomic, copy  ) NSString *cellIdentifier;

@property (nonatomic, strong) NSNumber *cell_height;

@property (nonatomic, strong) NSString *image_url;

@end

typedef void(^PicDetailHeightBlock)(CGFloat height);

@interface YBLPicDetailCell : UITableViewCell

@property (nonatomic, copy  ) PicDetailHeightBlock picDetailHeightBlock;

@property (nonatomic, strong) UIImageView *goodDetailImageView;

@end
