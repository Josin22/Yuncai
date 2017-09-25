//
//  YBLVerifyGoodViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLVerifyGoodViewController.h"

typedef NS_ENUM(NSInteger,VerifyGoodType) {
    VerifyGoodTypeSuccess = 0,
    VerifyGoodTypeIng ,
    VerifyGoodTypeFail
};

@interface YBLVerifyGoodCell : UITableViewCell

@property (nonatomic, assign) VerifyGoodType verifyGoodType;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *storeOrGoodName;

@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, retain) UILabel *infoLabel;

@property (nonatomic, strong) UIButton *verifyButton;

@property (nonatomic, strong) UIButton *otherButton;

+ (CGFloat)getHI;

@end

@implementation YBLVerifyGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hei = [YBLVerifyGoodCell getHI];
    
    CGFloat imageWi = hei-2*space;
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, imageWi, imageWi)];
    //    goodImageView.centerY = hei/2;
    goodImageView.layer.borderColor = YBLLineColor.CGColor;
    goodImageView.layer.borderWidth = 0.5;
    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    [self addSubview:goodImageView];
    self.goodImageView = goodImageView;
    
    CGFloat buttonWi = 70;
    CGFloat buttonHi = 25;
    
    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodImageView.right+space, self.goodImageView.top, YBLWindowWidth-self.goodImageView.right-space*2, 20)];
    goodNameLabel.text = @"贵州茅台集团52度500ml6瓶 精品特供";
    goodNameLabel.font = YBLFont(14);
    goodNameLabel.textColor = BlackTextColor;
    [self addSubview:goodNameLabel];
    self.storeOrGoodName = goodNameLabel;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodNameLabel.left, goodNameLabel.bottom+5, goodNameLabel.width-buttonWi, goodNameLabel.height)];
    priceLabel.text = @"¥12.33-13.22";
    priceLabel.textColor = YBLTextColor;
    priceLabel.font = YBLFont(15);
    priceLabel.textColor = YBLThemeColor;
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.left, hei-space-15, priceLabel.width, 15)];
    infoLabel.text = @"商品图太模糊不符合商品图上传规定";
    infoLabel.font = YBLFont(11);
    infoLabel.textColor = YBLThemeColor;
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyButton.frame = CGRectMake(YBLWindowWidth-space*2-buttonWi*2, hei-buttonHi-5, buttonWi, buttonHi);
    [verifyButton setTitleColor:YBLColor(0, 162, 0, 1) forState:UIControlStateNormal];
    [verifyButton setTitle:@"审核通过" forState:UIControlStateNormal];
    verifyButton.titleLabel.font = YBLFont(13);
    verifyButton.layer.cornerRadius = 3;
    verifyButton.layer.masksToBounds = YES;
    verifyButton.layer.borderColor = YBLColor(0, 162, 0, 1).CGColor;
    verifyButton.layer.borderWidth = 0.5;
    [self addSubview:verifyButton];
    self.verifyButton = verifyButton;
    
    UIButton * otherButton= [UIButton buttonWithType:UIButtonTypeCustom];
    otherButton.frame = CGRectMake(verifyButton.right+space, verifyButton.top, buttonWi, buttonHi);
    otherButton.titleLabel.font = YBLFont(13);
    otherButton.layer.cornerRadius = 3;
    otherButton.layer.masksToBounds = YES;
    otherButton.layer.borderColor = YBLColor(0, 162, 0, 1).CGColor;
    otherButton.layer.borderWidth = 0.5;
    [self addSubview:otherButton];
    self.otherButton = otherButton;
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, hei-0.5, YBLWindowWidth, 0.5)]];
}

- (void)setVerifyGoodType:(VerifyGoodType)verifyGoodType{
    
    switch (verifyGoodType) {
        case VerifyGoodTypeSuccess:
        {
            self.verifyButton.hidden = NO;
            self.infoLabel.hidden = YES;
            self.otherButton.layer.borderColor = YBLThemeColor.CGColor;
            [self.otherButton setTitle:@"上架商品" forState:UIControlStateNormal];
            [self.otherButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        }
            break;
        case VerifyGoodTypeIng:
        {
            self.verifyButton.hidden = YES;
            self.infoLabel.hidden = YES;
            self.otherButton.layer.borderColor = YBLColor(233, 106, 42, 1).CGColor;
            [self.otherButton setTitle:@"审核中" forState:UIControlStateNormal];
            [self.otherButton setTitleColor:YBLColor(233, 106, 42, 1) forState:UIControlStateNormal];
        }
            break;
        case VerifyGoodTypeFail:
        {
            self.verifyButton.hidden = YES;
            self.infoLabel.hidden = NO;
            self.otherButton.layer.borderColor = YBLColor(170, 170, 170, 1).CGColor;
            [self.otherButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            [self.otherButton setTitleColor:YBLColor(170, 170, 170, 1) forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}


+ (CGFloat)getHI{
    
    return 80;
}

@end

@interface YBLVerifyGoodViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *marTableView;

@property (nonatomic, strong) NSMutableArray *testArray;

@end

@implementation YBLVerifyGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"审核商品";
    
    [self.view addSubview:self.marTableView];
}

- (NSMutableArray *)testArray{
    
    if (!_testArray) {
        _testArray = [NSMutableArray array];
        [_testArray addObject:@0];
        [_testArray addObject:@1];
        [_testArray addObject:@2];
        [_testArray addObject:@2];
        [_testArray addObject:@1];
        [_testArray addObject:@1];
        [_testArray addObject:@2];
    }
    return _testArray;
}

- (UITableView *)marTableView{
    
    if (!_marTableView) {
        _marTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _marTableView.rowHeight = [YBLVerifyGoodCell getHI];
        [_marTableView registerClass:NSClassFromString(@"YBLVerifyGoodCell") forCellReuseIdentifier:@"YBLVerifyGoodCell"];
        _marTableView.backgroundColor = [UIColor whiteColor];
        _marTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _marTableView.dataSource = self;
        _marTableView.delegate = self;
        
    }
    return _marTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.testArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLVerifyGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLVerifyGoodCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLVerifyGoodCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.verifyGoodType = [self.testArray[indexPath.row] integerValue];
    WEAK
    [[[cell.otherButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
