//
//  YBLCompanyTypePricesHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCompanyTypePricesHeaderView.h"
#import "TextImageButton.h"
#import "YBLCompanyTypePricesParaModel.h"


static NSInteger const tag_text_button = 111;

@interface YBLCompanyTypePricesHeaderView ()
{
    
}

@property (nonatomic, strong) UIButton *directionButton;

@end

@implementation YBLCompanyTypePricesHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat height = [YBLCompanyTypePricesHeaderView getHeaderHi];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth/2, 45)];
    titleLabel.font = YBLFont(16);
    titleLabel.textColor = BlackTextColor;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    self.priceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.priceSwitch.onTintColor = YBLThemeColor;
    self.priceSwitch.right = YBLWindowWidth-space;
    self.priceSwitch.centerY = titleLabel.centerY;
    [self.contentView addSubview:self.priceSwitch];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(space, titleLabel.bottom-.5, YBLWindowWidth-space, .5)]];
    
    CGFloat image_button_wi = 30;
    CGFloat lessBottom = height-titleLabel.bottom;
    NSInteger count = 3;
    
    CGFloat text_button_wi = (YBLWindowWidth-space*2-image_button_wi)/count;
    
    for (int i = 0; i < count; i++) {
        
        CGRect newFrame = CGRectMake(i*text_button_wi, titleLabel.bottom, text_button_wi, lessBottom);
        
        TextImageButton *textButton = [[TextImageButton alloc] initWithFrame:newFrame Type:TypeText];
        textButton.topLabel.font = YBLFont(15);
        textButton.bottomLabel.font = YBLFont(12);
//        textButton.bottomLabel.top -= 1;
        textButton.tag = tag_text_button+i;
        textButton.normalColor = YBLTextColor;
        [self.contentView addSubview:textButton];
    }
    
    self.directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.directionButton.frame = CGRectMake(0, titleLabel.bottom, lessBottom, lessBottom);
    self.directionButton.right = YBLWindowWidth-space;
    [self.directionButton setImage:[UIImage imageNamed:@"jshop_category_arrow_down"] forState:UIControlStateNormal];
    [self.directionButton setImage:[UIImage imageNamed:@"jshop_category_arrow_up"] forState:UIControlStateSelected];
    [self.directionButton addTarget:self action:@selector(showLessPriceRow:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.directionButton];
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(0, height-.5, YBLWindowWidth, .5)]];
}

- (void)updatePriceArray:(id)priceArray{
    
    YBLCompanyTypePricesParaModel *model = (YBLCompanyTypePricesParaModel *)priceArray;
    self.directionButton.selected = model.isNotShowRow;
    self.priceSwitch.on = model.active.boolValue;
    NSInteger index = 0;
//    NSInteger lastPrice = 1;
    for (PricesItemModel *priceModel in model.prices) {
        TextImageButton *textButton = (TextImageButton *)[self viewWithTag:tag_text_button+index];
        textButton.topLabel.text = [NSString stringWithFormat:@"¥ %.2f",priceModel.sale_price.doubleValue];
        textButton.bottomLabel.text = [NSString stringWithFormat:@"%ld%@起批",(long)priceModel.min.integerValue,model.unit];
        textButton.selected = priceModel.active.boolValue;
//        lastPrice = priceModel.min.integerValue+1;
        index++;
    }
    
}

+ (CGFloat)getHeaderHi{
    
    return 85;
}

- (void)showLessPriceRow:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    BLOCK_EXEC(self.companyTypePricesHeaderViewDirectionButtonBlock,btn.selected)
}

@end
