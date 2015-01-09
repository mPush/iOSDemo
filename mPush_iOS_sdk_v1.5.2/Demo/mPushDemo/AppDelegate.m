//
//  AppDelegate.m
//  mPushDemo
// 
//  Copyright (c) 2014年 mRocker. All rights reserved.
//

#import "AppDelegate.h"
#import "PushManager.h"

#import "ViewController.h"
#import "DemoViewController.h"

@interface AppDelegate()<PushManagerDelegate,DeviceTokenDelegate>

@property (nonatomic, strong) ViewController *viewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // Optional 自定义展示页，添加后，新建推送时，可指定页面，注意新建推送时，看到的是自定义的界面的别名Key。可查看 http://mportal.mrocker.com/index.php/user/newMsg.html 中`打开方式`部分。
    // key:设置预打开界面的别名  value:自定义展示界面的类名
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:NSStringFromClass([DemoViewController class]) forKey:@"DemoPage"];
    
    /**
     *  开启推送服务并设置推送代理以及DeviceToken获取回调代理、自定义展示页面数据
     *  pushDelegate  推送代理
     *  deviceTokenDelegate  DeviceToken获取代理，如果无需获取SDK中得DeviceToken，此项可为nil
     *  customViews 为自定义展示页面数据字典，如果无需自定义，此项可为nil
     */
    [PushManager startPushServiceWithDelegate:self tokenDelegate:self customViews:dictionary];
    
    /**
     *  设置是否为调试模式 默认为不开启  enabled:YES  打开   enabled:NO 关闭
     */
    [PushManager setDebugMode:YES];
    
    /**
     *   追加代理，append：YES 为追加  append：NO 为首项添加 （非必须）
     */
    [PushManager setPushDelegate:self append:YES];
    
    /**
     *  为设备应用设置别名
     */
    [PushManager setAlias:@"Alias-Testing"];
    
    /**
     *  按渠道检查版本,传入渠道名称即可 
     *
     */
    [PushManager checkNewUpdateWithChannel:@"AppStore" success:^(BOOL isNewest) {
        if (isNewest) {
            NSLog(@"已经是最新版本");
        }
    }];
    
    
    _viewController = [[ViewController alloc] init];
    self.window.rootViewController = _viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}



#pragma mark --
#pragma mark -- PushManagerDelegate Method
- (BOOL)onMessage:(NSString *)title content:(NSString *)content extention:(NSDictionary *)extention{
    
    _viewController.titleLabel.text = [NSString stringWithFormat:@"title:%@",title];
    _viewController.contentLabel.text = [NSString stringWithFormat:@"content:%@",content];
    
    UIApplicationState appState = [extention[AppStateKey] integerValue];
    
    NSLog(@"title : %@ \n content : %@ \n extention : %@ \n appState : %ld \n",title,content,[extention description],appState);
    
    return YES;
}



#pragma mark --
#pragma mark -- DeviceTokenDelegate Method
- (void)didReciveDeviceToken:(NSString *)deviceToken{
    NSLog(@"deviceToken --- String : %@",deviceToken);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"原生 deviceToken : %@",deviceToken);
}

@end
