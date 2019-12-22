//
//  NetRequest.m
//  YCJF-Pro
//
//  Created by 姜宁桃 on 2017/11/29.
//  Copyright © 2017年 Yincheng. All rights reserved.
//

#import "NetRequest.h"

#define RequestTimeOut 30.0f // 配置请求超时时间

@implementation NetRequest

+ (AFHTTPSessionManager *)httpManager{
    //获取请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;//去除空值
    manager.responseSerializer = response;//申明返回的结果是json类
    // 添加这句代码
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 设置请求格式
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    manager.requestSerializer.timeoutInterval = RequestTimeOut;
    return manager;
}

+ (void)postUrl:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
//    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [self httpManager];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:@{@"client_type":@"ios",@"client_code":KGetIDFA, @"code":KAcceess, @"lang":KChineseStyle?@"zh":@"en", @"apikey":KAcceess}];
    [params setValuesForKeysWithDictionary:parameters];
    
    //开始请求
    NSLog(@"接口和参数：%@", [self JointUrlAddressWithUrl:urlStr parameter:params]);
    [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
        NSMutableDictionary *resDict = (NSMutableDictionary *)[responseObject mj_JSONObject];
        NSLog(@"接口数据：%@", resDict);
        success(resDict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
        NSLog(@"错误信息：%@",error);
         failure(error);
    }];
}

+ (void)getUrl:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [self httpManager];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:@{@"client_type":@"ios",@"client_code":KGetIDFA, @"code":KAcceess, @"lang":KChineseStyle?@"zh":@"en", @"apikey":KAcceess}];;
    [params setValuesForKeysWithDictionary:parameters];
    //开始请求
    [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *resDict = (NSMutableDictionary *)[responseObject mj_JSONObject];
        
        success(resDict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        failure(error);
    }];
}

+ (void)AFImageByPostWithUrlString:(NSString *)urlString params:(NSDictionary *)params image:(UIImage *)image success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    AFHTTPSessionManager * manager = [self httpManager];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@.png",@"photo"];
        UIImage * image1 = image;
        NSData *data =UIImageJPEGRepresentation(image1, 1.0);
        
        /******** 1.上传已经获取到的img *******/
        // 把图片转换成data
        //        NSData *data = UIImagePNGRepresentation(image);
        // 拼接数据到请求题中
        [formData appendPartWithFileData:data name:@"file" fileName:@"headimage.png" mimeType:@"image/png"];
        /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        // 打印上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", jsonObj);
        NSLog(@"%@", responseObject);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseString: %@", responseString);
        NSMutableString * str = [NSMutableString stringWithString:responseString];
        NSString * dicStr = [NSString stringWithFormat:@"%@}",[[str componentsSeparatedByString:@"}"]  firstObject]];
        NSLog(@"responseStr: %@", str);
        successBlock(jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error.localizedDescription);
    }];
    
}

+ (NSString *)JointUrlAddressWithUrl:(NSString *)url parameter:(NSDictionary *)params
{
    NSString * paramsStr = [[NSString alloc] init];
    for (int i = 0; i < params.allKeys.count; i++) {
        paramsStr = [paramsStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", params.allKeys[i], params.allValues[i]]];
    }
    paramsStr = [NSString stringWithFormat:@"%@?%@", url, paramsStr];
    return paramsStr;
}

+(void)initlizedData:(NSString *)urlStr  paramsdata:(NSDictionary*)params  dicBlick:(void (^)(NSDictionary * info))dicBlick
{
//    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString   *string=[NSString    new];
    string=urlStr;
    
    [manager POST:string parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
        //接受网络数据
        NSDictionary * info = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (dicBlick) {
            dicBlick(info);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
        NSLog(@"-------数据请求失败-------, %@", error);
//        [MBProgressHUD hideHUD];
    }];
    
    
}



@end
