//
//  PictureOfArticle.h
//  头版
//
//  Created by YunInfo on 14-3-10.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ArticleContentObject;

@interface PictureOfArticle : NSManagedObject

@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSNumber * pictureid;
@property (nonatomic, retain) NSString * pictureMemo;
@property (nonatomic, retain) NSString * pictureTitle;
@property (nonatomic, retain) NSString * pictureUrl;
@property (nonatomic, retain) ArticleContentObject *articleContentObject;

@end
