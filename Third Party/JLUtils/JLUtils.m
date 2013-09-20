//
//  JLUtils.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 20..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

@implementation JLUtils

+ (void)traceSubviews:(UIView *)view
{
	void (^traceSubviews)(UIView *, NSInteger);
	__block void (^_traceSubviews)(UIView *, NSInteger);
	
	_traceSubviews = traceSubviews = ^(UIView *view, NSInteger indentation) {
		NSMutableString *indentaionString = [@"|-- " mutableCopy];
		for( NSInteger i = 0; i < indentation; i++ )
		{
			[indentaionString insertString:@"|   " atIndex:0];
		}
		
		NSLog( @"%@%@", indentaionString, [view.class description] );
		
		for( UIView *subview in view.subviews )
		{
			_traceSubviews( subview, indentation + 1 );
		}
	};
	
	traceSubviews( view, 0 );
}

@end