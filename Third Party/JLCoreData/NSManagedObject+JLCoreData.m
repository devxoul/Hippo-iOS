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

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"eee, dd MMM yyyy HH:mm:ss ZZZZ";
	dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        if (value == nil || [value isEqual:[NSNull null]]) {
            continue;
        }
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value integerValue]];
        } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
            value = [dateFormatter dateFromString:value];
        }
        [self setValue:value forKey:attribute];
    }
}

@end
