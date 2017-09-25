//
//  YBLMethodTools.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLSystemSocialModel.h"

@class YBLAdsModel;

static NSString  *animation_key_shake = @"animation_key_shake";
static NSString  *animation_key_3droation = @"animation_key_3droation";


@interface YBLOrderPropertyItemModel : NSObject

@property (nonatomic, copy  ) NSString *order_state;
@property (nonatomic, copy  ) NSString *order_action;
@property (nonatomic, copy  ) NSString *order_button_title;
@property (nonatomic, strong) UIColor  *order_button_color;

+ (YBLOrderPropertyItemModel *)getItemModelWithOrderState:(NSString *)order_state
                                             order_action:(NSString *)order_action
                                       order_button_title:(NSString *)order_button_title;

@end

@interface YBLOrderPropertyModel : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, copy  ) NSString *order_state;
/**
 *  正向订单按钮
 */
@property (nonatomic, strong) NSMutableArray *orderStateCount;
/**
 *  采购订单按钮
 */
@property (nonatomic, strong) NSMutableArray *purchaseOrderStateCount;

+ (YBLOrderPropertyModel *)getPropertyModelWithState:(NSString *)state Count:(NSArray *)count purchaseCount:(NSArray *)purchaseCount;

@end


typedef struct {
    /**
     *  最低批发量
     */
    NSInteger minWholesaleCount;
    /**
     *  当前数量所在价格
     */
    float currentPrice;
    /**
     *  是否设置过多价格
     */
    BOOL isSettingPrice;
    
}Prices_prices;

@class YBLCompanyTypePricesParaModel,YBLButton;

@interface YBLMethodTools : NSObject

+ (NSMutableAttributedString *)getJoinVisitAttributedStringWithJoin:(NSString *)join
                                                          visitTime:(NSString *)visit
                                                      componeString:(NSString *)componeString;

+ (int)getRandomNumber:(int)from to:(int)to;

+ (NSString *)getAppVersion;

+ (NSString *)getAppBuildNumber;
    
+ (void)OpenURL:(NSURL *)url;

+ (void)filter_priceModel:(YBLCompanyTypePricesParaModel *)priceModel;

+ (Prices_prices)getPrice_priceWithModel:(YBLCompanyTypePricesParaModel *)priceModel;

+ (float)getCurrentPriceWithCount:(NSInteger)count InPriceArray:(NSArray *)priceArray;

+ (void)addAnimationWith:(UIView *)view;

+ (void) popAnimationWithView:(UIView*)aView;

+(CABasicAnimation *) AlphaLight:(float)time;

+ (CATransform3D)transformFirstViewLayer;

+ (CATransform3D)transformSecondViewLayer;

+ (NSMutableArray *)getSeckillTimeWithNewTime:(NSString *)time;

+ (UIImage *)addLabelWithModel:(YBLSystemSocialModel *)model AndQRCImage:(UIImage *)qrcImage ToGoodImage:(UIImage *)goodImage;

+ (UIImage *)addQRCImage:(UIImage *)qrcImage ToImage:(UIImage *)image;

+ (UIImage *)addTextLabel:(UILabel *)textLabel AndQrcImage:(UIImage *)qrcImage ToGoodImage:(UIImage *)goodImage;

+ (void)transformOpenView:(UIView *)view
                SuperView:(UIView *)sview
                  fromeVC:(UIViewController *)vc
                      Top:(CGFloat)top;

+ (void)transformCloseView:(UIView *)view
                 SuperView:(UIView *)sview
                   fromeVC:(UIViewController *)vc
                       Top:(CGFloat)top
                completion:(void (^ )(BOOL finished))completion;

+ (void)callWithNumber:(NSString *)number;

+ (UIButton *)getContactKefuButtonWithFrame:(CGRect)frame;

+ (UIButton *)getNextButtonWithFrame:(CGRect)frame;

+ (UIButton *)getFurtureMoneyButtonWithFrame:(CGRect)frame;

+ (UIButton *)getFangButtonWithFrame:(CGRect)frame;

+ (UIView *)addLineView:(CGRect)frame;

+ (UIView *)getSuperShadowViewWithFrame:(CGRect)frame;

+ (void)addLeftShadowToView:(UIView *)view;

+ (void)addTopShadowToView:(UIView *)view;

+ (void)addTopShadowToGoodView:(UIView *)view;

+ (UIButton *)buttonWithImage:(NSString *)imageName title:(NSString *)title subtitle:(NSString *)subTitle litTitle:(NSString *)litTitle;

+ (NSArray *)getRowCount:(NSInteger)count;

+ (void)pushVc:(UIViewController *)Vc withNavigationVc:(UINavigationController *)navigationVc;

+ (void)popVc:(UIViewController *)Vc withNavigationVc:(UINavigationController *)navigationVc;

+ (NSString *)dateTimeDifferenceWithEndTime:(NSString *)endTime;

+ (NSString *)diffDayOf:(NSString *)beginTime andEndTime:(NSString*)endTime;

+ (NSInteger)getGoodManageStatusWith:(NSString *)value;

+ (void)headerRefreshWithTableView:(id )view completion:(void (^)(void))completion;

+ (void)footerRefreshWithTableView:(id )view completion:(void (^)(void))completion;

+ (void)footerAutoRefreshWithTableView:(id )view completion:(void (^)(void))completion;

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay dateFormatter:(NSDateFormatter *)dateFormatter;

+ (int)getBaozhengJINWithCount:(NSInteger)count Price:(float)price;

+ (UIColor *)getPurchaseOrderStatusBGColorWithAasmState:(NSString *)aasm_state;

+ (NSString *)getPurchaseOrderStatusTitleWithAasmState:(NSString *)aasm_state;

+ (PurchaseOrderType)getPurchaseOrderTypeWithAasmState:(NSString *)aasm_state;

+ (NSString *)getPurchaseOrderStatusButtonTitleWithAasmState:(NSString *)aasm_state;

+ (NSString *)getOrderButtonAction:(NSString *)currentTitle;

+ (NSString *)getOrderTypeTitleWithState:(NSString *)state;

+ (NSString *)getOrderTypeButtonTitleWithState:(NSString *)state;

+ (BOOL)popToFoundVCFrom:(UIViewController *)fromeVC;

+ (BOOL)popToMyPurchaseVCFrom:(UIViewController *)fromeVC;

+ (BOOL)popToHomeBarFromEditPurchaseVC:(UIViewController *)vc ;

+ (void)dismissViewControllerToRoot:(UIViewController *)Vc;

+ (void)pushVC:(UIViewController *)Vc FromeUndefineVC:(UIViewController *)superVC;

+ (NSString *)getStaffRoleNamesWithArray:(NSArray *)array;

+ (NSString *)getStaffRoleValueWithArray:(NSArray *)array;

+ (void)removeSearchBarBackgroundColorWithBar:(UIView *)bar;

+ (void)changeSearchBarCancleButton:(UIView *)bar;

+ (NSString *)getFullAppendingAddressWithArray:(NSMutableArray *)selectArray;

+ (NSString *)getCachImageSize;

+ (void)cleanImageCach;

+ (BOOL)checkLoginWithVc:(UIViewController *)Vc;

+ (UIButton *)getButtonWithImage:(NSString *)imageName;

+ (YBLButton *)getTopAndCommandButton;

/********   New Method  ********/
+ (YBLOrderPropertyModel *)buyerOrderStateWith:(NSString *)state;
+ (YBLOrderPropertyModel *)sellerOrderStateWith:(NSString *)state;

+ (BOOL)checkPhone:(NSString *)phoneNumber;
+ (BOOL)checkEmail:(NSString *)email;
+ (BOOL)checkIsChinese:(NSString *)string;
+ (void)setStatusBarBackgroundColor:(UIColor *)color;
+ (NSString *)transform:(NSString *)chinese;
+ (NSString *)getAppendingStringWithArray:(NSArray *)array appendingKey:(NSString *)key;
+ (NSString *)getAppendingTitleStringWithArray:(NSArray *)array appendingKey:(NSString *)key;
+ (NSString *)getAppendingShippingmentTitleStringWithArray:(NSArray *)array appendingKey:(NSString *)key;
+ (NSString *)getAppendingPaymentTitleStringWithArray:(NSArray *)array appendingKey:(NSString *)key;
+ (void)pushWebVcFrom:(UIViewController *)Vc URL:(NSString *)URL title:(NSString *)title;
+ (NSString *)replaceNYRDataStringWith:(NSString *)dataString;
+ (void)cleanNotificationNumber;

+ (NSString *)updateURL:(NSString *)url versionWithSiganlNumber:(NSInteger)number;
+ (NSMutableArray *)getRowAppendingIndexPathsWithIndex:(NSInteger)index_from appendingCount:(NSInteger)appendingCount inSection:(NSInteger)inSection;
+ (NSMutableArray *)getSectionAppendingIndexPathsWithIndex:(NSInteger)index_from appendingCount:(NSInteger)appendingCount inSection:(NSInteger)inSection;
+ (BOOL)isSatisfyPrestrainDataWithAllcount:(NSInteger)allCount currentRow:(NSInteger)currentRow;
+ (YBLButton *)getImageTextButtonWithText:(NSString *)text buttonSize:(CGSize)buttonSize;
+ (NSString *)changeToNiMing:(NSString *)name;

+ (CABasicAnimation *)getShakeAnimation;
+ (CABasicAnimation *)get3DRotationAnimation;
+ (CABasicAnimation *)getScaleAnimationScale:(CGFloat)scale;
+ (void)copyString:(NSString *)copyString;
+ (void)handleAdsModel:(YBLAdsModel *)adsModel Vc:(UIViewController *)Vc;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;
+ (NSString*)getTimeNow;
@end
