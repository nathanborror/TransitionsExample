//
//  CustomTransition.m
//  TransitionsExample
//
//  Created by Nathan Borror on 4/27/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "CustomTransition.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation CustomTransition {
  UIViewController *_parentViewController;
  id<UIViewControllerContextTransitioning> _transitionContext;
}

- (instancetype)initWithParentViewController:(UIViewController *)viewController
{
  if (self = [super init]) {
    _parentViewController = viewController;
  }
  return self;
}

- (void)handlePan:(UIScreenEdgePanGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:recognizer.view];
  CGPoint velocity = [recognizer velocityInView:recognizer.view];

  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      _interactive = YES;

      if (location.x < CGRectGetMidX(recognizer.view.bounds)) {
        DetailViewController *viewController = [[DetailViewController alloc] init];
        [viewController setModalPresentationStyle:UIModalPresentationCustom];
        [viewController setTransitioningDelegate:(MasterViewController *)_parentViewController];
        [_parentViewController presentViewController:viewController animated:YES completion:nil];
      } else {
        [_parentViewController dismissViewControllerAnimated:YES completion:nil];
      }
      break;
    }

    case UIGestureRecognizerStateChanged: {
      CGFloat ratio = location.x / CGRectGetWidth(recognizer.view.bounds);
      [self updateInteractiveTransition:ratio];
      break;
    }

    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled: {
      if (_presenting) {
        if (velocity.x > 0) {
          [self finishInteractiveTransition];
        } else {
          [self cancelInteractiveTransition];
        }
      } else {
        if (velocity.x < 0) {
          [self finishInteractiveTransition];
        } else {
          [self cancelInteractiveTransition];
        }
      }
      break;
    }

    default:
      break;
  }
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
  return .35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
  UIView *container = transitionContext.containerView;
  UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
  UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;

  if (_presenting) {
    [toView setFrame:CGRectMake(-CGRectGetWidth(fromView.bounds), 0, CGRectGetWidth(toView.bounds), CGRectGetHeight(toView.bounds))];
    [container addSubview:toView];
  } else {
    [container insertSubview:toView belowSubview:fromView];
  }

  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    if (_presenting) {
      [toView setFrame:CGRectMake(0, 0, CGRectGetWidth(toView.bounds), CGRectGetHeight(toView.bounds))];
    } else {
      [fromView setFrame:CGRectMake(-CGRectGetWidth(toView.bounds), 0, CGRectGetWidth(fromView.bounds), CGRectGetHeight(fromView.bounds))];
    }
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:YES];
  }];
}

- (void)animationEnded:(BOOL)transitionCompleted
{
  _interactive = NO;
  _presenting = NO;
  _transitionContext = nil;
}

#pragma mark - UIViewControllerInteractiveTransitioning

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  _transitionContext = transitionContext;

  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  CGRect endFrame = [[transitionContext containerView] bounds];

  if (_presenting) {
    // The order of these matters – determines the view hierarchy order.
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];

    endFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
  } else {
    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext.containerView addSubview:fromViewController.view];
  }

  toViewController.view.frame = endFrame;
}

#pragma mark - UIPercentDrivenInteractiveTransition

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
  UIViewController *fromViewController = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  // Presenting goes from 0...1 and dismissing goes from 1...0
  CGRect frame = CGRectOffset([[_transitionContext containerView] bounds], -CGRectGetWidth([[_transitionContext containerView] bounds]) * (1.0f - percentComplete), 0);

  if (_presenting) {
    toViewController.view.frame = frame;
  } else {
    fromViewController.view.frame = frame;
  }
}

- (void)finishInteractiveTransition
{
  UIViewController *fromViewController = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  if (_presenting) {
    CGRect endFrame = [[_transitionContext containerView] bounds];

    [UIView animateWithDuration:0.5f animations:^{
      toViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
      [_transitionContext completeTransition:YES];
    }];
  }
  else {
    CGRect endFrame = CGRectOffset([[_transitionContext containerView] bounds], -CGRectGetWidth([[_transitionContext containerView] bounds]), 0);

    [UIView animateWithDuration:0.5f animations:^{
      fromViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
      [_transitionContext completeTransition:YES];
    }];
  }
}

- (void)cancelInteractiveTransition
{
  UIViewController *fromViewController = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  if (_presenting) {
    CGRect endFrame = CGRectOffset([[_transitionContext containerView] bounds], -CGRectGetWidth([[_transitionContext containerView] bounds]), 0);

    [UIView animateWithDuration:0.5f animations:^{
      toViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
      [_transitionContext completeTransition:NO];
    }];
  } else {
    CGRect endFrame = [[_transitionContext containerView] bounds];

    [UIView animateWithDuration:0.5f animations:^{
      fromViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
      [_transitionContext completeTransition:NO];
    }];
  }
}

@end
