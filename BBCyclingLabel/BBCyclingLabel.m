//
//  BBCyclingLabel.m
//  BBCyclingLabelDemo
//
//  Created by Bruno de Carvalho on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBCyclingLabel.h"



#pragma mark - Constants

NSTimeInterval const kBBCyclingLabelDefaultTransitionDuration = 0.3;



#pragma mark -

@interface BBCyclingLabel ()
{
    NSUInteger _currentLabelIndex;
}


#pragma mark Private properties

@property(strong, nonatomic) NSArray* labels;
@property(strong, nonatomic) UILabel* currentLabel;


#pragma mark Private helpers

- (void)setupWithType:(BBCyclingLabelType)type andTransitionDuration:(NSTimeInterval)duration;
- (void)prepareTransitionBlocks;
- (NSUInteger)nextLabelIndex;
- (void)resetLabel:(UILabel*)label;

@end



#pragma mark -

@implementation BBCyclingLabel


#pragma mark Property synthesizers

@synthesize type               = _type;
@synthesize preTransitionBlock = _preTransitionBlock;
@synthesize transitionBlock    = _transitionBlock;
@synthesize transitionDuration = _transitionDuration;
// Private
@synthesize labels       = _labels;
@synthesize currentLabel = _currentLabel;


#pragma mark Creation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupWithType:BBCyclingLabelTypeDefault andTransitionDuration:kBBCyclingLabelDefaultTransitionDuration];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame andType:(BBCyclingLabelType)type
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupWithType:type andTransitionDuration:kBBCyclingLabelDefaultTransitionDuration];
    }

    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self != nil) {
        [self setupWithType:BBCyclingLabelTypeDefault andTransitionDuration:kBBCyclingLabelDefaultTransitionDuration];
    }

    return self;
}


#pragma mark Manual property accessors

- (void)setType:(BBCyclingLabelType)type
{
    _type = type;
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

- (UITextAlignment)textAlignment
{
    return _currentLabel.textAlignment;
}

- (void)setTextAlignment:(UITextAlignment)textAlignment
{
    for (UILabel* label in _labels) {
        label.textAlignment = textAlignment;
    }
}

- (UILineBreakMode)lineBreakMode
{
    return _currentLabel.lineBreakMode;
}

- (void)setLineBreakMode:(UILineBreakMode)lineBreakMode
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

- (CGFloat)minimumFontSize
{
    return _currentLabel.minimumFontSize;
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize
{
    for (UILabel* label in _labels) {
        label.minimumFontSize = minimumFontSize;
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


#pragma mark Public methods

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
    self.currentLabel = nextLabel;
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

    // TODO
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
//        if (finished) {
//            // Hide the label that was just shown and clear its text when animation finished properly.
//            // When it doesn't finish, it means a new text change kicked in, in which case we can't hide or set to nil
//            // as we'd be altering the next-next label.
//            previousLabel.hidden = YES;
//            previousLabel.text = nil;
//        }
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

- (void)setupWithType:(BBCyclingLabelType)type andTransitionDuration:(NSTimeInterval)duration
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
    self.currentLabel = [labels objectAtIndex:0];
    self.labels = labels;

    _currentLabel.hidden = NO;

    self.type = type;
    self.transitionDuration = duration;
}

- (void)prepareTransitionBlocks
{
    switch (_type) {
        case BBCyclingLabelTypeDefault: {
            self.preTransitionBlock = nil;
            self.transitionBlock = nil;
            break;
        }

        case BBCyclingLabelTypeScaleFadeOut: {
            self.preTransitionBlock = ^(UILabel* labelToEnter) {
                labelToEnter.transform = CGAffineTransformIdentity;
                labelToEnter.alpha = 0;
            };
            self.transitionBlock = ^(UILabel* labelToExit, UILabel* labelToEnter) {
                labelToExit.transform = CGAffineTransformMakeScale(1.5, 1.5);
                labelToExit.alpha = 0;
                labelToEnter.alpha = 1;
            };
            break;
        }

        case BBCyclingLabelTypeScaleFadeIn: {
            self.preTransitionBlock = ^(UILabel* labelToEnter) {
                labelToEnter.transform = CGAffineTransformMakeScale(0.5, 0.5);
                labelToEnter.alpha = 0;
            };
            self.transitionBlock = ^(UILabel* labelToExit, UILabel* labelToEnter) {
                labelToEnter.transform = CGAffineTransformIdentity;
                labelToEnter.alpha = 1;
                labelToExit.alpha = 0;
            };
            break;
        }

        case BBCyclingLabelTypeScrollUp: {
            self.preTransitionBlock = ^(UILabel* labelToEnter) {
                CGRect frame = labelToEnter.frame;
                frame.origin.y = self.bounds.size.height;
                labelToEnter.frame = frame;
            };
            self.transitionBlock = ^(UILabel* labelToExit, UILabel* labelToEnter) {
                CGRect frame = labelToExit.frame;
                frame.origin.y = 0 - frame.size.height;
                labelToExit.frame = frame;

                CGRect enterFrame = labelToEnter.frame;
                enterFrame.origin.y = roundf((self.bounds.size.height / 2) - (enterFrame.size.height / 2));
                labelToEnter.frame = enterFrame;
            };
            break;
        }

        case BBCyclingLabelTypeScrollDown: {
            self.preTransitionBlock = ^(UILabel* labelToEnter) {
                CGRect frame = labelToEnter.frame;
                frame.origin.y = 0 - frame.size.height;
                labelToEnter.frame = frame;
            };
            self.transitionBlock = ^(UILabel* labelToExit, UILabel* labelToEnter) {
                CGRect frame = labelToExit.frame;
                frame.origin.y = self.bounds.size.height;
                labelToExit.frame = frame;

                CGRect enterFrame = labelToEnter.frame;
                enterFrame.origin.y = roundf((self.bounds.size.height / 2) - (enterFrame.size.height / 2));
                labelToEnter.frame = enterFrame;
            };
            break;
        }

        case BBCyclingLabelTypeCustom:
        default:
            // Do nothing, user must define them manually
            break;
    }
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
