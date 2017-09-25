//
//  YBLSetLogisticsPricesCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSetLogisticsPricesCell.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLGetProductShippPricesModel.h"
#import "YBLAreaRadiusItemModel.h"


@interface YBLSetLogisticsPricesCell ()

@property (nonatomic, strong) UIButton *circleButton;

@end

@implementation YBLSetLogisticsPricesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    CGFloat cell_height = [YBLSetLogisticsPricesCell getItemCellHeightWithModel:nil];
    
    self.logisticsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth/2, 20)];
    self.logisticsTitleLabel.textColor = BlackTextColor;
    self.logisticsTitleLabel.centerY = cell_height/2;
    self.logisticsTitleLabel.font = YBLFont(15);
    self.logisticsTitleLabel.text = @"快递名字";
    [self.contentView addSubview:self.logisticsTitleLabel];
    
    self.addSubView = [[YBLAddSubtractView alloc] initWithFrame:CGRectMake(0, 0, 120, 30) integerOrFloatType:IntegerOrFloatTypeFloat];
    self.addSubView.centerY = cell_height/2;
    self.addSubView.right = YBLWindowWidth-space;
    self.addSubView.minFloat = 0.0;
    self.addSubView.maxFloat = HUGE_VALF;
    [self.contentView addSubview:self.addSubView];
    
    CGFloat circleButtonWi = 30;
    
    self.circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.circleButton.frame = CGRectMake(0, 0, circleButtonWi, circleButtonWi);
    self.circleButton.right = YBLWindowWidth-space;
    self.circleButton.centerY = cell_height/2;
    self.circleButton.userInteractionEnabled = NO;
    [self.circleButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [self.circleButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    self.circleButton.hidden = YES;
    [self.contentView addSubview:self.circleButton];

    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, cell_height-.5, YBLWindowWidth, .5)]];
}

- (void)updateItemCellModel:(id)itemModel{
    
    if ([itemModel isKindOfClass:[YBLExpressCompanyItemModel class]]) {
        YBLExpressCompanyItemModel *model = (YBLExpressCompanyItemModel *)itemModel;
        self.logisticsTitleLabel.text = model.title;
        self.addSubView.currentFloat = model.price.doubleValue;
    } else if ([itemModel isKindOfClass:[area_prices class]]) {
        area_prices *areaPriceModel = (area_prices *)itemModel;
        self.logisticsTitleLabel.text = areaPriceModel.area_text;
        self.addSubView.currentFloat = areaPriceModel.price.doubleValue;
    } else if ([itemModel isKindOfClass:[YBLAreaRadiusItemModel class]]){
        YBLAreaRadiusItemModel *areaRadiusModel = (YBLAreaRadiusItemModel *)itemModel;
        self.logisticsTitleLabel.text = [NSString stringWithFormat:@"%ld 公里配送半径内",(long)areaRadiusModel.radius.integerValue];
        self.addSubView.currentFloat = areaRadiusModel.price.doubleValue;
    }
}

- (void)setIsSelectRow:(BOOL)isSelectRow{
    _isSelectRow = isSelectRow;
    self.circleButton.hidden = NO;
    self.addSubView.hidden = YES;
    self.circleButton.selected = _isSelectRow;
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 50;
}

@end
