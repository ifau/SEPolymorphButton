SEPolymorphButton
=================

SEPolymorphButton is a subclass of UIControl that simulate the basic behavior of button and allows to transform own shape to circle, heart or star. Written in __Swift__, requires __iOS 8__ or later.

![First gif](https://github.com/ifau/SEPolymorphButton/blob/master/Readme/1.gif?raw=true)

![Second gif](https://github.com/ifau/SEPolymorphButton/blob/master/Readme/2.gif?raw=true)

#Usage

```swift
let polyButton = SEPolymorphButton()
view.addSubview(polyButton)
...
polyButton.changeStyle(.💛, animationDuration: 0.5)
// alternative: polyButton.changeStyle(.heartStyle, animationDuration: 0.5)
polyButton.changeStyle(.🌕, animationDuration: 0.5)
// alternative: polyButton.changeStyle(.circleStyle, animationDuration: 0.5)
polyButton.changeStyle(.🌟, animationDuration: 0.5)
// alternative: polyButton.changeStyle(.starStyle, animationDuration: 0.5)
```

You can handle clicks by setting action for `TouchUpInside` control events:

```swift
polyButton.addTarget(self, action: "buttonDidPressed", forControlEvents: .TouchUpInside)
...
func buttonDidPressed()
{
	println("yay!")
}
```

#Configuration

SEPolymorphButton allows you to change the following properties:

* `lineWidth : Float`
	
	Width of main shape, __default__ is __1.0__.
	
*	`margins : Float`
	
	Offset inward button's frame, __default__ is __0.0__.

* `strokeColor : UIColor`
	
	Color of main shape, __default__ is __UIColor.blackColor()__.
	
* `fillColor : UIColor`
	
	Color of fill main shape, __default__ is __UIColor.clearColor()__.
	
* `gradientColors : [UIColor]?`
	
	Array of colors that will be applied to the shape as gradient.
	
	__Note:__ Setting this property ___invalidates strokeColor and fillColor___.
	
* `vibrancyForBlurEffectStyle : UIBlurEffectStyle?`
	
	Create vibrancy effect for display on view with a given blur effect.
	
	__Note:__ if this property is set, button ___should be placed in the contentView of UIVisualEffectView___.
	
* `defaultOpacity : Float`
	
	Opacity of main shape in normal state, __default__ is __0.7__.
	
* `highlightedOpacity : Float`
	
	Opacity of main shape in highlighted state, __default__ is __1.0__.
	
* `highlightedFillColor : UIColor`
	
	Color of fill main shape in highlighted state, __default__ is __UIColor.clearColor()__.

#Installation

Simply drag `SEPolymorphButton.swift` to your project.

#License

	The MIT License (MIT)

	Copyright (c) 2015 Seliverstov Evgeney

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.