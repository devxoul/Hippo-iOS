//
//  Webtoon.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "Webtoon.h"

@implementation Webtoon

+ (Webtoon *)webtoonWithDictionary:(NSDictionary *)data
{
	Webtoon *webtoon = [[Webtoon alloc] init];
	webtoon.id = [[data objectForKeyNotNull:@"id"] integerValue];
	webtoon.portal = [data objectForKeyNotNull:@"portal"];
	webtoon.portalID = [data objectForKeyNotNull:@"portal_id"];
	webtoon.title = [data objectForKeyNotNull:@"title"];
	webtoon.thumbnailURL = [NSString stringWithFormat:@"%@%@", WEB_ROOT_URL, [data objectForKeyNotNull:@"thumbnail_url"]];
	webtoon.mon = [[data objectForKeyNotNull:@"mon"] boolValue];
	webtoon.tue = [[data objectForKeyNotNull:@"tue"] boolValue];
	webtoon.wed = [[data objectForKeyNotNull:@"wed"] boolValue];
	webtoon.thu = [[data objectForKeyNotNull:@"thu"] boolValue];
	webtoon.fri = [[data objectForKeyNotNull:@"fri"] boolValue];
	webtoon.sat = [[data objectForKeyNotNull:@"sat"] boolValue];
	webtoon.sun = [[data objectForKeyNotNull:@"sun"] boolValue];
	webtoon.finished = [[data objectForKeyNotNull:@"finished"] boolValue];
	webtoon.subscribed = [[data objectForKeyNotNull:@"subscribed"] boolValue];
	webtoon.newCount = [[data objectForKeyNotNull:@"new_count"] integerValue];
	return webtoon;
}

@end
