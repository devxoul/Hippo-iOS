//
//  UIView+JLAnimations.m
//  Dish by.me
//
//  Created by 전수열 on 13. 4. 25..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "UIView+JLAnimations.h"

@implementation UIView (JLAnimations)

//- (void)shakeCount:(NSInteger)count radius:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void(^)(void))completion
//{
//	
//}

- (void)shakeCount:(NSInteger)count radius:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void(^)(void))completion
{
	[UIView animateWithDuration:duration animations:^{
		self.transform = CGAffineTransformMakeTranslation( -radius, 0 );
		
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:duration animations:^{
			self.transform = CGAffineTransformMakeTranslation( radius, 0 );
			
		} completion:^(BOOL finished) {
			if( count > 1 )
			{
				[self shakeCount:count - 1 radius:radius duration:duration delay:0 completion:completion];
			}
			else
			{
				[UIView animateWithDuration:duration * 0.5 animations:^{
					self.transform = CGAffineTransformMakeTranslation( 0, 0 );
					
				} completion:^(BOOL finished) {
					self.transform = CGAffineTransformIdentity;
					if( completion )
					{
						completion();
					}
				}];
			}
		}];
	}];
}

@end
