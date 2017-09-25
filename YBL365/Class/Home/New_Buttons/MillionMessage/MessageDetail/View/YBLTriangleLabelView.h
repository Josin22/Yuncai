//
//  YBLTriangleLabelView.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLInsertLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;

@end

typedef NS_ENUM(NSInteger,TriangleDirection) {
    TriangleDirectionLeft = 0,
    TriangleDirectionRight,
    TriangleDirectionTop,
    TriangleDirectionBottom
    
};

@interface YBLTriangleLabelView : UIView

@property (nonatomic, retain) YBLInsertLabel *contentLabel;

@property (nonatomic, assign) CGFloat trianglePiontX;

@property (nonatomic, assign) CGFloat fin_height;

@end
