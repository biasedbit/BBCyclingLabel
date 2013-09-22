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

#import "BBCyclingLabel.h"



#pragma mark - Constants

NSTimeInterval const kBBCyclingLabelDefaultTransitionDuration = 0.3;



#pragma mark -

@implementation BBCyclingLabel
{
    NSUInteger _currentLabelIndex;
    NSArray* _labels;
    UILabel* _currentLabel;
}

#pragma mark Creation

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupWithEffect:BBCyclingLabelTransitionEffectDefault
                  andDuration:kBBCyclingLabelDefaultTransitionDuration];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self != nil) {
        [self setupWithEffect:BBCyclingLabelTransitionEffectDefault
                  andDuration:kBBCyclingLabelDefaultTransitionDuration];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTransitionType:(BBCyclingLabelTransitionEffect)transitionEffect
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupWithEffect:transitionEffect
                  andDuration:kBBCyclingLabelDefaultTransitionDuration];
    }

    return self;
}


#pragma mark Properties

- (void)setTransitionEffect:(BBCyclingLabelTransitionEffect)transitionEffect
{
    _transitionEffect = transitionEffect;
    [self prepareTransitionBlocks];
}

- (NSString*)text
{
    return _currentLabel.text;
}

- (void)setText:(NSString*)text
{
    [self setText:text animated:YES];
}

- (UIFont*)font
{
    return _currentLabel.font;
}

- (void)setFont:(UIFont*)font
{
    for (UILabel* label in _labels) {
        label.font = font;
    }
}

- (UIColor*)textColor
{
    return _currentLabel.textColor;
}

- (void)setTextColor:(UIColor*)textColor
{
    for (UILabel* label in _labels) {
        label.textColor = textColor;
    }
}

- (UIColor*)shadowColor
{
    return _currentLabel.shadowColor;
}

- (void)setShadowColor:(UIColor*)shadowColor
{
    for (UILabel* label in _labels) {
        label.shadowColor = shadowColor;
    }
}

- (CGSize)shadowOffset
{
    return _currentLabel.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    for (UILabel* label in _labels) {
        label.shadowOffset = shadowOffset;
    }
}

- (NSTextAlignment)textAlignment
{
    return _currentLabel.textAlignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    for (UILabel* label in _labels) {
        label.textAlignment = textAlignment;
    }
}

- (NSLineBreakMode)lineBreakMode
{
    return _currentLabel.lineBreakMode;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    for (UILabel* label in _labels) {
        label.lineBreakMode = lineBreakMode;
    }
}

- (NSInteger)numberOfLines
{
    return _currentLabel.numberOfLines;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    for (UILabel* label in _labels) {
        label.numberOfLines = numberOfLines;
    }
}

- (BOOL)adjustsFontSizeToFitWidth
{
    return _currentLabel.adjustsFontSizeToFitWidth;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{
    for (UILabel* label in _labels) {
        label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    }
}

- (CGFloat)minimumScaleFactor
{
    return _currentLabel.minimumScaleFactor;
}

- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor
{
    for (UILabel* label in _labels) {
        label.minimumScaleFactor = minimumScaleFactor;
    }
}

- (UIBaselineAdjustment)baselineAdjustment
{
    return _currentLabel.baselineAdjustment;
}

- (void)setBaselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    for (UILabel* label in _labels) {
        label.baselineAdjustment = baselineAdjustment;
    }
}


#pragma mark Interface

- (void)setText:(NSString*)text animated:(BOOL)animated
{
    NSUInteger nextLabelIndex = [self nextLabelIndex];
    UILabel* nextLabel = [_labels objectAtIndex:nextLabelIndex];
    UILabel* previousLabel = _currentLabel;

    nextLabel.text = text;
    // Resetting the label state ensures we can change the transition type without extra code on pre-transition block.
    // Without it a transition that has no alpha changes would have to ensure alpha = 1 on pre-transition block (as
    // well as with every other possible animatable property)
    [self resetLabel:nextLabel];

    // Update both current label index and current label pointer
    _currentLabel = nextLabel;
    _currentLabelIndex = nextLabelIndex;

    // Prepare the next label before the transition animation
    if (_preTransitionBlock != nil) {
        _preTransitionBlock(nextLabel);
    } else {
        // If no pre-transition block is set, prepare the next label for a cross-fade
        nextLabel.alpha = 0;
    }

    // Unhide the label that's about to be shown
    nextLabel.hidden = NO;

    void (^changeBlock)() = ^() {
        // Perform the user provided changes
        if (_transitionBlock != nil) {
            _transitionBlock(previousLabel, nextLabel);
        } else {
            // If no transition block is set, perform a simple cross-fade
            previousLabel.alpha = 0;
            nextLabel.alpha = 1;
        }
    };
    
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        // TODO this is kind of bugged since all transitions that include affine transforms always return finished
        // as true, even when it doesn't finish...
        if (finished) previousLabel.hidden = YES;
    };

    if (animated) {
        // Animate the transition between both labels
        [UIView animateWithDuration:_transitionDuration animations:changeBlock completion:completionBlock];
    } else {
        changeBlock();
        completionBlock(YES);
    }
}


#pragma mark Private helpers

- (void)setupWithEffect:(BBCyclingLabelTransitionEffect)effect andDuration:(NSTimeInterval)duration
{
    NSUInteger size = 2;
    NSMutableArray* labels = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < size; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.hidden = YES;
        label.numberOfLines = 0;

        [labels addObject:label];
    }

    _currentLabelIndex = 0;
    _currentLabel = [labels objectAtIndex:0];
    _labels = labels;

    _currentLabel.hidden = NO;

    self.transitionEffect = effect;
    self.transitionDuration = duration;
}

- (void)prepareTransitionBlocks
{
    if (_transitionEffect == BBCyclingLabelTransitionEffectCustom) return;

    BBCyclingLabelTransitionEffect type = _transitionEffect;
    CGFloat currentHeight = self.bounds.size.height;
    self.preTransitionBlock = ^(UILabel* labelToEnter) {
        if (type & BBCyclingLabelTransitionEffectFadeIn) labelToEnter.alpha = 0;
        if (type & BBCyclingLabelTransitionEffectZoomIn) labelToEnter.transform = CGAffineTransformMakeScale(0.5, 0.5);

        if (type & (BBCyclingLabelTransitionEffectScrollUp | BBCyclingLabelTransitionEffectScrollDown)) {
            CGRect frame = labelToEnter.frame;

            if (type & BBCyclingLabelTransitionEffectScrollUp) frame.origin.y = currentHeight;
            if (type & BBCyclingLabelTransitionEffectScrollDown) frame.origin.y = 0 - frame.size.height;

            labelToEnter.frame = frame;
        }
    };
    self.transitionBlock = ^(UILabel* labelToExit, UILabel* labelToEnter) {
        if (type & BBCyclingLabelTransitionEffectFadeIn) labelToEnter.alpha = 1;
        if (type & BBCyclingLabelTransitionEffectFadeOut) labelToExit.alpha = 0;
        if (type & BBCyclingLabelTransitionEffectZoomOut) labelToExit.transform = CGAffineTransformMakeScale(1.5, 1.5);

        if (type & BBCyclingLabelTransitionEffectZoomIn) labelToEnter.transform = CGAffineTransformIdentity;

        if (type & (BBCyclingLabelTransitionEffectScrollUp | BBCyclingLabelTransitionEffectScrollDown)) {
            CGRect frame = labelToExit.frame;
            CGRect enterFrame = labelToEnter.frame;

            if (type & BBCyclingLabelTransitionEffectScrollUp) {
                frame.origin.y = 0 - frame.size.height; 
                enterFrame.origin.y = roundf((currentHeight / 2) - (enterFrame.size.height / 2));
            }

            if (type & BBCyclingLabelTransitionEffectScrollDown) {
                frame.origin.y = currentHeight;
                enterFrame.origin.y = roundf((currentHeight / 2) - (enterFrame.size.height / 2));
            }

            labelToExit.frame = frame;
            labelToEnter.frame = enterFrame;
        }
    };
}

- (NSUInteger)nextLabelIndex
{
    return (_currentLabelIndex + 1) % [_labels count];
}

- (void)resetLabel:(UILabel*)label
{
    label.alpha = 1;
    label.transform = CGAffineTransformIdentity;
    label.frame = self.bounds;
}

@end
