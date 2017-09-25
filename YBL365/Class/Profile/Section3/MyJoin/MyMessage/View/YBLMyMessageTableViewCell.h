//
//  YBLMyMessageTableViewCell.h
//  YBL365
//
//  Created by 代恒彬 on 2017/1/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLTimeDown.h"
@interface YBLMyMessageTableViewCell : UITableViewCell
+(CGFloat)getMyMessageTableViewCellRowHeight;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *productNameLabel;
@property (nonatomic,strong)UILabel *focusLabel;
@property (nonatomic,strong)UILabel *noticelabel;
@property (nonatomic,strong)YBLTimeDown *leftTimeView;
@end
