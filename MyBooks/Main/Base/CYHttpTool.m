//
//  CYHttpTool.m
//  MyBooks
//
//  Created by zcy on 2018/7/25.
//  Copyright © 2018年 CY. All rights reserved.
//

#import "CYHttpTool.h"
#import "AFNetworking.h"

@implementation CYHttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self checkNetWorkStatusChange];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 30.f;
    mgr.securityPolicy = [self securityPolicy];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CYLog(@"operation.request.URL : ## %@ ",operation.request.URL);
//        if ([responseObject[@"err"] isEqualToString:@"token信息有误"]||[responseObject[@"err"] isEqualToString:@"token失效！"]||[responseObject[@"err"] isEqualToString:@"您还没有登录！"]||[responseObject[@"resCode"] isEqualToString:@"E0000002"]) {
//            if (![DKDUserDefaults objectForKey:DKDUserDefaultOtherLoginKey]) {
//                [DKDNotificationDefaultCenter postNotificationName:DKDNotificationLogoutKey object:nil];
//            }
//            return ;
//        }

        if (responseObject) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            CYLog(@"operation.request.URL : ## %@, ERROR ## : %@",operation.request.URL,error);
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 10.0f;
    mgr.securityPolicy = [self securityPolicy];
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject[@"err"]isEqualToString:@"token信息有误"]||[responseObject[@"err"]isEqualToString:@"token失效！"]||[responseObject[@"err"]isEqualToString:@"您还没有登录！"]||[responseObject[@"resCode"]isEqualToString:@"E0000002"]) {
//            if (![DKDUserDefaults objectForKey:DKDUserDefaultOtherLoginKey]) {
//                NSLock *threadLock = [[NSLock alloc]init];
//                [threadLock lock];
//                [DKDNotificationDefaultCenter postNotificationName:DKDNotificationLogoutKey object:nil];
//                [threadLock unlock];
//            }
//            return ;
//        }
        CYLog(@"operation.request.URL : ## %@ ",operation.request.URL);
        
        
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            CYLog(@"operation.request.URL : ## %@,ERROR ## : %@",operation.request.URL,error);
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(void(^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.securityPolicy = [self securityPolicy];
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imgData name:@"files" fileName:@"iosImage.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            CYLog(@"operation.request.URL : ## %@,ERROR ## : %@",operation.request.URL,error);
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params imageList:(NSArray *)imageArr imageNameList:(NSArray *)nameArr success:(void(^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.securityPolicy = [self securityPolicy];
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int count = 0; count < imageArr.count; count ++) {
            UIImage *image = imageArr[count];
            NSData *imgData = UIImageJPEGRepresentation(image, 0.8);
            CYLog(@"imgData : %zd",[imgData length]);
            NSString *fileName = nameArr[count];
            [formData appendPartWithFileData:imgData name:@"files" fileName:fileName mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            CYLog(@"operation.request.URL : ## %@,ERROR ## : %@",operation.request.URL,error);
            failure(error);
        }
    }];
}

+ (void)postSingleFile:(NSString *)url params:(NSDictionary *)params and:(UIImage*)icon success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [self securityPolicy];
    [manager POST:url parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    NSData *eachImgData = UIImagePNGRepresentation(icon);
    [formData appendPartWithFileData:eachImgData name:[NSString stringWithFormat:@"files"] fileName:[NSString stringWithFormat:@"image111.png"] mimeType:@"image/png"];
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (responseObject) {
                  success(responseObject);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
              CYLog(@"image : ## %@",operation.request.URL);
          }];
}

+ (NSDictionary *)jsonStringWithObject:(id)jsonData imei:(NSString *)imei{
    NSMutableDictionary *base = [NSMutableDictionary dictionary];
//    base[@"imei"] = [FCUUID uuidForDevice];
//    base[@"params"] = [self jsonStringWithObject:jsonData];
//    base[@"token"] = [FCUUID uuidForDevice];
    return base;
}

/**
 *  字典或者数组转json语句
 *
 *  @param objectData 需要转换的数据
 *
 *  @return 转换之后的json语句
 */
+ (NSString *)jsonStringWithObject:(NSDictionary *)objectData{
    NSData *queryData = [NSJSONSerialization dataWithJSONObject:objectData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *queryJson = [[NSString alloc] initWithData:queryData encoding:NSUTF8StringEncoding];
    return queryJson;
}

+ (void)checkNetWorkStatusChange{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                CYLog(@"网络状态未知");
                [MBProgressHUD showText:@"当前网络状态未知"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                CYLog(@"WIFI状态");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                CYLog(@"自带网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [MBProgressHUD showText:@"当前网络不可用"];
                break;
            default:
                break;
        }
    }];
    //开启监控
    [mgr startMonitoring];
}

+ (AFSecurityPolicy *)securityPolicy{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = YES;
    securityPolicy.validatesCertificateChain = NO;
    return securityPolicy;
}
@end
