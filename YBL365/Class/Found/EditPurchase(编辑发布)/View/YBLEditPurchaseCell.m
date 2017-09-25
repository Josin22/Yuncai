//
//  YBLEditPurchaseCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPurchaseCell.h"

@interface YBLEditPurchaseCell ()

@end

@implementation YBLEditPurchaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:NO];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI:YES];
    }
    return self;
}

- (void)createUI:(BOOL)isCell{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat height = 0;
    
    if (isCell) {
        height = 50;
    } else {
        height = self.height<50?50:self.height;
        self.height = height;
    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 80, 20)];
    textLabel.textColor = BlackTextColor;
    textLabel.centerY = height/2;
    textLabel.font = YBLFont(14);
    [self.contentView addSubview:textLabel];
    self.ttLabel = textLabel;
    
    self.valueTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(textLabel.right+space/2, 0, YBLWindowWidth-textLabel.right-space*2-30, height)];
    self.valueTextFeild.font = YBLFont(14);
    self.valueTextFeild.textColor = BlackTextColor;
    self.valueTextFeild.borderStyle = UITextBorderStyleNone;
    self.valueTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.valueTextFeild addTarget:self action:@selector(textFieldsChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.valueTextFeild];
    
    self.valueTextLabel = [[UILabel alloc] initWithFrame:self.valueTextFeild.frame];
    self.valueTextLabel.numberOfLines = 0;
    self.valueTextLabel.font = YBLFont(14);
    self.valueTextLabel.textColor = BlackTextColor;
    [self.contentView addSubview:self.valueTextLabel];
    self.valueTextLabel.hidden = YES;
    
    UIButton *maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    maskButton.frame = self.valueTextFeild.frame;
    [self.contentView addSubview:maskButton];
    self.maskButton = maskButton;
    
    self.good_switch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.good_switch.onTintColor = YBLThemeColor;
    self.good_switch.right = YBLWindowWidth-space;
    self.good_switch.centerY = height/2;
    [self.contentView addSubview:self.good_switch];
    self.good_switch.hidden = YES;
    
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    arrowButton.frame = CGRectMake(self.valueTextFeild.right+space, 0, 30, 30);
    arrowButton.centerY = height/2;
    [self.contentView addSubview:arrowButton];
    self.arrowButton = arrowButton;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, height-0.5, YBLWindowWidth-space, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
}

- (void)resetEditTypeCell:(EditTypeCell)editTypeCell{
    
    if (editTypeCell == EditTypeCellOnlyWrite) {
        
        self.arrowButton.hidden = YES;
        self.maskButton.hidden = YES;
        self.good_switch.hidden = YES;
        self.valueTextFeild.hidden = NO;
        self.valueTextLabel.hidden = YES;
        
    } else if (editTypeCell == EditTypeCellOnlyClick) {

        self.arrowButton.hidden = NO;
        self.valueTextFeild.hidden = YES;
        self.valueTextLabel.hidden = NO;
        self.maskButton.hidden = NO;
        self.good_switch.hidden = YES;
        self.arrowButton.userInteractionEnabled = NO;
        
    } else if (editTypeCell == EditTypeCellWriteAndClick) {
        
        self.arrowButton.userInteractionEnabled = YES;
        self.arrowButton.hidden = NO;
        self.valueTextFeild.hidden = NO;
        self.valueTextLabel.hidden = YES;
        self.maskButton.hidden = YES;
        self.good_switch.hidden = YES;
        
    } else if (editTypeCell == EditTypeCellOnlySwith) {
        
        self.arrowButton.hidden = YES;
        self.good_switch.hidden = NO;
        self.valueTextFeild.hidden = YES;
        self.valueTextLabel.hidden = YES;
        self.maskButton.hidden = YES;
        
    } else if (editTypeCell == EditTypeCellSwithWrite) {
        
        self.arrowButton.hidden = YES;
        self.good_switch.hidden = NO;
        self.valueTextFeild.hidden = NO;
        self.valueTextLabel.hidden = YES;
        self.maskButton.hidden = YES;
        
    } else if (editTypeCell == EditTypeCellNoWriteClick){

        self.arrowButton.hidden = YES;
        self.valueTextFeild.hidden = NO;
        self.maskButton.hidden = NO;
        self.good_switch.hidden = YES;
        self.valueTextFeild.hidden = YES;
        self.valueTextLabel.hidden = NO;
        self.arrowButton.userInteractionEnabled = NO;
    }
}

- (void)updateItemCellModel:(id)itemModel{
    
    YBLEditItemGoodParaModel *model = (YBLEditItemGoodParaModel *)itemModel;
 
    self.lineView.bottom = self.height;
    [self resetEditTypeCell:model.editTypeCell];
    if ([model.value hasPrefix:@"0"]) {
        self.valueTextFeild.placeholder = @"0";
        self.valueTextFeild.text = @"0";
    } else {
        self.valueTextFeild.text = model.value;
    }
    self.valueTextLabel.text = model.value;
    self.valueTextFeild.keyboardType = model.keyboardType;
    self.ttLabel.text = model.title;
    self.ttLabel.centerY = self.height/2;
    CGSize textSize = [model.title heightWithFont:YBLFont(14) MaxWidth:200];
    self.ttLabel.width = textSize.width;
    self.valueTextFeild.placeholder = model.placeholder;
    self.valueTextFeild.left = self.ttLabel.right+space/2;
    CGFloat arrowWi = 40;
    self.arrowButton.centerY = self.height/2;
    NSString *arrow_image = nil;
    if (self.arrowButton.isHidden) {
        arrowWi = 0;
    } else {
        if (model.arrow_image) {
            arrow_image = model.arrow_image;
        } else {
            arrow_image = @"right_arrow";
        }
    }
    [self.arrowButton setImage:[UIImage imageNamed:arrow_image] forState:UIControlStateNormal];
    self.valueTextFeild.width = YBLWindowWidth-self.ttLabel.right-arrowWi-space;
    self.valueTextFeild.height = self.height;
    self.valueTextLabel.frame = self.valueTextFeild.frame;
    self.maskButton.left = self.valueTextFeild.left;
    self.maskButton.width = self.valueTextFeild.width+space+self.arrowButton.width;
    self.maskButton.height = self.height;
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    YBLEditItemGoodParaModel *model = (YBLEditItemGoodParaModel *)itemModel;
    EditTypeCell editTypeCell = model.editTypeCell;
    CGFloat finalHeight = 50;
    if (editTypeCell == EditTypeCellOnlyClick) {
        if (model.value.length>0) {
            CGSize textSize = [model.title heightWithFont:YBLFont(14) MaxWidth:200];
            CGSize valueSize = [model.value heightWithFont:YBLFont(17) MaxWidth:YBLWindowWidth-textSize.width-space*1.5-30];
            finalHeight = valueSize.height;
        }
    } else if (editTypeCell == EditTypeCellNoWriteClick){
        if (model.value.length>0) {
            CGSize textSize = [model.title heightWithFont:YBLFont(14) MaxWidth:200];
            CGSize valueSize = [model.value heightWithFont:YBLFont(17) MaxWidth:YBLWindowWidth-textSize.width-space*2];
            finalHeight = valueSize.height;
        }
    } else {
        finalHeight = 50;
    }
    return finalHeight<50?50:finalHeight;
}

@end
