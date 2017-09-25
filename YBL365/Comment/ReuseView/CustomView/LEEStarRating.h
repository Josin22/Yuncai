
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RatingType) {
    
    RatingTypeWhole , // 整颗星星

    RatingTypeHalf , // 半颗星星
    
    RatingTypeUnlimited // 无限制
};;

@interface LEEStarRating : UIView

/**
 间距 (初始化后设置 默认 5.0)
 */
@property (nonatomic , assign ) CGFloat spacing;

/**
 已选中星星图片 (初始化后设置)
 */
@property (nonatomic , strong ) UIImage *checkedImage;

/**
 未选中星星图片 (初始化后设置)
 */
@property (nonatomic , strong ) UIImage *uncheckedImage;

/**
 最大分数 (初始化后设置 , 默认 5.0)
 */
@property (nonatomic , assign ) CGFloat maximumScore;

/**
 最小分数 (初始化后设置 , 默认 0.0)
 */
@property (nonatomic , assign ) CGFloat minimumScore;

/**
 启用点击 (初始化后设置 , 默认 NO)
 */
@property (nonatomic , assign ) BOOL touchEnabled;

/**
 启用滑动 (初始化后设置 , 默认 NO)
 */
@property (nonatomic , assign ) BOOL slideEnabled;

/**
 评分类型 (初始化后设置 , 默认 RatingTypeWhole)
 */
@property (nonatomic , assign ) RatingType type;

/**
 当前分数 (以上设置完毕后 , 再设置 , 默认 0.0)
 */
@property (nonatomic , assign ) CGFloat currentScore;

/**
 当前分数变更Block
 */
@property (nonatomic , copy ) void (^currentScoreChangeBlock)(CGFloat);


/**
 初始化方法

 @param frame frame
 @param count 个数 (默认为 5)
 @return UIView
 */
- (instancetype)initWithFrame:(CGRect)frame Count:(NSUInteger)count;

@end
