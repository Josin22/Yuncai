//
//  YBLGoodListManageTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodListManageTableView.h"
#import "YBLGoodModel.h"
#import "YBLFooterSignView.h"

@interface YBLGoodManageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *goodStatusLabel;
@property (nonatomic, retain) UILabel *storge_salecountLabel;
@property (nonatomic, retain) UILabel *storeOrGoodName;
//@property (nonatomic, retain) UILabel *look_favorite_shareLabel;
@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *xiajiaButton;

@property (nonatomic, assign) GoodManageButtonStatus goodManageButtonStatus;

+ (CGFloat)getHI;

@end

@implementation YBLGoodManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat hei = [YBLGoodManageCell getHI];
    
    CGFloat imageWi = hei-2*space;
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, imageWi, imageWi)];
    //    goodImageView.centerY = hei/2;
//    goodImageView.layer.borderColor = YBLLineColor.CGColor;
//    goodImageView.layer.borderWidth = 0.5;
//    goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    [self addSubview:goodImageView];
    self.goodImageView = goodImageView;
    
    self.goodStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, goodImageView.width, 20)];
    self.goodStatusLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    self.goodStatusLabel.textColor = [UIColor whiteColor];
    self.goodStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.goodStatusLabel.font = YBLFont(13);
    [self.goodImageView addSubview:self.goodStatusLabel];
    
    CGFloat buttonWi = 70;
    CGFloat buttonHi = 25;
    
    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodImageView.right+space, self.goodImageView.top, YBLWindowWidth-self.goodImageView.right-space*2, 20)];
    goodNameLabel.text = @"正在加载中...";
    goodNameLabel.font = YBLFont(14);
    goodNameLabel.textColor = BlackTextColor;
    [self addSubview:goodNameLabel];
    self.storeOrGoodName = goodNameLabel;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodNameLabel.left, goodNameLabel.bottom+space, goodNameLabel.width-buttonWi, 30)];
    priceLabel.text = @"¥12.33-13.22";
    priceLabel.textColor = YBLTextColor;
    priceLabel.font = YBLFont(14);
    priceLabel.textColor = YBLThemeColor;
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *storge_salecountLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom, priceLabel.width, priceLabel.height)];
    storge_salecountLabel.text = @"库存 :222   月销 :222";
    storge_salecountLabel.textColor = YBLTextColor;
    storge_salecountLabel.font = YBLFont(12);
    [self addSubview:storge_salecountLabel];
    self.storge_salecountLabel = storge_salecountLabel;
    
//    UILabel *look_favorite_shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(storge_salecountLabel.left, storge_salecountLabel.bottom, storge_salecountLabel.width, storge_salecountLabel.height)];
//    look_favorite_shareLabel.text = @"222人浏览/23人收藏/111人分享";
//    look_favorite_shareLabel.textColor = YBLTextColor;
//    look_favorite_shareLabel.font = YBLFont(12);
//    [self addSubview:look_favorite_shareLabel];
//    self.look_favorite_shareLabel = look_favorite_shareLabel;
    
    UIButton *xiajiaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xiajiaButton.frame = CGRectMake(YBLWindowWidth-space-buttonWi, 0, buttonWi, buttonHi);
    xiajiaButton.centerY = goodImageView.centerY;
    [xiajiaButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    [xiajiaButton setTitle:@"下架商品" forState:UIControlStateNormal];
    xiajiaButton.titleLabel.font = YBLFont(13);
    xiajiaButton.layer.cornerRadius = 3;
    xiajiaButton.layer.masksToBounds = YES;
    xiajiaButton.layer.borderColor = YBLThemeColor.CGColor;
    xiajiaButton.layer.borderWidth = 0.5;
    [self addSubview:xiajiaButton];
    self.xiajiaButton = xiajiaButton;
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(goodNameLabel.left, hei-0.5, YBLWindowWidth-goodNameLabel.left, 0.5)]];
}

- (void)setGoodManageButtonStatus:(GoodManageButtonStatus)goodManageButtonStatus{
    _goodManageButtonStatus = goodManageButtonStatus;
    
    switch (_goodManageButtonStatus) {
        case GoodManageButtonStatusRack:
        {
            [self.xiajiaButton setTitle:@"编辑商品" forState:UIControlStateNormal];
            self.goodStatusLabel.text = @"待编辑";
            self.goodStatusLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        }
            break;
        case GoodManageButtonStatusOffline:
        {
            [self.xiajiaButton setTitle:@"上架商品" forState:UIControlStateNormal];
            self.goodStatusLabel.text = @"已下架";
            self.goodStatusLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        }
            break;
        case GoodManageButtonStatusOnline:
        {
            [self.xiajiaButton setTitle:@"下架商品" forState:UIControlStateNormal];
            self.goodStatusLabel.text = @"销售中";
            self.goodStatusLabel.backgroundColor = [YBLColor(34, 197, 54, 1) colorWithAlphaComponent:.9];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)updateItemCellModel:(YBLGoodModel *)itemModel{
    
    [self.goodImageView js_alpha_setImageWithURL:[NSURL URLWithString:itemModel.avatar_url] placeholderImage:smallImagePlaceholder];
    self.storeOrGoodName.text = itemModel.title;
    if (itemModel.cost_price.doubleValue==0) {
        self.priceLabel.text = [NSString stringWithFormat:@"暂无价格"];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",itemModel.cost_price.doubleValue];
    }
    self.storge_salecountLabel.text = [NSString stringWithFormat:@"库存 :%@   销量 :%@",itemModel.stock,itemModel.sale_count];
//    self.look_favorite_shareLabel.text = itemModel.specification;
    self.goodManageButtonStatus = [YBLMethodTools getGoodManageStatusWith:itemModel.state.value];
    if (itemModel.stock.integerValue <= 0) {
        self.goodStatusLabel.text = @"待补货";
    }
}

+ (CGFloat)getHI{
    
    return 100;
}

@end

@interface YBLGoodListManageTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YBLGoodListManageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.rowHeight = [YBLGoodManageCell getHI];
        [self registerClass:NSClassFromString(@"YBLGoodManageCell") forCellReuseIdentifier:@"YBLGoodManageCell"];
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight+buttonHeight+space)];
        self.dataSource = self;
        self.delegate = self;

    }
    return self;
}

//- (void)setDataArray:(NSMutableArray *)dataArray{
//    _dataArray = dataArray;
//    
////    [self jsReloadData];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLGoodManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLGoodManageCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLGoodManageCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLGoodModel *model = self.dataArray[row];
    [cell updateItemCellModel:model];
    WEAK
    [[[cell.xiajiaButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        BLOCK_EXEC(self.goodListManageTableViewButtonClickBlock,indexPath,model);
    }];
    BOOL isSatisfy = [YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:row];
    if (isSatisfy) {
        BLOCK_EXEC(self.prestrainBlock,);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    YBLGoodModel *model = self.dataArray[row];
    BLOCK_EXEC(self.goodListManageTableViewCellDidSelectBlock,indexPath,model);
    
}


@end
