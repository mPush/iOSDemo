# iOS SDK 集成指南 #
- [使用提示](#1)
- [产品功能说明](#2)
- [主要特点](#3)
- [SDK压缩包内容](#4)
- [IOS 版本要求](#5)
- [SDK集成步骤](#6)
  - [1. 配置 推送证书](#9) 
  - [2. 导入SDK开发包到您的项目工程](#7)
  - [3. 配置 MPushAppID](#8) 
  - [4. 添加必须得framework](#10) 
  - [5. 编写代码](#11) 
  - [6. 测试确认](#12) 
- [SDK 接口详细说明](#13)
  - [远程推送 API](#14)
  - [本地推送 API](#15)
  - [推送回调 API](#16)
  - [DeviceToken回调 API](#17)
  - [调用流程](#18)
  - [别名和标签 API](#19)

<h2 id='1'>使用提示</h2>
***

本文是 mPush iOS SDK 标准集成指南。如有问题，请咨询技术支持QQ群：372650575

如果您想要快速地测试、感受下mPush的效果，请参考 [3 分钟快速 Demo](http://doc.mpush.cn/ios_demo.md)。 如果您看到本文档，但还未下载iOS SDK，请访问[SDK下载页面](/sdk)下载。本SDK只在真机环境下有效！


<h2 id='2'>产品功能说明</h2>
***

`mPush`是一个端到端的推送服务，使得服务器端消息能够及时地推送到终端用户手机上，让开发者积极地保持与用户的连接，从而提高用户活跃度、提高应用的留存率。

本 iOS SDK 方便开发者基于 mPush 来快捷地为 iOS App 增加推送功能。


<h2 id='3'>主要特点</h2>
***

* 客户端集成简单，无需对APNs进行相关操作。
* 可定制展示的界面。方便在接收到指定类型的通知后，打开展示界面。
* 可注册多个推送代理，分别处理回调信息。

<h2 id='4'>SDK压缩包内容</h2>
***
 

* lib文件夹：包含头文件 PushManager.h，静态库文件 libmPushSDK.a。
* doc文件夹：开发指南文档
* demo文件夹：（一个完整的iOS示例项目，演示mPush基本用法，可参考。）

![SDK压缩包内容](img/ios_guide_lib.png)

<h2 id='5'>iOS 版本要求</h2>
***

* 建议使用 xCode 4.5 或以上版本
* 目前SDK只支持iOS 5.0 及以上版本

<h2 id='6'>SDK集成步骤</h2>
***


<h3 id = '7'>1. 配置 推送证书</h3>     

此部分内容请参考[iOS 推送证书配置指南](http://doc.mpush.cn/ios_cert.md)。


<h3 id='8'>2. 导入SDK开发包到您的项目工程</h3>

* 解压缩mPush-sdk-v1.x.y.zip压缩包
* 复制lib文件夹到您的项目工程中，或者在项目工程名称处右键选择“Add files to 'Your project name'...”，将解压后的lib子文件夹（包含PushManager.h、libmPushSDK.a）添加到你的工程目录中。

![导入SDK开发包到你自己的应用程序项目](img/ios_guide_addsdk.png)

<h3 id='9'>3. 配置 MPushAppID </h3>

* 在您的项目文件`‘Your project name’-Info.plist`中右键选择“Add Row”,添加一行。

* 命名新建行的`key`值为`MPushAppID`,类型为`string`,`value`为在Protal上创建应用后所分配的`APP ID`。（此步骤为必选项，否则mPush将不会起作用！）
 
     ![MPushAppKey设置](img/MPushAppKey.png)
      

<h3 id='10'>4. 添加必要的框架</h3> 
    
		  CFNetwork.framework
		  CoreFoundation.framewo
		  CoreTelephony.frameworkrk
		  SystemConfiguration.framewo
		  Security.framework
		  StoreKit.framework
		  CoreLocation.framework
		  libz.dylib
		  Foundation.framework
		  UIKit.framework


<h3 id='11'>5. 添加代码</h3> 

在application: didFinishLaunchingWithOptions:中调用`startPushService: pushDelegate: deviceTokenDelegate: customViews:`，注册mPush服务：

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
        // Override point for customization after application launch.
     ......
    
        /**
         *  开启推送服务并设置推送代理以及DeviceToken回调代理、自定义展示页面数据
         *  pushDelegate  推送代理，必须，参数对象必须实现onMessage:content:extention:方法
         *  deviceTokenDelegate  DeviceToken获取代理，如果无需获取SDK中得DeviceToken，此项可为nil。
         *  customViews 为自定义展示页面数据字典，如果无需自定义，此项可为nil
         */
        [PushManager startPushService:launchOptions pushDelegate:self deviceTokenDelegate:nil customViews:nil];
    
        return YES;
	}
	
	
#### 实现PushManagerDelegate协议，必须实现方法onMessage:content:extention:

	/**
	  *  代理回调方法
	  *
	  *  @param title     消息title内容
	  *  @param content   消息content内容
	  *  @param extention 自定义参数数据字典，如果在新建推送通知的时候使用了自定义参数，则extention中包含有所有自定义参数数据。
	  *
	  *  @return BOOL 当返回YES时，仅处理至当前事件处，后续事件将不再执行，当返回NO时，按照事件链继续执行，直至返回YES或者所有事件执行完。
	  */
	- (BOOL)onMessage:(NSString *)title content:(NSString *)content extention:(NSDictionary *)extention{
    //在这里您可以处理收到的消息内容
    	NSLog(@"title : %@ \n content : %@ \n extention : %@ \n",title,content,[extention description]);
    	return YES;
	} 

<h3 id='12'>6. 测试确认</h3>   

1.  确认 MPushAppID（你在 mPush Protal 上创建应用后所分配给应用的APP ID）已经正确的写入 `‘Your project name’-Info.plist`中 ，如未填写，请参考[3. 配置 MPushAppID](#8)进行配置。
2.  确认所使用的签名证书是具有推送权限的证书，如果不是，请参考[iOS 推送证书配置指南](http://doc.mpush.cn/ios_cert.md)进行配置。
3.  如证书无误，确认项目的`Bundle ID`和推送证书配置时的`Bundle ID`是否一致。
4.  确认程序启动时调用了`startPushService: pushDelegate: deviceTokenDelegate: customViews:`接口。并实现了PushManagerDelegate协议方法。
5.  确认测试设备已成功接入网络，且网络正常。
6.  确认以上步骤无误后，启动应用程序，在 Portal 上向应用程序发送推送消息（详情请参考管理Portal），如果 SDK 工作正常，客户端应可收到下发的通知，应有消息到达的日志信息。
7.  如以上步骤确认无误，仍无法接收到推送消息，请咨询技术支持QQ群：`372650575`。


<h2 id='13'>SDK接口详细说明</h2>
***

mPush SDK 提供的 API 主要集中在 PushManager.h 接口类中。

<h3 id='14'>远程推送 API</h3> 
 
	/**
	 *  开启推送服务并设置推送代理以及DeviceToken获取回调代理、自定义展示页面数据
	 *  pushDelegate  推送代理，必须，参数对象必须实现onMessage:content:extention:方法
	 *  deviceTokenDelegate  DeviceToken获取代理，如果无需获取得DeviceToken，此项可为nil。(此DeviceToken为苹果原生DeviceToken的32位hex字符串。)
	 *  customViews 为自定义展示页面数据字典，如果无需自定义，此项可为nil
	 */

	+ (void)startPushService:(NSDictionary *)launchOptions
            	pushDelegate:(id <PushManagerDelegate>) pushDelegate
     	deviceTokenDelegate:(id <DeviceTokenDelegate>) deviceTokenDelegate
            	 customViews:(NSDictionary *)displaysMap;

示例代码：
		
	// Optional 自定义展示页，添加后，新建推送时，可指定页面，注意新建推送时，看到的是自定义的界面的别名Key。
    // key:设置预打开界面的别名  value:自定义展示界面的类名
    	
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:NSStringFromClass([DemoViewController class]) forKey:@"DemoPage"];
    
    [PushManager startPushService:launchOptions pushDelegate:self deviceTokenDelegate:self customViews:dictionary];



<h3 id='15'>本地推送 API</h3> 

<h5>创建本地通知</h5>

	/**
 	 *  创建本地通知
	 *
	 *  @param title      通知标题
  	 *  @param content    通知内容
 	 *  @param action     详见 LocalPushAction 类
 	 *  @param extention  自定义参数集合
 	 *  @param fireDate   通知发生时间
 	 *
 	 *  @return SDK分配给本通知的唯一标识
 	 */
	 + (NSString *)sendLocalPushMsg:(NSString *)title
                       content:(NSString *)content
                        action:(LocalPushAction *)action
                    extentions:(NSDictionary *)extention
                      fireDate:(NSDate *)fireDate;



<h5>取消指定标识的单个本地通知</h5>
	/**
	 *  取消指定标识的单个本地通知
	 *
 	 *  @param key 通知标识，为创建时所分配。
 	 */
	+ (void)cancelLocalPushForKey:(NSString *)key;

<h5>取消所有的本地通知</h5>
	/**
	 *  一次性取消所有的本地通知
	 */
	+ (void)cancelAllLocalPush;

<h3 id='16'>推送回调 API</h3>

		/**
		 *  推送消息代理回调方法 （包含远程推送和本地推送）
		 *
		 *  @param title     消息title内容
		 *  @param content   消息content内容
		 *  @param extention 自定义参数字典
		 *
		 *   @return BOOL 当返回YES时，仅处理至当前事件处，后续事件将不再执行，当返回NO时，按照事件链继续执行，直至返回YES或者所有事件执行完。
		 */
		- (BOOL)onMessage:(NSString *)title 
				  content:(NSString *)content 
				extention:(NSDictionary *)extention;

<h3 id='17'>DeviceToken回调 API</h3>

	/**
	 *  获取DeviceToken，此DeviceToken为苹果原生DeviceToken 的32位hex字符串。
	 *  如果需要原生的DeviceToken，可使用系统 didRegisterForRemoteNotificationsWithDeviceToken: 方法获取
	 *
	 *  @return deviceToken
	 */
	 - (void)didReciveDeviceToken:(NSString *)deviceToken;
 
 

 

 <h2 id='18'>调用流程</h2>


	1. 如果需要添加自定义展示界面，则在 `YourAppDelegate`的`application: didFinishLaunchingWithOptions:`方法中 事先定义好展示界面的数据字典，如果无需添加，可忽略此步。

		NSMutableDictionary字典对象定义：key->展示界面别名，object->展示界面的Class。示例代码：

			//key:设置预打开界面的别名  value:自定义展示界面的类名
			NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
			[dictionary setObject:NSStringFromClass([ViewController class]) forKey:@"主页"];


	2. 定义好相关参数后，调用`startPushService: pushDelegate: deviceTokenDelegate: customViews:`方法，传入相关参数,如果需要查看调试日志，可设置`DebugMode`为`true`。

			/**
			 *  开启推送服务并设置推送代理以及DeviceToken获取回调代理、自定义展示页面数据
			 *  pushDelegate  推送代理，必须，参数对象必须实现onMessage:content:extention:方法
			 *  deviceTokenDelegate  DeviceToken获取代理，如果无需获取SDK中得DeviceToken，此项可为nil
			 *  customViews 为自定义展示页面数据字典，如果无需自定义，此项可为nil
			 */
            
            [PushManager startPushService:launchOptions pushDelegate:self deviceTokenDelegate:self customViews:dictionary];
            
			/**
            *  设置是否为调试模式 默认为不开启  enabled:YES  打开   enabled:NO 关闭
            */
            
            [PushManager setDebugMode:YES];   
            
			/**
             *   追加代理，append：YES 为追加  append：NO 为首项添加
             */
             
            [PushManager setPushDelegate:self append:YES];
            
            
    3. 添加本地通知。完成第二步之后，使用`sendLocalPushMsg:content:action:extentions:fireDate:`方法创建一个本地通知，此方法会返回SDK给本通知分配的唯一标识key：
    
    		NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"v",@"k",@"v1",@"k1", nil];
    
   			LocalPushAction *localPushAction = [[LocalPushAction alloc] init];
   			localPushAction.type = LocalPushOpenUrlAction;
   			localPushAction.value = @"http://mpush.cn/";
    
   			localPushKey = [PushManager sendLocalPushMsg:@"消息标题"
   			   			 						 content:@"消息内容" 
   			   			 						 action:localPushAction 
   			   			 						 extentions:dic 
   			   			 						 fireDate:[NSDate dateWithTimeIntervalSinceNow:30.0]];
             
             
    4. 取消本地通知。如果要取消单个本地通知，则使用创建本地通知时所返回的通知标识来取消：
    
    		[PushManager cancelLocalPushForKey:localPushKey];   
    		 
       或取消所有的本地通知：
    		
    		[PushManager cancelAllLocalPush];      
      
	5. 回调方法的实现。如果注册了回调代理，则必须实现`onMessage:content:extention:`代理方法。以用来处理推送消息以及控制事件处理链，如无需自行处理消息内容，可直接返回YES。示例代码：
	
	
			/**
			 *  PushManagerDelegate回调方法
			 *
			 *  @param title     消息title内容
			 *  @param content   消息content内容
			 *  @param extention 自定义参数字典
			 *
			 *  @return BOOL 当返回YES时，仅处理至当前事件处，后续事件将不再执行，当返回NO时，按照事件链继续执行，直至返回YES或者所有事件执行完。
			 */
			- (BOOL)onMessage:(NSString *)title content:(NSString *)content extention:(NSDictionary *)extention{
				 NSLog(@"title : %@   content : %@ extention : %@",title,content,extention);
				 return YES;
			}
	
			/**
			 * DeviceTokenDelegate回调方法	
			 *  获取DeviceToken，此DeviceToken为苹果原生DeviceToken 的32位hex字符串。
			 *  如果需要原生的DeviceToken，可使用系统 didRegisterForRemoteNotificationsWithDeviceToken 方法获取
			 *  @return deviceToken	
			 */
			 - (void)didReciveDeviceToken:(NSString *)deviceToken{
			 	NSLog(@"deviceToken = %@",deviceToken);
			 }


<h2 id='19'>别名和标签 API</h2>

<h4>别名 alias</h4>

上报用户的别名(例如用户昵称)，以便支持按别名推送消息。
		
	/**
 	 *  为设备设置别名或移除别名,设置的前提条件是设备的DeviceToken已经获取成功。
	 *
	 *  @param alias 别名名称，当为nil或者@""时，为移除别名，否则为设置别名。重复调用会自动更新至最后一次调用时的别名。
	 */
	+ (void)setAlias:(NSString *)alias;


<h4>标签 tag</h4>

开发者可以针对不同的用户设置标签，以便根据标签进行指向性推送消息。

 <h6>设置标签</h6>

	/**
	 *  为设备设置tag，可以为多个。
	 *
	 *  @param tags tag名称。
	 */
	+ (void)setTags:(NSMutableArray *)tags;

<h6>删除标签</h6>

	/**
	 *  删除设置过的tag，可以为多个。
	 *
	 *  @param tags tag名称。
	 */
	+ (void)deleteTags:(NSMutableArray *)tags;