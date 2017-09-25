//
//  YBLButtonsView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , ButtonsType) {
    ButtonsTypeSingleSelect = 0,
    ButtonsTypeMuttipleSelect
};

typedef void(^ButtonsViewClickBlock)(id selectValue,NSInteger index);

@interface YBLButtonsView : UIView

@property (nonatomic, assign) BOOL isItemEnable;

@property (nonatomic, copy  ) ButtonsViewClickBlock buttonsViewClickBlock;

@property (nonatomic, assign) NSInteger currentIndex;

- (void)updateTextDataArray:(NSMutableArray *)textDataArray title:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame
                  buttonsType:(ButtonsType)buttonsType
                textDataArray:(NSMutableArray *)textDataArray
                        title:(NSString *)title;
@end
