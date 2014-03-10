//
//  ArticleContentObject.m
//  头版
//
//  Created by YunInfo on 14-3-10.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "ArticleContentObject.h"
#import "PictureOfArticle.h"


@implementation ArticleContentObject

@dynamic articleId;
@dynamic articleType;
@dynamic articleUrl;
@dynamic content;
@dynamic createTime;
@dynamic leaderette;
@dynamic originalLink;
@dynamic publishTime;
@dynamic sourceName;
@dynamic sourceStatus;
@dynamic summary;
@dynamic title;
@dynamic pictureListSet;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:[(NSNumber*)value stringValue ] forKey:@"articleId"];
    }
   
    if ([key isEqualToString:@"pictureList"]) {
        NSArray * array = value;
        for (NSDictionary * each in array) {
            //建立新对象
            PictureOfArticle * pa = [PictureOfArticle MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
            [pa setValuesForKeysWithDictionary:each];
            //增加
            [self addpictureListSetObject:pa];
        }
    }
    
}



@end
