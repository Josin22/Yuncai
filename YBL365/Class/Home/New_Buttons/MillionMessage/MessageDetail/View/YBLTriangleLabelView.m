//
//  YBLTriangleLabelView.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTriangleLabelView.h"

//2. implementation file
@implementation YBLInsertLabel

@synthesize insets=_insets;
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}
-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}
-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end

@interface YBLTriangleLabelView ()

@property (nonatomic, assign) TriangleDirection direction;

@end

@implementation YBLTriangleLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame direction:TriangleDirectionLeft];
}

- (instancetype)initWithFrame:(CGRect)frame direction:(TriangleDirection)direction
{
    self = [super initWithFrame:frame];
    if (self) {
        _direction = direction;
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.contentLabel = [[YBLInsertLabel alloc] initWithFrame:CGRectMake(space, 0, self.width-space, self.height)];
    self.contentLabel.textColor = YBLTextColor;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = YBLFont(13);
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    self.contentLabel.layer.borderColor = YBLLineColor.CGColor;
    self.contentLabel.layer.borderWidth = 0.5f;;
    self.contentLabel.layer.cornerRadius = 3;
    self.contentLabel.layer.masksToBounds = YES;
    CGFloat textSpace = 5;
    self.contentLabel.insets = UIEdgeInsetsMake(0, textSpace, 0, textSpace);
    [self addSubview:self.contentLabel];

}

- (void)setFin_height:(CGFloat)fin_height{
    _fin_height = fin_height;
    self.contentLabel.height = _fin_height;
    self.height = _fin_height;
}

@end
