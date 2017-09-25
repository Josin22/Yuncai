//
//  YBLCopyWriterItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/6/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCopyWriterItemCell.h"

@interface YBLCopyWriterItemCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YBLCopyWriterItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSSUI];
    }
    return self;
}

- (void)createSSUI{

    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.cwTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, YBLWindowWidth-2*space, 40)];
    self.cwTextLabel.textColor = BlackTextColor;
    self.cwTextLabel.font = YBLFont(14);
    self.cwTextLabel.numberOfLines = 0;
    [self.contentView addSubview:self.cwTextLabel];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"address_edit"] forState:UIControlStateNormal];
    editButton.frame = CGRectMake(0, 0, 30, 30);
    editButton.right = YBLWindowWidth-space;
    [self.contentView addSubview:editButton];
    self.editButton = editButton;
    
    self.cwTextLabel.width = self.editButton.left-space;
    
    UIView *lineView = [YBLMethodTools addLineView:CGRectMake(space, 0, YBLWindowWidth-space, .5)];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)updateItemCellModel:(id)itemModel{
    NSString *valueString = (NSString *)itemModel;
    self.cwTextLabel.text = valueString;
    self.cwTextLabel.height = self.height-space*2;
    self.lineView.bottom = self.height;
    self.editButton.centerY = self.height/2;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    NSString *valueString = (NSString *)itemModel;
    CGSize valueSize = [valueString heightWithFont:YBLFont(14) MaxWidth:YBLWindowWidth-2*space-40];
    return valueSize.height+2*space;
}

@end
