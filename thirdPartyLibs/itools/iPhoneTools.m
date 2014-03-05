//
//  iPhoneTools.m
//  Model
//
//  Created by chenggk on 13-4-5.
//  Copyright (c) 2013年 21cn. All rights reserved.
//

#import "iPhoneTools.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
#include <mach/mach.h>
#include <mach/mach_init.h>
#include <mach/task.h>
#include <mach/task_info.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <uuid/uuid.h>
#include <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#import <dirent.h>
#import <sys/stat.h>
#import <sys/types.h>
@implementation NSString (WBEncode)
- (NSString*)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString*)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
	return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),encoding) );
}
@end

const char * getiPhoneMac() {
	
	int                    mib[6];
	size_t                len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = (char*)malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [[NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)] uppercaseString];
	free(buf);
	return [outstring UTF8String];
}


const char * getMD5(const char * str) {
	
    unsigned char result[16];
    CC_MD5( str, strlen(str), result );
    return [[[NSString stringWithFormat:
              @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
              result[0], result[1], result[2], result[3],
              result[4], result[5], result[6], result[7],
              result[8], result[9], result[10], result[11],
              result[12], result[13], result[14], result[15]
              ] lowercaseString] UTF8String];
}



@implementation iPhoneTools

+(NSString*)nameOfChannelIndex:(NSInteger) index
{
    NSString * name = nil;
    NSDictionary * dict = [self getMennuNameDictionary];
    name = [dict objectForKey:[NSString stringWithFormat:@"menu%d",dict.count-index]];
    return name;
}

//恒大 - 获取动态菜单名字典
+(NSMutableDictionary*)getMennuNameDictionary
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    NSString *fileName=[plistPaht stringByAppendingString:@"/muneNameDict.plist"];
    //     NSFileManager* fm = [NSFileManager defaultManager];
    
    NSMutableDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return dict;
}

//恒大 - 获取头图字典
+(NSMutableDictionary*)getHeaderDictionary
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    NSString *fileName=[plistPaht stringByAppendingString:@"/headerPics.plist"];
    //     NSFileManager* fm = [NSFileManager defaultManager];
    
    NSMutableDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return dict;
}


+ (NSString*)getIMEI
{
    
    
//    char buffer[128] = {0};
//    getIMEI(buffer);
    const char * s = getiPhoneMac();
    NSLog(@"%s",s);
    
    long long a=0;
    long  long b=0;
    for(int i=0;s[i]!='\0';i++)
    {
        if(s[i]>='a'&&s[i]<='f')b=s[i]-'a'+10;
        if(s[i]>='A'&&s[i]<='F')b=s[i]-'A'+10;
        if(s[i]>='0'&&s[i]<='9')b=s[i]-'0';
        a=a*16+b;
    }
    
    NSString * mac =[NSString stringWithFormat:@"%lld", a];
    if ([mac length]< 15)
    {
       mac = [mac stringByAppendingFormat:@"111110000000000"];        
    }
    
    mac = [mac substringToIndex:15];
    
  // NSString * mac = [[UIDevice currentDevice]uniqueIdentifier];
    return mac;
}


+ (NSString *)documentPath
{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (!paths) {
        return nil;
    }
    return [paths objectAtIndex:0];
}


+ (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


+ (BOOL)isFileExists:(NSString*)filePath
{
	return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}


+ (bool)isDirExists:(NSString*)dirPath
{
    if(!dirPath)
    {
        return false;
    }
    
	DIR* dir;
	dir= opendir([dirPath UTF8String]);
	if(dir == NULL)
	{
		return false;
	}
	closedir(dir);
	return true;
}

+ (bool)createDir:(NSString*)dir
{
	return [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
}


+ (bool)createDirIfNoExists:(NSString*)dir
{
    if ([self isDirExists:dir])
    {
        return NO;
    }
    
    return [self createDir:dir];
}


+ (NSString*)getCacheSize
{
    
    NSLog(@"Get Cache Size");
    NSString* cachePath = [self cachePath];
    NSString* fullPath = [NSString stringWithFormat:@"%@/com.news.21cn.-1CNNews/EGOCache", cachePath];
    uint64_t size = [self fileSizeOnDisk:fullPath];
    
    NSString* documentPath = [self documentPath];
    
    uint64_t document_size = [self fileSizeOnDisk:documentPath];
    
    size = size + document_size;
    if (size <= 800)
    {
        size = 0;
    }
    
    if (size > 1024)
    {
        return [NSString stringWithFormat:@"%lldM", size / 1024];
    }
    
        
    return [NSString stringWithFormat:@"%lldK", size];
}


+ (NSString*)getCurrentVersion
{
    return @"v1.0版本";
}


+ (uint64_t)fileSizeOnDisk:(NSString*)path
{
    if (path && [path length] > 0)
    {
        NSFileManager *manager = [[NSFileManager alloc] init];
        NSDictionary *attributes = [manager attributesOfItemAtPath:path error:NULL];
        if (attributes)
        {
            return [attributes fileSize];
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}


+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(BOOL)isUnderWIFIConnect{
    
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
    

}

+ (BOOL) isUnder3GConnect{
    
    return([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
    
}

+ (BOOL) isNetworkReachable
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    /**
     *  SCNetworkReachabilityRef: 用来保存创建测试连接返回的引用
     *
     *  SCNetworkReachabilityCreateWithAddress: 根据传入的地址测试连接.
     *  第一个参数可以为NULL或kCFAllocatorDefault
     *  第二个参数为需要测试连接的IP地址,当为0.0.0.0时则可以查询本机的网络连接状态.
     *  同时返回一个引用必须在用完后释放.
     *  PS: SCNetworkReachabilityCreateWithName: 这个是根据传入的网址测试连接,
     *  第二个参数比如为"www.apple.com",其他和上一个一样.
     *
     *  SCNetworkReachabilityGetFlags: 这个函数用来获得测试连接的状态,
     *  第一个参数为之前建立的测试连接的引用,
     *  第二个参数用来保存获得的状态,
     *  如果能获得状态则返回TRUE，否则返回FALSE
     *
     **/
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     *
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

 

@end
