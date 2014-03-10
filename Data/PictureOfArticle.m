//
//  PictureOfArticle.m
//  头版
//
//  Created by YunInfo on 14-3-10.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "PictureOfArticle.h"
#import "ArticleContentObject.h"


@implementation PictureOfArticle

@dynamic createTime;
@dynamic pictureid;
@dynamic pictureMemo;
@dynamic pictureTitle;
@dynamic pictureUrl;
@dynamic articleContentObject;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:[(NSNumber*)value stringValue ] forKey:@"articleId"];
    }

}

-(NSString*)description
{
    return [NSString stringWithFormat:@"pictureUrl is %@",self.pictureUrl];
}

@end
