
//
//  YBLCreditsPayRecordsCell.m
//  YC168
//
//  Created by 乔同新 on 2017/5/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCreditsPayRecordsCell.h"
#import "YBLCreditsPayRecordsModel.h"

@interface YBLCreditsPayRecordsCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, retain) UILabel *serviceNameLabel;

@property (nonatomic, retain) UILabel *createAtTimeLabel;

@property (nonatomic, retain) UILabel *orderNumberLabel;

@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, retain) UILabel *payModelLabel;

@end

@implementation YBLCreditsPayRecordsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat cell_height = [YBLCreditsPayRecordsCell getItemCellHeightWithModel:nil];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, cell_height-2*space, cell_height-2*space)];
    [self.contentView addSubview:self.iconImageView];
    
    self.serviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right+space, self.iconImageView.top, YBLWindowWidth-2*space-self.iconImageView.right, self.iconImageView.height/3)];
    self.serviceNameLabel.textColor = BlackTextColor;
    self.serviceNameLabel.font = YBLFont(14);
    [self.contentView addSubview:self.serviceNameLabel];
    
    self.orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.serviceNameLabel.left, self.serviceNameLabel.bottom, self.serviceNameLabel.width, self.serviceNameLabel.height)];
    self.orderNumberLabel.textColor = YBLTextLightColor;
    self.orderNumberLabel.font = YBLFont(12);
    [self.contentView addSubview:self.orderNumberLabel];
    
    self.createAtTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.serviceNameLabel.left, self.orderNumberLabel.bottom, self.serviceNameLabel.width, self.serviceNameLabel.height)];
    self.createAtTimeLabel.textColor = YBLTextLightColor;
    self.createAtTimeLabel.font = YBLFont(12);
    [self.contentView addSubview:self.createAtTimeLabel];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.orderNumberLabel.top, 100, self.orderNumberLabel.height)];
    self.priceLabel.right = YBLWindowWidth-space;
    self.priceLabel.textColor = BlackTextColor;
    self.priceLabel.font = YBLFont(14);
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLabel];
    
    self.payModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.createAtTimeLabel.top, 100, self.createAtTimeLabel.height)];
    self.payModelLabel.font = YBLFont(12);
    self.payModelLabel.textColor = YBLTextLightColor;
    self.payModelLabel.textAlignment = NSTextAlignmentRight;
    self.payModelLabel.right = YBLWindowWidth-space;
    [self.contentView addSubview:self.payModelLabel];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(self.serviceNameLabel.left, cell_height-.5, YBLWindowWidth-self.serviceNameLabel.left, .5)]];
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLCreditsPayRecordsModel *model = (YBLCreditsPayRecordsModel *)itemModel;
    [self.iconImageView js_alpha_setImageWithURL:[NSURL URLWithString:model.userinfo.head_img] placeholderImage:smallImagePlaceholder];
    self.serviceNameLabel.text = model.title;

    if (model.pay_mode.integerValue == 1) {
        self.payModelLabel.text = @"支付宝支付";
    } else {
        self.payModelLabel.text = @"微信支付";
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",model.price.doubleValue];
    
//    NSString *begainString = [NSString stringWithFormat:@"于%@开通",model.userinfo.credit_begin_date];
    NSString *begainString = [NSString stringWithFormat:@"%@",model.number];
    self.orderNumberLabel.text = begainString;
    CGSize begainSize = [begainString heightWithFont:YBLFont(13) MaxWidth:YBLWindowWidth];
    self.orderNumberLabel.width = begainSize.width;
    
//    NSString *endString = [NSString stringWithFormat:@"截止%@到期",model.userinfo.credit_end_date];;
    NSString *endString = model.paid_at;
    self.createAtTimeLabel.text = endString;
    CGSize endSize = [endString heightWithFont:YBLFont(13) MaxWidth:YBLWindowWidth];
    self.createAtTimeLabel.width = endSize.width;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 100;
}

@end
