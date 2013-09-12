//
//  User.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 13..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * thumbnail_url;

@end
