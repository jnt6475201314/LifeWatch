//
//  NetRequest.h
//  YCJF-Pro
//
//  Created by 姜宁桃 on 2017/11/29.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSString *errorDes);
typedef void(^HideHUDBlock)(void);

@interface NetRequest : NSObject

+ (void)postUrl:(NSString *)urlStr
     Parameters:(NSDictionary *)parameters
        success:(void (^)(NSDictionary *resDict))success
        failure:(void (^)(NSError *error))failure;

+ (void)getUrl:(NSString *)urlStr
    Parameters:(NSDictionary *)parameters
       success:(void (^)(id))success
       failure:(void (^)(NSError *error))failure;

+ (NSString *)JointUrlAddressWithUrl:(NSString *)url
                           parameter:(NSDictionary *)params;

// 上传图片
+ (void)AFImageByPostWithUrlString:(NSString *)urlString
                                params:(NSDictionary *)params
                                 image:(UIImage *)image
                               success:(SuccessBlock)successBlock
                                  fail:(FailBlock)failBlock;


+(void)initlizedData:(NSString *)urlStr  paramsdata:(NSDictionary*)params  dicBlick:(void (^)(NSDictionary * info))dic;



@end
