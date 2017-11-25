//
//  YBLAPI.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#ifndef YBLAPI_h
#define YBLAPI_h

/* 根 URL */
/*
static NSString * const BaseURL_Release3001         = @"https://water.iamyuhang.com:3001/api/v1/";
static NSString * const BaseURL_Release81           = @"https://water.iamyuhang.com/api/v1/";
static NSString * const BASE_URL                    = @"https://water.iamyuhang.com/api/v1/";
static NSString * const BaseURL_ReleaseAdmin        = @"https://water.iamyuhang.com/api/admin/v1/";
static NSString * const BaseURL_Login_Release       = @"https://water.iamyuhang.com/";
static NSString * const BASE_URL_Login              = @"https://water.iamyuhang.com/";
*/
static NSString * const BaseURL_Release3001         = @"https://water.iamyuhang.com:3001/api/v1/";
static NSString * const BaseURL_Release81           = @"https://water.iamyuhang.com/api/v1/";
static NSString * const BASE_URL                    = @"https://water.iamyuhang.com/api/v1/";
static NSString * const BaseURL_ReleaseAdmin        = @"https://water.iamyuhang.com/api/admin/v1/";
static NSString * const BaseURL_Login_Release       = @"https://water.iamyuhang.com/";
static NSString * const BASE_URL_Login              = @"https://water.iamyuhang.com/";

///版本监测
#define url_versions                                [BASE_URL stringByAppendingString:@"versions"]

#pragma mark-----优惠券------coupons
#define url_coupons                  [BaseURL_ReleaseAdmin stringByAppendingString:@"coupons"]
/**
 *  获取所有商家优惠券
 */
#define url_couponss                               [BASE_URL stringByAppendingString:@"coupons/"]
/**
 *  获取我的优惠券
 */
#define url_couponss_mine                               [url_couponss stringByAppendingString:@"mine"]
///领取优惠券
#define url_couponss_take(x)                               [[url_couponss stringByAppendingString:x] stringByAppendingString:@"/take"]

#pragma mark-----公海------customers
#define url_customers                               [BASE_URL stringByAppendingString:@"customers/"]
#define url_customers_bind                          [url_customers stringByAppendingString:@"action_bind"]
#define url_customers_mine                          [url_customers stringByAppendingString:@"mine"]
#define url_customers_logs                          [url_customers stringByAppendingString:@"logs"]
#define url_customers_log(x)                        [[url_customers stringByAppendingString:x] stringByAppendingString:@"/logs"]

#pragma mark-----微营销------wmarket
///店铺微营销信息获取(列表)
#define url_small_marketing                         [BASE_URL stringByAppendingString:@"small_marketing"]
///店铺微营销信息获取
#define url_small_marketing_set(x)                  [[BASE_URL stringByAppendingString:@"small_marketing/"]stringByAppendingString:x]
/// 上传图片
#define url_small_marketing_uppic(x)                [url_small_marketing_set(x) stringByAppendingString:@"/upload_picture"]
///同步文案
#define url_small_marketing_sync                    [url_small_marketing stringByAppendingString:@"/sync"]

#pragma mark-----员工管理------sallesmen

#define url_salesmen                                [BaseURL_ReleaseAdmin stringByAppendingString:@"salesmen"]
#define url_salesmen_delete(x)                      [[BaseURL_ReleaseAdmin stringByAppendingString:@"salesmen/"] stringByAppendingString:x]

#pragma mark-----钱包------ wallets
///判断云币是否足够
#define url_wallets                                 [BASE_URL stringByAppendingString:@"wallets/"]
#define url_wallets_flows                           [url_wallets stringByAppendingString:@"flows"]
#define url_wallets_check_gold                      [url_wallets stringByAppendingString:@"check_gold"]

#pragma mark-----反向订单------ perchanse_order
///判断是否同城
#define url_purchasingorder_same_city                [url_purchasingorder stringByAppendingString:@"/same_city"]

#define url_purchasingorder_purchase_order_push     [url_purchasingorder stringByAppendingString:@"/purchase_order_push"]
///获取采购商品的信息
#define url_purchasingorder_purchaseproduct     [url_purchasingorder stringByAppendingString:@"/purchase_product"]
///获取采购订单设置的基本条件
#define url_purchasingorder_purchaseinfos       [url_purchasingorder stringByAppendingString:@"/purchase_infos"]
//获取采购订单支付方式&配送方式&配送时效
#define url_purchase_paytype_distribution       [url_purchasingorder stringByAppendingString:@"/purchase_paytype_distribution"]
///生成采购订单
#define url_purchasingorder                     [BASE_URL stringByAppendingString:@"purchasingorder"]
///获取其他人设置的采购商品的信息
#define url_purchasingorder_otherinfo           [url_purchasingorder stringByAppendingString:@"/otherinfo"]
///获取采购订单
#define url_purchasingorder_purchaseorder       [url_purchasingorder stringByAppendingString:@"/purchaseorder"]
#define url_purchasingorder_purchaseorders       [url_purchasingorder stringByAppendingString:@"/purchaseorders"]
///竞标查询GET   /    竞标POST
#define url_purchasingorder_bidding             [url_purchasingorder stringByAppendingString:@"/bidding"]
#define url_purchasingorder_biddings             [url_purchasingorder stringByAppendingString:@"/biddings"]
///竞标取消
#define url_purchasingorder_cancle              [url_purchasingorder stringByAppendingString:@"/cancel_purchaseorder"]
///选择中标者
#define url_purchasingorder_choose              [url_purchasingorder stringByAppendingString:@"/choose_bid"]
///合计数据
#define url_purchase_datacount                  [url_purchasingorder stringByAppendingString:@"/datacount"]

#pragma mark-----信用通------ credits
////生成信用通订单  POST
#define url_credit                          [BaseURL_ReleaseAdmin stringByAppendingString:@"credits"]
#define url_credit_member                   [BaseURL_ReleaseAdmin stringByAppendingString:@"credits/member"]
///获取信用通收费标准  GET
#define url_credit_price_standards          [url_credit stringByAppendingString:@"/credit_price_standards"]
///查询信用通开通状态  GET
#define url_credit_check(x)                 [[BaseURL_ReleaseAdmin stringByAppendingString:@"credits/"] stringByAppendingString:x]
///查询VIP通开通状态  GET
#define url_credit_memeber_check(x)                 [[BaseURL_ReleaseAdmin stringByAppendingString:@"credits/member/"] stringByAppendingString:x]
///获取充值收费标准
#define url_credit_recharge_price_standards     [url_credit stringByAppendingString:@"/recharge_price_standards"]
///生成充值订单
#define url_credit_recharge                     [url_credit stringByAppendingString:@"/recharge"]
///查询充值订单
#define url_credit_recharge_check(x)            [[url_credit_recharge stringByAppendingString:@"/"] stringByAppendingString:x]
///查询信用通记录
#define url_credit_payments                     [url_credit stringByAppendingString:@"/payments"]

#pragma mark-----支付-----index -- alipay

#define url_pay                         [BASE_URL stringByAppendingString:@"orders/test_alipay"]
#define url_payment(x)                  [[BASE_URL stringByAppendingString:@"payment/"] stringByAppendingString:x]

#pragma mark-----首页-----index -- hotsells

#define url_hotsells                    [BASE_URL stringByAppendingString:@"index/hotsells"]
#define url_products                    [BASE_URL stringByAppendingString:@"index/products"]
#define url_ads                         [BASE_URL stringByAppendingString:@"index/ads"]
#define url_floors                      [BASE_URL stringByAppendingString:@"index/floors"]
#define url_get_unfollow_shops                      [BASE_URL stringByAppendingString:@"index/get_unfollow_shops"]
#define url_products_recommand          [BASE_URL stringByAppendingString:@"products/recommend"]

#define url_get_share_products          [BASE_URL stringByAppendingString:@"index/get_share_products"]


#pragma mark-----商品库分类----categories-tree 
#define url_categories_tree(x)                          [[BASE_URL stringByAppendingString:@"categories/tree/"] stringByAppendingString:x]

#define url_category_products(x)                        [[[BaseURL_Release3001 stringByAppendingString:@"category/"]stringByAppendingString:x] stringByAppendingString:@"/products"]

#define url_purchase_products(x)                        [[[BaseURL_Release3001 stringByAppendingString:@"category/"]stringByAppendingString:x] stringByAppendingString:@"/products_for_purchase_order"]

#define url_product_search                            [BaseURL_Release3001 stringByAppendingString:@"/product/search"]


#pragma mark-----快递物流----express_companies
///获取 创建或更新 所有物流公司
#define url_express_companies                           [BaseURL_ReleaseAdmin stringByAppendingString:@"express_companies/"]
///删除物流公司
#define url_express_companies_delete(x)                 [url_express_companies stringByAppendingString:x]
///获取 设置 已开通物流公司列表
#define url_express_companies_valid_express_companies   [url_express_companies stringByAppendingString:@"valid_express_companies"]


#pragma mark-----商品----products -- products
#define url_share_money_products                [url_product_shipping_price_products stringByAppendingString:@"/share_money_products"]
///设置分享佣金
#define url_products_share_money                [url_product_shipping_price_products stringByAppendingString:@"/share_money"]
///增加分享次数
#define url_products_add_share_count                [url_product_shipping_price_products stringByAppendingString:@"add_share_count"]
///获取商品分享者
#define url_products_sharers(x)         [[url_product_shipping_price_products stringByAppendingString:x] stringByAppendingString:@"/sharers"]


#define url_products_products_qrcode             [url_products_products stringByAppendingString:@"qrcode"]
///根据地址或物流价格
#define url_product_shiping_price(x)            [url_products_products_id(x) stringByAppendingString:@"/shipping_prices"]
///修改商品区域状态
#define url_product_area_status(x)              [url_products_save(x) stringByAppendingString:@"/area_status"]
///修改商品状态
#define url_product_change_status(x)            [[url_product_shipping_price_products stringByAppendingString:x] stringByAppendingString:@"/status"]
///获取为设置支付配送商品列表
#define url_product_no_pay_shippings_products   [url_product_shipping_price_products stringByAppendingString:@"no_shippings_and_payments_products"]
#define url_product_shipping_price_products     [BaseURL_ReleaseAdmin stringByAppendingString:@"products/"]
///获取未设置物流价格商品列表
#define url_product_no_shipping_price_products  [url_product_shipping_price_products stringByAppendingString:@"no_shipping_price_products"]
///获取商品物流价格
#define url_products_shipping_prices(x)         [[url_product_shipping_price_products stringByAppendingString:x] stringByAppendingString:@"/shipping_prices"]
///设置商品物流价格
#define url_products_set_shipping_prices        [url_product_shipping_price_products stringByAppendingString:@"shipping_prices"]

///商品搜索
///GET 获取商品列表
#define url_products_products                   [BASE_URL stringByAppendingString:@"products/"]
///GET根据商品ID获取商品详情
#define url_products_products_id(x)             [url_products_products stringByAppendingString:x]
/// 保存商品到店铺
#define url_products_savetostore(x)             [[BaseURL_ReleaseAdmin stringByAppendingString:@"products/save_to_store/"]stringByAppendingString:x]
/// 添加商品的列表
#define url_products_goodlist(x)                [[BaseURL_ReleaseAdmin stringByAppendingString:@"products/category_id="]stringByAppendingString:x]
///PUT 保存编辑商品
#define url_products_save(x)                    [[BaseURL_ReleaseAdmin stringByAppendingString:@"products/"] stringByAppendingString:x]
///GET 获取编辑商品信息
#define url_product_rack(x)                     [[BaseURL_ReleaseAdmin stringByAppendingString:@"products/rack/"] stringByAppendingString:x]
///获取商品属性值
#define url_product_option_types(x)             [[url_products_products stringByAppendingString:@"option_types/"] stringByAppendingString:x]
///获取所有的配送及支付方式
#define url_shippings_and_payments              [BaseURL_ReleaseAdmin stringByAppendingString:@"products/shippings_and_payments"]
///设置或显示商品配送及支付方式
#define url_shippings_and_payments_id(x)        [url_products_save(x) stringByAppendingString:@"/shippings_and_payments"]
///设置商品销售区域或显示区域
#define url_setareas(x)                         [url_products_save(x) stringByAppendingString:@"/areas"]
///显示
#define url_sales_area_display_price_area(x)    [url_products_save(x) stringByAppendingString:@"/sales_area_display_price_area"]
///设置商品多价格体系
#define url_company_type_prices(x)              [url_products_save(x) stringByAppendingString:@"/company_type_prices"]
///修改商品图片
#define url_upload_photo(x)                     [url_products_save(x) stringByAppendingString:@"/upload_photo"]
///修改商品顺序
#define url_sort_photo(x)                       [url_products_save(x) stringByAppendingString:@"/sort_photo"]
///删除图片
#define url_delete_photo(x)                     [url_products_save(x) stringByAppendingString:@"/photo"]

#define url_product_follow(x)                   [url_products_products_id(x) stringByAppendingString:@"/follow"]

#define url_product_unfollow(x)                 [url_products_products_id(x) stringByAppendingString:@"/unfollow"]

#define url_product_myfollow                    [url_products_products stringByAppendingString:@"/my_followed_products"]

#pragma mark-----店铺----shops

#define url_shops(x)                            [[BASE_URL stringByAppendingString:@"shops/"]stringByAppendingString:x]

#define url_admin_base_shops                    [BaseURL_ReleaseAdmin stringByAppendingString:@"shops/"]

#define url_admin_shops(x)                      [url_admin_base_shops stringByAppendingString:x]

#define url_shops_search                        [BASE_URL stringByAppendingString:@"shops/search"]
#define url_shopfixtrue_picture                 [BASE_URL stringByAppendingString:@"fixture_picture"]
#define url_shopfixtrue                         [BASE_URL stringByAppendingString:@"shopfixtrue"]
//店铺信息设置
#define url_shopinfo                            [BASE_URL stringByAppendingString:@"shopinfo"]
//店铺信息获取
#define url_shopinfo_set                        [url_shopinfo stringByAppendingString:@"/set"]

#define url_store_myfollow                      [BaseURL_ReleaseAdmin stringByAppendingString:@"shops/my_followed_shops"]
//关注店铺
#define url_store_follow(x)                     [url_admin_shops(x) stringByAppendingString:@"/follow"]
//取消关注店铺
#define url_store_unfollow(x)                   [url_admin_shops(x) stringByAppendingString:@"/unfollow"]
//关注我的店铺列表
#define url_store_my_followers                  [url_admin_base_shops stringByAppendingString:@"my_followers"]
//我关注的店铺列表
#define url_store_my_followed_shops             [url_admin_base_shops stringByAppendingString:@"my_followed_shops"]
//设置关注选项  获取关注选项
#define url_store_follow_options                [url_admin_base_shops stringByAppendingString:@"follow_options"]
//转移金币
#define url_store_transfer                      [url_admin_base_shops stringByAppendingString:@"transfer"]
//支付小B关注云币
#define url_store_pay(x)                           [url_admin_shops(x) stringByAppendingString:@"/pay"]

#pragma mark-----购物车----carts

#define url_carts_rebuy                          [BASE_URL stringByAppendingString:@"carts/rebuy"]
#define url_carts_line_items                     [BASE_URL stringByAppendingString:@"carts/line_items"]
#define url_carts_line_items_quantity            [url_carts_line_items stringByAppendingString:@"/quantity"]
#define url_carts_line_items_onebyone_quantity   [BASE_URL stringByAppendingString:@"carts/add_quantity"]
#define url_carts_product_quantity               [BASE_URL stringByAppendingString:@"carts/product_quantity"]

#pragma mark------评价----comments
#define url_orders_comments_up_pic                     [url_orders_comments stringByAppendingString:@"/upload_picture"]
///创建评价
#define url_orders_comments                     [BASE_URL stringByAppendingString:@"comments"]
///商品评价
#define url_product_comments                    [url_orders_comments stringByAppendingString:@"/product_comments"]

#pragma mark------订单----orders
#define url_orders_bullet                       [url_orders stringByAppendingString:@"/bullet"]
#define url_orders                              [BASE_URL stringByAppendingString:@"orders"]
#define url_order_state                         [BASE_URL stringByAppendingString:@"order_state"]
#define url_orders_product_shipping_prices      [url_orders stringByAppendingString:@"/product_shipping_prices"]
#define url_orders_customer_cancel_reason       [BASE_URL stringByAppendingString:@"dictionaries"]
#define url_orders_confirm                      [url_orders stringByAppendingString:@"/confirm"]
#define url_orders_confirm_old                  [url_orders stringByAppendingString:@"/confirm_old"]
///所有小b订单
#define url_orders_customer                     [url_orders stringByAppendingString:@"/customer"]
///所有大B订单
#define url_orders_seller                       [url_orders stringByAppendingString:@"/seller"]
///订单详情
#define url_orders_detail(x)                    [[url_orders stringByAppendingString:@"/"] stringByAppendingString:x]
#define url_order_state_state(x)                [[url_order_state stringByAppendingString:@"/"] stringByAppendingString:x]
///票据历史
#define url_orders_invoices                     [url_orders stringByAppendingString:@"/invoices"]
///物流
#define url_orders_order_tracks(x)              [[[url_order_state stringByAppendingString:@"/"] stringByAppendingString:x] stringByAppendingString:@"/tracks"]

#pragma mark------代理----agent
#define url_agent                               [BASE_URL stringByAppendingString:@"agent/"]
#define url_agent_price_range                   [url_agent stringByAppendingString:@"price_range"]

#pragma mark------公司性质----company_types
#define url_company_types                       [BASE_URL stringByAppendingString:@"company_types"]

#pragma mark------地址----receiptinfos
/// GET / POST
#define url_receiptinfos                [BASE_URL stringByAppendingString:@"address"]
///DELETE
#define url_receiptinfos_delete(x)      [[url_receiptinfos stringByAppendingString:@"/"] stringByAppendingString:x]
///PUT
#define url_receiptinfos_change(x)      url_receiptinfos_delete(x)

#define url_address_area(x)             [[BASE_URL stringByAppendingString:@"address/area"]stringByAppendingString:x]

#define url_address_area_list(x)        [[BASE_URL stringByAppendingString:@"address/area/list/"] stringByAppendingString:x]

#pragma mark------用户----users
///GET
#define url_users_wxsearch                          [BASE_URL stringByAppendingString:@"users/wxsearch"]
///POST
#define url_users_wxcreate                          [BASE_URL stringByAppendingString:@"users/wx_create"]
///GET
#define url_users_search                            [BASE_URL stringByAppendingString:@"users/search"]
///POST
#define url_users_verifycode                        [BASE_URL stringByAppendingString:@"users/verifycode"]
///POST
#define url_users                                   [BASE_URL stringByAppendingString:@"users"]
///PUT
#define url_users_id(x)                             [url_users stringByAppendingString:x]
///POSTPOST
#define url_users_phone_password_reset(x)           [[url_users stringByAppendingString:x] stringByAppendingString:@"/password_reset"]

#pragma mark------用户----userinfos

#define url_userinfos_base            [BASE_URL stringByAppendingString:@"userinfos/"]

#define url_checkbankcard             [url_userinfos_base stringByAppendingString:@"checkbankcard"]

#define url_checkidcard               [url_userinfos_base stringByAppendingString:@"checkidcard"]
///
#define url_getbankcardinfo           [url_userinfos_base stringByAppendingString:@"getbankcardinfo"]
///POST
#define url_setuseraddress            [url_userinfos_base stringByAppendingString:@"user_address"]
///POST
#define url_setuserinfobank           [url_userinfos_base stringByAppendingString:@"setuserinfobank"]
///POST
#define url_setuserinfopricture       [url_userinfos_base stringByAppendingString:@"setuserinfopricture"]

#define url_userinfos                 [url_userinfos_base stringByAppendingString:@"show"]

#define url_userinfo_center           [url_userinfos_base stringByAppendingString:@"userinfo_center"]


#pragma mark------用户----创建
#define url_user_create               [BaseURL_Release81 stringByAppendingString:@"users"]
#pragma mark------用户----登录
//#define url_login                     [BASE_URL_Login stringByAppendingString:@"users/mobile_sign_in.json"]
#define url_login_new                     [BaseURL_Release81 stringByAppendingString:@"users/sign_in"]
#pragma mark------用户----注销
//#define url_logout                    [BASE_URL_Login stringByAppendingString:@"users/mobile_sign_out.json"]
#define url_logout_new                    [BaseURL_Release81 stringByAppendingString:@"users/sign_out"]
#endif /* YBLAPI_h */
