//
//  iPhoneTools.h
//  Model
//
//  Created by chenggk on 13-4-5.
//  Copyright (c) 2013年 21cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"


@interface NSString (WBEncode)

- (NSString*)URLEncodedString;

@end

@interface iPhoneTools : NSObject


+ (NSString*)getCurrentVersionCode;


//恒大 - 按照cell索引获取菜单名字
+(NSString*)nameOfChannelIndex:(NSInteger) index;
//恒大 - 获取动态菜单名字典
+(NSMutableDictionary*)getMennuNameDictionary;

//恒大 - 获取头图字典
+(NSMutableDictionary*)getHeaderDictionary;

+ (NSString *)documentPath;

+ (NSString *)cachePath;

+ (BOOL)isFileExists:(NSString*)filePath;

+ (bool)isDirExists:(NSString*)dirPath;

+ (bool)createDir:(NSString*)dir;

+ (bool)createDirIfNoExists:(NSString*)dir;

+ (NSString*)getCacheSize;

+ (NSString*)getCurrentVersion;

+ (uint64_t)fileSizeOnDisk:(NSString*)path;

+(UIColor *)colorWithHexString: (NSString *)color;

//测试网络状态
+ (BOOL) isNetworkReachable;
+(BOOL)isUnderWIFIConnect;
+ (BOOL) isUnder3GConnect;

@end
