//
//  YBLShowSelectAreaRadiusView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShowSelectAreaRadiusView.h"
#import "YBLExpressPriceTableView.h"

#define TOP  YBLWindowHeight/8

static YBLShowSelectAreaRadiusView *selectAreaRadiusView = nil;

@interface YBLShowSelectAreaRadiusView ()
{
    
}
@property (nonatomic, strong) NSMutableArray *areaRadiusDataArray;

@property (nonatomic, copy) ShowSelectAreaRadiusViewDoneBlock doneBlock;

@property (nonatomic, weak) UIViewController *Vc;

@property (nonatomic, strong) YBLExpressPriceTableView *radiusPriceTableView;

@property (nonatomic, assign) DistanceRadiusType distanceRadiusType;

@end

@implementation YBLShowSelectAreaRadiusView

+ (void)showselectAreaRadiusViewFromVC:(UIViewController *)Vc
                    distanceRadiusType:(DistanceRadiusType)distanceRadiusType
                   areaRadiusDataArray:(NSMutableArray *)areaRadiusDataArray
                            doneHandle:(ShowSelectAreaRadiusViewDoneBlock)doneBlock{
    if (!selectAreaRadiusView) {
        selectAreaRadiusView = [[YBLShowSelectAreaRadiusView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                                           FromVC:Vc
                                                               distanceRadiusType:distanceRadiusType
                                                              areaRadiusDataArray:areaRadiusDataArray
                                                                       doneHandle:doneBlock];
           }
    [YBLMethodTools transformOpenView:selectAreaRadiusView.contentView SuperView:selectAreaRadiusView fromeVC:selectAreaRadiusView.Vc Top:TOP];
}

- (instancetype)initWithFrame:(CGRect)frame
                       FromVC:(UIViewController *)Vc
           distanceRadiusType:(DistanceRadiusType)distanceRadiusType
          areaRadiusDataArray:(NSMutableArray *)areaRadiusDataArray
                   doneHandle:(ShowSelectAreaRadiusViewDoneBlock)doneBlock
{
    self = [super initWithFrame:frame];
    if (self) {

        _areaRadiusDataArray = areaRadiusDataArray;
        _Vc = Vc;
        _doneBlock = doneBlock;
        _distanceRadiusType = distanceRadiusType;
        _radiusPriceTableView.dataArray = selectAreaRadiusView.areaRadiusDataArray;
        
        
        [self createSUI];
    }
    return self;
}

- (void)createSUI{
    
    self.contentView.height = YBLWindowHeight-TOP;
    self.bgView.alpha = 0.1;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YBLFont(16);
    titleLabel.textColor = BlackTextColor;
    [self.contentView addSubview:titleLabel];
    [titleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleLabel.height-.5, titleLabel.width, .5)]];
    
    self.radiusPriceTableView = [[YBLExpressPriceTableView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.contentView.width, self.contentView.height-titleLabel.bottom-buttonHeight)
                                                                          style:UITableViewStylePlain
                                                             distanceRadiusType:self.distanceRadiusType];
    self.radiusPriceTableView.dataArray = self.areaRadiusDataArray;
    self.radiusPriceTableView.expressPriceTableViewCellDidSelectRowBlock = ^(NSIndexPath *indexPath, id model) {
        if (self.distanceRadiusType == DistanceRadiusTypeEdit) {
            
//            titleLabel.text = @"已选配送半径";
            
        } else if (self.distanceRadiusType == DistanceRadiusTypeChoose) {
            
//            titleLabel.text = @"选择配送半径";
            
        } else if (self.distanceRadiusType == DistanceRadiusTypeExpressPriceChoose) {
            
//            titleLabel.text = @"选择快递物流价格方式";
            
        }
    };
    [self.contentView addSubview:self.radiusPriceTableView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, self.radiusPriceTableView.bottom, self.contentView.width, buttonHeight);
    doneButton.backgroundColor = YBLThemeColor;
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = YBLFont(16);
    [self.contentView addSubview:doneButton];
    WEAK
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        BLOCK_EXEC(selectAreaRadiusView.doneBlock,);
        [self dismiss];
    }];
    
    if (self.distanceRadiusType == DistanceRadiusTypeEdit) {

        titleLabel.text = @"已选配送半径";
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    } else if (self.distanceRadiusType == DistanceRadiusTypeChoose) {
        
        titleLabel.text = @"选择配送半径";
        [doneButton setTitle:@"保存" forState:UIControlStateNormal];
    } else if (self.distanceRadiusType == DistanceRadiusTypeExpressPriceChoose) {
        
        titleLabel.text = @"选择快递物流价格方式";
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    }
}


- (void)dismiss{
    //重置
    [YBLMethodTools transformCloseView:selectAreaRadiusView.contentView
                             SuperView:selectAreaRadiusView
                               fromeVC:selectAreaRadiusView.Vc
                                   Top:YBLWindowHeight
                            completion:^(BOOL finished) {
                                [selectAreaRadiusView removeFromSuperview];
                                selectAreaRadiusView = nil;
                            }];
    
}

@end
