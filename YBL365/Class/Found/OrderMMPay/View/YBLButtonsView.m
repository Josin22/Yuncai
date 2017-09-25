//
//  YBLButtonsView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLButtonsView.h"
#import "YBLpurchaseInfosModel.h"

static NSInteger const tag_button = 220;

@interface YBLButtonsView ()

@property (nonatomic, assign) ButtonsType buttonsType;

@property (nonatomic, strong) NSMutableArray *textDataArray;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSString *title;

@end

@implementation YBLButtonsView

- (instancetype)initWithFrame:(CGRect)frame
                  buttonsType:(ButtonsType)buttonsType
                textDataArray:(NSMutableArray *)textDataArray
                        title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _title = title;
        _buttonsType = buttonsType;
        _textDataArray = textDataArray;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{

    self.currentIndex = -1;
    
    CGFloat top_view = 0;
    if (_title) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0,self.width-2*space, 30)];
        self.titleLabel.textColor = BlackTextColor;
        self.titleLabel.font = YBLFont(14);
        [self addSubview:self.titleLabel];
        top_view = self.titleLabel.bottom;
    }
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, top_view, self.width, self.height - top_view)];
    self.contentView.backgroundColor = YBLViewBGColor;
    [self addSubview:self.contentView];
    
    [self updateTextDataArray:_textDataArray title:_title];
    
}

- (void)updateTextDataArray:(NSMutableArray *)textDataArray title:(NSString *)title{
    _textDataArray = textDataArray;
    if (title) {
        _title = title;
        self.titleLabel.text = _title;
    }
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    NSInteger index = 0;
    NSInteger count = _textDataArray.count;
    NSInteger payshiping_lie = count>3?3:count;
    
    CGFloat itemWi = (self.width-4*space)/payshiping_lie;
    CGFloat itemHi = 40;
    
    for (id obj in _textDataArray) {
        
        NSString *title = nil;
        BOOL isSelect = NO;
        BOOL isActive = YES;
        if ([obj isKindOfClass:[NSString class]]) {
            title = (NSString *)obj;
        } else if ([obj isKindOfClass:[YBLPurchaseInfosModel class]]){
            YBLPurchaseInfosModel *infoModel = (YBLPurchaseInfosModel *)obj;
            title = infoModel.title;
            isSelect = infoModel.is_select;
            isActive = infoModel.active.boolValue;
        }
//        CGSize titleSize = [title heightWithFont:YBLFont(13) MaxWidth:itemWi];
        NSInteger row = index/payshiping_lie;
        NSInteger col = index%payshiping_lie;
        CGRect frame = CGRectMake(space+col*(itemWi+space), space+row*(itemHi+space), itemWi, itemHi);
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = frame;
        [itemButton setTitle:title forState:UIControlStateNormal];
        [itemButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [itemButton setTitleColor:YBLTextColor forState:UIControlStateDisabled];
        [itemButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemButton setBackgroundColor:YBLThemeColor forState:UIControlStateSelected];
        [itemButton setBackgroundColor:YBLLineColor forState:UIControlStateDisabled];
        itemButton.titleLabel.font = YBLFont(13);
        itemButton.titleLabel.numberOfLines = 0;
        itemButton.centerX = (self.width/(payshiping_lie*2))*(col*2+1);
        itemButton.layer.cornerRadius = 3;
        itemButton.layer.masksToBounds = YES;
        itemButton.enabled = isActive;
        itemButton.tag = tag_button+index;
//        itemButton.layer.borderWidth = .5;
//        itemButton.layer.borderColor = YBLLineColor.CGColor;
        itemButton.selected = isSelect;
        [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemButton];
        index++;
        if (index == count) {
            self.contentView.height = itemButton.bottom+space;
            self.height = self.contentView.bottom;
        }
    }
    
}

- (void)itemClick:(UIButton *)btn{

    NSInteger btnIndex = btn.tag-tag_button;
    id model = self.textDataArray[btnIndex];
    
    if (self.currentIndex!=btnIndex) {
        if (self.currentIndex == -1) {
            self.currentIndex = 0;
        }
//        id curren_model = self.textDataArray[self.currentIndex];
        UIButton *currentButton = (UIButton *)[self viewWithTag:self.currentIndex+tag_button];
        currentButton.selected = NO;
//        if ([curren_model isKindOfClass:[YBLPurchaseInfosModel class]]) {
//            YBLPurchaseInfosModel *curren_new_model = (YBLPurchaseInfosModel *)curren_model;
//            curren_new_model.is_select = NO;
//        }
        
//        if ([model isKindOfClass:[YBLPurchaseInfosModel class]]) {
//            YBLPurchaseInfosModel *curren_new_model = (YBLPurchaseInfosModel *)model;
//            curren_new_model.is_select = YES;
//        }
        btn.selected = YES;
        self.currentIndex = btnIndex;
        
    } else {
        btn.selected = !btn.selected;
    }
    if (!btn.selected) {
        model =  nil;
    }
    
     BLOCK_EXEC(self.buttonsViewClickBlock,model,btnIndex)
}

- (void)resetIndex:(NSInteger)index{
    id model = self.textDataArray[index];
    if ([model isKindOfClass:[YBLPurchaseInfosModel class]]) {
        YBLPurchaseInfosModel *curren_new_model = (YBLPurchaseInfosModel *)model;
        curren_new_model.is_select = YES;
    }
}

- (void)setIsItemEnable:(BOOL)isItemEnable{
    _isItemEnable = isItemEnable;
    
    for (int i = 0; i<_textDataArray.count; i++) {
        UIButton *itemButton = (UIButton *)[self viewWithTag:tag_button+i];
        itemButton.enabled = _isItemEnable;
    }
}

@end
