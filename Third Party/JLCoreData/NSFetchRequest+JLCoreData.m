//
//  NSFetchRequest+JLCoreData.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 10..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "NSFetchRequest+JLCoreData.h"

@implementation NSFetchRequest (JLCoreData)

- (NSFetchRequest *)filter:(NSString *)format, ...;
{
	va_list ap;
	va_start( ap, format );
	NSString *predicate = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end( ap );
	
	self.predicate = [NSPredicate predicateWithFormat:predicate];
	return self;
}

- (NSFetchRequest *)orderBy:(NSString *)key
{
	NSString *orderKey = nil;
	BOOL ascending;
	
	if( [key hasSuffix:@"desc"] ) {
		orderKey = [[key componentsSeparatedByString:@" "] firstObject];
		ascending = NO;
	} else {
		orderKey = key;
		ascending = YES;
	}
	
	if( ![self.entity.propertiesByName.allKeys containsObject:orderKey] ) {
		return self;
	}
	
	self.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:orderKey ascending:ascending]];
	return self;
}

- (id)first
{
	return [[self all] firstObject];
}

- (id)last
{
	return [[self all] lastObject];
}

- (NSArray *)all
{
	NSManagedObjectContext *context = [AppDelegate appDelegate].managedObjectContext;
	return [context executeFetchRequest:self error:nil];
}

@end
