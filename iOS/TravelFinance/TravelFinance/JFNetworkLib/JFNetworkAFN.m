//
//  JFNetworkAFN.m
//  TravelFinance
//
//  Created by cuiyong on 16/10/26.
//  Copyright © 2016年 cuiyong. All rights reserved.
//

#import "JFNetworkAFN.h"

#import <objc/message.h>

@interface JFNetworkAFN ()

@property (nonatomic, strong) NSString *networkError;

@end
@implementation JFNetworkAFN


+ (JFNetworkAFN *)sharedNetwork {
    static id dc = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dc = [[[self class]alloc]init];
    });
    return dc;
}

- (void)requestHttpDataWithPath:(NSString *)URLString params:(NSDictionary *)params withMethodType:(HttpRequestType)NetworkMethod cacheSupport:(BOOL)isCache delegate:(id)delegate {
    self.delegate = delegate;
    self.urlSession = [AFHTTPSessionManager manager];
    self.urlSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.urlSession.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"multipart/form-data", nil];
    
    AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    self.urlSession.securityPolicy = policy;
    self.urlSession.operationQueue.maxConcurrentOperationCount = 5;
    self.urlSession.requestSerializer.timeoutInterval = 30;
    if (isCache) {
        self.urlSession.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    } else {
        self.urlSession.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    NSString *url_UTF8 = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    self.requestURL = url_UTF8;
    
    __weak typeof(self) weakSelf = self;
    void(^successBlock)(NSURLSessionDataTask * _Nonnull, id _Nullable) = ^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)task.response;
        //LOG
        NSDate *nowDate = [NSDate date];
        NSTimeInterval timeStamp = [nowDate timeIntervalSince1970];
        NSTimeInterval deltaTimeStamp = timeStamp - self.timeStamp;
        NSLog(@"\n rquesst success ==================> \n requestURL = %@ \n 结束时间:%f \n 时间差:deltaTimeStamp:%f", url_UTF8,timeStamp,deltaTimeStamp);
        if ([weakSelf.delegate respondsToSelector:@selector(jfURLConnection:withError:)]) {
            
            if (httpURLResponse.statusCode >= 500) {
                self.networkError = @"服务器访问超时，请稍后重试！";
            } else if (httpURLResponse.statusCode >= 400) {
                self.networkError = @"服务器访问超时，请稍后重试！";
            } else {
                self.networkError = @"";
                weakSelf.responseData = responseObject;
            }
            NSError *error = nil;
            [weakSelf.delegate jfURLConnection:weakSelf withError:error];
        }
        [task cancel];
        
    };
    void(^failureBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //LOG
        NSDate *nowDate = [NSDate date];
        NSTimeInterval timeStamp = [nowDate timeIntervalSince1970];
        NSTimeInterval deltaTimeStamp = timeStamp - self.timeStamp;
        NSLog(@"\n rquesst failed \n ==================> \n requestURL = %@ \n 结束时间:%f \n 时间差:deltaTimeStamp:%f", url_UTF8,timeStamp,deltaTimeStamp);
        if ([weakSelf.delegate respondsToSelector:@selector(jfURLConnection:withError:)]) {
            NSString *errorMessage = [[NSString alloc] init];
            if (error.code == NSURLErrorTimedOut
                || error.code == NSURLErrorNetworkConnectionLost
                || error.code == NSURLErrorNotConnectedToInternet) {
                errorMessage = @"您的网络信号不好,请稍后重试。";
            } else {
                errorMessage = @"您的网络信号不好,请稍后重试。";
            }
            [weakSelf.delegate jfURLConnection:weakSelf withError:errorMessage];
        }
        [task cancel];
    };
    
    NSString *TypeMethod = NetworkMethod == HttpRequestTypePost? @"POST" : @"GET";
    NSString *selecterStr = [NSString stringWithFormat:@"%@:parameters:progress:success:failure:",TypeMethod];
    NSURLSessionDataTask * (*action)(id, SEL, NSString *, id,void(^progress)(NSProgress * _Nonnull), void(^successBlock)(NSURLSessionDataTask * _Nonnull, id _Nullable), void(^failureBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull)) = (NSURLSessionDataTask * (*)(id, SEL, NSString *, id,void(^progress)(NSProgress * _Nonnull), void(^successBlock)(NSURLSessionDataTask * _Nonnull, id _Nullable), void(^failureBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))) objc_msgSend;
    self.sessionDataTask = action(self.urlSession, NSSelectorFromString(selecterStr), url_UTF8, params, nil, successBlock, failureBlock);
    //LOG
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeStamp = [nowDate timeIntervalSince1970];
    NSLog(@"\n 请求开始URL:%@ \n ==================> 开始时间:%f",url_UTF8,timeStamp);
    self.timeStamp = timeStamp;
}

- (void)setConnectionType:(NSInteger)connectionType {
    _connectionType = connectionType;
}

//- (NSInteger)connectionType {
//    return _connectionpe;
//}


@end
