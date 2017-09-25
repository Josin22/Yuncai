//
//  YBLDataMacro.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#ifndef YBLDataMacro_h
#define YBLDataMacro_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/* boudle ID */
#define Develop_person                          @"com.danshui.yuncai"
#define Disdstribution_company                  @"com.josin.yy"

static NSString *const TEST_MOBILE             = @"18538073222";

/* MBK  KEY */
static NSString *const BMK_DISTRIBUTION_KEY    = @"0OTXgtY3jWCwCIAthGBIpNpKIoOu7Z8u";
/* WX 微信*/
static NSString *const WX_Key                  = @"wxded06ad7a215b206";
static NSString *const WX_Secret               = @"65d09c85890836a33a92de3f2ca5401f";
/* QQ  */
static NSString *const QQ_Key                  = @"1106030816";
static NSString *const QQ_Secret               = @"FpqPiHhQcHYUykyo";
/* 新浪微博  */
static NSString *const SINA_Key                = @"1010015327";
static NSString *const SINA_Secret             = @"44c3f15a50e3bcef1ec919593bdcc523";
/* 支付宝 */
static NSString *const AP_Key                  = @"";
static NSString *const AP_Secret               = @"";
/* SHARE SDK */
static NSString *const ShareSDK_Key            = @"1bdecb16edd35";
static NSString *const ShareSDK_Secret         = @"a8d16cd853a41b3583869401226be963";
/* BUG_TGS */
static NSString *const Bug_Tags_Develop_Key    = @"b9128a22ee1dbf7f3f77d1e8835aa277";
static NSString *const Bug_Tags_Develop_Screct = @"b965f1df5d187b1b2160d18ab97df2b5";

static NSString *const Bug_Tags_Release_Key    = @"90c45cd798744736c4e809ac24e878e2";
static NSString *const Bug_Tags_Release_Screct = @"5ed395c78f79c2bce6fbd5bfe4acc475";
/* 魔窗 */
static NSString *const Mochuange_Key           = @"H7ZL1LZR008F41A6GZDU43GFEDKOY7VX";

/* talk data */
static NSString *const TalkData_Key            = @"C4E4FD999AA840A09765E6215FD0965E";;

/* 极光推送 */
static NSString *const Jiguang_Key             = @"eb19704d31d240cdee125115";
static NSString *const Jiguang_Secret          = @"b8ac9d9714f1495b03d2833c";

/* Bugly */
static NSString *const Bugly_Key               = @"2c0a95ad-dba9-4a53-8fb2-912439426d64";

static NSString *appending_key                 = @"key";

static NSString *appending_title               = @"title";

static NSString *appending_payment             = @"payment";

static NSString *appending_shippingment        = @"shippingment";

//间距
static CGFloat const space                   = 10;
static CGFloat const comments_left_space     = 40;
static CGFloat const space_middle            = 15;
static CGFloat const scroll_top              = 70;
static CGFloat const shadows_space           = .5;
// 系统控件默认高度
static CGFloat   const kStatusBarHeight      = 20;
static CGFloat   const kBottomBarHeight      = 49;
static CGFloat   const kNavigationbarHeight  = 64;
static CGFloat   const Height_CollectionView = 30;
static CGFloat   const buttonHeight          = 45;

static NSInteger Tab_bar_Tag                 = 4444;

static CGFloat const scrollLimitSpace        = 30;

/**
 *  留言最大数
 */
static NSInteger const maxLength_for_massage = 30;

static NSInteger const maxLength_for_storename = 10;
/**
 *  电话号最大数
 */
static NSInteger const maxLength_for_phone   = 11;
/**
 *  采购订单半分比
 */
static float     const percent_purchase      = 0.05;

static NSInteger const ValueNummber          = 3;
/**
 *  昵称最大字数
 */
static NSInteger const limit_for_name        = 20;
/**
 *  页数量
 */
static NSInteger const page_size             = 20;
/**
 *  订单延迟点击最大次数
 */
static int const Delay_Click_Count           = 2;
/**
 *  预加载回调
 */
typedef void(^ViewPrestrainBlock)();

typedef void(^PhotoPickerDone)(UIImage *image);
/**
 *  预加载剩余数量
 */
static NSInteger const PrestrainLessCount    = 10;

static CGFloat const Pull_Max_Y              = 50;

static CGFloat const Pull_FooterPrints_Max_Y = 80;

//相册名
static NSString *const BSCollectionName            = @"云采相册";
//联系电话
static NSString *const Service_PhoneCall           = @"0371-63223381";

static NSString * const Key_JsonBody               = @"body";
static NSString * const Key_JsonStatusCode         = @"statusCode";

static NSString * const sharedApplication_WIFI     = @"prefs:root=WIFI";
static NSString * const sharedApplication_App_WIFI = @"App-Prefs:root=WIFI";

static NSString *const user_type_guest_key         = @"guest";
static NSString *const user_type_seller_key        = @"seller";
static NSString *const user_type_buyer_key         = @"buyer";

static NSString *const dict_data_identity_key      = @"dict_data_identity_key";
static NSString *const dict_same_city_key          = @"dict_same_city_key";
static NSString *const dict_data_identity_value    = @"dict_data_identity_value";
static NSString *const cell_data_identity_key      = @"cell_data_identity_key";
static NSString *const cell_identity_key           = @"cell_identity_key";
static NSString *const cell_content_data_key       = @"cell_content_data_key";
static NSString *const header_identity_key         = @"header_identity_key";
static NSString *const header_resu_key             = @"header_resu_key";
static NSString *const footer_identity_key         = @"footer_identity_key";

static NSString *const onlineString                = @"PaymentMethod::Online";
static NSString *const expressString               = @"PaymentMethod::ExpressCollecting";

static NSString *const loadString                  = @"加载中";
static NSString *const WX_PAY_NOTIFICATION_NAME    = @"WX_PAY_NOTIFICATION_NAME";
static NSString *const XKey                        = @"5604a417c3666e0b7300001a";
static NSString *const RequsestErrorTitle          = @"请求超时";
static NSString *const RequsestLoseErrorTitle      = @"网络失去连接~";
static NSString *const RequsestNullErrorTitle      = @"啥也没返回,是个null";
static NSString *const RequsestErrorCodeTitle      = @"错误的status code";

static NSString *const Yuncai_Slog_string          = @"信用连接世界 生意从此简单";

static NSString *const NO_CAN_LOOK_GOOD_STATUES    = @"NO_CAN_LOOK_GOOD_STATUES";

static NSString *const NO_FIRST_LAUNCH_KEY         = @"IS_FIRST_LAUNCH_KEY";
static NSString *const PING_URL                    = @"www.kuaiyiyuncai.cn";

static NSString *const MoreButton_DownloadImageTitle  = @"下载图片";
static NSString *const MoreButton_WMarketTitle        = @"微营销";
static NSString *const MoreButton_HomeTitle           = @"首页";
static NSString *const MoreButton_SearchTitle         = @"搜索";
static NSString *const MoreButton_GoodStateTitle      = @"商品状态";
static NSString *const MoreButton_ReportPurchaseTitle = @"转发采购";
static NSString *const MoreButton_ReportSellTitle     = @"转发售卖";

///H5 URL

/**
 *  小心有空格
 */
//static NSString *const AppOfVersion_URL          = @"https://itunes.apple.com/lookup?id=1214306170";
static NSString *const App_Notification_Version  = @"App_Notification_Version";
static NSString *const AppOfAppstore_URL         = @"https://itunes.apple.com/cn/app/shou-ji-yun-cai/id1214306170?l=zh&ls=1&mt=8";
static NSString *const AppOfAppstoreEvaluate_URL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1214306170";

/**
 *  信用通
 */
static NSString *const H5_URL_WhatsXYT                   = @"https://www.kuaiyiyuncai.cn/%E4%BF%A1%E7%94%A8%E9%80%9A%E8%AF%B4%E6%98%8E.html";

static NSString *const H5_URL_WhatsXYT_image             = @"http://www.kuaiyiyuncai.cn/system/help/xinyongtongshuoming.jpg";
/**
 *  VIP
 */
static NSString *const H5_URL_WhatVIP                    = @"https://www.kuaiyiyuncai.cn/VIP%E4%BC%9A%E5%91%98%E8%AF%B4%E6%98%8E.html";

///帮助中心
static NSString *const H5_URL_UseHelp                    = @"https://api.kuaiyiyuncai.cn/clauses/1";

static NSString *const H5_URL_UseHelp_image              = @"http://www.kuaiyiyuncai.cn/system/help/zhuceliuchengshuoming.jpg";
/**
 *  特别声明
 */
static NSString *const H5_URL_HerebyDeclare              = @"https://www.kuaiyiyuncai.cn/%E7%89%B9%E5%88%AB%E8%AF%B4%E6%98%8E.html";
/**
 *  云采商城服务协议
 */
static NSString *const H5_URL_YunCaiSmallServiceDelegate = @"http://www.kuaiyiyuncai.cn/system/help/about/58ecbf7fccf959417a91be5d.jpg";
//static NSString *const H5_URL_YunCaiSmallServiceDelegate = @"https://www.kuaiyiyuncai.cn/%E4%BA%91%E9%87%87%E5%95%86%E5%9F%8E%E6%9C%8D%E5%8A%A1%E5%8D%8F%E8%AE%AE.html";

/**
 *  法律声明及隐私权政策
 */
static NSString *const H5_URL_LowyerDelegate = @"http://www.kuaiyiyuncai.cn/system/help/about/58ecbf23ccf959417a91be58.jpg";
//static NSString *const H5_URL_LowyerDelegate = @"https://www.kuaiyiyuncai.cn/%E6%B3%95%E5%BE%8B%E5%A3%B0%E6%98%8E%E5%8F%8A%E9%9A%90%E7%A7%81%E6%9D%83%E6%94%BF%E7%AD%96.html";

/**
 *  商品图片库说明
 */
static NSString *const H5_URL_SmallGoodStorgeDeclare = @"https://www.kuaiyiyuncai.cn/%E5%95%86%E5%93%81%E5%9B%BE%E5%BA%93%E8%AF%B4%E6%98%8E.html";
static NSString *const H5_URL_SmallGoodStorgeDeclare_image = @"http://www.kuaiyiyuncai.cn/system/help/shangpintukushuoming.jpg";

/**
 *  商品详情编辑说明
 */
static NSString *const H5_URL_GoodEditDeclare = @"https://www.kuaiyiyuncai.cn/%E5%95%86%E5%93%81%E8%AF%A6%E6%83%85%E7%BC%96%E8%BE%91%E8%AF%B4%E6%98%8E.html";
/**
 *  采购订单发布及报价协议
 */
static NSString *const H5_URL_PurchaseReleaseAndOutPriceDelegate = @"https://www.kuaiyiyuncai.cn/%E9%87%87%E8%B4%AD%E8%AE%A2%E5%8D%95%E5%8F%8A%E6%8A%A5%E4%BB%B7%E5%8D%8F%E8%AE%AE%E7%AE%A1%E7%90%86%E5%8A%9E%E6%B3%95.html";
/**
 *  信用通协议
 */
static NSString *const H5_URL_CreditDelegate = @"http://www.kuaiyiyuncai.cn/system/help/about/58ecbf5dccf959417a91be5b.jpg";
/**
 *  信用体系服务协议
 */
static NSString *const H5_URL_CreditServiceDelegate = @"http://www.kuaiyiyuncai.cn/system/help/about/58ecbf54ccf959417a91be5a.jpg";
/**
 *  采购订单发布编辑说明
 */
static NSString *const H5_URL_PurchaseReleaseEditDelegate = @"https://www.kuaiyiyuncai.cn/%E9%87%87%E8%B4%AD%E8%AE%A2%E5%8D%95%E5%8F%91%E5%B8%83%E7%BC%96%E8%BE%91%E8%AF%B4%E6%98%8E.html";
static NSString *const H5_URL_PurchaseReleaseEditDelegate_image = @"http://www.kuaiyiyuncai.cn/system/help/caigoudingdanfabushuoming.jpg";

/**
 *  商品设置页面说明
 */
static NSString *const H5_URL_GoodSettingDeclare = @"https://www.kuaiyiyuncai.cn/%E5%95%86%E5%93%81%E8%AE%BE%E7%BD%AE%E9%A1%B5%E9%9D%A2%E8%AF%B4%E6%98%8E.html";
/**
 *  销售区域设置说明
 */
static NSString *const H5_URL_SaleAreaSettingDeclare = @"https://www.kuaiyiyuncai.cn/%E9%94%80%E5%94%AE%E5%8C%BA%E5%9F%9F%E8%AE%BE%E7%BD%AE%E8%AF%B4%E6%98%8E.html";
/**
 *  配送支付方式说明
 */
static NSString *const H5_URL_ShippingPaymentDeclare = @"https://www.kuaiyiyuncai.cn/%E9%85%8D%E9%80%81%E6%94%AF%E4%BB%98%E6%96%B9%E5%BC%8F%E8%AF%B4%E6%98%8E.html";
/**
 *  销售价格以及起批量设置说明
 */
static NSString *const H5_URL_SalePriceAndPISettingDeclare = @"https://www.kuaiyiyuncai.cn/%E9%94%80%E5%94%AE%E4%BB%B7%E6%A0%BC%E4%BB%A5%E5%8F%8A%E8%B5%B7%E6%89%B9%E9%87%8F%E8%AE%BE%E7%BD%AE%E8%AF%B4%E6%98%8E.html";
/**
 *  云币使用说明
 */
static NSString *const H5_URL_YunMoneyHelp = @"https://www.kuaiyiyuncai.cn/%E4%BA%91%E5%B8%81%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E.html";
static NSString *const H5_URL_YunMoneyHelp_image = @"http://www.kuaiyiyuncai.cn/system/help/jinbishiyongbangzhu.jpg";
/**
 *  店铺帮助
 */
static NSString *const H5_URL_StoreHelp_image = @"http://www.kuaiyiyuncai.cn/system/help/shangpuguanlishuoming.jpg";

//static NSString *const H5_URL_StoreHelp_image = @"http://www.kuaiyiyuncai.cn/system/help/zhuceliuchengshuoming.jpg";


///**
// *  <#Description#>
// */
//static NSString *const H5_URL_ = @"";
///**
// *  <#Description#>
// */
//static NSString *const H5_URL_ = @"";

/**
 *  协议
 */
//按钮名字
///大b
static NSString *const begainApproveString     = @"开始核单";
static NSString *const approveDoneString       = @"核单完成";
static NSString *const agreeCancelString       = @"同意取消";
static NSString *const begainPickString        = @"开始拣货";
static NSString *const pickDoneString          = @"拣货完成";
static NSString *const begainShipString        = @"开始配送";
static NSString *const delayShipString         = @"延迟配送";
static NSString *const shipDoneString          = @"配送完成";
static NSString *const pickUpDoneString        = @"提货完成";
static NSString *const sureTihuoString         = @"确认提货";
static NSString *const sureShouhuoString       = @"确认收货";
//小b
static NSString *const yanchiTihuoString       = @"延迟提货";
//static NSString *const yanchiShouhuoString     = @"延迟收货";
static NSString *const fullDoneString          = @"订单完成";
static NSString *const buyAgainString          = @"再次购买";
static NSString *const deleteOrderString       = @"删除订单";
static NSString *const refundOrderString       = @"拒绝接单";
static NSString *const cancleOrderString       = @"取消订单";
//static NSString *const releaseAgainOrderString = @"再次发布";
static NSString *const goPayString             = @"去支付";
static NSString *const wuliuPayString          = @"物流支付";
static NSString *const pingzhengPayString      = @"凭证支付";
static NSString *const payaAgainString         = @"再次购买";

static NSString *const IAlsoAgreeCancelString  = @"我也取消";
static NSString *const IAgreeString            = @"同意";
static NSString *const IDisAgreeString         = @"不同意";

///采购订单按钮
static NSString *const purchase_order_button_release_again1  = @"重新发布";
static NSString *const purchase_order_button_cancel          = @"取消订单";
static NSString *const purchase_order_button_release_again2  = @"再次发布";
static NSString *const purchase_order_button_look_price      = @"查看竞价";
static NSString *const purchase_order_button_bidding_again   = @"再次竞价";
static NSString *const purchase_order_button_out_price_again = @"再次报价";
static NSString *const purchase_order_button_lookOrderString = @"查看订单";
static NSString *const purchase_order_button_lookMyYunDou    = @"查看云币";
static NSString *const purchase_order_button_rechargeRelease = @"充值发布";
static NSString *const purchase_order_button_outPriceSuccess = @"报价成功";
static NSString *const PurchaseBarButtonConfirmPurchase      = @"确认采购";
static NSString *const PurchaseBarButtonTitleGOGO            = @"开始报价";
static NSString *const PurchaseBarButtonTitleEndBidding      = @"报价结束";
static NSString *const PurchaseBarButtonRecharge             = @"充值发布";


//Action
static NSString *const begainApproveActionString   = @"start_approve";
static NSString *const approveDoneActionString     = @"approve";
static NSString *const begainPickActionString      = @"start_pick";
static NSString *const pickDoneActionString        = @"pick";
static NSString *const begainShipActionString      = @"start_ship";
static NSString *const shipDoneActionString        = @"shipped";
static NSString *const pickUpDoneActionString      = @"pick_up";
static NSString *const acceptCancelActionString    = @"accept_cancel";

static NSString *const key_purchase_request_cancel = @"purchase_request_cancel";

//占位图
static NSString *smallImagePlaceholder             = @"small_placehoder";
static NSString *middleImagePlaceholder            = @"middle_placehoder";
static NSString *bannerImagePlaceholder            = @"banner_placehoder";

typedef NS_ENUM(NSInteger,CouponsType) {
    /**
     *  发行中
     */
    CouponsTypeReleasing = 0,
    /**
     *  可领取
     */
    CouponsTypeAvailableGet,
    /**
     *  已使用
     */
    CouponsTypeUsed,
    /**
     *  失效
     */
    CouponsTypeInvaild
};

typedef NS_ENUM(NSInteger,MyPurchaseType) {
    MyPurchaseTypePurchaseOrder = 0,//我的采购
    MyPurchaseTypePurchaseRecords,   //报价记录
//    MyPurchaseTypePurchaseAllRecords   //所有报价记录
};

typedef NS_ENUM(NSInteger,ButtonsChooseStyle) {
    /**
     *  单选
     */
    ButtonsChooseStyleSingleSelect = 0,
    /**
     *  多选
     */
    ButtonsChooseStyleMultiSelect
};

typedef NS_ENUM(NSInteger, GridViewType) {
    /**
     *  无图
     */
    GridViewTypeNone = 0,
    /**
     *  一张图
     */
    GridViewTypeOne ,
    /**
     *  四个排列
     */
    GridViewTypeFour,
    /**
     *  九宫格排列
     */
    GridViewTypeNineSort
};

typedef NS_ENUM(NSInteger,OrderSequenceText) {
    /**
     *  综合
     */
    OrderSequenceTextComposite = 0,
    /**
     *  销量
     */
    OrderSequenceTextSaleCount,
    /**
     *  价格
     */
    OrderSequenceTextPrice
};

typedef NS_ENUM(NSInteger,OrderSequence) {
    /**
     *  Descending===>>>降序
     */
    OrderSequenceDescending = 0,
    /**
     *  Ascending===>>>升序
     */
    OrderSequenceAscending
    
};

typedef NS_ENUM(NSInteger,UserOpenedCreditType) {
    UserOpenedCreditTypeNone = 0,
    UserOpenedCreditTypeCredit,
    UserOpenedCreditTypeMember
};


typedef NS_ENUM(NSInteger,OpenCreditType) {
    OpenCreditTypeCredit = 0,
    OpenCreditTypeMember
};

typedef NS_ENUM(NSInteger,UserType) {
    //游客
    UserTypeGuest = 0,
    //小b
    UserTypeBuyer,
    //大B
    UserTypeSeller,
};

typedef NS_ENUM(NSInteger,SearchType) {
    SearchTypeGood = 0,
    SearchTypeStore = 1
};

typedef NS_ENUM(NSInteger,PurchaseDetailPushType) {
    PurchaseDetailPushTypeNormal = 0,//正常push
    PurchaseDetailPushTypeSepacial   //非正常
};

typedef NS_ENUM(NSInteger,AasmState) {
    ///初始状态
    AasmStateInitial = 0,
    ///等待审核
    AasmStateWaiteApproved,
    ///审核通过
    AasmStateApproved,
    ///被拒绝
    AasmStateRejected,
    ///未知
    AasmStateUnknown
};

typedef NS_ENUM(NSInteger,StoreAuthenType) {
    //实体店铺类型
    StoreAuthenTypeEntityShop = 0,
    //商品生产企业类型
    StoreAuthenTypeProductionEnterprise
};

typedef NS_ENUM(NSInteger,PayWayCashierType) {
    //云采收银台
    PayWayCashierTypeYunCai = 0,
    //微信
    PayWayCashierTypeWXPay,
    //支付宝
    PayWayCashierTypeAlipay
};

typedef NS_ENUM(NSInteger,TakeOrderType) {
    /**
     *  下单
     */
    TakeOrderTypeNormalOrder = 0,
    /**
     *  开通信用通
     */
    TakeOrderTypeCreditPay,
    /**
     *  充值云币
     */
    TakeOrderTypeRechargeYunMoeny
};

typedef NS_ENUM(NSInteger,PayWayType) {
    //通联支付
    PayWayTypeTonglian = 0,
    //微信
    PayWayTypeWXPay,
    //支付宝
    PayWayTypeAlipay
};

typedef NS_ENUM(NSInteger,OrderType) {
    //正向订单支付
    OrderTypeForwardOrder = 0,
    //反向订单支付
    OrderTypeReverseOrder,
};

typedef NS_ENUM(NSInteger,OrderSource) {
    //小b订单
    OrderSourceBuyer = 0,
    //大B订单
    OrderSourceSeller,
    /**
     *  采购小b订单
     */
    OrderSourcePurchaseBuyer,
    /**
     *  采购大B订单
     */
    OrderSourcePurchaseSeller
};

typedef NS_ENUM(NSInteger,SaveImageType) {
    //正向商品图片
    SaveImageTypeNormalGoods = 0,
    //采购商品图片
    SaveImageTypePurchaseGoods,
    //任何图片
    SaveImageTypeAnyPic
};


typedef NS_ENUM(NSInteger,GoodCategoryType) {
    ///商城分类商品
    GoodCategoryTypeForHomeCategory = 0,
    ///商品总库
    GoodCategoryTypeForCommodityPoolCategory,
    ///商品采购有tabbar
    GoodCategoryTypeForPurchaseWithTabbar,
    ///商品采购无tabbar
    GoodCategoryTypeForPurchaseWithOutTabbar
    
};

typedef NS_ENUM(NSInteger, AddressGenre) {
    ///物流收货地址
    AddressGenreShipping = 0,
    ///自提地址
    AddressGenreZiti,
    ///已选地址
    AddressGenreSelectZiti,
    ///下单选择自提地址
    AddressGenreTakeOrderSelectZiti,
    AddressGenreGoodDetailShipping
    
};

typedef NS_ENUM(NSInteger,PurchaseOrderType) {
    ///采购进行中
    PurchaseOrderTypePurchaseing = 0,
    ///未缴纳押金的订单
    PurchaseOrderTypeUnbond ,
    ///已选择中标者的订单
    PurchaseOrderTypeBidded,
    ///流拍的订单
    PurchaseOrderTypeNoBid,
    ///已取消的订单
    PurchaseOrderTypeCancle,
    ///设置自选但是订单发布时间结束后未选择
    PurchaseOrderTypeChoiceBuUnselected,
    ///完成
    PurchaseOrderTypeFullComplete,
    ///等待取消
    PurchaseOrderTypeWaiteCancle,
};

typedef NS_ENUM(NSInteger,DistanceRadiusType) {
    ///修改查看
    DistanceRadiusTypeEdit = 0,
    ///选择
    DistanceRadiusTypeChoose,
    ///展示不可编辑
    DistanceRadiusTypeJustShow,
    ///物流价格选择
    DistanceRadiusTypeExpressPriceChoose,
    ///单个商品修改
    DistanceRadiusTypeSingleGoodExpressPriceEdit
};

typedef NS_ENUM(NSInteger,TableType) {
    tableTypeSXArrow = 0,
    tableTypeSXNoneArrow
};


#endif /* YBLDataMacro_h */
