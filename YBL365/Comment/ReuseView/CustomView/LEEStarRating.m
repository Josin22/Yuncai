
#import "LEEStarRating.h"

#define STARCOUNT starCount

#define SPACING self.spacing

#define SELFWIDTH CGRectGetWidth(self.frame)

#define SELFHEIGHT CGRectGetHeight(self.frame)

#define X(view) view.frame.origin.x

#define Y(view) view.frame.origin.y

#define WIDTH(view) CGRectGetWidth(view.frame)

#define HEIGHT(view) CGRectGetHeight(view.frame)

@interface LEEStarRating ()

@property (nonatomic , strong ) UIView *checkedImagesView; // 已选中星星图片视图

@property (nonatomic , strong ) UIView *uncheckedImagesView; // 未选中星星图片视图

@end

@implementation LEEStarRating
{
    CGSize starSize;
    
    NSUInteger starCount;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame Count:5];
}

- (instancetype)initWithFrame:(CGRect)frame Count:(NSUInteger)count
{
    starCount = count;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化数据
        
        [self initData];
        
        // 初始化子视图
        
        [self initSubViews];
        
        // 设置布局
        
        [self configLayout];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 重新设置布局
    
    [self configLayout];
}

- (void)initData{
    
    // 设置默认值
    
    _spacing = 5.0f;
    
    _minimumScore = 0.0f;
    
    _maximumScore = 5.0f;
    
    _currentScore = 0.0f;
    
    _type = RatingTypeWhole;
}

- (void)initSubViews{
    
    // 初始化已选中和未选中图片视图
    
    _uncheckedImagesView = [[UIView alloc] init];
    
    [self addSubview:_uncheckedImagesView];
    
    _checkedImagesView = [[UIView alloc] init];
    
    _checkedImagesView.clipsToBounds = YES;
    
    [self addSubview:_checkedImagesView];
    
    // 循环初始化已选中和未选中子视图
    
    for (NSInteger i = 0; i < STARCOUNT; i++) {
        
        UIImageView *uncheckedImage = [[UIImageView alloc] initWithImage:self.uncheckedImage];
        
        [self.uncheckedImagesView addSubview:uncheckedImage];
        
        UIImageView *checkedImage = [[UIImageView alloc] initWithImage:self.checkedImage];
        
        [self.checkedImagesView addSubview:checkedImage];
    }
    
}

- (void)configLayout{
    
    // 宽度或高度发生改变 更新子视图布局
    
    if (WIDTH(self.uncheckedImagesView) != SELFWIDTH ||
        HEIGHT(self.uncheckedImagesView) != starSize.height) {
        
        self.uncheckedImagesView.frame = CGRectMake(0, 0, SELFWIDTH, starSize.height);
        
        self.uncheckedImagesView.center = CGPointMake(SELFWIDTH * 0.5f, SELFHEIGHT * 0.5f);
        
        self.checkedImagesView.frame = CGRectMake(0, Y(self.uncheckedImagesView), WIDTH(self.checkedImagesView), starSize.height);
        
        for (NSInteger i = 0; i < STARCOUNT; i++) {
            
            UIImageView *uncheckedImage = self.uncheckedImagesView.subviews[i];
            
            UIImageView *checkedImage = self.checkedImagesView.subviews[i];
            
            CGRect imageFrame = CGRectMake(i ? (starSize.width + SPACING) * i + SPACING : SPACING, 0, starSize.width, starSize.height);
            
            uncheckedImage.frame = imageFrame;
            
            checkedImage.frame = imageFrame;
        }
        
    }
    
}

#pragma mark - Setter

- (void)setFrame:(CGRect)frame{
    
    // 计算星星大小
    
    if (frame.size.width) {
        
        NSAssert(STARCOUNT * SPACING < SELFWIDTH, @"间距过长 已超出视图大小");
        
        CGFloat size = (frame.size.width - (STARCOUNT + 1) * SPACING) / STARCOUNT ? : 0;
        
        starSize = CGSizeMake(size, size);
    }
    
    // 如果当前高度不等于于星星高度 则设置当前高度为星星高度
    
    if (frame.size.height != starSize.height) frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, starSize.height);
    
    [super setFrame:frame];
}

- (void)setSpacing:(CGFloat)spacing{
    
    _spacing = spacing;
    
    self.frame = self.frame;
}

- (void)setTouchEnabled:(BOOL)touchEnabled{
    
    _touchEnabled = touchEnabled;
    
    if (touchEnabled) {
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
        
        [self addGestureRecognizer:tapGesture];
    }
    
}

- (void)setSlideEnabled:(BOOL)slideEnabled{
    
    _slideEnabled = slideEnabled;
    
    if (slideEnabled) {
        
        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureEvent:)];
        
        [self addGestureRecognizer:panGesture];
    }
    
}

- (void)setUncheckedImage:(UIImage *)uncheckedImage{
    
    _uncheckedImage = uncheckedImage;
    
    [self.uncheckedImagesView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        imageView.image = uncheckedImage;
    }];
}

- (void)setCheckedImage:(UIImage *)checkedImage{
    
    _checkedImage = checkedImage;
    
    [self.checkedImagesView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        imageView.image = checkedImage;
    }];
}

- (void)setCurrentScore:(CGFloat)currentScore{
    
    NSAssert(self.minimumScore <= currentScore, @"当前分数小于最小分数");
    
    NSAssert(self.maximumScore >= currentScore, @"当前分数大于最大分数");
    
    if (currentScore < self.minimumScore) currentScore = self.minimumScore;
    
    if (currentScore > self.maximumScore) currentScore = self.maximumScore;
    
    [self updateStarView:(currentScore - self.minimumScore) / (self.maximumScore - self.minimumScore)];
}

- (void)setMinimumScore:(CGFloat)minimumScore{
    
    _minimumScore = minimumScore;
    
    NSAssert(minimumScore >= 0, @"最小分数不能小于0");
}

- (void)setMaximumScore:(CGFloat)maximumScore{
    
    _maximumScore = maximumScore;
    
    NSAssert(maximumScore > 0, @"最大分数不能小于0");
    
    NSAssert(maximumScore > self.minimumScore, @"最大分数不能小于最小分数");
}

- (void)setCurrentScoreChangeBlock:(void (^)(CGFloat))currentScoreChangeBlock{
    
    _currentScoreChangeBlock = currentScoreChangeBlock;
    
    if (currentScoreChangeBlock) currentScoreChangeBlock(self.currentScore);
}

#pragma mark - Action

- (void)tapGestureEvent:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:self];
    
    [self updateStarView:[self pointToRatio:point]];
}

- (void)panGestureEvent:(UITapGestureRecognizer *)pan{
    
    CGPoint point = [pan locationInView:self];
    
    [self updateStarView:[self pointToRatio:point]];
}

#pragma mark - Tools

- (CGFloat)pointToRatio:(CGPoint)point{
    
    // 坐标 转 所选中的比例
    
    CGFloat ratio = 0.0f;
    
    if (SPACING > point.x) {
        
        ratio = 0.0f;
        
    } else if (SELFWIDTH - SPACING < point.x) {
        
        ratio = 1.0f;
        
    } else {
        
        /* 比例转换
         *
         * 当前点击位置在当前视图宽度中的比例 转换为 当前点击星星位置在全部星星宽度中的比例
         * 当前点击位置去除其中的间距宽度等于星星的宽度 point.x - 间距 = 所选中的星星宽度
         * 所选中的星星宽度 / 所有星星宽度 = 当前选中的比例
         */
        
        CGFloat itemWidth = SPACING + starSize.width;
        
        CGFloat icount = point.x / itemWidth;
        
        NSInteger count = floorf(icount);
        
        CGFloat added = (itemWidth * (icount - count));
        
        added = added >= SPACING ? SPACING : added;
        
        CGFloat x = point.x - SPACING * count - added;
        
        ratio = x / (starSize.width * STARCOUNT);
    }
    
    return ratio;
}

#pragma mark - 更新星星视图 传入当前所选中的比例值

- (void)updateStarView:(CGFloat)ratio{
    
    if (ratio < 0) return;
    
    if (ratio > 1) return;
    
    CGFloat width = 0.0f;
    
    // 根据类型计算比例和宽度
    
    switch (self.type) {
            
        case RatingTypeWhole:
        {
            ratio = ceilf(STARCOUNT * ratio);
            
            width = starSize.width * ratio + (SPACING * roundf(ratio));
        }
            break;
            
        case RatingTypeHalf:
        {
            
            ratio = STARCOUNT * ratio;
            
            CGFloat z = floorf(ratio);
            
            CGFloat s = ratio - z;
            
            if (s >= 0.5f) ratio = z + 1.0f;
            
            if (s < 0.5f && s > 0.001f) ratio = z + 0.5f;
            
            width = starSize.width * ratio + (SPACING * roundf(ratio));
        }
            break;
            
        case RatingTypeUnlimited:
            
            ratio = STARCOUNT * ratio;
            
            width = starSize.width * ratio + (SPACING * ceilf(ratio));
            
            break;
            
        default:
            break;
    }
    
    // 设置宽度
    
    if (width < 0) width = 0;
    
    if (width > SELFWIDTH) width = SELFWIDTH;
    
    CGRect checkedImagesViewFrame = self.checkedImagesView.frame;
    
    checkedImagesViewFrame.size.width = width;
    
    self.checkedImagesView.frame = checkedImagesViewFrame;
    
    // 设置当前分数
    
    NSDecimalNumber *numRatio = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.4lf", ratio / STARCOUNT]];
    
    NSDecimalNumber *numScore = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.4lf", self.maximumScore - self.minimumScore]];
    
    NSDecimalNumber *numResult = [numRatio decimalNumberByMultiplyingBy:numScore];
    
    CGFloat currentScore = numResult.floatValue + self.minimumScore;
    
    if (currentScore < self.minimumScore) currentScore = self.minimumScore;
    
    if (currentScore > self.maximumScore) currentScore = self.maximumScore;
    
    if (_currentScore != currentScore) {
        
        _currentScore = currentScore;
        
        if (self.currentScoreChangeBlock) self.currentScoreChangeBlock(self.currentScore);
    }
    
}

@end
