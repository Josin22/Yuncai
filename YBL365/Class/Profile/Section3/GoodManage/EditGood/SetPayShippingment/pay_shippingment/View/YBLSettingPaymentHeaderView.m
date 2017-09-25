//
//  YBLSettingPaymentHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSettingPaymentHeaderView.h"
#import "payshippingment_model.h"
#import "YBLPayshipmentItemButtonCollectionView.h"
#import "ZJUsefulPickerView.h"
#import "YBLShowPayShippingsmentModel.h"

@interface YBLSettingPaymentHeaderView ()

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *payTitleLabel;

@property (nonatomic, retain) UILabel *shippingTitleLabel;

@property (nonatomic, strong) YBLPayshipmentItemButtonCollectionView *payshipmentItemButtonCollectionView;

@end

@implementation YBLSettingPaymentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self cteatyeUI];
    }
    return self;
}

- (void)cteatyeUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth, 50)];
    titleLabel.textColor = BlackTextColor;
    titleLabel.font = YBLFont(16);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleLabel.height-.5, YBLWindowWidth, .5)]];
    
    self.payTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, 35)];
    self.payTitleLabel.text = @"支付方式 : ";
    self.payTitleLabel.textColor = BlackTextColor;
    self.payTitleLabel.font = YBLFont(14);
    [self.contentView addSubview:self.payTitleLabel];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((YBLWindowWidth-space)/4, 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, space);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.payshipmentItemButtonCollectionView = [[YBLPayshipmentItemButtonCollectionView alloc] initWithFrame:CGRectMake(0, self.payTitleLabel.bottom, YBLWindowWidth, 50)
                                                                                        collectionViewLayout:layout
                                                                                   payShipMentItemButtonType:PayShipMentItemButtonTypeGoodSettingMent];
    [self.contentView addSubview:self.payshipmentItemButtonCollectionView];
    WEAK
    /**
     *  itemButtonClickMehtod
     */
    self.payshipmentItemButtonCollectionView.payshipmentItemButtonCollectionViewButtonClickBlock = ^(id model,NSInteger index,BOOL isDefault) {
        STRONG
        YBLShowPayShippingsmentModel *new_model = (YBLShowPayShippingsmentModel *)model;
        /**
         *  payment_method
         */
        if (isDefault) {
            //点击默认
            //点击默认按钮状态 -->>取消默认
            if (new_model.is_default.boolValue) {
                return ;
                /*
                [new_model setValue:@(NO) forKey:@"is_default"];
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
                [self.payshipmentItemButtonCollectionView reloadItemsAtIndexPaths:@[indexpath]];
                 */
            }
            //点击非默认状态按钮 -->>取消其他选中,选中当默认
            for (YBLShowPayShippingsmentModel*old_model in self.payshipmentItemButtonCollectionView.dataArray) {
                [old_model setValue:@(NO) forKey:@"is_default"];
            }
            [new_model setValue:@(YES) forKey:@"is_default"];
            [new_model setValue:@(YES) forKey:@"is_select"];

        } else {
            //点击itemButton
            //点击选中方式按钮状态 -->>
            new_model.is_select = !new_model.is_select;
            if (!new_model.is_select) {
                [new_model setValue:@(NO) forKey:@"is_default"];
            }
            [new_model setValue:@(new_model.is_select) forKey:@"is_select"];

        }
        
        BLOCK_EXEC(self.settingPaymentDependBlock,new_model,new_model.payment_method.permit_shipping_method_ids)
        /*
        //要是物流代收
        if ([sef_type isEqualToString:@"PaymentMethod::ExpressCollecting"]) {
            //点击默认
            if (isDefault) {
                //未默认状态点击 && 按钮已选中状态
                if (!new_model.is_default.boolValue&&new_model.is_select) {
                    for (YBLShowPayShippingsmentModel*old_model in self.payshipmentItemButtonCollectionView.dataArray) {
                        [old_model setValue:@(NO) forKey:@"is_default"];
                    }
                    [new_model setValue:@(YES) forKey:@"is_default"];
                    [self.payshipmentItemButtonCollectionView jsReloadData];
                } else if(new_model.is_default.boolValue){
                //默认状态点击
                    [new_model setValue:@(NO) forKey:@"is_default"];
                    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
                    [self.payshipmentItemButtonCollectionView reloadItemsAtIndexPaths:@[indexpath]];
                    return ;
                }
            }
            //
            if (!new_model.is_select&&!new_model.is_default.boolValue) {
                //弹出
                [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"物流代收预付款"
                                                              withData:@[@"0%",
//                                                                         @"5%",
//                                                                         @"10%",
//                                                                         @"15%",
//                                                                         @"20%",
//                                                                         @"25%",
//                                                                         @"30%",
//                                                                         @"35%",
//                                                                         @"40%",
//                                                                         @"45%",
//                                                                         @"50%"
                                                                         ]
                                                      withDefaultIndex:0
                                                     withCancelHandler:^{
                                                     }
                                                       withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                                                           STRONG
                                                           if (isDefault) {
                                                               for (YBLShowPayShippingsmentModel*old_model in self.payshipmentItemButtonCollectionView.dataArray) {
                                                                   [old_model setValue:@(NO) forKey:@"is_default"];
                                                               }
                                                               [new_model setValue:@(YES) forKey:@"is_default"];
                                                               [self.payshipmentItemButtonCollectionView jsReloadData];
                                                           }
                                                           float value = (selectedIndex)*0.05;
                                                           [new_model setValue:[NSNumber numberWithFloat:value] forKey:@"down_payment_percent"];
                                                           [new_model setValue:@(YES) forKey:@"is_select"];
                                                           NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
                                                           [self.payshipmentItemButtonCollectionView reloadItemsAtIndexPaths:@[indexpath]];
                                                       }];
            } else {
                if (!isDefault) {
                    [new_model setValue:@(NO) forKey:@"is_select"];
                    [new_model setValue:@(NO) forKey:@"is_default"];
                    [new_model setValue:[NSNumber numberWithFloat:0.0] forKey:@"down_payment_percent"];
                    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
                    [self.payshipmentItemButtonCollectionView reloadItemsAtIndexPaths:@[indexpath]];
                }
            }
            
        } else {
           //其他按钮
            if (isDefault) {
                //点击默认按钮状态 -->>取消默认
                if (new_model.is_default.boolValue) {
                    [new_model setValue:@(NO) forKey:@"is_default"];
                    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
                    [self.payshipmentItemButtonCollectionView reloadItemsAtIndexPaths:@[indexpath]];
                } else {
                    //点击非默认状态按钮 -->>取消其他选中,选中当默认
                    for (YBLShowPayShippingsmentModel*old_model in self.payshipmentItemButtonCollectionView.dataArray) {
                        [old_model setValue:@(NO) forKey:@"is_default"];
//                        [old_model setValue:[NSNumber numberWithFloat:0.0] forKey:@"down_payment_percent"];
                    }
                    [new_model setValue:@(YES) forKey:@"is_default"];
                    [new_model setValue:@(YES) forKey:@"is_select"];
                    [self.payshipmentItemButtonCollectionView jsReloadData];
                }
                
            } else {
                //点击选中方式按钮状态 -->>
                new_model.is_select = !new_model.is_select;
                if (!new_model.is_select) {
                    [new_model setValue:@(NO) forKey:@"is_default"];
                }
                [new_model setValue:@(new_model.is_select) forKey:@"is_select"];
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
                [self.payshipmentItemButtonCollectionView reloadItemsAtIndexPaths:@[indexpath]];
            }
            
        }
         */
    };
    
    self.shippingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.payTitleLabel.left, self.payshipmentItemButtonCollectionView.bottom, self.titleLabel.width, 35)];
    self.shippingTitleLabel.text = @"配送方式 : ";
    self.shippingTitleLabel.font = YBLFont(14);
    self.shippingTitleLabel.textColor = BlackTextColor;
    [self.contentView addSubview:self.shippingTitleLabel];
}

- (void)updateItemCellModel:(id)itemModel row:(NSInteger)row{
    
    NSMutableArray *modelArray = (NSMutableArray *)itemModel;
    self.payshipmentItemButtonCollectionView.dataArray = modelArray;
    if (row == 0) {
        self.titleLabel.text = @"同城支付配送选择";
    } else {
        self.titleLabel.text = @"异地支付配送选择";
    }
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    return 170;
}

@end
