//
//  BBRootViewController.h
//  BBCyclingLabelDemo
//
//  Created by Bruno de Carvalho on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBCyclingLabel.h"



#pragma mark -

@interface BBRootViewController : UIViewController


#pragma mark Interface builder wiring

@property(weak, nonatomic) IBOutlet BBCyclingLabel* defaultLabel;
@property(weak, nonatomic) IBOutlet BBCyclingLabel* scaleOutLabel;
@property(weak, nonatomic) IBOutlet BBCyclingLabel* scrollUpLabel;
@property(weak, nonatomic) IBOutlet BBCyclingLabel* customLabel;
@property(weak, nonatomic) IBOutlet UITextField*    textField;

@end
