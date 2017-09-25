//
//  YBLBannerView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBannerView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@interface YBLBannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer      *timer;
@property (nonatomic, assign) NSInteger    numberOfPages;
@property (nonatomic, assign) BOOL         beginDrag;
@property (nonatomic, strong) NSArray      *viewList;
@property (nonatomic, assign) CGFloat      timeInterval;
@property (nonatomic, strong) NSString     *placeholder;

@end

@implementation YBLBannerView

- (instancetype)initViewWithFrame:(CGRect)frame
                         viewList:(NSArray *)viewList
                     timeInterval:(CGFloat)timeInterval {
    
    if (self = [super initWithFrame:frame]) {
        self.viewList = viewList;
        self.numberOfPages = viewList.count - 2;
        self.timeInterval = timeInterval;
        [self setupContentWithView];
        [self logic];
    }
    return self;
}

- (instancetype)initImageViewWithFrame:(CGRect)frame
                             imageList:(NSArray<NSString *> *)imageList
                          timeInterval:(CGFloat)timeInterval {
    
    if (self = [super initWithFrame:frame]) {
        self.numberOfPages = imageList.count;
        self.timeInterval = timeInterval;
        [self setupContentWithImageView:imageList];
        [self logic];
    }
    return self;
}

- (instancetype)initImageViewWithFrame:(CGRect)frame
                      placeholderImage:(NSString *)placeholder
                             imageList:(NSArray<NSString *> *)imageList
                          timeInterval:(CGFloat)timeInterval {
    
    if (self = [super initWithFrame:frame]) {
        self.numberOfPages = imageList.count;
        self.timeInterval = timeInterval;
        self.placeholder = placeholder;
        [self setupContentWithImageView:imageList];
        [self logic];
    }
    return self;
}

-(void)logic {
    [self addTimer];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setupContentWithImageView:(NSArray *)imageNames {
    NSInteger count = imageNames.count + 2;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSInteger index = i-1;
        if (i == count - 1) {
            index = 0;
        }
        if (i == 0) {
            index = count - 3;
        }
        CGRect rect = CGRectMake(i * Width, 0, Width, Height);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        if ([imageNames[index] hasPrefix:@"http"]) {
            [imageView js_alpha_setImageWithURL:[NSURL URLWithString:imageNames[index]] placeholderImage:self.placeholder];
        }else {
            imageView.image = [UIImage imageNamed:imageNames[index]];
        }
        [self.scrollView addSubview:imageView];
        [array addObject:imageView];
    }
    self.viewList = array;
    [self setupScrollView:count];
}

- (void)setupContentWithView {
    NSInteger count = self.viewList.count;
    for (int i = 0; i < count; i++) {
        UIView *view = self.viewList[i];
        CGRect rect = CGRectMake(i * Width, 0, Width, Height);
        view.frame = rect;
        [self.scrollView addSubview:view];
    }
    [self setupScrollView:count];
}

- (void)setupScrollView:(NSInteger)count {
    self.scrollView.contentSize = CGSizeMake(Width * count, 0);
    self.scrollView.contentOffset = CGPointMake(Width, 0);
}

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval: self.timeInterval target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage {
    NSInteger page = self.pageControl.currentPage + 2;
    [self.scrollView setContentOffset:CGPointMake(page * Width, 0) animated:true];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)offsetLogic {
    if (self.pageControl.currentPage == 0) {
        self.scrollView.contentOffset = CGPointMake(Width, 0);
    }
    if (self.pageControl.currentPage == self.numberOfPages - 1) {
        self.scrollView.contentOffset = CGPointMake(Width * self.numberOfPages, 0);
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (scrollView.contentOffset.x + Width * 0.5) / Width;
    if (page == self.numberOfPages + 1) {
        self.pageControl.currentPage = 0;
    }else if (page == 0) {
        self.pageControl.currentPage = self.numberOfPages - 1;
    }else {
        self.pageControl.currentPage = page - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginDrag = true;
    [self removeTimer];
    [self offsetLogic];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    int page = (scrollView.contentOffset.x + Width * 0.5) / Width;
    if (page == self.numberOfPages + 1) {
        self.scrollView.contentOffset = CGPointMake(Width, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self offsetLogic];
    self.beginDrag = false;
    [self addTimer];
}

#pragma mark - tap action

- (void)tapAction {
    NSInteger index = self.pageControl.currentPage;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAction:didSelectView:)]) {
        [self.delegate selectAction:index didSelectView:(index + 1) < self.viewList.count ? self.viewList[index + 1]: nil];
    }
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        CGFloat width = 15 * self.numberOfPages;
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(Width / 2 - width / 2, CGRectGetHeight(self.scrollView.frame) - 20, width, 20)];
        _pageControl.numberOfPages = self.numberOfPages;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

@end
