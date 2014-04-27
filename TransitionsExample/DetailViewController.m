//
//  DetailViewController.m
//  TransitionsExample
//
//  Created by Nathan Borror on 4/27/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomTransition.h"

@implementation DetailViewController {
  UIButton *_button;
  CustomTransition *_animator;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setTitle:@"Detail"];
  [self.view setBackgroundColor:[UIColor redColor]];

  _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, CGRectGetWidth(self.view.bounds), 44)];
  [_button setTitle:@"Back" forState:UIControlStateNormal];
  [_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
  [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.view addSubview:_button];

  _animator = [[CustomTransition alloc] initWithParentViewController:self];

  UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:_animator action:@selector(handlePan:)];
  [gestureRecognizer setEdges:UIRectEdgeRight];
  [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)back:(UIButton *)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
