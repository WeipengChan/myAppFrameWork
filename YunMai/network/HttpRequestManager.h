//
//  HttpRequestManager.h
//  头版
//
//  Created by YunInfo on 14-3-7.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "MSServiceContent.h"
#import <Foundation/Foundation.h>
typedef    void (^HttpRequestFinishedNSDictionaryBlock)  (NSDictionary *)   ;
typedef    void (^HttpRequestFinishedNSMutableArrayBlock) (NSMutableArray*) ;
typedef    void (^HttpRequestFailedBlock)   (NSError *);
typedef    void (^HttpRequestFinallyBlock)  ();

//
@interface HttpRequestManager : NSObject

@property (retain,nonatomic) id parameterObject;
@property (copy,nonatomic) HttpRequestFinishedNSDictionaryBlock  httpRequestFinishedNSDictionaryBlock;
@property (copy,nonatomic) HttpRequestFinishedNSMutableArrayBlock  httpRequestFinishedNSMutableArrayBlock;
@property (copy,nonatomic) HttpRequestFailedBlock  httpRequestFailedBlock;
@property (copy,nonatomic) HttpRequestFinallyBlock  httpRequestFinallyBlock;

+(HttpRequestManager *)shareInstance;

//序列号
-(NSString*)getUserSerialNum;
- (void)checkUserSerialNum;

//版本
-(void)checkAppVersion;

//文章详情页
-(ASIFormDataRequest *)loadArticleContentUsingArticleId:(int)articleId;

//文章列表
-(ASIFormDataRequest *)loadOnePageNewsUsingToptime:(NSString*)lastTopTime usingListId:(NSString*)listId;

@end
