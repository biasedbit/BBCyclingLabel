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
	// Triggers user provided pre and transition blocks
	BBCyclingLabelTypeCustom = 0,
    BBCyclingLabelTypeFadeIn = 1 << 0,
	BBCyclingLabelTypeFadeOut = 1 << 1,
	BBCyclingLabelTypeDefault = BBCyclingLabelTypeFadeIn | BBCyclingLabelTypeFadeOut,
	BBCyclingLabelTypeZoomIn = 1 << 2,
	BBCyclingLabelTypeZoomOut = 1 << 3,
	// Scales the exiting label from 1x to 2x w/ cross-fade
    BBCyclingLabelTypeScaleFadeOut = BBCyclingLabelTypeFadeIn | BBCyclingLabelTypeFadeOut | BBCyclingLabelTypeZoomOut,
	// Scales the entering label from 0.5x to 1x w/ cross-fade
    BBCyclingLabelTypeScaleFadeIn = BBCyclingLabelTypeFadeIn | BBCyclingLabelTypeFadeOut | BBCyclingLabelTypeZoomIn, 
    // These two move the entering label from above/below to center and exiting label up/down without cross-fade
    // It's a good idea to set the clipsToBounds property of the BBCyclingLabel to true and use this in a confined space
    BBCyclingLabelTypeScrollUp = 1 << 4,
    BBCyclingLabelTypeScrollDown = 1 << 5
} BBCyclingLabelType;



#pragma mark - Custom types

typedef void(^BBCyclingLabelPreTransitionBlock)(UILabel* labelToEnter);
typedef void(^BBCyclingLabelTransitionBlock)(UILabel* labelToExit, UILabel* labelToEnter);



#pragma mark -

@interface BBCyclingLabel : UIView


#pragma mark Public properties

@property(assign, nonatomic) BBCyclingLabelType               type;
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

- (id)initWithFrame:(CGRect)frame andType:(BBCyclingLabelType)type;


#pragma mark Public methods

/*! Sets the text for the next label and performs a transition between current and next label (if animated is YES) */
- (void)setText:(NSString*)text animated:(BOOL)animated;

@end
