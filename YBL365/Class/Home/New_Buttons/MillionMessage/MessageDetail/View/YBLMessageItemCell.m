
//
//  YBLMessageItemCell.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMessageItemCell.h"
#import "YBLCustomersLogsModel.h"
#import "YBLCustomersLabel.h"
#import "YBLTriangleLabelView.h"

@interface YBLMessageItemCell ()

@property (nonatomic, retain) YBLCustomersLabel *iconLabel;

@property (nonatomic, strong) YBLTriangleLabelView *trangleLabel;

@end

@implementation YBLMessageItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    self.contentView.backgroundColor = YBLColor(237, 237, 237, 1);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconLabel = [[YBLCustomersLabel alloc] initWithFrame:CGRectMake(space, space, 50, 50)];
    [self.contentView addSubview:self.iconLabel];
    
    self.trangleLabel = [[YBLTriangleLabelView alloc] initWithFrame:CGRectMake(self.iconLabel.right, self.iconLabel.top, YBLWindowWidth-self.iconLabel.right-space, 20)];
    [self.contentView addSubview:self.trangleLabel];
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLCustomersLogsModel *logsModel = (YBLCustomersLogsModel *)itemModel;
    self.iconLabel.text = logsModel.first_name;
    self.iconLabel.backgroundColor = logsModel.name_bg_color;
    self.trangleLabel.fin_height = logsModel.content_height;
    self.trangleLabel.contentLabel.text = logsModel.content;
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    YBLCustomersLogsModel *logsModel = (YBLCustomersLogsModel *)itemModel;
    return logsModel.content_height+space*2;
}

@end
