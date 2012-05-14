//
// Copyright 2012 BiasedBit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

//
//  Created by Bruno de Carvalho -- @biasedbit / http://biasedbit.com
//  Copyright (c) 2012 BiasedBit. All rights reserved.
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
