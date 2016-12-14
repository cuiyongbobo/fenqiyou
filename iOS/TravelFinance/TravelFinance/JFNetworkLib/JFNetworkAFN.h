//
//  JFNetworkAFN.h
//  TravelFinance
//
//  Created by cuiyong on 16/10/26.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "JFConnectionType.h"

/**网络请求类型**/
typedef NS_ENUM(NSInteger,HttpRequestType){
    HttpRequestTypeGet = 0,
    HttpRequestTypePost,
    HttpRequestTypePut,
    HttpRequestTypeDelete
};


@protocol JFURLConnectionDelegate;


@interface JFNetworkAFN : NSObject

@property (nonatomic, weak) id <JFURLConnectionDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval timeStamp;
@property (nonatomic, strong) AFHTTPSessionManager *urlSession;
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, assign) NSInteger connectionType;


+(JFNetworkAFN *)sharedNetwork;

/**
 *  发送一个POST请求
 *
 *  @param URLString        请求路径
 *  @param params           请求参数
 *  @param NetworkMethod    网络请求类型
 *  @param isCache          是否缓存
 *  @param delegate         请求代理对象
 */

- (void)requestHttpDataWithPath:(NSString *)URLString params:(NSDictionary *)params withMethodType:(HttpRequestType)NetworkMethod cacheSupport:(BOOL)isCache delegate:(id)delegate;

@end

@protocol JFURLConnectionDelegate <NSObject>

/**
 *  网络请求回调
 */
- (void)jfURLConnection:(JFNetworkAFN *)jfURLConnection withError:(id)error;

@end
