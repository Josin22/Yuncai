//
//  YBLReferenceTableView.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLReferenceTableView.h"
#import "YBLReferenceItemLineCollectionView.h"

#pragma mark  YBLSwitchButton

@interface  YBLSwitchButton: UIButton

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, retain) UILabel *leftLabel;

@property (nonatomic, retain) UILabel *rightLabel;

@property (nonatomic, strong) UIColor *tinColor;

@end


@implementation YBLSwitchButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.clipsToBounds = YES;
    
    _tinColor = YBLThemeColor;
    
    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = YBLColor(190, 190, 190, 1);
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width/2, self.height)];
    _maskView.backgroundColor = _tinColor;
    _maskView.layer.cornerRadius = self.height/2;
    _maskView.layer.masksToBounds = YES;
    _maskView.userInteractionEnabled = NO;
    [self addSubview:_maskView];
    
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width/2, self.height)];
    _leftLabel.text = @"月";
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    _leftLabel.textColor = [UIColor whiteColor];
    _leftLabel.adjustsFontSizeToFitWidth = YES;
    _leftLabel.font = YBLFont(13);
    [self addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftLabel.right, _leftLabel.top, _leftLabel.width, _leftLabel.height)];
    _rightLabel.text = @"周";
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.textColor = [UIColor whiteColor];
    _rightLabel.adjustsFontSizeToFitWidth = YES;
    _rightLabel.font = YBLFont(13);
    [self addSubview:_rightLabel];
    
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    CGFloat cenX = selected == YES?self.width*3/4:self.width/4;
    
    [UIView animateWithDuration:.3f
                          delay:0
         usingSpringWithDamping:.6
          initialSpringVelocity:.3
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.maskView.centerX = cenX;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


@end

#pragma mark  ReferenceHeaderView

@interface ReferenceHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *bgImageView;

+ (CGFloat)getHeaderHi;

@end

@implementation ReferenceHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    CGFloat wi = 750;
    CGFloat hi = 464;
    
    UIImage *image = [UIImage imageWithOriginal:@"reference_header_image"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    bgImageView.frame = CGRectMake(0, 0, YBLWindowWidth, (double)hi/wi*YBLWindowWidth);
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    /*指导价*/
    CGFloat zhidaojiaHi = (double)95/hi*self.bgImageView.height;
    UILabel *zhidaojiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bgImageView.width, zhidaojiaHi-15)];
    zhidaojiaLabel.text = @"¥65.23";
    zhidaojiaLabel.textColor = YBLThemeColor;
    zhidaojiaLabel.font = YBLFont(25);
    zhidaojiaLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:zhidaojiaLabel];
    UILabel *zhidaojiaLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, zhidaojiaLabel.bottom, self.bgImageView.width, 15)];
    zhidaojiaLabel1.text = @"厂家指导价";
    zhidaojiaLabel1.textColor = YBLTextColor;
    zhidaojiaLabel1.font = YBLFont(14);
    zhidaojiaLabel1.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:zhidaojiaLabel1];
    
    /*百分比*/
    CGFloat leftPPWi = (double)260/wi * self.bgImageView.width;
    CGFloat leftPPHi = (double)176/hi * self.bgImageView.height;
    UILabel *leftPPLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, leftPPHi-30, leftPPWi, 30)];
    leftPPLabel.text = @"65%";
    leftPPLabel.textColor = YBLColor(253, 104, 0, 1);
    leftPPLabel.font = YBLFont(25);
    leftPPLabel.textAlignment = NSTextAlignmentRight;
    [self.bgImageView addSubview:leftPPLabel];
    
    CGFloat rightPPleft = self.bgImageView.width-leftPPWi;
    UILabel *rightPPLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightPPleft, leftPPLabel.top, leftPPWi, 30)];
    rightPPLabel.text = @"75%";
    rightPPLabel.textColor = YBLColor(253, 104, 0, 1);
    rightPPLabel.font = YBLFont(25);
    rightPPLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgImageView addSubview:rightPPLabel];
    
    /* 市场价 */
    CGFloat left_shichangjia_Top = (double)257/hi * self.bgImageView.height;
    UILabel *left_shichangjia_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, left_shichangjia_Top, leftPPWi, 30)];
    left_shichangjia_Label.text = @"¥165.23";
    left_shichangjia_Label.textColor = YBLThemeColor;
    left_shichangjia_Label.font = YBLFont(25);
    left_shichangjia_Label.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:left_shichangjia_Label];
}

- (CGFloat)getHeaderHi{
    
    return self.bgImageView.height;
}

+ (CGFloat)getHeaderHi{
    
    return [[ReferenceHeaderView new] getHeaderHi];
}

@end


#pragma mark  ReferenceItemCell

@interface ReferenceItemCell : UITableViewCell

@property (nonatomic, strong) YBLReferenceItemLineCollectionView *referenceCollectionView;

+ (CGFloat)getHi;

@end

@implementation ReferenceItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40)];
    [self addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, topView.width/2, topView.height)];
    titleLabel.text = @"全国金店人数分布图";
    titleLabel.textColor = BlackTextColor;
    titleLabel.font = YBLFont(14);
    [topView addSubview:titleLabel];
    
    CGFloat button_wi = 60;
    
    YBLSwitchButton *swithButton = [[YBLSwitchButton alloc] initWithFrame:CGRectMake(topView.width-space-button_wi, 5, button_wi, 20)];
    swithButton.centerY = topView.height/2;
    [topView addSubview:swithButton];
    [swithButton addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGFloat wi = YBLWindowWidth/6;
    CGFloat hi = 200;
    layout.itemSize = CGSizeMake(wi, hi);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    YBLReferenceItemLineCollectionView *referenceCollectionView = [[YBLReferenceItemLineCollectionView alloc] initWithFrame:CGRectMake(0,topView.bottom,topView.width,hi) collectionViewLayout:layout];
    [self addSubview:referenceCollectionView];
    self.referenceCollectionView = referenceCollectionView;
}

- (void)switchClick:(YBLSwitchButton *)btn{
    
    btn.selected = !btn.selected;
}

- (CGFloat)getHi{
    
    return self.referenceCollectionView.bottom;
}

+ (CGFloat)getHi{
    
    return [[ReferenceItemCell new] getHi];
}

@end


#pragma mark  YBLReferenceTableView

@interface YBLReferenceTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YBLReferenceTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [self registerClass:NSClassFromString(@"ReferenceItemCell") forCellReuseIdentifier:@"ReferenceItemCell"];
        [self registerClass:NSClassFromString(@"ReferenceHeaderView") forHeaderFooterViewReuseIdentifier:@"ReferenceHeaderView"];
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = [ReferenceItemCell getHi];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return [ReferenceHeaderView getHeaderHi];
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        ReferenceHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ReferenceHeaderView"];
        return headerView;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReferenceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReferenceItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ReferenceItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
