//
//  ViewController.m
//  GitHub
//
//  Created by jidao on 16/6/27.
//  Copyright © 2016年 iOS轰炸机. All rights reserved.
//

#import "ViewController.h"
#import "HLScrollPageView.h"
#import "GuoHeadVideoSDK.h"
//插屏
#import "GuoHeadInterstitialSDK.h"
@interface ViewController ()<HLScrollPageViewDelegate,GuoHeadVideoSDKDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    HLScrollPageView * pageView = [[HLScrollPageView alloc] initHLScrollPageViewFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    pageView.hlDuration = 3;
    pageView.hlIsWebImage = YES;
    pageView.delegate = self;
    pageView.hlImageAry = [[NSMutableArray alloc] initWithObjects:@"http://img.sc115.com/uploads/allimg/110518/201105181939411411.jpg",@"http://pic.nipic.com/2007-12-24/20071224181948306_2.jpg",@"http://img.taopic.com/uploads/allimg/140328/235043-14032Q1063876.jpg",nil];
    [self.view addSubview:pageView];
    
    
    
    
    
    
    
    
    
    
    
    
    //    插屏广告
    [GuoHeadInterstitialSDK configInterstitialSDKWithAppKey:@"230a5e458aacfada"];
    [GuoHeadInterstitialSDK preloadInterstitialWithDelegate:self withPlace:nil];
    
    
    
    
    
    
    [GuoHeadVideoSDK launchSDKWithSpid:@"230a5e458aacfada"];
    
    
    NSString *userCoins = [[NSUserDefaults standardUserDefaults] objectForKey:@"coins"];
    NSString *rewards = [[NSUserDefaults standardUserDefaults] objectForKey:@"rewards"];
    
}

-(void)HLdidSelectPageViewWithNumber:(NSInteger)SelectNumber{
    
    if ((arc4random() % 100)<50) {
        [GuoHeadInterstitialSDK displayInterstitialWithDelegate:self withPlace:nil withCurrentViewController:self];
    }else
    [GuoHeadVideoSDK playAdWithViewController:self
                                     delegate:self
                                    placeName:nil
                          onlySupportPortrait:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//下面都是插屏
- (void)ghInterstitialSDKDidCacheFailureWithPlace:(NSString *)place {
    NSLog(@"预加载失败");
}

- (void)ghInterstitialSDKDidCacheSuccessWithPlace:(NSString *)place {
    NSLog(@"预加载成功");
}

- (void)ghInterstitialSDKDidClickedWithPlace:(NSString *)place {
    NSLog(@"点击了广告内容");
}

- (void)ghInterstitialSDKDidClosedWithPlace:(NSString *)place {
    NSLog(@"广告被关闭，预加载下一条广告");
    [GuoHeadInterstitialSDK preloadInterstitialWithDelegate:self withPlace:nil];
}

- (void)ghInterstitialSDKDidShowFailureWithPlace:(NSString *)place {
    
}

- (void)ghInterstitialSDKDidShowSuccessWithPlace:(NSString *)place {
    
}

- (void)ghInterstitialSDKNoActivityWithPlace:(NSString *)place {
    
}







#pragma mark -
#pragma mark - GuoHeadVideoSDKDelegate optional

- (void)guoheadVideoSDKWillPlayAd:(NSString *)placeName {
    NSLog(@"GuoHeadVideoSDK::CallBack-guoheadVideoSDKWillPlayAd:");
}

- (void)guoheadVideoSDKDidClickAdContent:(NSString *)placeName {
    NSLog(@"GuoHeadVideoSDK::CallBack-guoheadVideoSDKDidClickAdContent:");
}

- (void)guoheadVideoSDKPlayAdFailure:(NSError *)error {
    NSLog(@"GuoHeadVideoSDK::CallBack-guoheadVideoSDKPlayAdFailure:%@", error.description);
}


#pragma mark -
#pragma mark - video 播放完成是否获取奖励的回调 requried
- (void)guoheadVideoSDKRewardWithPlaceName:(NSString *)placeName success:(BOOL)success rewardType:(NSString *)rewardName rewardAmount:(NSInteger)rewardAmount {
    NSLog(@"GuoHeadVideoSDK::CallBack-guoheadVideoSDKRewardWithPlaceName:success:rewardType:rewardAmount:");
    NSString *string = [NSString stringWithFormat:@"place : %@ \nsuccess : %d \nrewardType : %@ \nrewardAmount : %ld", placeName, success, rewardName, (long)rewardAmount];
    [[[UIAlertView alloc] initWithTitle:@"播放完成之后的奖励信息" message:string delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    
    
    
    NSNumber *userCoins = [[NSUserDefaults standardUserDefaults] objectForKey:@"coins"];
    
    if (userCoins == nil) {
        
        // --------------请在这里进行判断，然后将玩家的积分数目做逻辑上调整--------------
        if (success) {
            
            // test //
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:rewardAmount] forKey:@"coins"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:rewardAmount] forKey:@"rewards"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        if (success) {
            // test //
            NSInteger newUserCoins = userCoins.integerValue + rewardAmount;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:newUserCoins] forKey:@"coins"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:rewardAmount] forKey:@"rewards"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - 广告被完全关闭的回调方法
- (void)guoheadVideoSDKDidCloseAd:(NSString *)placeName shouldReward:(BOOL)shouldReward {
    NSLog(@"GuoHeadVideoSDK::CallBack-guoheadVideoSDKDidCloseAd:shouldReward:");
    
    NSNumber *userCoins = [[NSUserDefaults standardUserDefaults] objectForKey:@"coins"];
    NSNumber *rewards = [[NSUserDefaults standardUserDefaults] objectForKey:@"rewards"];
    

}


@end







