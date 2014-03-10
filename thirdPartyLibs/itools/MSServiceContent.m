//
//  MSServiceContent.m
//  EggplantAlbums
//
//  Created by cwp on 13-8-6.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "MSServiceContent.h"


//#import "NSObject+SBJson.h"

@implementation MSServiceContent

+ (ASIFormDataRequest *)postAsynchronRequest:(NSString *)urlStr
                                   parameter:(NSDictionary *)parameter
                                 didFinished:(void (^)(NSDictionary *))finishedBlock
                                   didFailed:(void (^)(NSError *))failedBlock
                                     finally:(void (^)())finallyBlock
{
    if (![iPhoneTools isNetworkReachable]) {
        [MSUtil showTipsWithHUD:@"无网络连接，请检查网络连接" showTime:3.0];
#if NS_BLOCKS_AVAILABLE
        if (finallyBlock) {
            finallyBlock();
        }
#endif
        return nil;
    }
    MSDebug(@"PostURL:%@", urlStr);
    MSDebug(@"urlStr请求字典为:%@",parameter);
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setRequestMethod:@"POST"];
    
    if (parameter) {
        for (id key in parameter.allKeys) {
            [request setPostValue:[parameter objectForKey:key] forKey:key];
        }
        
    }

    
    [request setCompletionBlock:^{
#if NS_BLOCKS_AVAILABLE
        
       __strong ASIFormDataRequest * requestStrong = request;
        
        if (!requestStrong)
        {
            return ;
        }
        
        if (finishedBlock) {
            
            
//使用原生解析，速度最快
//            NSString *responseString = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
            NSError *error;  
            NSDictionary * dict =  [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
            MSDebug(@"urlStr返回的字符串为:%@",dict);
            finishedBlock(dict);
        }
        if (finallyBlock) {
            finallyBlock();
        }
#endif
    }];
    [request setFailedBlock:^{
        
       __strong ASIFormDataRequest * requestStrong = request;//ARC下 block不能直接引用self，会造成retain cycle
        
        if (!requestStrong)//防止多线程下，弱引用request赋给requestStrong
        {
            return ;
        }
#if NS_BLOCKS_AVAILABLE
        if (failedBlock) {
            failedBlock([request error]);
        }
        if (finallyBlock) {
            finallyBlock();
        }
#endif
    }];
    
    [request startAsynchronous];
    
    return request;
}




+ (ASIFormDataRequest *)postAsynchronRequest:(NSString *)urlStr
                                   parameter:(NSDictionary *)parameter
                                      nsdata:(NSDictionary*)dataParas
                                 didFinished:(void (^)(NSDictionary *))finishedBlock
                                   didFailed:(void (^)(NSError *))failedBlock
                                     finally:(void (^)())finallyBlock
{
    
    if (![iPhoneTools isNetworkReachable]) {
        [MSUtil showTipsWithHUD:@"无网络连接，请检查网络连接" showTime:3.0];
#if NS_BLOCKS_AVAILABLE
        if (finallyBlock) {
            finallyBlock();
        }
#endif
        return nil;
    }
    MSDebug(@"PostURL:%@", urlStr);
    MSDebug(@"urlStr请求字典为:%@",parameter);
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setRequestMethod:@"POST"];
    
    if (parameter) {
        for (id key in parameter.allKeys) {
            [request setPostValue:[parameter objectForKey:key] forKey:key];
        }
        
    }
    for (id key in dataParas.allKeys) {
        [request addData:[dataParas objectForKey:key] forKey:key];
    }
    
    
    
    [request setCompletionBlock:^{
#if NS_BLOCKS_AVAILABLE
        
        __strong ASIFormDataRequest * requestStrong = request;
        
        if (!requestStrong)
        {
            return ;
        }

        
        if (finishedBlock) {
            //使用原生解析，速度最快
            //            NSString *responseString = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
            NSError *error;
            NSDictionary * dict =  [NSJSONSerialization JSONObjectWithData:[requestStrong responseData] options:NSJSONReadingMutableLeaves error:&error];
            MSDebug(@"urlStr返回的字符串为:%@",dict);
            finishedBlock(dict);
        }
        if (finallyBlock) {
            finallyBlock();
        }
#endif
    }];
    [request setFailedBlock:^{
#if NS_BLOCKS_AVAILABLE
        
        __strong ASIFormDataRequest * requestStrong = request;
        
        if (!requestStrong)
        {
            return ;
        }
        
        if (failedBlock) {
            failedBlock([request error]);
        }
        if (finallyBlock) {
            finallyBlock();
        }
#endif
    }];
    
    [request startAsynchronous];
    
    return request;
    
}



+(NSDictionary *)synRequestForTest:(NSString *)urlStr
                           parameter:(NSDictionary *)parameter
{
    if (![iPhoneTools isNetworkReachable])  return nil;
    MSDebug(@"PostURL:%@", urlStr);
    MSDebug(@"urlStr请求字典为:%@",parameter);
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setRequestMethod:@"POST"];
    
    if (parameter) {
        for (id key in parameter.allKeys) {
            [request setPostValue:[parameter objectForKey:key] forKey:key];
        }
        
    }
    
    [request startSynchronous];
    MSDebug(@"%@",[request responseString]);
    
    
    NSError *error;
    NSDictionary * dict =  [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
        return dict;

}


@end
