//
//  ORM.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "ORM.h"

@implementation ORM

+ (id)insert
{
	id object = [NSEntityDescription insertNewObjectForEntityForName:[self description] inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
	return object;
}

+ (NSArray *)all
{
	NSManagedObjectContext *context = [AppDelegate appDelegate].managedObjectContext;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:[self description] inManagedObjectContext:context];
	
	return [context executeFetchRequest:request error:nil];
}

+ (NSArray *)filter:(NSString *)format, ...;
{
	NSManagedObjectContext *context = [AppDelegate appDelegate].managedObjectContext;
	
	va_list ap;
	va_start( ap, format );
	NSString *predicate = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end( ap );
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:[self description] inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:predicate];
	
	return [context executeFetchRequest:request error:nil];
}

@end
