//
//  ArticleObjectInList.h
//  头版
//
//  Created by YunInfo on 14-3-10.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArticleObjectInList : NSManagedObject

@property (nonatomic, retain) NSString * articleId;
@property (nonatomic, retain) NSString * articleType;
@property (nonatomic, retain) NSString * articleUrl;
@property (nonatomic, retain) NSString * columnId;
@property (nonatomic, retain) NSString * isHot;
@property (nonatomic, retain) NSString * isRecommend;
@property (nonatomic, retain) NSString * isSpecial;
@property (nonatomic, retain) NSString * originalHeight;
@property (nonatomic, retain) NSString * originalWidth;
@property (nonatomic, retain) NSString * publishTime;
@property (nonatomic, retain) NSString * regionId;
@property (nonatomic, retain) NSString * reviewNum;
@property (nonatomic, retain) NSString * showBigPic;
@property (nonatomic, retain) NSString * sourceId;
@property (nonatomic, retain) NSString * sourceName;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * thumbImgUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * topTime;
@property (nonatomic, retain) NSString * weight;

@end
