//
//  GuoHeadVideoSDK.h
//  GuoHeadVideoSDK
//
//  Copyright © 2016 keith.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GuoHeadVideoSDKDelegate;

typedef NS_ENUM(NSUInteger, GuoHeadSDKPreloadStatus) {
    GuoHeadSDKPreloadStatusFailure = 1,
    GuoHeadSDKPreloadStatusSuccess,
    GuoHeadSDKPreloadStatusProgressing,
};

#pragma mark - 果合视频广告SDK 接口函数

@interface GuoHeadVideoSDK : NSObject

/**
 *  初始化配置SDK
 *  建议在工程启动的时候立即调用
 *  @param spid 您app的唯一识别码，请在果合公司官网http://www.guohead.com的开发者页面获取
 *  @return GuoHeadVideoSDK单例对象
 */
+ (GuoHeadVideoSDK *)launchSDKWithSpid:(NSString *)spid;

/**
 *  播放广告方法
 *  传入要承载视频广告界面的UIViewController和delegate，将会进行播放
    将会直接进行请求远程video的链接进行播放，会进行一段时间的缓冲
 *  如果播放过程中希望获得更多信息，可以传入delegate实现相关方法进行查看
 *  @param viewController       要以presentViewController形式呈现的viewController，可以传nil
 *                              如果传入nil，SDK则会内部获取当前app正在显示的UIViewController
 *  @param delegate             GuoHeadVideoSDKDelegate的委托对象必须遵循，否则无法获取奖励回调
 *  @param placeName            广告位：如果传入nil，SDK会默认为“default”
 *  @param onlySupportPortrait  若app仅支持竖屏或倒立方向请传入 YES，否则传入 NO
 */
+ (void)playAdWithViewController:(UIViewController*)viewController
                        delegate:(id<GuoHeadVideoSDKDelegate>)delegate
                       placeName:(NSString *)placeName
             onlySupportPortrait:(BOOL)onlySupportPortrait;

@end



#pragma mark - 果合视频广告SDK回调函数

@protocol GuoHeadVideoSDKDelegate <NSObject>

@optional
/**
 *  广告即将开始播放触发的回调
 *
 *  由于即将要播放指定广告位的视频内容，可以实现该方法做一些操作例如：暂停游戏、关闭游戏的音效
 *  待广告播放流程完毕之后，再重新开启游戏和游戏音效。参考：“用户点击了广告关闭按钮触发的回调”
 *  @param placeName 广告位
 */
- (void)guoheadVideoSDKWillPlayAd:(NSString *)placeName;

/**
 *  广告播放出错触发的回调
 *
 *  @param error 错误信息
 */
- (void)guoheadVideoSDKPlayAdFailure:(NSError *)error;

/**
 *  用户观看完视频后，点击广告内容图而跳转到AppStore时触发的回调
 *
 *  @param placeName 当前广告的广告位
 */
- (void)guoheadVideoSDKDidClickAdContent:(NSString *)placeName;


#pragma mark - 请实现此回调
@required
/**
 *  视频广告播放完成后，用户获得奖励的回调
 *
 *  当播放广告完成后用户将会获得相应的奖励，在该回调中根据您制定的规则调整用户的积分数目等逻辑
 *  在关闭广告之后，在界面中通知用户得到相关奖励即可。参考：“用户点击了广告关闭按钮触发的回调”
 *  注意：视频播放完成会触发此回调，通过success的值来进行判断是否应该对用户进行积分奖励
 *  @param placeName    当前广告的广告位
 *  @param success      是否应该对用户进行奖励，YES：应该奖励 NO：不应该奖励
 *  @param rewardName   奖励类型：例如：currency（代表积分）、life（代表生命）等
 *  @param rewardAmount 奖励数量：例如：10（返回给用户的奖励数目）
 */
- (void)guoheadVideoSDKRewardWithPlaceName:(NSString *)placeName
                                   success:(BOOL)success
                                rewardType:(NSString *)rewardName
                              rewardAmount:(NSInteger)rewardAmount;

#pragma mark - 请实现此回调
/**
 *  用户点击了广告关闭按钮触发的回调
 *
 *  当广告播放完毕后，用户点击了页面的关闭按钮或者用户点击了广告内容进行了跳转之后，在该方法
 *  中：判断当前用户是否获取到奖励，
 *  例如用户的积分等是否满足奖励条件，如果满足则可以更改界面积分，通知用户获取到了相应的奖励
 *  可以在此回调中调用预加载方法请求下一条广告
 *  @param placeName    当前广告的广告位
 *  @param shouldReward 用户是否应该获得奖励 YES：应该获得奖励 NO：用户中途关闭了广告
 */
- (void)guoheadVideoSDKDidCloseAd:(NSString *)placeName shouldReward:(BOOL)shouldReward;

@end

