//
//  YBLPayshipmentItemButtonCollectionView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayshipmentItemButtonCollectionView.h"
//#import "YBLTakeOrderPaymentMethodModel.h"
//#import "YBLTakeOrderShippingmentMethodModel.h"
#import "payshippingment_model.h"
#import "YBLAddressAreaModel.h"
#import "YBLShowPayShippingsmentModel.h"

@interface YBLPayshipWayCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *defaultButton;

@property (nonatomic, strong) UIButton *itemButton;

@property (nonatomic, retain) UILabel *percentLabel;

@property (nonatomic, strong) YBLButton *deleteButton;

@end

@implementation YBLPayshipWayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.itemButton.frame = CGRectMake(space, 0, self.width-space, self.height);
    [self.itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.itemButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
    self.itemButton.titleLabel.font = YBLFont(13);
    self.itemButton.layer.cornerRadius = 3;
    self.itemButton.layer.masksToBounds = YES;
    self.itemButton.layer.borderWidth = .5;
    self.itemButton.layer.borderColor = YBLLineColor.CGColor;
    [self.contentView addSubview:self.itemButton];

    CGFloat top = 0;
    if (self.height != 30) {
        top = self.height-30;
        
        CGFloat sameHi = top*4/5;
        
        self.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, top*1.5, sameHi)];
        self.percentLabel.text = @"50%";
        self.percentLabel.textColor = [UIColor whiteColor];
        self.percentLabel.backgroundColor = YBLThemeColor;
        self.percentLabel.layer.cornerRadius = sameHi/2;
        self.percentLabel.textAlignment = NSTextAlignmentCenter;
        self.percentLabel.layer.masksToBounds = YES;
        self.percentLabel.font = YBLFont(10);
        [self.contentView addSubview:self.percentLabel];
        
        self.defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.defaultButton.frame = CGRectMake(self.width-(self.itemButton.width/2), 0, self.itemButton.width/2, sameHi);
        self.defaultButton.layer.cornerRadius = sameHi/2;
        self.defaultButton.layer.masksToBounds = YES;
        [self.defaultButton setTitle:@"默认" forState:UIControlStateNormal];
        self.defaultButton.titleLabel.font = YBLFont(10);
        [self.defaultButton setBackgroundColor:YBLColor(210, 210, 210, 1) forState:UIControlStateNormal];
        [self.defaultButton setBackgroundColor:YBLColor(6, 156, 22, 1) forState:UIControlStateSelected];
        [self.contentView addSubview:self.defaultButton];
        
        self.percentLabel.centerX = self.itemButton.width/4+space;
    }
    self.itemButton.top = top;
    self.itemButton.height -= top;
    
    
    self.deleteButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(0, 0, self.itemButton.height, self.itemButton.height);
    self.deleteButton.right = self.itemButton.width;
    [self.deleteButton setImage:[UIImage imageNamed:@"area_delete"] forState:UIControlStateNormal];
    CGFloat imageWi = 15;
    self.deleteButton.imageRect = CGRectMake(self.itemButton.height-imageWi, 0, imageWi, imageWi);
    [self.itemButton addSubview:self.deleteButton];
    self.deleteButton.hidden = YES;
    
}

@end

@interface YBLPayshipmentItemButtonCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) PayShipMentItemButtonType payShipMentItemButtonType;

@end

@implementation YBLPayshipmentItemButtonCollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
    payShipMentItemButtonType:(PayShipMentItemButtonType)payShipMentItemButtonType{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        _payShipMentItemButtonType = payShipMentItemButtonType;
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:NSClassFromString(@"YBLPayshipWayCell") forCellWithReuseIdentifier:@"YBLPayshipWayCell"];
        
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    [self jsReloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YBLPayshipWayCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLPayshipWayCell" forIndexPath:indexPath];
    
    id model = self.dataArray[indexPath.row];
    switch (_payShipMentItemButtonType) {
        case PayShipMentItemButtonTypeTakeOrderChooseMent:
        {
            YBLShowPayShippingsmentModel *pay_ship_model = (YBLShowPayShippingsmentModel *)model;
            
            if (pay_ship_model.payment_method) {
                
                cell.itemButton.selected = pay_ship_model.is_default.boolValue;
                [cell.itemButton setTitle:pay_ship_model.payment_method.name forState:UIControlStateNormal];
            }
            if (pay_ship_model.shipping_method) {
                
                cell.itemButton.selected = pay_ship_model.is_default.boolValue;
                [cell.itemButton setTitle:pay_ship_model.shipping_method.name forState:UIControlStateNormal];
            }

        }
            break;
        case PayShipMentItemButtonTypeGoodSettingMent:
        {
            //展示配送方式
            /*  横向   */
            YBLShowPayShippingsmentModel *new_model = (YBLShowPayShippingsmentModel *)model;
            NSString *sef_name = nil;
            NSString *sef_type = nil;
            if (new_model.shipping_method) {
                sef_name = new_model.shipping_method.name;
                sef_type = new_model.shipping_method.type;
            }
            if (new_model.payment_method) {
                sef_name = new_model.payment_method.name;
                sef_type = new_model.payment_method.type;
            }
            cell.itemButton.selected = new_model.is_select;
            cell.defaultButton.selected = new_model.is_default.boolValue;
            [cell.itemButton setTitle:sef_name forState:UIControlStateNormal];
            //要是物流代收
            if ([sef_type isEqualToString:@"PaymentMethod::ExpressCollecting"]) {
                cell.percentLabel.hidden = NO;
                cell.percentLabel.text = [NSString stringWithFormat:@"%.f％",new_model.down_payment_percent*100];
            } else {
                cell.percentLabel.hidden = YES;
            }

        }
            break;
        case PayShipMentItemButtonTypeGoodShowMent:
        {
            //地区
            YBLAddressAreaModel *areaModel = (YBLAddressAreaModel *)model;
            [cell.itemButton setTitle:areaModel.text forState:UIControlStateNormal];
            cell.deleteButton.hidden = !areaModel.isShowDeleteButton;
            [cell.itemButton setBackgroundColor:YBLColor(240, 240, 240, 1) forState:UIControlStateNormal];

        }
            break;
            
        default:
            break;
    }
    WEAK
    ///itemButton
    [[[cell.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        BLOCK_EXEC(self.payshipmentItemButtonCollectionViewButtonClickBlock,model,indexPath.row,NO);
    }];
    ///默认
    [[[cell.defaultButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        BLOCK_EXEC(self.payshipmentItemButtonCollectionViewButtonClickBlock,model,indexPath.row,YES);
    }];
    ///删除
    [[[cell.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        NSIndexPath *getPath = [self indexPathForCell:cell];
        [self.dataArray removeObjectAtIndex:getPath.row];
        [self deleteItemsAtIndexPaths:@[getPath]];
    }];
    
    return cell;
}

@end
