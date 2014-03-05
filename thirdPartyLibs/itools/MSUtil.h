//
//  MSServiceContent.m
//  EggplantAlbums
//
//  Created by yeby on 13-8-6.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "Reachability.h"


@interface MSUtil : NSObject

+(NSDictionary*)dictionaryFromBundleWithName:(NSString*)fileName withType:(NSString*)typeName;
//字符串MD5转换
+ (NSString *)md5HexDigest:(NSString*)input;

+ (NSDate *)getNowTime;
+ (void)showTipsWithHUD:(NSString *)labelText showTime:(CGFloat)time;
+ (void)showTipsWithView:(UIView *)uiview labelText:(NSString *)labelText showTime:(CGFloat)time;
+(void) showHudMessage:(NSString*) msg hideAfterDelay:(NSInteger) sec uiview:(UIView *)uiview;

//+ (NetworkStatus)getCurrentNetworkStatus;
+ (NetworkStatus)getCurrentNetworkStatusForLocal;
+ (void)showNotReachabileTips;

+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)stringFromDate:(NSDate *)date;


//获取后台服务器主机名
+(NSString*)readFromUmengOlineHostname;
//获取后台api字典
+(NSDictionary * )getURLs;

//loadingView方法集
+(void)addLoadingViewInView:(UIView*)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle;
+(void)removeLoadingViewInView:(UIView*)viewToLoadData;
+(void)addLoadingViewInView:(UIView*)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle usingColor:(UIColor*)color;


+(void)removeLoadingViewAndLabelInView:(UIView*)viewToLoadData;
+(void)addLoadingViewAndLabelInView:(UIView*)viewToLoadData usingOrignalYPosition:(CGFloat)yPosition;
+(void)addLoadingViewAndLabelInView:(UIView*)viewToLoadData;

//来自茄子的便利方法

+(NSString *)getXingzuo:(NSDate *)in_date;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation; //图片旋转

//将图片保存到应用程序沙盒中去,imageNameString的格式为 @"upLoad.png" 
+ (void)saveImagetoLocal:(UIImage*)image imageName:(NSString *)imageNameString;


//begin 视频上传配置信息
+(NSString *)getServerIp;   //获取视频or音频上传服务器地址
+(NSString *)getFlag;       //
+(NSString *) fileMd5sum:(NSString * )filename; //md5转换
+(NSString * ) getRecordFilename;                     //将录制的视频的名字按照日期来命名，这样方便读取,例如iphone_record_20130821133639.mov
+(NSString * ) getRecordAudioFilename;                ////将录制的音频的名字按照日期来命名，这样方便读取,例如iphone_record_20130821133639.mp3

+(NSString * ) getPhotoFilename;//将录制的相片的名字按照日期来命名，这样方便读取,例如iphone_record_20130821133639.jpg
+(void)saveVideoToShaHe:(NSData *)videoData;          //保存视频数据到沙盒
+(void)saveVideoToShaHe:(NSData *)videoData recordFilename:(NSString *)RecordFileName;
+(NSString *)getVideoFileName:(NSString *)RecordFileName;  //获取完整的视频文件名
//end
@end
