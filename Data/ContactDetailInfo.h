//
//  ContactDetailInfo.h
//  头版
//
//  Created by YunInfo on 14-3-6.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactDetailInfo : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSManagedObject *info;

@end
