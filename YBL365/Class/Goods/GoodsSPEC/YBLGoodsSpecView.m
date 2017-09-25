//
//  YBLGoodsSpecView.m
//  YBL365
//
//  Created by 乔同新 on 2016/12/30.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLGoodsSpecView.h"
#import "YBLSpecCell.h"
#import "YBLGoodModel.h"
#import "YBLShopCarViewModel.h"

static CGFloat Top = 120;

static YBLGoodsSpecView *specView = nil;

@interface YBLGoodsSpecView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) GoodsSpecType type;

@property (nonatomic, weak  ) UIViewController *vc;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITableView *specTableView;

@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *goodsImageView;

@property (nonatomic, copy  ) SpecViewOneBuyClickBlock oneBuyBlock;

@property (nonatomic, copy  ) SpecViewAddCartClickBlock addCartClickBlock;

@property (nonatomic, strong) id goodModel;

@end

@implementation YBLGoodsSpecView


+ (void)showGoodsSpecViewFormVC:(UIViewController *)vc
                       SpecType:(GoodsSpecType)type
                      goodModel:(id)goodModel
       specViewOneBuyClickBlock:(SpecViewOneBuyClickBlock)oneBuyBlock
      specViewAddCartClickBlock:(SpecViewAddCartClickBlock)addCartClickBlock{
    
    if (!specView) {
        specView = [[YBLGoodsSpecView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                    FormVC:vc
                                                  SpecType:type
                                                 goodModel:goodModel
                                  specViewOneBuyClickBlock:oneBuyBlock
                                 specViewAddCartClickBlock:addCartClickBlock];
    }
    
    [YBLMethodTools transformOpenView:specView.contentView SuperView:specView fromeVC:vc Top:Top];
    
}

- (instancetype)initWithFrame:(CGRect)frame
                       FormVC:(UIViewController *)vc
                     SpecType:(GoodsSpecType)type
                    goodModel:(id)goodModel
     specViewOneBuyClickBlock:(SpecViewOneBuyClickBlock)oneBuyBlock
    specViewAddCartClickBlock:(SpecViewAddCartClickBlock)addCartClickBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = type;
        _vc = vc;
        _oneBuyBlock = oneBuyBlock;
        _addCartClickBlock = addCartClickBlock;
        _goodModel = goodModel;
        
        self.backgroundColor = YBLColor(0, 0, 0, 0);
        
        [self createSpecUI];
    }
    return self;
}

- (void)createSpecUI{
    
    UIView *bg = [[UIView alloc] initWithFrame:[self bounds]];
    bg.backgroundColor = [UIColor clearColor];
    [self addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bg addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight+space, self.width, self.height-Top)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [YBLMethodTools addTopShadowToView:contentView];
    self.contentView = contentView;
    
    CGFloat imageWi = (self.width-4*space)/3;
    /* good info */
    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, -space, imageWi, imageWi)];
    goodsImageView.layer.cornerRadius = 3;
    goodsImageView.layer.masksToBounds = YES;
    goodsImageView.layer.borderColor = YBLLineColor.CGColor;
    goodsImageView.layer.borderWidth = 0.5;
    [contentView addSubview:goodsImageView];
    [YBLMethodTools addTopShadowToView:goodsImageView];
    self.goodsImageView = goodsImageView;
    
    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImageView.frame)+space, 0, contentView.width-goodsImageView.right-2*space, (imageWi-space)*1/2)];
    goodsNameLabel.numberOfLines = 2;
    goodsNameLabel.font = YBLFont(15);
    [contentView addSubview:goodsNameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(goodsNameLabel.frame), CGRectGetMaxY(goodsNameLabel.frame), goodsNameLabel.width, (imageWi-space)*1/2)];
    [contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UIView *linev = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(goodsImageView.frame)+space, contentView.width, 0.5)];
    linev.backgroundColor = YBLLineColor;
    [contentView addSubview:linev];
    
    CGFloat wi = 50;
    /* table view */
    self.specTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, linev.bottom, contentView.width, contentView.height-linev.bottom-wi) style:UITableViewStylePlain];
    self.specTableView.dataSource = self;
    self.specTableView.delegate = self;
    self.specTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.specTableView.rowHeight = [YBLSpecCell getSpecHi];
    [self.specTableView registerClass:NSClassFromString(@"YBLSpecCell") forCellReuseIdentifier:@"YBLSpecCell"];
    [contentView addSubview:self.specTableView];
    /* bottom view */
    /*
    YBLButton *oneCaiButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    oneCaiButton.frame = CGRectMake(0, contentView.height-wi, contentView.width/2, wi);
    oneCaiButton.backgroundColor = YBLColor(127, 210, 195, 1);
    [oneCaiButton setTitle:@"一键采" forState:UIControlStateNormal];
    [oneCaiButton setImage:[UIImage imageNamed:@"goods_car"] forState:UIControlStateNormal];
    [oneCaiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oneCaiButton.titleRect = CGRectMake(0, 30, self.width/2, 20);
    oneCaiButton.imageRect = CGRectMake(self.width/4-10, 10, 20, 20);
    oneCaiButton.titleLabel.font = YBLFont(13);
    oneCaiButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [oneCaiButton addTarget:self action:@selector(oneBuyClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:oneCaiButton];
    
    */
    YBLButton *addCartButton = [YBLButton buttonWithType:UIButtonTypeCustom];
//    addCartButton.frame = CGRectMake(CGRectGetMaxX(oneCaiButton.frame), contentView.height-wi, contentView.width/2, wi);
    addCartButton.frame = CGRectMake(0, contentView.height-wi, contentView.width, wi);
    addCartButton.backgroundColor = YBLThemeColor;
    [addCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addCartButton.titleLabel.font = YBLFont(17);
    [addCartButton addTarget:self action:@selector(addCartClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:addCartButton];
    

    /* Set Value */
    if ([self.goodModel isKindOfClass:[YBLGoodModel class]]) {
        YBLGoodModel *goodDetail = (YBLGoodModel *)self.goodModel;
        [self.goodsImageView js_alpha_setImageWithURL:[NSURL URLWithString:goodDetail.avatar_url] placeholderImage:smallImagePlaceholder];
        goodsNameLabel.text = goodDetail.title;
        self.priceLabel.attributedText = [NSString stringPrice:[NSString stringWithFormat:@"¥ %.2f",goodDetail.currentPrice.doubleValue] color:YBLThemeColor font:20 isBoldFont:NO appendingString:nil];
        
    }
}

#pragma mark - method

- (void)dismiss{
    
    [YBLMethodTools transformCloseView:self.contentView
                             SuperView:specView
                               fromeVC:self.vc
                                   Top:YBLWindowHeight+10
                            completion:^(BOOL finished) {
                                [specView removeFromSuperview];
                                specView = nil;
                            }];
}

- (void)oneBuyClick:(UIButton *)btn{
    BLOCK_EXEC(specView.oneBuyBlock,);
    [self dismiss];
}

- (void)addCartClick:(UIButton *)btn{
    BLOCK_EXEC(specView.addCartClickBlock,);
    [self dismiss];
}


#pragma mark - datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLSpecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLSpecCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLSpecCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.goodModel isKindOfClass:[YBLGoodModel class]]) {
        YBLGoodModel *goodDetail = (YBLGoodModel *)self.goodModel;

        cell.spec1Label.text = goodDetail.specification;
//        cell.spec2Label.text = ;
//        cell.storgeLabel.text = [NSString stringWithFormat:@"库存:%ld",(long)goodDetail.stock.integerValue];
        cell.addSubtractView.maxCount = goodDetail.stock.integerValue;
        cell.addSubtractView.minCount = goodDetail.minCount.integerValue;
        cell.addSubtractView.currentCount = goodDetail.quantity.integerValue;
        WEAK
        cell.addSubtractView.currentCountChangeBlock = ^(NSInteger countValue, YBLAddSubtractView *addSubView,BOOL isButtonClick) {
            STRONG
            addSubView.isEnableButton = YES;
            goodDetail.quantity = @(countValue);
            float fin_price = [YBLMethodTools getCurrentPriceWithCount:goodDetail.quantity.integerValue InPriceArray:goodDetail.prices.prices];
            goodDetail.currentPrice = @(fin_price);
            self.priceLabel.attributedText = [NSString stringPrice:[NSString stringWithFormat:@"¥ %.2f",fin_price] color:YBLThemeColor font:20 isBoldFont:NO appendingString:nil];
        };
     
    }

}


@end
