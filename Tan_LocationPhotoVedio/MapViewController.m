//
//  MapViewController.m
//  Tan_LocationPhotoVedio
//
//  Created by PX_Mac on 16/5/7. ..  
//  Copyright © 2016年 PX_Mac. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController ()<MKMapViewDelegate>{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1、添加地图视图
    CGRect rect = [UIScreen mainScreen].bounds;
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 50, rect.size.width, rect.size.height - 50)];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate = self;
    
    //2、请求定位服务
    _locationManager = [[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //3、用户位置追踪
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //4、设置地图类型
    _mapView.mapType = MKMapTypeStandard;
}

//返回上一页
- (IBAction)returnLastPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
