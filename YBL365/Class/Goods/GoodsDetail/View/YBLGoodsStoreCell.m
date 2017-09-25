//
//  YBLGoodsStoreCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsStoreCell.h"
#import "shop.h"

static NSInteger label_value_tag = 400;

static NSInteger label_count_tag = 500;

static NSInteger label_title_tag = 600;

@interface YBLGoodsStoreCell ()
{
//    NSMutableArray *valueArray;
//    NSMutableArray *countArray;
    NSMutableArray *titleArray;
}

@property (nonatomic, retain) UILabel *storeInfoLabel;

@property (nonatomic, retain) UILabel *storeValueLabel;

@property (nonatomic, retain) UILabel *zongLabel;

@end

@implementation YBLGoodsStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createStoreUI];
    }
    return self;
}

- (void)createStoreUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    valueArray = [NSMutableArray array];
//    [valueArray addObject:@"商品 9.9"];
//    [valueArray addObject:@"物流 9.9"];
//    [valueArray addObject:@"服务 9.9"];
//    
//    countArray = [NSMutableArray array];
//    [countArray addObject:@"2.8万"];
//    [countArray addObject:@"129"];
//    [countArray addObject:@"31"];
    
    titleArray = [NSMutableArray array];
    [titleArray addObject:@"关注人数"];
    [titleArray addObject:@"全部商品"];
    [titleArray addObject:@"店铺动态"];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
    _storeImageView.backgroundColor = YBLColor(240, 240, 240, 1);
    _storeImageView.image = [UIImage imageNamed:middleImagePlaceholder];
    _storeImageView.layer.borderWidth = 1;
    _storeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.contentView addSubview:_storeImageView];
    
    _storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_storeImageView.frame)+5, _storeImageView.top,YBLWindowWidth-15-40-CGRectGetMaxX(_storeImageView.frame), 15)];
    _storeNameLabel.text = @"云采旗舰店";
    _storeNameLabel.font = YBLFont(14);
    _storeNameLabel.textColor = YBLColor(40, 40, 40, 1);
    [self.contentView addSubview:_storeNameLabel];
    
    UILabel *zongLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    zongLabel.centerY = _storeImageView.centerY;
    zongLabel.right = YBLWindowWidth-space;
    zongLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:zongLabel];
    self.zongLabel = zongLabel;
    
  /*
    for (int i = 0; i < 5; i++) {
        UIButton *xingjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xingjiButton setImage:[UIImage imageNamed:@"store_xinji_normal"] forState:UIControlStateNormal];
        [xingjiButton setImage:[UIImage imageNamed:@"store_xinji_select"] forState:UIControlStateSelected];
        xingjiButton.frame = CGRectMake(_storeNameLabel.left+i*14, _storeNameLabel.bottom+1, 12, 12);
        xingjiButton.selected = YES;
        [self addSubview:xingjiButton];
    }
   */
    
//    _storeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_storeNameLabel.frame), CGRectGetMaxY(_storeNameLabel.frame), _storeNameLabel.width, 15)];
//    _storeInfoLabel.font = YBLFont(11);
//    _storeInfoLabel.textColor = YBLTextColor;
//    _storeInfoLabel.text = @"钻石服务认证商家![云采配送 货到付款]";
//    [self addSubview:_storeInfoLabel];
    
    
    
    CGFloat wi = YBLWindowWidth/3;
    
    for (int i = 0; i < 3; i++) {
      
//        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*wi, CGRectGetMaxY(_storeImageView.frame)+10, wi, 15)];
//        valueLabel.tag = label_value_tag+i;
//        valueLabel.text = valueArray[i];
//        valueLabel.font = YBLFont(12);
//        valueLabel.textAlignment = NSTextAlignmentCenter;
//        valueLabel.textColor = YBLTextColor;
//        [self addSubview:valueLabel];
//       
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*wi, CGRectGetMaxY(_storeImageView.frame)+5, wi, 20)];
        countLabel.tag = label_count_tag+i;
        countLabel.font = YBLFont(17);
        countLabel.textColor = YBLColor(40, 40, 40, 1);
        countLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:countLabel];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*wi, CGRectGetMaxY(countLabel.frame)+5, wi, 15)];
        titleLabel.tag = label_title_tag+i;
        titleLabel.text = titleArray[i];
        titleLabel.font = YBLFont(11);
        titleLabel.textColor = YBLTextColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
    }
    
    CGFloat buttonWi = (YBLWindowWidth-30)/2;
    
    YBLButton *callButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    callButton.frame = CGRectMake(10, 90, buttonWi, 30);
    callButton.layer.borderColor = YBLTextLightColor.CGColor;
    callButton.layer.borderWidth = 0.5;
    callButton.layer.cornerRadius = 3;
    callButton.layer.masksToBounds = YES;
    callButton.titleLabel.font = YBLFont(14);
    [callButton setTitle:@"联系电话" forState:UIControlStateNormal];
    [callButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [callButton setImage:[UIImage imageNamed:@"goods_phonecall"] forState:UIControlStateNormal];
    callButton.imageRect = CGRectMake(buttonWi/2-35, 7.5, 15, 15);
    callButton.titleRect = CGRectMake(buttonWi/2-18, 0, buttonWi/2+30, 30);
    [self.contentView addSubview:callButton];
    self.callButton = callButton;
    
    YBLButton *goStoreButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    goStoreButton.frame = CGRectMake(CGRectGetMaxX(callButton.frame)+10, CGRectGetMinY(callButton.frame), buttonWi, 30);
    goStoreButton.layer.borderColor = YBLTextLightColor.CGColor;
    goStoreButton.layer.borderWidth = 0.5;
    goStoreButton.titleLabel.font = YBLFont(14);
    goStoreButton.layer.cornerRadius = 3;
    goStoreButton.layer.masksToBounds = YES;
    [goStoreButton setTitle:@"进入店铺" forState:UIControlStateNormal];
    [goStoreButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [goStoreButton setImage:[UIImage imageNamed:@"goods_store"] forState:UIControlStateNormal];
    goStoreButton.imageRect = CGRectMake(buttonWi/2-35, 7.5, 15, 15);
    goStoreButton.titleRect = CGRectMake(buttonWi/2-18, 0, buttonWi/2+30, 30);
    [self.contentView addSubview:goStoreButton];
    self.goStoreButton = goStoreButton;
}

- (void)updateItemCellModel:(id)itemModel{
    
    shop *shom = (shop *)itemModel;
    
    NSString *followCount = [NSString stringWithFormat:@"%ld",shom.followers_count.integerValue];
    NSString *countString = [NSString stringWithFormat:@"%@",shom.pdcount];
    NSInteger index = 0;
    for (NSString *value in @[followCount,countString,countString]) {
        UILabel *counLabel = (UILabel *)[self viewWithTag:label_count_tag+index];
        counLabel.text = value;
        index++;
    }
    self.storeNameLabel.text = shom.shopname;
    [self.storeImageView js_alpha_setImageWithURL:[NSURL URLWithString:shom.logo_url] placeholderImage:smallImagePlaceholder];
    NSString *zongString = [NSString stringWithFormat:@"综合 %.1f",shom.comment_rate.doubleValue];
    NSRange dianRange = [zongString rangeOfString:@" "];
    NSMutableAttributedString *zongAtt = [[NSMutableAttributedString alloc] initWithString:zongString];
    [zongAtt addAttributes:@{NSFontAttributeName:YBLFont(12),
                             NSForegroundColorAttributeName:YBLTextLightColor} range:NSMakeRange(0, dianRange.location)];
    [zongAtt addAttributes:@{NSFontAttributeName:YBLFont(13),
                             NSForegroundColorAttributeName:YBLThemeColor} range:NSMakeRange(dianRange.location, zongString.length-dianRange.location)];
    self.zongLabel.attributedText = zongAtt;
}

- (CGFloat)getHi{
    
    return self.callButton.bottom+space;
}

+ (CGFloat)getGoodsStoreCellHeight{
    
    return [[YBLGoodsStoreCell new] getHi];
}

@end
