//
//  HttpRequestManager.m
//  头版
//
//  Created by YunInfo on 14-3-7.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "HttpRequestManager.h"
#import "OpenUDID.h"

typedef enum
{
    TextNewsType = 11,
    PicsNewsType = 12,
    videosNewsType = 13
    
}NewsType;

@implementation HttpRequestManager

-(void)dealloc
{
    self.httpRequestFailedBlock = nil;
    self.httpRequestFinallyBlock = nil;
    self.httpRequestFinishedNSDictionaryBlock = nil;
    self.httpRequestFinishedNSMutableArrayBlock = nil;
}

//并不是一定要单例的
+(HttpRequestManager *)shareInstance
{
    static HttpRequestManager* a_instance = nil;
    
    if (nil == a_instance)
    {
        @synchronized(@"HttpRequestManager")
        {
            if (nil == a_instance)
            {
                a_instance = [[HttpRequestManager alloc] init];
            }
        }
    }
    
    return a_instance;
}


- (ASIFormDataRequest *)postAsynReques:(NSString *)urlStr usingParameter:(NSDictionary*)paraDict
{
    return    [MSServiceContent postAsynchronRequest:urlStr parameter:Nil didFinished:
               ^(NSDictionary *dict)
               {
                   if (self.httpRequestFinishedNSDictionaryBlock)
                   {
                        self.httpRequestFinishedNSDictionaryBlock(dict);
                   }
               }
                                           didFailed:^(NSError *error)
               {
                   
                   if (self.httpRequestFailedBlock) {
                       self.httpRequestFailedBlock(error);
                       
                   }
               } finally:
               ^{
                   if (self.httpRequestFinallyBlock) {
                       self.httpRequestFinallyBlock();
                   }
               }];

}

#pragma mark - UserSerialNum


-(NSString*)getUserSerialNum
{
    
    NSString * userSeriaNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"userSerialNum"];
    if (!userSeriaNum) {
        userSeriaNum = @"Ariyym";
    }
    return userSeriaNum ;
}

- (void)checkUserSerialNum
{
    NSString * originUserSeriaNum = [self getUserSerialNum];
    if (originUserSeriaNum) {
        return;
    }
    
    NSString* imei =[OpenUDID value];
    //  NSArray * a = [imei componentsSeparatedByString:@"-"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@&imeiCode=%@&imsiCode=%@", @"http://k.21cn.com/cloundapp/api/saveClientUser.do?", @"appId=8", imei, imei];
    
    [MSServiceContent postAsynchronRequest:urlStr parameter:Nil didFinished:
     ^(NSDictionary *dict)
    {
        NSString * msg = [dict objectForKey:@"msg"];
        NSString * userSerialNum = [dict objectForKey:@"userSerialNum"];
    
        if ([msg isEqualToString:@"ok"]) {
            [[NSUserDefaults standardUserDefaults]setObject:userSerialNum forKey:@"userSerialNum"];
        }
        
    } didFailed:nil finally:nil];
    
}

#pragma mark - app version

-(void)checkAppVersion
{
    NSString * urlStr = [NSString stringWithFormat:@"http://k.21cn.com/cloundapp/api/appVersion/getAppLastVersion.do?appId=13&appVersionCode=%@",[iPhoneTools getCurrentVersionCode]];
    
    [MSServiceContent postAsynchronRequest:urlStr parameter:Nil didFinished:
     ^(NSDictionary *dict)
     {
         self.httpRequestFinishedNSDictionaryBlock(dict);
     } didFailed:nil finally:nil];
    
    
}


#pragma mark - article content

-(ASIFormDataRequest *)loadArticleContentUsingArticleId:(int)articleId
{
    ASIFormDataRequest * request = nil;
    NSString* userSerialNum = [self getUserSerialNum];
    
    NSString* urlStr = [NSString stringWithFormat:@"http://www.21cn.com/api/client/v2/getArticleContent.do?articleId=%d&userSerialNumber=%@", articleId, userSerialNum];
    MSDebug(@"article urlStr:%@",urlStr);
    
    request = [self postAsynReques:urlStr usingParameter:nil];
    
    return request;
}

#pragma mark - article news list

-(ASIFormDataRequest *)loadOnePageNewsUsingToptime:(NSString*)lastTopTime usingListId:(NSString*)listId
{
    
    ASIFormDataRequest * request = nil;
    
    //本地新闻频道
    if ([ listId isEqualToString:[NSString stringWithFormat:@"0"]]) {
        
        NSString* province =  [[NSUserDefaults standardUserDefaults] objectForKey:@"local_province"];
        NSString* city =  [[NSUserDefaults standardUserDefaults]objectForKey:@"local_city"];
        NSString* userSerialNum = [self getUserSerialNum];
        
        if (!userSerialNum) {
            userSerialNum = @"Ariyym";
        }
        
        if (!province) {
            province = @"广东";
        }
        
        if (!city) {
            city = @"广州";
        }
        
        
        NSString *provinceStr=[province URLEncodedString];
        NSString *cityStr=[city  URLEncodedString];
        NSString *urlStr=[NSString stringWithFormat:@"http://www.21cn.com/api/client/v2/getLocalNewsList.do?province=%@&pageSize=20&city=%@&pageNo=1&userSerialNumber=%@&hasImg=0&getRealSize=0&ltTopTime=%@",provinceStr,cityStr,userSerialNum,[lastTopTime URLEncodedString]];
        MSDebug(@"current address usl:%@",urlStr);
       
       request =  [MSServiceContent postAsynchronRequest:urlStr parameter:Nil didFinished:
         ^(NSDictionary *dict)
         {
             NSString * msg = [dict objectForKey:@"msg"];
             NSString * userSerialNum = [dict objectForKey:@"userSerialNum"];
             
             if ([msg isEqualToString:@"ok"]) {
                 [[NSUserDefaults standardUserDefaults]setObject:userSerialNum forKey:@"userSerialNum"];
             }
             
         } didFailed:nil finally:nil];
        
    }
    
    else
    {
        
     /*
        //BOOL bHasImg = ![SettingManager shareInstance].isNoneImageMode; picSize=s98x72
        NSString *urlStr ;
        int articleType = [self getArtiCleTypeNum:channelObject.listType];
       
        if (articleType == 12) {
            urlStr = [NSString stringWithFormat:@"http://www.21cn.com/api/client/v2/getClientArticleList.do?listIds=%@&pageNo=1&pageSize=20&hasImg=%d&articleType=%d&userSerialNumber=%@&getRealSize=1&ltTopTime=%@", channelObject.listIds, 0, channelObject.articleType,userSerialNum,[lastTopTime URLEncodedString]];
            MSDebug(@"current address usl:%@",urlStr);
        }
        
        
        urlStr = [NSString stringWithFormat:@"http://www.21cn.com/api/client/v2/getClientArticleList.do?listIds=%@&pageNo=1&pageSize=20&hasImg=%d&articleType=%d&userSerialNumber=%@&getRealSize=0&ltTopTime=%@", channelObject.listIds,  0, channelObject.articleType,userSerialNum,[lastTopTime URLEncodedString]];
        MSDebug(@"current address usl:%@",urlStr);
        //        }
        
        NSURL* url = [NSURL URLWithString:urlStr];
        NSURLRequest *req= [NSURLRequest requestWithURL:url];
        
        opForUi = [[LSURLDispatcher sharedDispatcher] dispatchShortRequest:req delegate:self];
        
        [opForUi start];
       */
    }

    return request;
}



@end



