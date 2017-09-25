//
//  YBLGuideView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGuideView.h"

static YBLGuideView *guideView = nil;

@interface YBLGuideView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy  ) GuideViewDoneBlock doneBlock;

@end

@implementation YBLGuideView

+ (void)showGuideViewWithDataArray:(NSMutableArray *)dataArray doneBlock:(GuideViewDoneBlock)doneBlock{
    
    if (!guideView) {
        guideView = [[YBLGuideView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)
                                              dataArray:dataArray
                                              doneBlock:doneBlock];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:guideView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSMutableArray *)dataArray
                    doneBlock:(GuideViewDoneBlock)doneBlock{

    self = [super initWithFrame:frame];
    if (self) {
        
        _dataArray = dataArray;
        _doneBlock = doneBlock;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
	
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:[self bounds]];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    [self addSubview:self.contentScrollView];
    
    NSInteger index = 0;
    for (NSString *imageName in _dataArray) {
        
        UIImageView *guideImageView = [[UIImageView alloc] initWithImage:[UIImage contentFileWithName:imageName Type:@"png"]];
        guideImageView.frame = [self.contentScrollView bounds];
        guideImageView.left = index*self.contentScrollView.width;
        [self.contentScrollView addSubview:guideImageView];
        
        if (index == _dataArray.count-1) {
            guideImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *imageClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lastImageViewClick:)];
            [guideImageView addGestureRecognizer:imageClick];
            self.contentScrollView.contentSize = CGSizeMake(guideImageView.right, self.contentScrollView.height);
        }
        
        index++;
    }
}

- (void)lastImageViewClick:(UITapGestureRecognizer *)tap {
	
    [self dismissMethod];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger count_for_image = _dataArray.count;
    CGFloat total_value = (float)(count_for_image-1)*self.width+scrollLimitSpace;
    if (offsetX >= total_value) {
        [self dismissMethod];
    }
}

- (void)dismissMethod{
    BLOCK_EXEC(self.doneBlock,)
    [self dismissView];
}

- (void)dismissView{
    
    guideView.alpha = 1;
    
    [UIView animateWithDuration:.5 animations:^{
        
        guideView.alpha = 0;
        guideView.right = 0;
        
    } completion:^(BOOL finished) {
        
        [guideView removeFromSuperview];
        guideView = nil;
    }];
}

@end
