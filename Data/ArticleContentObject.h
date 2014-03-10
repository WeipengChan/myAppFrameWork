//
//  ArticleContentObject.h
//  头版
//
//  Created by YunInfo on 14-3-10.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PictureOfArticle;

@interface ArticleContentObject : NSManagedObject

@property (nonatomic, retain) NSString * articleId;
@property (nonatomic, retain) NSNumber * articleType;
@property (nonatomic, retain) NSString * articleUrl;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * leaderette;
@property (nonatomic, retain) NSString * originalLink;
@property (nonatomic, retain) NSString * publishTime;
@property (nonatomic, retain) NSString * sourceName;
@property (nonatomic, retain) NSNumber * sourceStatus;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *pictureListSet;
@end

@interface ArticleContentObject (CoreDataGeneratedAccessors)

- (void)addpictureListSetObject:(PictureOfArticle *)value;
- (void)removepictureListSetObject:(PictureOfArticle *)value;
- (void)addpictureListSet:(NSSet *)values;
- (void)removepictureListSet:(NSSet *)values;

@end
