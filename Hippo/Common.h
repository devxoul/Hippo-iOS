//
//  Common.h
//  Dish by.me
//
//  Created by 전 수열 on 12. 9. 20..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define LANGUAGE [[NSLocale preferredLanguages] objectAtIndex:0]

#define WEB_ROOT_URL	@"http://hippo.joyfl.net/"
#define API_ROOT_URL	@"http://hippo.joyfl.net/api/"

#define showErrorAlert() [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Status Code : %d\nError Code : %d\nMessage : %@", statusCode, errorCode, message] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
#define alert( title, msg ) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
