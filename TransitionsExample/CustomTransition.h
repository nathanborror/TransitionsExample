//
//  CustomTransition.h
//  TransitionsExample
//
//  Created by Nathan Borror on 4/27/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) BOOL interactive;

-(id)initWithParentViewController:(UIViewController *)viewController;
-(void)handlePan:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer;

@end
