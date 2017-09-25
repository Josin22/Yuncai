//
//  YBLBMLocationService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBMLocationService.h"
#import "YBLBMLocationViewController.h"
#import "YBLBMLocationViewModel.h"
#import "YBLMapItemCell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "YBLBMLocationViewModel.h"

static CGFloat const kCurrentLocationBtnWH = 50;

@implementation BMKPoiInfoModel

@end

@interface YBLBMLocationService ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BMKMapView             * mapView;
@property (nonatomic,strong) BMKLocationService     * locService;
@property (nonatomic,strong) BMKGeoCodeSearch       * geocodesearch;
@property (nonatomic,strong) UITableView            *tableView;
@property (nonatomic,strong) NSMutableArray         *dataSource;
@property (nonatomic,assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic,strong) UIImageView            *centerCallOutImageView;
@property (nonatomic,strong) UIButton               *currentLocationBtn;
@property (nonatomic,weak  ) YBLBMLocationViewModel *viewModel;
@property (nonatomic,weak  ) YBLBMLocationViewController *Vc;

@property (nonatomic,strong) BMKPoiInfoModel *selectModel;

@end

@implementation YBLBMLocationService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLBMLocationViewModel *)viewModel;
        _Vc = (YBLBMLocationViewController *)VC;
        
        //
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
        backItem.tintColor = YBLTextColor;
        self.Vc.navigationItem.leftBarButtonItem = backItem;
        
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveSelectMap)];
        saveItem.tintColor = YBLThemeColor;
        self.Vc.navigationItem.rightBarButtonItem = saveItem;
        
        [self createUI];
        
        //开启定位
        [self checkLocationService];
        
        [[self.Vc rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(RACTuple * _Nullable x) {
            [self.mapView viewWillAppear];
            self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
            self.locService.delegate = self;
            self.geocodesearch.delegate = self;
        }];
        
        [[self.Vc rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(RACTuple * _Nullable x) {
            [self.mapView viewWillDisappear];
            self.mapView.delegate = nil; // 不用时，置nil
            self.locService.delegate = nil;
            self.geocodesearch.delegate = nil;
        }];
    }
    return self;
}

- (void)goback{
    
    [self.Vc dismissViewControllerAnimated:YES completion:nil];
    [self.Vc.navigationController popViewControllerAnimated:YES];
}


- (void)saveSelectMap {
    if (!self.selectModel) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选择地址哟~"];
        return;
    }
    NSString *new_name = self.selectModel.name;
    NSString *new_address = self.selectModel.address;
    self.selectModel.address = [NSString stringWithFormat:@"%@%@",new_address,new_name];
    BLOCK_EXEC(self.viewModel.mapSelectBlock,self.selectModel)
    [self goback];
}


-(void)createUI
{
    //BMKMapView
    self.mapView.frame = CGRectMake(0, 0, YBLWindowWidth, (YBLWindowHeight-kNavigationbarHeight*2)/2);
    [self.Vc.view addSubview:self.mapView];
    
    //固定定位图标
    self.centerCallOutImageView.frame = CGRectMake(0, 0, 40, 40);
    self.centerCallOutImageView.center = self.mapView.center;
    [self.Vc.view addSubview:self.centerCallOutImageView];
    [self.Vc.view bringSubviewToFront:self.centerCallOutImageView];
    
    [self.mapView layoutIfNeeded];
    
    //UITableView
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.mapView.frame), YBLWindowWidth, YBLWindowHeight-self.mapView.bottom);
    [self.Vc.view addSubview:self.tableView];
    
    //定位按钮
    self.currentLocationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.currentLocationBtn.frame = CGRectMake(0, CGRectGetMaxY(self.mapView.frame)-kCurrentLocationBtnWH-10, kCurrentLocationBtnWH, kCurrentLocationBtnWH);
    self.currentLocationBtn.right = YBLWindowWidth-space;
    [self.currentLocationBtn setImage:[UIImage imageNamed:@"map_local_self_normal"] forState:UIControlStateNormal];
    [self.currentLocationBtn setImage:[UIImage imageNamed:@"map_local_self_select"] forState:UIControlStateSelected];
    [self.currentLocationBtn addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    self.currentLocationBtn.backgroundColor = [UIColor whiteColor];
    self.currentLocationBtn.layer.cornerRadius = self.currentLocationBtn.height/2;
    self.currentLocationBtn.layer.masksToBounds = YES;
    [self.Vc.view addSubview:self.currentLocationBtn];
    [self.Vc.view bringSubviewToFront:self.currentLocationBtn];
}

- (void)checkLocationService{
    
    if (![self.viewModel checkLocationServicesIsEnabled]) {
        
        RACSignal * deallocSignal = [self.Vc rac_signalForSelector:@selector(viewWillDisappear:)];
        //回到程序
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:deallocSignal] subscribeNext:^(id x) {
            NSLog(@"UIApplicationDidEnterBackgroundNotification");
            //重新定位
            [self startLocation];
        }];
        /* 弹窗提示 */
        [YBLOrderActionView showTitle:@"无法获取您的位置信息。请到\n手机系统的[设置]->[隐私]->[定位服务]中打开定位服务,\n 并允许手机云采使用定位服务。"
                               cancle:@"取消"
                                 sure:@"前往设置"
                      WithSubmitBlock:^{
                          NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                          [YBLMethodTools OpenURL:url];
                      }
                          cancelBlock:^{
                              [self goback];
                          }];
    } else {
        [self startLocation];
    }
}

- (void)startLocation{
   
    self.currentLocationBtn.selected=YES;
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
}

-(void)startGeocodesearchWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    //反地理编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

-(void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate
{
    _currentCoordinate=currentCoordinate;
    [self startGeocodesearchWithCoordinate:currentCoordinate];
}

#pragma mark - BMKMapViewDelegate

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.currentLocationBtn.selected=NO;
    [self.mapView updateLocationData:userLocation];
    self.currentCoordinate=userLocation.location.coordinate;
    
    if (self.currentCoordinate.latitude!=0)
    {
        [self.locService stopUserLocationService];
    }
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D tt =[mapView convertPoint:self.centerCallOutImageView.center toCoordinateFromView:self.centerCallOutImageView];
    self.currentCoordinate=tt;
}

#pragma mark - BMKGeoCodeSearchDelegate

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        NSMutableIndexSet *indexp = [NSMutableIndexSet new];
        NSInteger index = 0;
        for (BMKPoiInfoModel *model in self.dataSource) {
            if (!model.isSelect) {
                [indexp addIndex:index];
            }
            index++;
        }
        [self.dataSource removeObjectsAtIndexes:indexp];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            BMKPoiInfoModel *model=[[BMKPoiInfoModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            model.pt = poiInfo.pt;
            [self.dataSource addObject:model];
        }

        [self.tableView jsReloadData];
    }
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LocationCell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    BMKPoiInfoModel *model=[self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=model.address;
    cell.detailTextLabel.textColor=[UIColor grayColor];
    
    if (model.isSelect)
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType=UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfoModel *model=[self.dataSource objectAtIndex:indexPath.row];
    NSLog(@"选择地址信息：{地址：%@ 经度：%f 维度：%f}",[NSString stringWithFormat:@"%@%@",model.address,model.name],model.pt.longitude,model.pt.latitude);
    
    if (model.isSelect) {
        return;
    }
    for (BMKPoiInfoModel *local_model in self.dataSource) {
        local_model.isSelect = NO;
    }
    
    [model setValue:@(YES) forKey:@"isSelect"];
    
    self.selectModel = model;
    
    [self relocalWithPT:model.pt];
    
    [self.tableView jsReloadData];
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)relocalWithPT:(CLLocationCoordinate2D)pt{
    BMKMapStatus *mapStatus =[self.mapView getMapStatus];
    mapStatus.targetGeoPt=pt;
    [self.mapView setMapStatus:mapStatus withAnimation:YES];
}

#pragma mark - Getters

-(BMKMapView*)mapView
{
    if (_mapView==nil)
    {
        _mapView =[BMKMapView new];
        _mapView.zoomEnabled=YES;
        _mapView.zoomEnabledWithTap=YES;
        _mapView.zoomLevel=17;
    }
    return _mapView;
}

-(BMKLocationService*)locService
{
    if (_locService==nil)
    {
        _locService = [[BMKLocationService alloc]init];
    }
    return _locService;
}

-(BMKGeoCodeSearch*)geocodesearch
{
    if (_geocodesearch==nil)
    {
        _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
}

-(UITableView*)tableView
{
    if (_tableView==nil)
    {
        _tableView=[UITableView new];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
    }
    return _tableView;
}

-(UIImageView*)centerCallOutImageView
{
    if (_centerCallOutImageView==nil)
    {
        _centerCallOutImageView=[UIImageView new];
        [_centerCallOutImageView setImage:[UIImage imageNamed:@"map_datouzhen"]];
        _centerCallOutImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerCallOutImageView;
}

-(NSMutableArray*)dataSource
{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    
    return _dataSource;
}

@end
