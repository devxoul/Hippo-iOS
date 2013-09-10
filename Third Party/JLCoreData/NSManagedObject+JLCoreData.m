//
//  NSManagedObject+JLCoreData.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 10..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "NSManagedObject+JLCoreData.h"
#import "NSFetchRequest+JLCoreData.h"

@implementation NSManagedObject (JLCoreData)

+ (id)insert
{
	id object = [NSEntityDescription insertNewObjectForEntityForName:[self description] inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
	return object;
}

+ (NSFetchRequest *)request
{
	NSManagedObjectContext *context = [AppDelegate appDelegate].managedObjectContext;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:[self description] inManagedObjectContext:context];
	return request;
}

+ (void)truncate
{
	NSManagedObjectContext *context = [AppDelegate appDelegate].managedObjectContext;
	NSArray *items = [[[self class] request] all];
	for(id obj in items) {
		[context deleteObject:obj];
	}
	[context save:nil];
}

@end
