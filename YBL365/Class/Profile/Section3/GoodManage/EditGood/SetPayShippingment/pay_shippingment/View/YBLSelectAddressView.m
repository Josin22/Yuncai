//
//  YBLSelectAddressView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSelectAddressView.h"
#import "YBLAddressTableView.h"

#define TOP  YBLWindowHeight/8

static YBLSelectAddressView *selectAddressView = nil;

@interface YBLSelectAddressView ()

@property (nonatomic, weak) UIViewController *Vc;

@property (nonatomic, strong) NSMutableArray *addressData;

@property (nonatomic, strong) YBLAddressTableView *addressTableView;

@property (nonatomic, copy  ) SelectAddressViewDoneBlock doneBlock;

@property (nonatomic, assign) AddressGenre addressGenre;

@end

@implementation YBLSelectAddressView

+ (void)showSelectAddressViewFromVC:(UIViewController *)Vc
                        addressData:(NSMutableArray *)addressData
                       addressGenre:(AddressGenre)addressGenre
                         doneHandle:(SelectAddressViewDoneBlock)block{
    
    if (!selectAddressView) {
        selectAddressView = [[YBLSelectAddressView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                                                 fromVC:Vc
                                                            addressData:addressData
                                                           addressGenre:addressGenre
                                                             doneHandle:block];
    }
    [YBLMethodTools transformOpenView:selectAddressView.contentView SuperView:selectAddressView fromeVC:selectAddressView.Vc Top:TOP];
}

- (instancetype)initWithFrame:(CGRect)frame
                       fromVC:(UIViewController *)Vc
                  addressData:(NSMutableArray *)addressData
                 addressGenre:(AddressGenre)addressGenre
                   doneHandle:(SelectAddressViewDoneBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.doneBlock = block;
        self.addressData = addressData;
        self.Vc = Vc;
        self.addressGenre = addressGenre;
        self.addressTableView.dataArray = addressData;
        
        [self createUISub];
    }
    return self;
}

- (void)createUISub{
    
    self.contentView.height = YBLWindowHeight-TOP;
    self.bgView.alpha = 0.1;
    
    NSString *textTitle = nil;
    NSString *buttonTitle = nil;
    if (self.addressGenre == AddressGenreZiti || self.addressGenre == AddressGenreSelectZiti) {
        textTitle = @"自提地址";
        buttonTitle = @"完成";
    } else if (self.addressGenre == AddressGenreTakeOrderSelectZiti){
        textTitle = @"选择自提地址";
        buttonTitle = @"完成";
    } else {
        textTitle = @"收货地址";
        buttonTitle = @"完成";
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 40)];
    titleLabel.text = textTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YBLFont(16);
    titleLabel.textColor = BlackTextColor;
    [self.contentView addSubview:titleLabel];
    [titleLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleLabel.height-.5, titleLabel.width, .5)]];
    
    self.addressTableView = [[YBLAddressTableView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.contentView.width, self.contentView.height-titleLabel.bottom-buttonHeight)
                                                                 style:UITableViewStylePlain
                                                          addressGenre:self.addressGenre];
    WEAK
    self.addressTableView.addressTableViewCellDeleteClickBlock = ^(YBLAddressModel *model, NSInteger row) {
        STRONG
        [self.addressData removeObjectAtIndex:row];
        [self.addressTableView jsReloadData];
        BLOCK_EXEC(selectAddressView.doneBlock,model);
        if (self.addressData.count==0) {
            [self dismiss];
        }
    };
    self.addressTableView.addressTableViewRowDidSelectBlock = ^(YBLAddressModel *model, NSInteger row) {
        STRONG
        BLOCK_EXEC(selectAddressView.doneBlock,model);
        [self dismiss];
    };
    
    [self.contentView addSubview:self.addressTableView];
    self.addressTableView.dataArray = self.addressData;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, self.addressTableView.bottom, self.contentView.width, buttonHeight);
    doneButton.backgroundColor = YBLThemeColor;
    [doneButton setTitle:buttonTitle forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = YBLFont(16);
    [self.contentView addSubview:doneButton];
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [self dismiss];
    }];

    
}


- (void)dismiss{
    
    [YBLMethodTools transformCloseView:selectAddressView.contentView SuperView:selectAddressView fromeVC:selectAddressView.Vc Top:YBLWindowHeight completion:^(BOOL finished) {
        [selectAddressView removeFromSuperview];
        selectAddressView = nil;
    }];
    
}

@end
