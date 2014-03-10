//
//  ContactInfo.m
//  头版
//
//  Created by YunInfo on 14-3-6.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "ContactInfo.h"
#import "ContactDetailInfo.h"


@implementation ContactInfo

@dynamic age;
@dynamic birthday;
@dynamic name;
@dynamic details;

-(NSString*)description
{
    return  [NSString stringWithFormat:@"age:%@ | name:%@ | details:%@",self.age,self.name,self.details];

}

@end
