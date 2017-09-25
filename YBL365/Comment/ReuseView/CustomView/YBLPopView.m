//
//  XNPopView.m
//  51XiaoNiu
//
//  Created by 乔同新 on 16/4/14.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLPopView.h"

#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define SPACE 2.f
#define ROW_HEIGHT 40.f
#define TITLE_FONT YBLFont(16)

static YBLPopView *popView = nil;

@interface YBLPopView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic) CGPoint showPoint;

@property (nonatomic, strong) UIButton *handerView;

@end

@implementation YBLPopView

+ (void)showWithPoint:(CGPoint)point
               titles:(NSArray *)titles
               images:(NSArray *)images
            doneBlock:(XNSelectRowAtIndexBlock)doneBlock
         dismissBlock:(XNPopViewDismissBlock)dismissBlock{
    if (!popView) {
        popView = [[YBLPopView alloc] initWithPoint:point
                                             titles:titles
                                             images:images
                                          doneBlock:doneBlock
                                       dismissBlock:dismissBlock];
        [popView show];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithPoint:CGPointMake(YBLWindowWidth/2, kNavigationbarHeight) titles:nil images:nil];
}

-(instancetype)initWithPoint:(CGPoint)point
                      titles:(NSArray *)titles
                      images:(NSArray *)images{
    
    return [self initWithPoint:point
                        titles:titles
                        images:images
                     doneBlock:nil
                  dismissBlock:nil];
}

-(instancetype)initWithPoint:(CGPoint)point
                      titles:(NSArray *)titles
                      images:(NSArray *)images
                   doneBlock:(XNSelectRowAtIndexBlock)doneBlock
                dismissBlock:(XNPopViewDismissBlock)dismissBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        if (doneBlock) {
            _selectRowAtIndexBlock = doneBlock;
        }
        if (dismissBlock) {
            _dismissBlock = dismissBlock;
        }
        self.showPoint = point;
        self.titleArray = titles;
        self.imageArray = images;
        
        self.frame = [self getViewFrame];
        
        [self addSubview:self.tableView];
        
    }
    return self;
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    
    frame.size.height = [self.titleArray count] * ROW_HEIGHT + SPACE + kArrowHeight;
    
    for (NSString *title in self.titleArray) {
        CGFloat width =  [title heightWithFont:TITLE_FONT MaxWidth:300].width;
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([self.titleArray count] == [self.imageArray count]) {
        frame.size.width = 10 + 25 + 10 + frame.size.width + 70;
    }else{
        frame.size.width = 10 + frame.size.width + 40;
    }
    
    if (self.showPoint.x>YBLWindowWidth/2) {
        
        frame.origin.x = YBLWindowWidth - frame.size.width-10;

    } else {
        frame.origin.x = self.showPoint.x - frame.size.width/2;
    }
    
    frame.origin.y = self.showPoint.y;
    
    //左间隔最小5x
    if (frame.origin.x < 5) {
        frame.origin.x = 5;
    }
//    //右间隔最小5x
//    if ((frame.origin.x + frame.size.width) > 315) {
//        frame.origin.x = 315 - frame.size.width;
//    }
    
    return frame;
}

-(void)show
{
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];

    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    
    self.frame = [self getViewFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = .9f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismiss
{
    
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
        if (popView) {
            [popView removeFromSuperview];
            popView = nil;
        }
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}


#pragma mark - UITableView

-(UITableView *)tableView
{
    if (!_tableView) {
        
        CGRect rect = self.frame;
        rect.origin.x = SPACE;
        rect.origin.y = kArrowHeight + SPACE;
        rect.size.width -= SPACE * 2;
        rect.size.height -= (SPACE - kArrowHeight);
        
        self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.alwaysBounceHorizontal = NO;
        _tableView.alwaysBounceVertical = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = ROW_HEIGHT;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    
    if ([_imageArray count] == [_titleArray count]) {
        cell.imageView.image = [UIImage newImageWithNamed:[_imageArray objectAtIndex:indexPath.row]
                                                     size:CGSizeMake(25, 25)];
    }
    cell.textLabel.font = YBLFont(15);
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.row != _titleArray.count-1) {
        CGRect newfame = [self getViewFrame];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, ROW_HEIGHT-0.5, newfame.size.width-15, 0.5)];
        lineView.backgroundColor = YBLColor(90, 90, 90, 1);
        [cell.contentView addSubview:lineView];
    }
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectRowAtIndexBlock) {
        self.selectRowAtIndexBlock(indexPath.row);
    }
    [self dismiss:YES];
}

- (void)drawRect:(CGRect)rect
{
    
    CGRect frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];//左上角
    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
    /********************向上的箭头**********************/
    [popoverPath addCurveToPoint:arrowPoint
                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
                   controlPoint2:arrowPoint];//actual arrow point
    
    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
                   controlPoint1:arrowPoint
                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
    /********************向上的箭头**********************/
    
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
    
    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
    
    //填充颜色
    [[YBLColor(63, 66, 71, 1) colorWithAlphaComponent:1] setFill];
    [popoverPath fill];
    
    [popoverPath closePath];
//    [popoverPath stroke];
}

@end
