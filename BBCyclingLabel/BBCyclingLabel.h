//
//  BBCyclingLabel.h
//  BBCyclingLabelDemo
//
//  Created by Bruno de Carvalho on 3/13/12.
//  Copyright (c) 2012 BiasedBit. All rights reserved.
//

#pragma mark - Enums

typedef enum
{
	// User must provide pre-transition and transition blocks
	BBCyclingLabelTransitionEffectCustom = 0,

    BBCyclingLabelTransitionEffectFadeIn  = 1 << 0,
	BBCyclingLabelTransitionEffectFadeOut = 1 << 1,
	BBCyclingLabelTransitionEffectDefault = BBCyclingLabelTransitionEffectFadeIn |
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
    BBCyclingLabelTransitionEffectScrollDown = 1 << 5
} BBCyclingLabelTransitionEffect;



#pragma mark - Custom types

typedef void(^BBCyclingLabelPreTransitionBlock)(UILabel* labelToEnter);
typedef void(^BBCyclingLabelTransitionBlock)(UILabel* labelToExit, UILabel* labelToEnter);



#pragma mark -

@interface BBCyclingLabel : UIView


#pragma mark Public properties

@property(assign, nonatomic) BBCyclingLabelTransitionEffect   transitionEffect;
@property(copy,   nonatomic) BBCyclingLabelPreTransitionBlock preTransitionBlock;
@property(copy,   nonatomic) BBCyclingLabelTransitionBlock    transitionBlock;
@property(assign, nonatomic) NSTimeInterval                   transitionDuration;
// Same properties as UILabel, these will be propagated to the underlying labels
@property(copy,   nonatomic) NSString*            text;
@property(strong, nonatomic) UIFont*              font;
@property(strong, nonatomic) UIColor*             textColor;
@property(strong, nonatomic) UIColor*             shadowColor;
@property(assign, nonatomic) CGSize               shadowOffset;
@property(assign, nonatomic) UITextAlignment      textAlignment;
@property(assign, nonatomic) UILineBreakMode      lineBreakMode;
@property(assign, nonatomic) NSInteger            numberOfLines;
@property(assign, nonatomic) BOOL                 adjustsFontSizeToFitWidth;
@property(assign, nonatomic) CGFloat              minimumFontSize;
@property(assign, nonatomic) UIBaselineAdjustment baselineAdjustment;


#pragma mark Creation

- (id)initWithFrame:(CGRect)frame andTransitionType:(BBCyclingLabelTransitionEffect)transitionEffect;


#pragma mark Public methods

/*! Sets the text for the next label and performs a transition between current and next label (if animated is YES) */
- (void)setText:(NSString*)text animated:(BOOL)animated;

@end
