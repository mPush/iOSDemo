//
//  ViewController.m
//  mPushDemo
//
//  Copyright (c) 2014年 mRocker. All rights reserved.
//

#import "ViewController.h"
#import "PushManager.h"

@interface ViewController (){
    
    NSString *localPushKey;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.view.frame) - 40, 50)];
    _titleLabel.backgroundColor = [UIColor grayColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.numberOfLines = 0;
    [self.view addSubview:_titleLabel];
    
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(_titleLabel.frame) + 20, CGRectGetWidth(_titleLabel.frame), 80)];
    _contentLabel.backgroundColor = [UIColor lightGrayColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _contentLabel.numberOfLines = 0;
    [self.view addSubview:_contentLabel];

    
    // Add LocalPush Btn
    UIButton *addLocalPushBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addLocalPushBtn.backgroundColor = [UIColor greenColor];
    addLocalPushBtn.frame = CGRectMake(20, 200, 100, 40);
    [addLocalPushBtn setTitle:@"创建本地通知" forState:UIControlStateNormal];
    [addLocalPushBtn addTarget:self action:@selector(createOneLocalPush) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addLocalPushBtn];
    
    //Cancel LocalPush For key
    UIButton *cancelLocalPushBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelLocalPushBtn.backgroundColor = [UIColor redColor];
    cancelLocalPushBtn.frame = CGRectMake(160, 200, 100, 40);
    [cancelLocalPushBtn setTitle:@"取消本地通知" forState:UIControlStateNormal];
    [cancelLocalPushBtn addTarget:self action:@selector(cancelOneLocalPush) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelLocalPushBtn];
 
    
    
    //get Auth Code From SMS
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getCodeBtn.backgroundColor = [UIColor blueColor];
    getCodeBtn.frame = CGRectMake(20, 250, 120, 40);
    [getCodeBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCodeBtn];
    
}


- (void)createOneLocalPush{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"v",@"k",@"v1",@"k1", nil];
    
    LocalPushAction *localPushAction = [[LocalPushAction alloc] init];
    localPushAction.type = LocalPushOpenUrlAction;
    localPushAction.value = @"http://mpush.cn/";
    
    localPushKey = [PushManager sendLocalPushMsg:@"消息标题"
                                         content:@"消息内容"
                                          action:localPushAction
                                      extentions:dic
                                        fireDate:[NSDate dateWithTimeIntervalSinceNow:30.0]];
}

- (void)cancelOneLocalPush{
    [PushManager cancelLocalPushForKey:localPushKey];
}

- (void)getAuthCode{
    [PushManager authSms:@"18618321894" timeInterval:3 finished:^(NSString *code, NSString *errorMsg) {
        NSLog(@"code = %@, errorMsg = %@",code,errorMsg);
        _contentLabel.text = [NSString stringWithFormat:@"code = %@ \n errorMsg = %@",code,errorMsg];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
