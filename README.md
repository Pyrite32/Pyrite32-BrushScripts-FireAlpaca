# Pyrite32-BrushScripts-FireAlpaca
A collection of the brush scripts I've made recently, for use with the free drawing program FireAlpaca. A mix of tools and brushes designed to be compatible with mice.

+ *addget.bs* reads in a color from the canvas and the foreground and calculates the color needed to obtain the target (foreground color) in additive blending mode. Results in RGB(255, 0, 0) if additive blending mode cannot produce the desired color.
Good for figuring out which color you need to use for highlights, if highlights are on a layer with Add blending mode.
+ *all-else.bs* prototype pen tool for use with mice.
+ *colormap.bs* generates a 11 x 11 swatch of colors that represent possible colors between the original (foreground color) and the destination color.
    * H-curve defines the transition between the hues of both colors. Low values => ease out. High values => ease in
    * Divergence adds saturation to the swatches
+ *complemix.bs* produces a gradient between a color on the canvas and its respective complementary color.
+ *envelope.bs* fills in a shape defined by a brush stroke, similar to the Lasso tool.
+ *envize.bs* tints colors according to the foreground color by centering the range of colors around the foreground color. To use it, draw a stroke from the palette's top left corner, and end the stroke on the palette's bottom right corner.
    * Intensity measures the reduction / increase in saturation.
+ *eq-brush-eaps.bs* Equation Brush, Easing Points. Artificial pen pressure brush that functions based on spaced-out easing points. 
+ *eq-brush-IDB.bs* Equation Brush, Increase, Decrease, Bounce. Artificial pen pressure brush that randomizes stroke pressure by randomly choosing to increase, decrease, or oscillate size.
+ *eq-brush-sine.bs* Equation Brush, Sine. Artificial pen pressure brush that creates a simple tapered stroke.
+ *fixedRandomBrush.bs* Artificial pen pressure brush that cycles periodically between large and small strokes.
+ *grid.bs* Simple utility that draws a grid. To use it, draw a stroke from the grid's top left corner, and end the stroke on the grid's bottom right corner.
+ *interpolate.bs* Similar to *complemix.bs*, *interpolate.bs* creates a gradient between the foreground color and a color on the canvas.
+ *mulget.bs* reads in a color from the canvas and the foreground and calculates the color needed to obtain the target (foreground color) in multiply blending mode. Results in RGB(255, 0, 0) if multiply blending mode cannot produce the desired color. Good for figuring out which color you need to use for shadows, if shadows are on a layer with Multiply blending mode.
+ *NEW SMART INTERPOLATION.bs* an advanced utility that takes the foreground color and a color on the canvas, and produces a color palette based on those two colors.
    * H-Curve affects hue transitioning. A value of 2 favors the hue of the canvas color, while a value of 3 favors the foreground color.
    * SV-Curve pair affects the transitioning between both the saturation and value of the two colors. A value of 2 favors higher saturation whereas a value of 3 favors lower saturation.
    * S and V-Divergence. increases/decreases the saturation/value of the palette respectively.
    * Bounce Clamping. Causes colors past the saturation/value limits to 'bounce' backwards.
    * Debug Mode. Displays a graph next to the palette that shows the transition of Hue, Saturation, and Value between the two colors.
+ *pixel_brush.bs* a brush useful for pixel art
    * Big Pixels is enabled by default and is used to keep the pixels consistently sized at high resolutions. It is recommended to turn it off for lower resolutions.
    * Dynamic Size applies artificial pen pressure to the stroke. It is recommended to turn off Big Pixels for this setting.
+ *square_brush.bs* an artificial pen-pressure brush that draws a square stroke.
+ *colorwheel.bs* a utility that draws a simple color wheel.
    * Ring Size is used to plot the point at which the foreground color is located.
    * Vignette effect is used to darken colors further away from the center.
    * Curl effect is used to apply hue shifting to colors further away from the center.
