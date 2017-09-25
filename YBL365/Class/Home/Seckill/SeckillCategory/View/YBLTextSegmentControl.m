//
//  YBLTextSegmentControl.m
//  YBL365
//
//  Created by 乔同新 on 12/23/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLTextSegmentControl.h"
#import "YBLCategoryTreeModel.h"
#import "YBLGetProductShippPricesModel.h"

static NSInteger BUTTON_TAG = 887;

static NSInteger BUTTON_TAG_DIR = 487;

@interface YBLTextSegmentControl ()
{
    BOOL isShow;
    NSInteger selectIndex;
}
@property (nonatomic, assign) TextSegmentType type;

@property (nonatomic, strong) UIButton *directionButton;
@property (nonatomic, strong) UIScrollView *textScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *allHeaderView;
@property (nonatomic, retain) UILabel *allLabel;
@property (nonatomic, strong) UIView *rightViewButton;


@end

@implementation YBLTextSegmentControl

- (instancetype)initWithFrame:(CGRect)frame TextSegmentType:(TextSegmentType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _textFont = YBLFont(16);
        [self createTextSegmentUI];
    }
    return self;
}

- (void)createTextSegmentUI{
    
    self.backgroundColor = [UIColor whiteColor];
    isShow = NO;
    selectIndex = 0;
    if (_type == TextSegmentTypeGoodsDetail) {
        self.height = 44;
    }
    
    _textScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _textScrollView.pagingEnabled = NO;
    _textScrollView.showsHorizontalScrollIndicator = NO;
    _textScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_textScrollView];

    if (_type == TextSegmentTypeCategoryArrow) {
        
        _textScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.height);
        _allHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width-self.height-0/.5, self.height)];
        _allHeaderView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_allHeaderView];
        
        self.rightViewButton.hidden = NO;
        
        [_directionButton addTarget:self action:@selector(showAllCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        _allLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.height-20)/2, self.width/2, 20)];
        _allLabel.textColor = YBLTextColor;
        _allLabel.font = YBLFont(14);
        [_allHeaderView addSubview:_allLabel];
        
        _allHeaderView.hidden = YES;
    } else if (_type == TextSegmentTypeLocationArrow) {
        
        self.rightViewButton.hidden = NO;
        [self.directionButton setImage:[UIImage imageNamed:@"purchase_order_home_local"] forState:UIControlStateNormal];
        [_directionButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UIView *)rightViewButton{
    if (!_rightViewButton) {
        UIView *rightViewButton = [[UIView alloc] initWithFrame:CGRectMake(self.width-self.height, 0, self.height, self.height)];
        rightViewButton.backgroundColor = [UIColor whiteColor];
        _rightViewButton = rightViewButton;
        [self addSubview:_rightViewButton];
        [YBLMethodTools addLeftShadowToView:_rightViewButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, rightViewButton.height)];
        line.backgroundColor = YBLLineColor;
        [rightViewButton addSubview:line];
        
        _directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _directionButton.frame = CGRectMake(0.5, 0, rightViewButton.width, rightViewButton.width);
        _directionButton.tag = BUTTON_TAG_DIR;
        [_directionButton setImage:[UIImage imageNamed:@"jshop_category_arrow_down"] forState:UIControlStateNormal];
        _directionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _directionButton.titleLabel.font = YBLFont(9);
        _directionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_directionButton setTitleColor:YBLTextLightColor forState:UIControlStateNormal];
        [rightViewButton addSubview:_directionButton];

        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        bottomLine.backgroundColor = YBLLineColor;
        [self addSubview:bottomLine];
    }
    return _rightViewButton;
}

- (void)updateTitleData:(NSMutableArray *)data{
    self.dataArray = data;
        
    for (UIView *view in self.textScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger count = data.count;
    CGFloat arrowWi = 0;
    CGFloat all_wi = 0;
    
    for (int i = 0; i<count; i++) {
        
        NSString *text = nil;
        id re = data[i];
        if ([re isKindOfClass:[YBLCategoryTreeModel class]]) {
            YBLCategoryTreeModel *model = (YBLCategoryTreeModel *)re;
            text = model.title;
        }
        if ([re isKindOfClass:[YBLExpressCompanyItemModel class]]) {
            YBLExpressCompanyItemModel *model = (YBLExpressCompanyItemModel *)re;
            text = model.title;
        }
        if ([re isKindOfClass:[NSString class]]){
            text = data[i];;
        }
        CGSize textSize = [text heightWithFont:_textFont MaxWidth:200];
        CGFloat width = textSize.width;
        CGRect frame = CGRectMake(space+all_wi, 0, width, self.height);
        if (_type == TextSegmentTypeGoodsDetail) {
            frame = CGRectMake(i*self.width/count, 0, self.width/count, self.height);
        }
  
        UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        textButton.frame = frame;
        [textButton setTitle:text forState:UIControlStateNormal];
        [textButton setTitleColor:YBLColor(40, 40, 40, 1) forState:UIControlStateNormal];
        [textButton setTitleColor:YBLThemeColor forState:UIControlStateSelected];
        [textButton setBackgroundColor:[UIColor clearColor]];
        if (selectIndex==i) {
            textButton.selected = YES;
            _lineView= [[UIView alloc] initWithFrame:CGRectMake(textButton.left, _textScrollView.height-2, textButton.width, 2)];
            _lineView.backgroundColor = YBLThemeColor;
            [_textScrollView addSubview:_lineView];
            if (_type == TextSegmentTypeGoodsDetail) {
                _lineView.width = textSize.width;
                _lineView.centerX = textButton.centerX;
            }
        }
        textButton.tag = BUTTON_TAG+i;
        [textButton addTarget:self action:@selector(textButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        textButton.titleLabel.font = _textFont;
        [_textScrollView addSubview:textButton];
        
        all_wi += (width+space);
    }
    
    if (_type == TextSegmentTypeCategoryArrow) {
        _allLabel.text = [NSString stringWithFormat:@"全部%@分类",@(count-1)];
    }
    _textScrollView.contentSize = CGSizeMake(all_wi+arrowWi, self.height);
    
}

- (void)showLocation:(UIButton *)btn{
    
    BLOCK_EXEC(self.textSegmentControlShowAllBlock,isShow);
}

- (void)showAllCategory:(UIButton *)btn{
    
    isShow = !isShow;
    _allHeaderView.hidden = !isShow;
    [UIView animateWithDuration:0.3
                     animations:^{
                         btn.transform = CGAffineTransformRotate(btn.transform, M_PI);
                     }
                     completion:^(BOOL finished) {}];

    BLOCK_EXEC(self.textSegmentControlShowAllBlock,isShow);
}

- (void)setCurrentIndex:(NSInteger )currentIndex{
    _currentIndex = currentIndex;
    
    [self doClick:_currentIndex];
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
}

- (void)setEnableSegment:(BOOL)enableSegment{
    _enableSegment = enableSegment;
    self.textScrollView.userInteractionEnabled = _enableSegment;
}

- (void)setSelectLocation:(NSString *)selectLocation{
    _selectLocation = selectLocation;
    CGFloat local_space = 2;
    CGFloat local_height = 10;
    if (_selectLocation.length==0) {
        local_space = 3;
        local_height = 0;
    }
    _directionButton.imageRect = CGRectMake(local_space, local_space, self.rightViewButton.width-local_space*2, self.rightViewButton.width-local_height-local_space*2);
    _directionButton.titleRect = CGRectMake(0, self.rightViewButton.width-local_space-local_height, self.rightViewButton.width, local_height);
    [self.directionButton setTitle:_selectLocation forState:UIControlStateNormal];
}

- (void)defaultView{
    
    UIButton *button = (UIButton *)[self viewWithTag:BUTTON_TAG_DIR];
    _allHeaderView.hidden = YES;
    isShow = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         button.transform = CGAffineTransformRotate(button.transform, M_PI);
                     }
                     completion:^(BOOL finished) {
                     }];
    
}

- (void)textButtonClick:(UIButton *)btn{

    NSInteger tag = btn.tag-BUTTON_TAG;
    
    [self doClick:tag];
}

- (void)doClick:(NSInteger)tag{
    
    UIButton *button = (UIButton *)[self viewWithTag:tag+BUTTON_TAG];
    if (_type != TextSegmentTypeGoodsDetail) {
        
        if (button.left>self.width/2) {
            [_textScrollView setContentOffset:CGPointMake(button.left-self.width/2, 0) animated:YES];
        } else {
            [_textScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    if (selectIndex != tag) {
        
        UIButton *currentButton = (UIButton *)[self viewWithTag:selectIndex+BUTTON_TAG];
        currentButton.selected = NO;
        button.selected = YES;
        selectIndex = tag;
        
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             if (_type == TextSegmentTypeGoodsDetail) {
                                 CGSize textSize = [button.currentTitle heightWithFont:YBLFont(16) MaxWidth:200];
                                 _lineView.width = textSize.width;
                                 _lineView.centerX = button.centerX;
                             } else {
                                 _lineView.left = button.left;
                                 _lineView.width = button.width;
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        if ([self.delegate respondsToSelector:@selector(textSegmentControlIndex:)]) {
            [self.delegate textSegmentControlIndex:selectIndex];
        }
        if ([self.delegate respondsToSelector:@selector(textSegmentControlIndex:selectModel:)]) {
            [self.delegate textSegmentControlIndex:selectIndex selectModel:self.dataArray[selectIndex]];
        }
    }
}


@end
