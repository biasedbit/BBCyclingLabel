//
//  BBRootViewController.m
//  BBCyclingLabelDemo
//
//  Created by Bruno de Carvalho on 3/13/12.
//  Copyright (c) 2012 BiasedBit. All rights reserved.
//

#import "BBRootViewController.h"



#pragma mark -

@interface BBRootViewController () <UITextFieldDelegate>

@end



#pragma mark -

@implementation BBRootViewController


#pragma mark Property synthesizers

@synthesize defaultLabel  = _defaultLabel;
@synthesize scaleOutLabel = _scaleOutLabel;
@synthesize scrollUpLabel = _scrollUpLabel;
@synthesize customLabel   = _customLabel;
@synthesize textField     = _textField;


#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _defaultLabel.font = [UIFont systemFontOfSize:15];
    _scaleOutLabel.font = [UIFont systemFontOfSize:15];
    _scrollUpLabel.font = [UIFont systemFontOfSize:15];
    _customLabel.font = [UIFont systemFontOfSize:15];

    _defaultLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    _scaleOutLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    _scrollUpLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    _customLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];

    _defaultLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];
    _scaleOutLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];
    _scrollUpLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];
    _customLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];

    _defaultLabel.shadowOffset = CGSizeMake(0, 1);
    _scaleOutLabel.shadowOffset = CGSizeMake(0, 1);
    _scrollUpLabel.shadowOffset = CGSizeMake(0, 1);
    _customLabel.shadowOffset = CGSizeMake(0, 1);

    _defaultLabel.numberOfLines = 1;
    _scaleOutLabel.numberOfLines = 1;
    _scrollUpLabel.numberOfLines = 1;
    _customLabel.numberOfLines = 1;

    _defaultLabel.textAlignment = UITextAlignmentCenter;
    _scaleOutLabel.textAlignment = UITextAlignmentCenter;
    _scrollUpLabel.textAlignment = UITextAlignmentCenter;
    _customLabel.textAlignment = UITextAlignmentCenter;

    // Slow so you can get a good look...
    _defaultLabel.transitionDuration = 0.75;
    _scaleOutLabel.transitionDuration = 0.75;
    _scrollUpLabel.transitionDuration = 0.75;
    _customLabel.transitionDuration = 0.75;

    [_defaultLabel setText:@"default label text" animated:NO];
    [_scaleOutLabel setText:@"scale out label text" animated:NO];
    [_scrollUpLabel setText:@"scroll up label text" animated:NO];
    [_customLabel setText:@"scroll up label text" animated:NO];

    _scaleOutLabel.transitionEffect = BBCyclingLabelTransitionEffectScaleFadeOut;

    _scrollUpLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
    // Since scrolling involves moving the frame of the underlying labels, we need to enable bound clipping
    _scrollUpLabel.clipsToBounds = YES;

    // Create a custom transition animation that rotates 180º, reduces size to 0.2 and fades out the exiting label
    _customLabel.transitionEffect = BBCyclingLabelTransitionEffectCustom;
    _customLabel.preTransitionBlock = ^(UILabel* labelToEnter) {
        labelToEnter.transform = CGAffineTransformIdentity;
        labelToEnter.alpha = 0;
    };
    _customLabel.transitionBlock = ^(UILabel* labelToExit, UILabel* labelToEnter) {
        labelToExit.alpha = 0;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        labelToExit.transform = CGAffineTransformScale(transform, 0.2, 0.2);

        labelToEnter.alpha = 1;
    };
    _customLabel.clipsToBounds = YES;

    _textField.delegate = self;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSString* text = textField.text;

    [_defaultLabel setText:text animated:YES];
    [_scaleOutLabel setText:text animated:YES];
    [_scrollUpLabel setText:text animated:YES];
    [_customLabel setText:text animated:YES];

    _textField.text = @"";

    return YES;
}

@end
