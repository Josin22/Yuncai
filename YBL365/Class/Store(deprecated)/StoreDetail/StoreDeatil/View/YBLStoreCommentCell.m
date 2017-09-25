//
//  YBLStoreCommentCell.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreCommentCell.h"

@interface YBLStoreCommentCell ()
@property (nonatomic, strong) UILabel * commentLab;
@property (nonatomic, strong) UILabel * serviceLab;
@property (nonatomic, strong) UILabel * sendLab;
@end

@implementation YBLStoreCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createrUI];
    }
    return self;
}

- (void)createrUI {
    NSArray * titleArr = @[@"商品评价",@"服务态度",@"物流速度", ];
    for (int i = 0; i<titleArr.count; i++) {
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(8, 10+25*i, 90, 20)];
        titleLab.text = titleArr[i];
        titleLab.font = YBLFont(16);
        titleLab.textColor = BlackTextColor;
        [self.contentView addSubview:titleLab];
        
    }
    
    _commentLab = [[UILabel alloc]initWithFrame:CGRectMake(105, 10, YBLWindowWidth-115, 20)];
    _commentLab.text = @"9.58分   高于同行7.9%";
    _commentLab.font = YBLFont(14);
    _commentLab.textColor = YBLThemeColor;
    [self.contentView addSubview:_commentLab];
    
    _serviceLab = [[UILabel alloc]initWithFrame:CGRectMake(105, 10+25, YBLWindowWidth-115, 20)];
    _serviceLab.text = @"9.58分   低于同行7.9%";
    _serviceLab.font = YBLFont(14);
    _serviceLab.textColor = [UIColor greenColor];
    [self.contentView addSubview:_serviceLab];
    _sendLab = [[UILabel alloc]initWithFrame:CGRectMake(105, 10+50, YBLWindowWidth-115, 20)];
    _sendLab.text = @"9.58分   高于同行7.9%";
    _sendLab.font = YBLFont(14);
    _sendLab.textColor = YBLThemeColor;
    [self.contentView addSubview:_sendLab];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
