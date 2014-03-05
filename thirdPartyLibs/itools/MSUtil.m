//
//  MSServiceContent.m
//  EggplantAlbums
//
//  Created by yeby on 13-8-6.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "MSUtil.h"


#import "MBProgressHUD.h"
#import "Reachability.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>

#include <ctype.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <dirent.h>
#import <CommonCrypto/CommonDigest.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/sockio.h>

#import "MobClick.h"

@implementation MSUtil

+(NSDictionary*)dictionaryFromBundleWithName:(NSString*)fileName withType:(NSString*)typeName
{
    NSDictionary * dict = nil;
    NSString *infoPlist = [[NSBundle mainBundle] pathForResource:fileName ofType:typeName];

    if ([[NSFileManager defaultManager] isReadableFileAtPath:infoPlist]) {
        NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:infoPlist];
        return dict;
    }
    return dict;
}


//MD5转换
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


+(NSString*)readFromUmengOlineHostname
{
    NSString * hostName = [MobClick getConfigParams:@"HOSTNAME"];
    
    if (hostName && ![hostName isEqualToString:@""])
    {
        return hostName;
    }
    else
    {
        return @"http://42.120.19.149/hengda/appbackend/Admin/index.php";
    }
    
}

+(void)removeLoadingViewAndLabelInView:(UIView*)viewToLoadData
{
    //viewToLoadData.hidden = NO;
    UIActivityIndicatorView * breakingLoadingView = (UIActivityIndicatorView*)[viewToLoadData  viewWithTag:10087];
    [breakingLoadingView stopAnimating];
    
    [[viewToLoadData  viewWithTag:10086] removeFromSuperview];
}

//推荐为10
+(void)addLoadingViewAndLabelInView:(UIView*)viewToLoadData
{
    [MSUtil addLoadingViewAndLabelInView:viewToLoadData usingOrignalYPosition:10];
}

+(void)addLoadingViewAndLabelInView:(UIView*)viewToLoadData usingOrignalYPosition:(CGFloat)yPosition
{
    //viewToLoadData.hidden = YES;
    
    UIView * loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, yPosition, viewToLoadData.frame.size.width , 60)];
    loadingView.tag = 10086;
    
    
    UIFont * labelFont = [UIFont systemFontOfSize:14.0f];
    
    CGSize  labelSize = [@"加载中" sizeWithFont:labelFont];

    if (![viewToLoadData viewWithTag:10087]) {
        UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.frame = CGRectMake(( loadingView.frame.size.width - labelSize.width-20-5)/2, 15.0f, 20.0f, 20.0f);
        activityIndicatorView.tag = 10087;
        [loadingView addSubview:activityIndicatorView];
          [activityIndicatorView startAnimating];
    }

    
    if (![viewToLoadData viewWithTag:10088]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([loadingView viewWithTag:10087] .frame.origin.x + 20+5, 10.0f, labelSize.width, 30.0f)];
        label.tag = 10088;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = labelFont;
        label.textColor = [UIColor whiteColor];
        // label.shadowColor = [UIColor colorWithWhite:.9f alpha:1.0f];
        //label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.text = @"加载中";
        [loadingView addSubview:label];
    }
    [viewToLoadData addSubview:loadingView];
  
}



#pragma mark - Only ActivityView

+(void)addLoadingViewInView:(UIView*)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle usingColor:(UIColor*)color
{
    UIActivityIndicatorView * breakingLoadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:aStyle];
    breakingLoadingView.tag = 99;
    breakingLoadingView.center = CGPointMake( (viewToLoadData.frame.size.width-40)/2+20, (viewToLoadData.frame.size.height-40)/2+20);
    breakingLoadingView.color = color;
    [breakingLoadingView startAnimating];
    [viewToLoadData addSubview:breakingLoadingView];
    
    
}


+(void)addLoadingViewInView:(UIView*)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle
{
//    UIActivityIndicatorView * breakingLoadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:aStyle];
//    breakingLoadingView.tag = 99;
//    breakingLoadingView.center = CGPointMake( (viewToLoadData.frame.size.width-40)/2+20, (viewToLoadData.frame.size.height-40)/2+20);
//    breakingLoadingView.color = [UIColor redColor];
//    [breakingLoadingView startAnimating];
//    [viewToLoadData addSubview:breakingLoadingView];
//
    [self addLoadingViewInView:viewToLoadData usingUIActivityIndicatorViewStyle:aStyle usingColor:[UIColor redColor]];
}

+(void)removeLoadingViewInView:(UIView*)viewToLoadData
{
    UIActivityIndicatorView * breakingLoadingView = (UIActivityIndicatorView*)[viewToLoadData  viewWithTag:99];
    [breakingLoadingView stopAnimating];
    [breakingLoadingView removeFromSuperview];
}





+(NSDictionary * )getURLs
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingString:@"/apiPages.plist"];
    
    //MSDebug(@"%@",);
    return [NSDictionary dictionaryWithContentsOfFile:fileName];
}


+ (NSDate *)getNowTime
{
    return [NSDate date];
}

+ (void)showTipsWithHUD:(NSString *)labelText showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[[[UIApplication sharedApplication] delegate] window]] ;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = labelText;
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hide:YES afterDelay:time];
}

+ (void)showTipsWithView:(UIView *)uiview labelText:(NSString *)labelText showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:uiview] ;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = labelText;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [uiview addSubview:hud];
    
    [hud hide:YES afterDelay:time];
}
+(void) showHudMessage:(NSString*) msg hideAfterDelay:(NSInteger) sec uiview:(UIView *)uiview{
    MBProgressHUD* hud2 = [MBProgressHUD showHUDAddedTo:uiview animated:YES];
    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = msg;
    hud2.margin = 12.0f;
    hud2.yOffset = 20.0f;
    hud2.removeFromSuperViewOnHide = YES;
    [hud2 hide:YES afterDelay:sec];
}

//+ (NetworkStatus)getCurrentNetworkStatus
//{
//    return [AppDelegate sharedNetworkStatus];
//}

+ (NetworkStatus)getCurrentNetworkStatusForLocal
{
    Reachability *tempReach = [Reachability reachabilityForInternetConnection];
    [tempReach startNotifier];
    
    return tempReach.currentReachabilityStatus;
}

+ (void)showNotReachabileTips
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"与服务端连接已断开,请检查您的网络连接是否正常."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

+(NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}
+(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
+(NSString *)getXingzuo:(NSDate *)in_date
{
    //计算星座
    
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month=0;
    NSString *theMonth = [dateFormat stringFromDate:in_date];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day=0;
    NSString *theDay = [dateFormat stringFromDate:in_date];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation //图片旋转
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

//将图片保存到应用程序沙盒中去,imageNameString的格式为 @"upLoad.png"
+ (void)saveImagetoLocal:(UIImage*)image imageName:(NSString *)imageNameString 
{
    if (image == nil || imageNameString.length == 0) {
        return;
    }
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *saveImagePath=[documentsDirectory stringByAppendingPathComponent:imageNameString];
    NSData *imageDataJPG=UIImageJPEGRepresentation(image, 0);//将图片大小进行压缩
    NSLog(@"图片大小为:%dkb",[imageDataJPG length]/1024);
//    NSData *imageData=UIImagePNGRepresentation(image);
    [imageDataJPG writeToFile:saveImagePath atomically:YES];
}

//begin 视频上传配置信息
+(NSString  *)getServerIp
{
    //return @"http://api.189pic.21cn.com";
    return @"http://p.21cn.com";
}

+(NSString *)getFlag
{
    return @"xxx";
}
//md5转换
+(NSString *) fileMd5sum:(NSString * )filename
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filename];
    if( handle== nil ) {
		return nil;
	}
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
	
	return s;
}
//将录制的视频的名字按照日期来命名，这样方便读取,例如iphone_record_20130821133639.mov
+(NSString * ) getRecordFilename
{
	char t[64];
	struct tm*stm;
    struct timeval tp;
    gettimeofday(&tp, NULL);
    stm = localtime( &tp.tv_sec );
    gettimeofday(&tp, NULL);
    stm = localtime( &tp.tv_sec );
    snprintf(t, sizeof(t), "iphone_record_%4d%02d%02d%02d%02d%02d",
             stm->tm_year + 1900, stm->tm_mon + 1, stm->tm_mday,
             stm->tm_hour, stm->tm_min, stm->tm_sec);
	
	return [NSString  stringWithFormat:@"%s.mov",t];
	
}
//将录制的音频频的名字按照日期来命名，这样方便读取,例如iphone_record_20130821133639.mp3
+(NSString * ) getRecordAudioFilename
{
	char t[64];
	struct tm*stm;
    struct timeval tp;
    gettimeofday(&tp, NULL);
    stm = localtime( &tp.tv_sec );
    gettimeofday(&tp, NULL);
    stm = localtime( &tp.tv_sec );
    snprintf(t, sizeof(t), "iphone_audiorecord_%4d%02d%02d%02d%02d%02d",
             stm->tm_year + 1900, stm->tm_mon + 1, stm->tm_mday,
             stm->tm_hour, stm->tm_min, stm->tm_sec);
	
	return [NSString  stringWithFormat:@"%s",t];
	
}
//将录制的相片的名字按照日期来命名，这样方便读取,例如iphone_record_20130821133639.jpg
+(NSString * ) getPhotoFilename
{
	char t[64];
	struct tm*stm;
    struct timeval tp;
    gettimeofday(&tp, NULL);
    stm = localtime( &tp.tv_sec );
    gettimeofday(&tp, NULL);
    stm = localtime( &tp.tv_sec );
    snprintf(t, sizeof(t), "iphone_audiorecord_%4d%02d%02d%02d%02d%02d",
             stm->tm_year + 1900, stm->tm_mon + 1, stm->tm_mday,
             stm->tm_hour, stm->tm_min, stm->tm_sec);
	
	return [NSString  stringWithFormat:@"%s.jpg",t];
	
}
//保存视频数据到沙盒
+(void)saveVideoToShaHe:(NSData *)videoData         
{
    if (videoData == nil) {
        MSDebug(@"videoData is nil");
        return;
    }
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString * tmp=[MSUtil getRecordFilename];
    NSString *videoFile = [documentsDirectory stringByAppendingPathComponent:tmp];
    NSLog(@"%@", videoFile);
    
    success = [fileManager fileExistsAtPath:videoFile];
    if(success) {
        success = [fileManager removeItemAtPath:videoFile error:&error];
    }
    [videoData writeToFile:videoFile atomically:YES];
}
//保存视频数据到沙盒 RecordFileName文件名称
+(void)saveVideoToShaHe:(NSData *)videoData recordFilename:(NSString *)RecordFileName
{
    if (videoData == nil) {
        MSDebug(@"videoData is nil");
        return;
    }
    if (RecordFileName.length == 0) {
        MSDebug(@"RecordFileName为空");
        return;
    }
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *videoFile = [documentsDirectory stringByAppendingPathComponent:RecordFileName];
    NSLog(@"%@", videoFile);
    
    success = [fileManager fileExistsAtPath:videoFile];
    if(success) {
        success = [fileManager removeItemAtPath:videoFile error:&error];
    }
    [videoData writeToFile:videoFile atomically:YES];
}
//从沙盒中获取视频路径 RecordFileName文件名称
+(NSString *)getVideoFileName:(NSString *)RecordFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *videoFile = [documentsDirectory stringByAppendingPathComponent:RecordFileName];
    return videoFile;
}
//end
@end
