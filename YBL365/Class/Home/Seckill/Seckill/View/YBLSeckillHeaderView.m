//
//  YBLSeckillHeaderView.m
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillHeaderView.h"
#import "YBLTimeDown.h"

@interface YBLSeckillHeaderView ()

@property (nonatomic, retain) UILabel *panicTimeLabel;

@property (nonatomic, retain) UILabel *endTimeLabel;

@end

@implementation YBLSeckillHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{
    
    static NSString *headerID = @"headerID";
    YBLSeckillHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView==nil) {
        headerView = [[YBLSeckillHeaderView alloc] initWithReuseIdentifier:headerID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setUpPanicHeaderView];
    }
    return self;
}

- (void)setUpPanicHeaderView{
    
    //抢购
    UILabel *panicTimeLabel = [[UILabel alloc] init];
    NSString *panicTimeString = @"08:00";
    panicTimeLabel.font = YBLFont(13);
    panicTimeLabel.text = [NSString stringWithFormat:@"抢购中%@开抢",panicTimeString];
    panicTimeLabel.textColor = YBLColor(34, 34, 34, 1);
    [self addSubview:panicTimeLabel];
    self.panicTimeLabel = panicTimeLabel;
    
    //倒计时
    UILabel *endTimeLabel = [[UILabel alloc] init];
    endTimeLabel.text = @"距结束";
    endTimeLabel.textColor =  YBLColor(104, 104, 104, 1);
    endTimeLabel.font = YBLFont(13);
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:endTimeLabel];
    self.endTimeLabel = endTimeLabel;
    
    YBLTimeDown *timeDownView = [[YBLTimeDown alloc] initWithFrame:CGRectMake(0, 0, 80, 16) WithType:TimeDownTypeNumber];
    NSString *testTime = @"2017-02-09 9:06:30";
    [timeDownView setEndTime:testTime
                      begainText:@""];
    timeDownView.textColor = [UIColor whiteColor];
    [self addSubview:timeDownView];
    self.timeDownView = timeDownView;

}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.panicTimeLabel.frame = CGRectMake(10, 0, self.width/2, 30);
    self.timeDownView.frame = CGRectMake(self.width-80-5, 7, 80, 16);
    self.endTimeLabel.frame = CGRectMake(self.timeDownView.frame.origin.x-65, self.timeDownView.frame.origin.y, 60, self.timeDownView.height);

}

@end
