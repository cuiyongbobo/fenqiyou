//
//  ShareManager.m
//  ShareDemo
//
//  Created by cuiyong on 15/3/13.
//  Copyright (c) 2015年 M.!. All rights reserved.
//

#import "YKShareModelMgr.h"

#import "SDWebImageManager.h"
//#import "YKAlertViewMgr.h"

@implementation YKShareModelMgr

+ (BOOL)registeShareOfType: (shareType )shareType AndAppID:(NSString *)appID
{
    if (shareType == ShareTypeWXSceneSession || shareType == ShareTypeWXSceneTimeline)
    {
        if ([WXApi registerApp:appID])
        {
            if ([WXApi isWXAppInstalled])
            {
                return YES;
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"未安装微信客户端，\n不支持该功能" preferredStyle: UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                
                return NO;
            }
        }
        else
            return NO;
    }
    else if (shareType == ShareTypeQQSceneSession || shareType == ShareTypeQQSceneTimeline)
    {
        if ([QQApiInterface isQQSupportApi])
        {
            TencentOAuth * tencentOAuth = [[TencentOAuth alloc]initWithAppId:appID andDelegate:nil];
            tencentOAuth.localAppId = @"yinkerSchemes";
            return YES;
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"未安装QQ客户端，\n不支持该功能" preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            return NO;
        }
    }
    else
        return NO;
}

+ (BOOL)sendTextContent:(NSString *)textContent ShareType:(shareType)shareType ShareScene:(shareScene)shareScene
{
    if (textContent)
    {
        if (shareType == ShareTypeWXSceneSession)
        {
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = YES;
            req.text = textContent;
            req.scene = shareScene;
            
            [WXApi sendReq:req];
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

+ (BOOL)sendImageWithImageName:(NSString *)imageName
                     ImageType:(NSString *)imageType
                      ShreType:(shareType )shareType
                    ShareScene:(shareScene)shareScene
{
    
    if (imageName&&imageType)
    {
        if (shareType == ShareTypeWXSceneSession)
        {
            WXMediaMessage *message = [WXMediaMessage message];
            WXImageObject *ext = [WXImageObject object];
            
            if ([imageName hasPrefix:@"http"] || [imageName hasPrefix:@"www"]) {
                imageName = @"shared";
            }
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
            
            if (filePath == nil) {
                NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[imageName stringByAppendingPathExtension:imageType]];
                ext.imageData = [NSData dataWithContentsOfFile:docPath] ;
            }
            else{
                ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
            }
            
            
            message.mediaObject = ext;
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = shareScene;
            [WXApi sendReq:req];
            
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

+ (BOOL)sendLinkTitle:(NSString *)title
          description:(NSString *)description
            ImageName:(NSString *)imageName
               URLAdd:(NSString *)urlAdd
                 Type:(shareType )shareType
{
    
    if (imageName&&urlAdd)
    {
        if (shareType == ShareTypeWXSceneSession)
        {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title =title;
            message.description = description;
            
            if ([imageName hasPrefix:@"www"]) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[@"http://" stringByAppendingString:imageName]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    [message setThumbImage:image];
                    
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl = urlAdd;
                    message.mediaObject = ext;
                    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = WXSceneSession;
                    [WXApi sendReq:req];
                }];
                
            }
            else if([imageName hasPrefix:@"http"]){
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageName] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [message setThumbImage:image];
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl = urlAdd;
                    message.mediaObject = ext;
                    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = WXSceneSession;
                    [WXApi sendReq:req];
                }];
            }
            else if([imageName hasPrefix:@"https"]){
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageName] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [message setThumbImage:image];
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl = urlAdd;
                    message.mediaObject = ext;
                    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = WXSceneSession;
                    [WXApi sendReq:req];
                }];
            }
            else{
                [message setThumbImage:[UIImage imageNamed:imageName]];
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = urlAdd;
                message.mediaObject = ext;
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneSession;
                [WXApi sendReq:req];
            }
            return YES;
        }else if (shareType == ShareTypeWXSceneTimeline) {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title =title;
            message.description = description;
            
            if ([imageName hasPrefix:@"www"]) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[@"http://" stringByAppendingString:imageName]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    [message setThumbImage:image];
                    
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl = urlAdd;
                    message.mediaObject = ext;
                    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = WXSceneTimeline;
                    [WXApi sendReq:req];
                }];
                
            }
            else if([imageName hasPrefix:@"http"]){
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageName] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [message setThumbImage:image];
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl = urlAdd;
                    message.mediaObject = ext;
                    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = WXSceneTimeline;
                    [WXApi sendReq:req];
                }];
            }
            else{
                [message setThumbImage:[UIImage imageNamed:imageName]];
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = urlAdd;
                message.mediaObject = ext;
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneTimeline;
                [WXApi sendReq:req];
            }
            return YES;
        }
        else if (shareType == ShareTypeQQSceneSession)
        {
            //好友
            QQApiNewsObject *obj;
            if ([imageName hasPrefix:@"www"]) {
                obj = [[QQApiNewsObject alloc] initWithURL:[NSURL URLWithString:urlAdd] title:title description:description previewImageURL:[NSURL URLWithString:imageName] targetContentType:QQApiURLTargetTypeNews];
            }else if([imageName hasPrefix:@"http"]){
                obj = [[QQApiNewsObject alloc] initWithURL:[NSURL URLWithString:urlAdd] title:title description:description previewImageURL:[NSURL URLWithString:imageName] targetContentType:QQApiURLTargetTypeNews];
            }else {
                UIImage *image = [UIImage imageNamed:imageName];
                NSData *data;
                if (UIImagePNGRepresentation(image) == nil) {
                    data = UIImageJPEGRepresentation(image, 1);
                } else {
                    data = UIImagePNGRepresentation(image);
                }
                obj = [[QQApiNewsObject alloc] initWithURL:[NSURL URLWithString:urlAdd] title:title description:description previewImageData:data targetContentType:QQApiURLTargetTypeNews];
            }
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            [QQApiInterface sendReq:req];
            return YES;
        }
        else
        {
            //空间
            QQApiNewsObject *obj;
            if ([imageName hasPrefix:@"www"]) {
                obj = [[QQApiNewsObject alloc] initWithURL:[NSURL URLWithString:urlAdd] title:title description:description previewImageURL:[NSURL URLWithString:imageName] targetContentType:QQApiURLTargetTypeNews];
            }else if([imageName hasPrefix:@"http"]){
                obj = [[QQApiNewsObject alloc] initWithURL:[NSURL URLWithString:urlAdd] title:title description:description previewImageURL:[NSURL URLWithString:imageName] targetContentType:QQApiURLTargetTypeNews];
            }else {
                UIImage *image = [UIImage imageNamed:imageName];
                NSData *data;
                if (UIImagePNGRepresentation(image) == nil) {
                    data = UIImageJPEGRepresentation(image, 1);
                } else {
                    data = UIImagePNGRepresentation(image);
                }
                obj = [[QQApiNewsObject alloc] initWithURL:[NSURL URLWithString:urlAdd] title:title description:description previewImageData:data targetContentType:QQApiURLTargetTypeNews];
            }
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            [QQApiInterface SendReqToQZone:req];
            return YES;
        }
        
    }
    else
        return NO;
}

@end
