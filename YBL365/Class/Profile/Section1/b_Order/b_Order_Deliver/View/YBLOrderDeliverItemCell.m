//
//  YBLOrderDeliverItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDeliverItemCell.h"
#import "YBLDeliveritemModel.h"

static CGFloat const leftSpace = 30;

@interface YBLOrderDeliverItemCell ()

@property (nonatomic, retain) UILabel *deliverLabel;

@property (nonatomic, retain) UILabel *deliverTimeLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YBLOrderDeliverItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat cellHi = [YBLOrderDeliverItemCell getItemCellHeightWithModel:nil];
    
//    self.contentView.backgroundColor = randomColor;
    
    self.timeLine = [[YBLTimeLineItemView alloc] initWithFrame:CGRectMake(0, 0, leftSpace, cellHi)];
    [self.contentView addSubview:self.timeLine];
    
    self.deliverLabel  = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 0, YBLWindowWidth-leftSpace-space, 40)];
    self.deliverLabel.numberOfLines = 0;
    self.deliverLabel.font = YBLFont(14);
    self.deliverLabel.textColor = YBLTextColor;
    [self.contentView addSubview:self.deliverLabel];
    
    self.deliverTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.deliverLabel.left, self.deliverLabel.bottom, self.deliverLabel.width, 20)];
    self.deliverTimeLabel.textColor = YBLColor(191, 191, 191, 1);
    self.deliverTimeLabel.font = YBLFont(12);
    [self.contentView addSubview:self.deliverTimeLabel];
    
    UIView *lineView = [YBLMethodTools addLineView:CGRectMake(leftSpace, cellHi-.5, YBLWindowWidth-leftSpace, .5)];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)updateItemCellModel:(id)itemModel{

    YBLDeliveritemModel *model = (YBLDeliveritemModel *)itemModel;
    if ([model.text isMatch:RX(@"\\d{11}")]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:model.text];
        NSRange mobRange = [model.text rangeOfString:model.mobile];
        [attString addAttributes:@{NSFontAttributeName:YBLFont(14),
                                   NSForegroundColorAttributeName:YBLTextColor} range:NSMakeRange(0, model.text.length)];
        [attString addAttribute:NSForegroundColorAttributeName value:YBLColor(0, 115, 255, 1) range:mobRange];
        self.deliverLabel.attributedText = attString;
    } else {
        self.deliverLabel.text = model.text;
    }
    self.deliverTimeLabel.text = model.date_time;
    self.deliverLabel.height = self.height-self.deliverTimeLabel.height;
    self.deliverTimeLabel.bottom = self.height;
    self.timeLine.frame = CGRectMake(0, 0, leftSpace, self.height);
    self.lineView.bottom = self.height;
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    YBLDeliveritemModel *model = (YBLDeliveritemModel *)itemModel;
    CGSize textSize = [model.text heightWithFont:YBLFont(14) MaxWidth:YBLWindowWidth-leftSpace-space];
    return textSize.height+space+20;
}

@end
