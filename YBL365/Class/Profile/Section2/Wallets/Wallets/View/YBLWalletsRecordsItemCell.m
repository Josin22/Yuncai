//
//  YBLWalletsRecordsItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWalletsRecordsItemCell.h"
#import "YBLWalletsRecordModel.h"

@interface YBLWalletsRecordsItemCell ()

@property (nonatomic, retain) UILabel *topLabel;

@property (nonatomic, retain) UILabel *bottomLabel;

@property (nonatomic, retain) UILabel *recordsLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YBLWalletsRecordsItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat recordsWi = 80;
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, YBLWindowWidth-2*space-recordsWi, 30)];
    self.topLabel.textColor = BlackTextColor;
    self.topLabel.text = loadString;
    self.topLabel.font = YBLFont(15);
    self.topLabel.numberOfLines = 0;
    [self.contentView addSubview:self.topLabel];
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.topLabel.left, self.topLabel.bottom, self.topLabel.width, 20)];
    self.bottomLabel.textColor = YBLTextColor;
    self.bottomLabel.text = loadString;
    self.bottomLabel.font = YBLFont(12);
    [self.contentView addSubview:self.bottomLabel];
    
    self.recordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(YBLWindowWidth-space-recordsWi, 0, recordsWi, 30)];
    self.recordsLabel.font = YBLBFont(26);
    self.recordsLabel.textColor = BlackTextColor;
    self.recordsLabel.textAlignment = NSTextAlignmentRight;
//    self.recordsLabel.centerY = hi/2;
    self.recordsLabel.text = loadString;
    [self.contentView addSubview:self.recordsLabel];
    
    UIView *lineView = [YBLMethodTools addLineView:CGRectMake(space, 0, YBLWindowWidth, .5)];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLWalletflowsItemModel *model = (YBLWalletflowsItemModel *)itemModel;
    self.topLabel.text = model.desc;
    self.bottomLabel.text = model.created_at;
    NSString *valueText = [NSString stringWithFormat:@"%@%.2f",model.signlText,model.amount.doubleValue];
    self.recordsLabel.textColor = model.textColor;
    self.recordsLabel.text = valueText;
    self.recordsLabel.centerY = self.height/2;
    
    self.recordsLabel.width = YBLWindowWidth/2;
    self.recordsLabel.right = YBLWindowWidth-space;

    self.topLabel.width = model.text_max_width;
    self.topLabel.height  = model.text_height;
    self.bottomLabel.bottom = self.height-space/2;
    
    self.lineView.bottom = self.height-.5;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    YBLWalletflowsItemModel *model = (YBLWalletflowsItemModel *)itemModel;
    
    return model.text_height+space*1.5+30;
}

@end
