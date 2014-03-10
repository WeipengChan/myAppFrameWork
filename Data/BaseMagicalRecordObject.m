//
//  BaseMagicalRecordObject.m
//  头版
//
//  Created by YunInfo on 14-3-7.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "BaseMagicalRecordObject.h"

@implementation BaseMagicalRecordObject


+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([self class]) inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
  return 	NSStringFromClass([self class]);
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:NSStringFromClass([self class])inManagedObjectContext:moc_];
}

- (id)objectID {
	return (id)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
    
	return keyPaths;
}


@end
