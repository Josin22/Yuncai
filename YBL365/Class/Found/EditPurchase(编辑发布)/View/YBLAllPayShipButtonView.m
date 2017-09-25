//
//  YBLAllPayShipButtonView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAllPayShipButtonView.h"
#import "YBLButtonsView.h"
#import "YBLpurchaseInfosModel.h"

static NSInteger tag_buttons_view = 165465;

@interface YBLAllPayShipButtonView()

@property (nonatomic, strong) YBLPurchaseInfosModel *currentPayModel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) SelectType selectType;

@end

@implementation YBLAllPayShipButtonView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray{
    
    return [self initWithFrame:frame dataArray:dataArray selectType:SelectTypeAll];
}

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray selectType:(SelectType)selectType
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataArray = dataArray;
        _selectType = selectType;
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = YBLViewBGColor;
    
    WEAK
    CGFloat save_height = 0;
    for (int i = 0; i<3; i++) {
        NSMutableArray *buttons_data = nil;
        NSString *title = @"  ";
        BOOL isHidden = YES;
        if (i==0) {
            buttons_data = _dataArray;
            title = @"支付方式";
            isHidden = NO;
        }
        YBLButtonsView *payButtonsView = [[YBLButtonsView alloc] initWithFrame:CGRectMake(0, space+save_height, self.width, 100)
                                                                   buttonsType:ButtonsTypeSingleSelect
                                                                 textDataArray:buttons_data
                                                                         title:title];
        payButtonsView.tag = tag_buttons_view+i;
        payButtonsView.buttonsViewClickBlock = ^(id selectValue, NSInteger index) {
            STRONG
            if (i == 0) {
                YBLPurchaseInfosModel *infoModel =  (YBLPurchaseInfosModel *)selectValue;
                [self updateDataFromPayArray:infoModel.filter_purchase_distribution_data];
                //清空
                if (self.selectDataDict.count>0) {
                    [self.selectDataDict removeAllObjects];
                }
                BLOCK_EXEC(self.allPayShipButtonViewClickBlock,infoModel)
            } else {
                if (_selectType == SelectTypeOneOfAll) {
                    if (i == 1) {
                        [self setAbleButton1];
                    } else if (i == 2){
                        [self setAbleButton2];
                    }
                }
                if (selectValue) {
                    [self.selectDataDict setObject:selectValue forKey:@(i)];
                } else {
                    [self.selectDataDict removeObjectForKey:@(i)];
                    if (_selectType == SelectTypeOneOfAll) {
                        [self setAbleButton12];
                    }
                }
                
            }
        };
        [self addSubview:payButtonsView];
        payButtonsView.hidden = isHidden;
        save_height += payButtonsView.height;
    }

}

- (void)setAbleButton12{
    YBLButtonsView *distributionButtonsView = (YBLButtonsView *)[self viewWithTag:tag_buttons_view+2];
    distributionButtonsView.isItemEnable = YES;
    YBLButtonsView *distributionButtonsView1 = (YBLButtonsView *)[self viewWithTag:tag_buttons_view+1];
    distributionButtonsView1.isItemEnable = YES;

}

- (void)setAbleButton1{
    YBLButtonsView *distributionButtonsView = (YBLButtonsView *)[self viewWithTag:tag_buttons_view+2];
    distributionButtonsView.isItemEnable = NO;
    YBLButtonsView *distributionButtonsView1 = (YBLButtonsView *)[self viewWithTag:tag_buttons_view+1];
    distributionButtonsView1.isItemEnable = YES;
}

- (void)setAbleButton2{
    YBLButtonsView *distributionButtonsView = (YBLButtonsView *)[self viewWithTag:tag_buttons_view+2];
    distributionButtonsView.isItemEnable = YES;
    YBLButtonsView *distributionButtonsView1 = (YBLButtonsView *)[self viewWithTag:tag_buttons_view+1];
    distributionButtonsView1.isItemEnable = NO;
}

- (void)updateDataFromPayArray:(NSMutableArray *)payArray{
    
    NSInteger count = payArray.count;
    CGFloat save_height = 0;
    YBLButtonsView *payButtonsView = (YBLButtonsView *)[self viewWithTag:tag_buttons_view];
    for (int index = 0; index < 2; index++) {
        YBLButtonsView *distributionButtonsView = (YBLButtonsView *)[self viewWithTag:tag_buttons_view+index+1];
        distributionButtonsView.hidden = YES;
        if (index<count) {
            NSMutableArray *payItemArray = payArray[index];
            distributionButtonsView.frame = CGRectMake(0, payButtonsView.bottom+save_height, self.width, 100);
            distributionButtonsView.hidden = NO;
            YBLPurchaseInfosModel *firstModel = payItemArray[0];
            NSString *title = nil;
            if (firstModel.same_city.boolValue) {
                title = @"同城";
            } else {
                title = @"异地";
            }
            [distributionButtonsView updateTextDataArray:payItemArray title:title];
            save_height += distributionButtonsView.height;
        }
        if (index == 1) {
            self.height = distributionButtonsView.bottom+2*space;
            NSLog(@"self.height--:%@",@(self.height));
        }
    }
    BLOCK_EXEC(self.allPayShipButtonViewUpdateHeightBlock,);
}

- (NSMutableDictionary *)selectDataDict{
    if (!_selectDataDict) {
        _selectDataDict = [NSMutableDictionary dictionary];
    }
    return _selectDataDict;
}

- (void)getFinalData{
    
    NSArray *allValue = [self.selectDataDict allValues];
    YBLPurchaseInfosModel *firstDisModel = allValue[0];
    YBLPurchaseInfosModel *firstPayModel = nil;
    NSMutableArray *distribution_titles = [NSMutableArray array];
    for (YBLPurchaseInfosModel *payModel in _dataArray) {
        for (NSString *ids in firstDisModel.purchase_pay_type_ids) {
            if ([ids isEqualToString:payModel._id]) {
                firstPayModel = payModel;
            }
        }
    }
    for (YBLPurchaseInfosModel *distributionModel in allValue) {
        [distribution_titles addObject:distributionModel.title];
    }
    NSString *distribution_ids =  [YBLMethodTools getAppendingStringWithArray:allValue appendingKey:@","];
    NSArray *idsArray = @[firstPayModel._id,distribution_ids];
    self.paraPayShipIdsArray = idsArray;
    [distribution_titles insertObject:firstPayModel.title atIndex:0];
    NSString *pay_distribution_titles =  [YBLMethodTools getAppendingStringWithArray:distribution_titles appendingKey:@" "];
    self.paraPayShipTitles = pay_distribution_titles;
}



@end
