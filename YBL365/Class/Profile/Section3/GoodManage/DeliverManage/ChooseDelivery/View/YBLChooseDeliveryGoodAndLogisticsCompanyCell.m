//
//  YBLChooseDeliveryGoodAndLogisticsCompanyCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseDeliveryGoodAndLogisticsCompanyCell.h"
#import "YBLChooseGoodLogisticsCompanyCollectionView.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLEditPurchaseCell.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLGoodModel.h"

@interface YBLChooseDeliveryGoodAndLogisticsCompanyCell ()

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) YBLChooseGoodLogisticsCompanyCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataAray;

@end

@implementation YBLChooseDeliveryGoodAndLogisticsCompanyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                               placeholder:(NSString *)placeholder
                                isSwitchOn:(BOOL)isSwitchOn
                                      type:(EditTypeCell)type{
    YBLEditItemGoodParaModel *model = [YBLEditItemGoodParaModel new];
    model.title = title;
    model.placeholder = placeholder;
    model.editTypeCell = type;
    model.isSwitchOn = isSwitchOn;
    
    return model;
}

- (void)createUI{
    
    WEAK
    
    CGFloat cell_height = [YBLChooseDeliveryGoodAndLogisticsCompanyCell getItemCellHeightWithModel:nil];
    
    self.titleNameLable = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth/2, 50)];
    self.titleNameLable.textColor = BlackTextColor;
    self.titleNameLable.font = YBLFont(15);
    self.titleNameLable.text = @"选择商品";
    [self.contentView addSubview:self.titleNameLable];
    
    self.selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAllButton.frame = CGRectMake(0, 0, 80, self.titleNameLable.height);
    self.selectAllButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.selectAllButton.right = YBLWindowWidth-space;
    [self.selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllButton setTitle:@"取消全选" forState:UIControlStateSelected];
    self.selectAllButton.titleLabel.font = YBLFont(15);
    [self.selectAllButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.contentView addSubview:self.selectAllButton];
    [[self.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       STRONG
        if (self.dataAray.count==0) {
            return ;
        }
        x.selected = !x.selected;
        for (id model in self.dataAray) {
            if ([model isKindOfClass:[YBLExpressCompanyItemModel class]]) {
                YBLExpressCompanyItemModel *newModel = (YBLExpressCompanyItemModel *)model;
                [newModel setValue:@(x.selected) forKey:@"is_select"];
            } else if ([model isKindOfClass:[YBLGoodModel class]])  {
                YBLGoodModel *newModel = (YBLGoodModel *)model;
                [newModel setValue:@(x.selected) forKey:@"is_select"];
            }
        }
        [self reloadTitleCount];
        self.collectionView.dataArray = self.dataAray;
        BLOCK_EXEC(self.chooseDeliveryGoodAndLogisticsCompanyCellItemBlock,nil);
    }];
    
    CGFloat itemHi = cell_height-self.titleNameLable.height*2;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemHi, itemHi);
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[YBLChooseGoodLogisticsCompanyCollectionView alloc] initWithFrame:CGRectMake(0, self.titleNameLable.bottom, YBLWindowWidth, itemHi) collectionViewLayout:layout];
    self.collectionView.backgroundColor = YBLColor(242, 242, 242, 1);
    
    self.collectionView.chooseGoodLogisticsCompanyCollectionViewCellDidSelectBlock = ^(id model) {
        STRONG
        BLOCK_EXEC(self.chooseDeliveryGoodAndLogisticsCompanyCellItemBlock,model);
    };
    [self.contentView addSubview:self.collectionView];
    
    YBLEditItemGoodParaModel *numModel = [self getModelWith:@"店铺共000个商品" placeholder:nil isSwitchOn:NO type:EditTypeCellOnlyClick];
    YBLEditPurchaseCell *numCell = [[YBLEditPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    numCell.frame = CGRectMake(0, self.collectionView.bottom, YBLWindowWidth, self.titleNameLable.height);
    [numCell updateItemCellModel:numModel];
    [[numCell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        BLOCK_EXEC(self.chooseDeliveryGoodAndLogisticsCompanyCellButtonClickBlock,)
    }];
    [self.contentView addSubview:numCell];
    self.numCell = numCell;
}

- (void)updateItemCellModel:(id)itemModel{
    
    NSMutableArray *dataAray = (NSMutableArray *)itemModel;
    _dataAray = dataAray;
    self.collectionView.dataArray = dataAray;

    [self reloadTitleCount];
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 180;
}

- (void)updateSection:(NSInteger)section {
    _section = section;
    
    [self reloadTitleCount];
}

- (void)reloadTitleCount {
    
    if (_section == 0) {
        self.titleNameLable.text = [NSString stringWithFormat:@"当前(%ld)个商品",(unsigned long)self.dataAray.count];
        self.numCell.ttLabel.text = @"添加店铺商品";
    } else if (_section == 1) {
        self.numCell.ttLabel.text = @"添加快递物流";
        self.titleNameLable.text = [NSString stringWithFormat:@"当前(%ld)个物流",(unsigned long)self.dataAray.count];
    }
}

@end
