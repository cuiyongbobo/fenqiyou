//
//  ShareManager.h
//  ShareDemo
//
//  Created by cuiyong on 15/3/13.
//  Copyright (c) 2015年 M.!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <objc/runtime.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

//分享方式 默认微信
typedef enum ShareType{
    ShareTypeWXSceneSession = 0, /*微信好友分享*/
    ShareTypeWXSceneTimeline,    /*微信朋友圈分享*/
    ShareTypeQQSceneSession,     /*QQ好友分享*/
    ShareTypeQQSceneTimeline     /*QQ空间分享*/
}shareType;

typedef enum ShareScene{
    SceneSession = 0,               /*好友分享*/
    SceneTimeline = 1,              /*朋友圈 空间分享*/
}shareScene;

@interface YKShareModelMgr : NSObject <WXApiDelegate>

/**
 * 注册授权
 
 * shareType 分享类型
 * appID 官方API授权的appID码
 */
+ (BOOL)registeShareOfType: (shareType )shareType AndAppID:(NSString *)appID;

/**
 * 发送文本内容
 
 * textContent 发送消息的文本内容
 * @note 文本长度必须大于0且小于10K
 
 * shareType 分享类型
 * shareScene 分享场景
 */
+ (BOOL)sendTextContent: (NSString *)textContent ShareType: (shareType )shareType ShareScene: (shareScene )shareScene;

/**
  * 发送图片内容
 
 *  thumbNmae 设置消息缩略图的方法
 * @note 大小不能超过32K
 
 * imageName  图片真实数据内容(图片名称)
 * imageType 图片真实数据内容(图片类型)
 * @note 大小不能超过10M
 
 * shareType 分享类型
 * shareScene 分享场景
 */
+ (BOOL)sendImageWithImageName:(NSString *)imageName ImageType:(NSString *)imageType ShreType:(shareType )shareType ShareScene: (shareScene )shareScene;

/**
  * 发送新闻类型内容
 
  * title  多媒体内容标题
  * @note 不能为空且长度小于512
 
  * imageName 多媒体内容缩略图
  * @note 大小小于10k
 
  * urlAdd 网页的url地址
  * @note 不能为空且长度不能超过255
 
  * shareType 分享类型
  * shareScene 分享场景
 */
+ (BOOL)sendLinkTitle:(NSString *)title description:(NSString *)description ImageName:(NSString *)imageName URLAdd:(NSString *)urlAdd Type:(shareType )shareType;

//+ (BOOL)sendSMS:(NSString *)bodyOfMessage urlAddress:(NSString *)address;


@end
