//
// Copyright 2013 BiasedBit
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
//  Copyright (c) 2013 BiasedBit. All rights reserved.
//

#pragma mark - Enums

typedef enum
{
    // User must provide pre-transition and transition blocks
    BBCyclingLabelTransitionEffectCustom = 0,

    BBCyclingLabelTransitionEffectFadeIn    = 1 << 0,
    BBCyclingLabelTransitionEffectFadeOut   = 1 << 1,
    BBCyclingLabelTransitionEffectCrossFade = BBCyclingLabelTransitionEffectFadeIn |
                                              BBCyclingLabelTransitionEffectFadeOut,

    BBCyclingLabelTransitionEffectZoomIn  = 1 << 2,
    BBCyclingLabelTransitionEffectZoomOut = 1 << 3,

    BBCyclingLabelTransitionEffectScaleFadeOut = BBCyclingLabelTransitionEffectFadeIn |
                                                 BBCyclingLabelTransitionEffectFadeOut |
                                                 BBCyclingLabelTransitionEffectZoomOut,
    BBCyclingLabelTransitionEffectScaleFadeIn  = BBCyclingLabelTransitionEffectFadeIn |
                                                 BBCyclingLabelTransitionEffectFadeOut |
                                                 BBCyclingLabelTransitionEffectZoomIn,

    // These two move the entering label from above/below to center and exiting label up/down without cross-fade
    // It's a good idea to set the clipsToBounds property of the BBCyclingLabel to true and use this in a confined space
    BBCyclingLabelTransitionEffectScrollUp   = 1 << 4,
    BBCyclingLabelTransitionEffectScrollDown = 1 << 5,

    BBCyclingLabelTransitionEffectDefault = BBCyclingLabelTransitionEffectCrossFade
} BBCyclingLabelTransitionEffect;



#pragma mark - Custom types

typedef void(^BBCyclingLabelPreTransitionBlock)(UILabel* labelToEnter);
typedef void(^BBCyclingLabelTransitionBlock)(UILabel* labelToExit, UILabel* labelToEnter);



#pragma mark -

@interface BBCyclingLabel : UIView


#pragma mark Properties

@property(assign, nonatomic) BBCyclingLabelTransitionEffect transitionEffect;
@property(assign, nonatomic) NSTimeInterval transitionDuration;
@property(copy,   nonatomic) BBCyclingLabelPreTransitionBlock preTransitionBlock;
@property(copy,   nonatomic) BBCyclingLabelTransitionBlock transitionBlock;
// Same properties as UILabel, these will be propagated to the underlying labels
@property(copy,   nonatomic) NSString* text;
@property(strong, nonatomic) UIFont* font;
@property(strong, nonatomic) UIColor* textColor;
@property(strong, nonatomic) UIColor* shadowColor;
@property(assign, nonatomic) CGSize shadowOffset;
@property(assign, nonatomic) NSTextAlignment textAlignment;
@property(assign, nonatomic) NSLineBreakMode lineBreakMode;
@property(assign, nonatomic) NSInteger numberOfLines;
@property(assign, nonatomic) BOOL adjustsFontSizeToFitWidth;
@property(assign, nonatomic) CGFloat minimumScaleFactor;
@property(assign, nonatomic) UIBaselineAdjustment baselineAdjustment;


#pragma mark Creation

- (instancetype)initWithFrame:(CGRect)frame andTransitionType:(BBCyclingLabelTransitionEffect)transitionEffect;


#pragma mark Interface

/*! Sets the text for the next label and performs a transition between current and next label (if animated is YES) */
- (void)setText:(NSString*)text animated:(BOOL)animated;

@end
