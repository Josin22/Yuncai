//
//  YBLSeckillCategoryView.m
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillCategoryView.h"
#import "YBLCategoryTreeModel.h"

static NSInteger BUTTON_TAG = 778;

static NSInteger const bgView_tag = 54;

static YBLSeckillCategoryView *categoryView = nil;

@interface YBLSeckillCategoryView ()

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIScrollView *buttonScrollView;

@property (nonatomic, copy  ) CategoryViewClickBlock categoryViewClickBlock;

@property (nonatomic, copy  ) CategoryViewDismissBlock misBlock;

@end

@implementation YBLSeckillCategoryView

+ (void)showCategoryViewOnView:(UIView *)view
                     DataArray:(NSMutableArray *)dataArray
                   SelectIndex:(NSInteger)index
                   SelectBlock:(CategoryViewClickBlock)block
                  DismissBlock:(CategoryViewDismissBlock)misBlock{
    if (!categoryView) {
        categoryView = [[YBLSeckillCategoryView alloc] initWithFrame:CGRectMake(0, 40, YBLWindowWidth, 0)
                                                              OnView:view
                                                           DataArray:dataArray
                                                         SelectIndex:index
                                                         selectBlock:block
                                                        dismissBlock:misBlock];
        [view addSubview:categoryView];
        
        categoryView.bgView.userInteractionEnabled = NO;
        [UIView animateWithDuration:.4f
                         animations:^{
                             categoryView.bgView.backgroundColor = [BlackTextColor colorWithAlphaComponent:0.5];
                         }
                         completion:^(BOOL finished) {
                             categoryView.bgView.userInteractionEnabled = YES;
                         }];
        

    }
}
- (instancetype)initWithFrame:(CGRect)frame
                       OnView:(UIView *)view
                    DataArray:(NSMutableArray *)dataArray
                  SelectIndex:(NSInteger)index
                  selectBlock:(CategoryViewClickBlock)block
                 dismissBlock:(CategoryViewDismissBlock)misBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _superView = view;
        _dataArray = dataArray;
        _selectIndex = index;
        _categoryViewClickBlock = block;
        _misBlock = misBlock;
        
        [self CategoryUI];
    }
    return self;
}

- (void)CategoryUI{
    
    self.backgroundColor = YBLColor(240, 240, 240, 1);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, YBLWindowWidth, YBLWindowHeight)];
    bgView.backgroundColor = [BlackTextColor colorWithAlphaComponent:0];
    bgView.tag = bgView_tag;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textSegmentDefault)];
    [bgView addGestureRecognizer:tap];
    bgView.userInteractionEnabled = NO;
    [self.superView addSubview:bgView];
    
    self.buttonScrollView = [[UIScrollView alloc] initWithFrame:[self bounds]];
    self.buttonScrollView.backgroundColor = YBLColor(240, 240, 240, 1);
    [self addSubview:self.buttonScrollView];
    
    self.bgView = bgView;
    
    if (self.subviews.count>1) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger count = self.dataArray.count;
    
    int margin = 20;
    int marginRow = 10;
    int width = (self.buttonScrollView.width-margin*5)/4;
    int height = 30;
    
    for (int i = 0; i < count; i++) {
        
        int row = i/4;
        int col = i%4;
        
        CGRect frame = CGRectMake(margin+col*(width+margin), marginRow+5+row*(height+marginRow), width, height);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setTitleColor:YBLColor(138,135,137,1) forState:UIControlStateNormal];
        [button setTitleColor:YBLThemeColor forState:UIControlStateSelected];
        NSString *text = nil;
        id re = self.dataArray[i];
        if ([re isKindOfClass:[YBLCategoryTreeModel class]]) {
            YBLCategoryTreeModel *model = (YBLCategoryTreeModel *)re;
            text = model.title;
        } else {
            text = self.dataArray[i];
        }
        [button setTitle:text forState:UIControlStateNormal];
        button.layer.cornerRadius = height/2;
        button.tag = BUTTON_TAG+i;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = YBLFont(12);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.layer.borderColor = YBLLineColor.CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonScrollView addSubview:button];
        if (_selectIndex == i) {
            button.selected = YES;
            button.layer.borderColor = YBLThemeColor.CGColor;
        }
        if (i == count-1) {
            
            NSInteger col_count = ceil((double)count/4)+1;
            CGFloat frameHeight = col_count*height+(col_count-2)*marginRow;
            self.buttonScrollView.contentSize = CGSizeMake(self.width, frameHeight);
            CGFloat finalHei = frameHeight>YBLWindowHeight/2?YBLWindowHeight/2:frameHeight;;
            self.buttonScrollView.height = finalHei;
            self.height = finalHei;
        }
    }

}

- (void)buttonClick:(UIButton *)btn{
    
    NSString *title = btn.currentTitle;
    
    [YBLSeckillCategoryView dismissView];
    
    BLOCK_EXEC(self.categoryViewClickBlock,title,btn.tag-BUTTON_TAG);
    
}

- (void)textSegmentDefault{
    
    [YBLSeckillCategoryView dismissView];
    
    BLOCK_EXEC(self.misBlock,);
}

+ (void)dismissView{
    
    UIView *bgView = (UIView *)[categoryView.superView viewWithTag:bgView_tag];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         categoryView.alpha = 0;
                         bgView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [categoryView removeFromSuperview];
                         [bgView removeFromSuperview];
                         categoryView = nil;
                     }];
    
}
@end
