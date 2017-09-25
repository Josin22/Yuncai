//
//  YBLEvaluateDetailCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEvaluateDetailCell.h"
#import "YBLEvaluatePicCollection.h"
#import "YBLOrderCommentsItemModel.h"
#import "YBLGridView.h"

static const NSInteger star_button_tag = 8263;

@interface YBLEvaluateDetailCell ()

@property (nonatomic, retain) UILabel *contentLabel;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *timeEvaluateLabel;

@property (nonatomic, retain) UILabel *specLabel;

@property (nonatomic, retain) UILabel *buyTimeLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) YBLGridView *gridView;

@property (nonatomic, assign) GridViewType gridViewType;

@end

@implementation YBLEvaluateDetailCell

+ (YBLEvaluateDetailCell *)cellReusableWithTabelView:(UITableView *)tableView
                                      rowAtIndexPath:(NSIndexPath *)indexPath
                                        gridViewType:(GridViewType)gridViewType
{
    
    static NSString *ID = @"YBLEvaluateDetailCell";
    // 根据标识去缓存池找cell
    YBLEvaluateDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    // 不写这句直接崩掉，找不到循环引用的cell
    if (cell.nameLabel == nil) {
        cell = [[YBLEvaluateDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:ID
                                               gridViewType:gridViewType
                ];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                 gridViewType:(GridViewType)gridViewType
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _gridViewType = gridViewType;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    
//    self.contentView.backgroundColor = randomColor;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    /* 姓名图片 时间 */
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 45)];
    [self.contentView addSubview:topView];
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(space/2, 0, 30, 30)];
    iconImageView.centerY = topView.height/2;
    iconImageView.layer.cornerRadius = iconImageView.width/2;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    [topView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+space/2, 0, topView.width/2, 15)];
    nameLabel.bottom = topView.height/2;
    nameLabel.textColor = BlackTextColor;
    nameLabel.font = YBLFont(12);
    [topView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *timeEvaluateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, nameLabel.height)];
    timeEvaluateLabel.textAlignment = NSTextAlignmentRight;
    timeEvaluateLabel.font = YBLFont(12);
    timeEvaluateLabel.right = topView.width-space;
    timeEvaluateLabel.textColor = YBLTextLightColor;
    timeEvaluateLabel.centerY = topView.height/2;
    [topView addSubview:timeEvaluateLabel];
    self.timeEvaluateLabel = timeEvaluateLabel;
    
    /* 小星星 */
    UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.left, topView.height/2+5, topView.width, 8)];
    [self addSubview:starView];
    for (int i = 0; i <  5; i++) {
        YBLButton *starButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        starButton.frame = CGRectMake(i*(starView.height+5), 0, starView.height, starView.height);
        starButton.tag = star_button_tag+i;
        [starButton setImage:[UIImage imageNamed:@"goods_start_normal"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"goods_start_select"] forState:UIControlStateDisabled];
        starButton.enabled = NO;
        [starView addSubview:starButton];
    }
    /* 评论 */
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, topView.bottom+space/2, topView.width-nameLabel.left-space, 20)];
    contentLabel.textColor = BlackTextColor;
    contentLabel.font = YBLFont(12);
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    /*图*/
    YBLGridView *gridView = [[YBLGridView alloc] initWithFrame:CGRectMake(contentLabel.left, contentLabel.bottom+space, contentLabel.width, 100)
                                                  gridViewType:self.gridViewType];
    [self.contentView addSubview:gridView];
    self.gridView = gridView;
    
    
    /*规格 时间*/
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.left, 0, nameLabel.width, 30)];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    UILabel *specLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, bottomView.height/2)];
    specLabel.font = YBLFont(12);
    specLabel.textColor = YBLTextLightColor;
    [self.bottomView addSubview:specLabel];
    self.specLabel = specLabel;
    
    UILabel *buyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, specLabel.bottom, specLabel.width, specLabel.height)];
    buyTimeLabel.font = YBLFont(12);
    buyTimeLabel.textColor = YBLTextLightColor;
    [self.bottomView addSubview:buyTimeLabel];
    self.buyTimeLabel = buyTimeLabel;
    
}

- (void)updateItemCellModel:(id)itemModel{
    YBLOrderCommentsModel *model = (YBLOrderCommentsModel *)itemModel;
    [self.iconImageView js_scale_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:smallImagePlaceholder];
    self.timeEvaluateLabel.text = model.created_at;
    self.contentLabel.text = model.content;
    self.contentLabel.height = model.content_height.floatValue;
    self.specLabel.text = model.specification;
    self.nameLabel.text = model.k_user_name;
    self.buyTimeLabel.text = [NSString stringWithFormat:@"购买日期:%@",model.buy_at];
    self.gridView.dataArray = model.pictures;
    CGFloat BOYTTO = space;
    if (model.pictures.count==0) {
        BOYTTO = 0;
    }
    self.gridView.top = self.contentLabel.bottom+space;
    self.bottomView.top = self.gridView.bottom+BOYTTO;
    
    NSInteger rating_count = model.score.integerValue/2;
    for (int i = 0; i < 5; i++) {
        YBLButton *starButton = (YBLButton *)[self viewWithTag:star_button_tag+i];
        starButton.enabled = YES;
        if (i<rating_count) {
            starButton.enabled = NO;
        }
    }
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    YBLOrderCommentsModel *model = (YBLOrderCommentsModel *)itemModel;
    CGFloat BOYTTO = space;
    if (model.pictures.count==0) {
        BOYTTO = 0;
    }
    CGFloat final_height = model.content_height.floatValue+model.gridView_height.floatValue+space+45+25+space+space+BOYTTO;
    return final_height;
}

@end
