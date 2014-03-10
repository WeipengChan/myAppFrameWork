//
//  MSServiceContent.h
//  EggplantAlbums
//
//  Created by yeby on 13-8-6.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface MSServiceContent : NSObject

//异步提交资源到网络
+ (ASIFormDataRequest *)postAsynchronRequest:(NSString *)urlStr
                                   parameter:(NSDictionary *)parameter
                                 didFinished:(void (^)(NSDictionary *dict))finishedBlock
                                   didFailed:(void (^)(NSError *error))failedBlock
                                     finally:(void (^)()) finallyBlock;

//异步提交字符串和NSData到网络
+ (ASIFormDataRequest *)postAsynchronRequest:(NSString *)urlStr
                                   parameter:(NSDictionary *)parameter
                                      nsdata:(NSDictionary*)dataParas
                                 didFinished:(void (^)(NSDictionary *))finishedBlock
                                   didFailed:(void (^)(NSError *))failedBlock
                                     finally:(void (^)())finallyBlock;


+(NSDictionary *)synRequestForTest:(NSString *)urlStr
                         parameter:(NSDictionary *)parameter;
@end
