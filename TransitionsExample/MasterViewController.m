//
//  MasterViewController.m
//  TransitionsExample
//
//  Created by Nathan Borror on 4/27/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CustomTransition.h"

@implementation MasterViewController {
  UIButton *_button;
  CustomTransition *_animator;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setTitle:@"Master"];
  [self.view setBackgroundColor:[UIColor whiteColor]];

  _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, CGRectGetWidth(self.view.bounds), 44)];
  [_button setTitle:@"Next" forState:UIControlStateNormal];
  [_button addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
  [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  [self.view addSubview:_button];

  _animator = [[CustomTransition alloc] initWithParentViewController:self];

  UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:_animator action:@selector(handlePan:)];
  [recognizer setEdges:UIRectEdgeLeft];
  [self.view addGestureRecognizer:recognizer];
}

- (void)next:(UIButton *)sender
{
  DetailViewController *viewController = [[DetailViewController alloc] init];
  [viewController setModalPresentationStyle:UIModalPresentationCustom];
  [viewController setTransitioningDelegate:self];
  [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  [_animator setPresenting:YES];
  return _animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  [_animator setPresenting:NO];
  return _animator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
  if (_animator.interactive) {
    return _animator;
  }
  return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
  if (_animator.interactive) {
    return _animator;
  }
  return nil;
}

@end
