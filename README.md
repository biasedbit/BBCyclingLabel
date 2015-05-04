BBCyclingLabel
==============

`BBCyclingLabel` is just like a `UILabel` but allows you to perform custom animations when changing text.

Instead of using two `UILabel`'s and cross fading them, you can use this component and configure it to crossfade; it'll then take care of performing the cross fade for you.

Here's a [demo video](http://d.pr/nMcl) of this component running on the demo project `BBCyclingLabelDemo`.


## Quick start

`BBCyclingLabel` is available on [CocoaPods](http://cocoapods.org).  Add the following to your `Podfile`:

```ruby
pod 'BBCyclingLabel', '~> 1.0'
```


## How it works

Under the hood, `BBCyclingLabel` simply animates transitions between two `UILabels`, which are always cycled when changing text.

## How to use it

```objc
CGRect labelFrame = ...;

BBCyclingLabel* label = [[BBCyclingLabel alloc] initWithFrame:labelFrame];
label.transitionEffect = BBCyclingLabelTransitionEffectCrossFade;
label.transitionDuration = 0.3;
// Initial text doesn't need to be animated so we explicitly call a method to bypass it
[label setText:@"Initial text" animated:NO];

// ...

// Using the property 'text', the component will always animate
label.text = @"This will cross fade with initial text"
```


## Component properties

Apart from all the properties present in a `UILabel`, `BBCyclingLabel` has four more properties:

```objc
BBCyclingLabelTransitionEffect   transitionEffect;
NSTimeInterval                   transitionDuration;
BBCyclingLabelPreTransitionBlock preTransitionBlock;
BBCyclingLabelTransitionBlock    transitionBlock;
```

* `transitionEffect`: A value of the enum `BBCyclingLabelTransitionEffect` that determines which animation effect will be used to cycle text.
* `transitionDuration`: Duration, in milliseconds, for the transition animation;
* `preTransitionBlock` and `transitionBlock`: Blocks to be executed before and during the transition -- should only be manually set when performing custom effects.


## Effects

This component supports the following simple effects:

* Fade in (`BBCyclingLabelTransitionEffectFadeIn`)
* Fade out (`BBCyclingLabelTransitionEffectFadeOut`)
* Zoom in (increase scale, `BBCyclingLabelTransitionEffectZoomIn`)
* Zoom out (reduce scale, `BBCyclingLabelTransitionEffectZoomOut`)
* Scroll up (`BBCyclingLabelTransitionEffectScrollUp`)
* Scroll down (`BBCyclingLabelTransitionEffectScrollDown`)

It also offers the following composite effects (combinations of the above):

* Cross fade (fade out + fade in, `BBCyclingLabelTransitionEffectCrossFade`)
* Scaled fade out (fade out + fade in + zoom out, `BBCyclingLabelTransitionEffectScaleFadeOut`)
* Scaled fade in (fade out + fade in + zoom in, `BBCyclingLabelTransitionEffectScaleFadeIn`)

Predefined effects can be combined using the logic OR operator. If you want to make the current text fade out while scrolling both current and new up, you can do this by combining the fade out and scroll up effects:

```objc
BBCyclingLabelTransitionEffect effect = BBCyclingLabelTransitionEffectFadeOut |
                                        BBCyclingLabelTransitionEffectScrollUp;
```

If you want to perform a cross fade with a scroll up, you can either do it in one of the following two ways:

```objc
BBCyclingLabelTransitionEffect effect = BBCyclingLabelTransitionEffectFadeOut |
                                        BBCyclingLabelTransitionEffectFadeIn |
                                        BBCyclingLabelTransitionEffectScrollUp;

BBCyclingLabelTransitionEffect effect = BBCyclingLabelTransitionEffectCrossFade |
                                        BBCyclingLabelTransitionEffectScrollUp;
```


## Customizable effects

If the predefined effects are not enough, you can get your hands dirty and roll in your own custom transitions. To do that, you need to set the `transitionEffect` property to `BBCyclingLabelTransitionEffectCustom` and assign blocks to `preTransitionBlock` and `transitionBlock`.

The `preTransitionBlock` block has the following signature:

```objc
^(UILabel* labelToEnter)
```

This block is called right before the transition begins so you can prepare the new label (the label that's about to replace the current text) to enter. This is where you should reset the state of the entering label.

The `transitionBlock` block has the following signature:

```objc
^(UILabel* labelToExit, UILabel* labelToEnter)
```

This block will be called with both labels, the one that's about to be replaced and the one with the new text. This is where you perform the transition itself. Hide, rotate, fade, scale, etc, this is where you go wild on the effects; just make sure you leave things in a usable state.

Here's a silly example that performs a 180º rotation + scale down to 0.2 on the exiting label and simply fades in the entering label:

```objc
// Never forget to set this to custom
_customLabel.transitionEffect = BBCyclingLabelTransitionEffectCustom;
_customLabel.preTransitionBlock = ^(UILabel* labelToEnter) {
    // Reset the label to enter; make sure it's at alpha 0 and has no transforms applied to it
    labelToEnter.transform = CGAffineTransformIdentity;
    labelToEnter.alpha = 0;
};
_customLabel.transitionBlock = ^(UILabel* labelToExit, UILabel* labelToEnter) {
    // Fade the exiting label out...
    labelToExit.alpha = 0;
    // ... and apply a rotation + scale transform
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    labelToExit.transform = CGAffineTransformScale(transform, 0.2, 0.2);
    // Fade the entering label in
    labelToEnter.alpha = 1;
};
```