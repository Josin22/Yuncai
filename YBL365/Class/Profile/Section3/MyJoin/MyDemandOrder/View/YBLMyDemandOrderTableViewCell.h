//
//  YBLMyDemandOrderTableViewCell.h
//  YBL365
//
//  Created by 代恒彬 on 2017/1/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLTimeDown.h"
@interface YBLMyDemandOrderTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *productnameLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)YBLTimeDown *remainingTime;
@property (nonatomic,strong)UILabel *remainPricelabel;
@property (nonatomic,strong)UILabel *lowPriceLabel;
@property (nonatomic,strong)UIButton *payButton;
@property (nonatomic,strong)UILabel *numberOfParticipateLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
+(CGFloat)getMyDemandOrderCellHeight;
@end
