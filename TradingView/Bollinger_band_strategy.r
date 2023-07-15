//@version=5
// Bollinger Bands: Madrid : 14/SEP/2014 11:07 : 2.0
// This displays the traditional Bollinger Bands, the difference is 
// that the 1st and 2nd StdDev are outlined with two colors and two
// different levels, one for each Standard Deviation

// Define the strategy settings
strategy(shorttitle="MBB", title="Bollinger Bands", overlay=true)

// Define the input options
src = input(close, "Source")
length = input.int(34, "Length", minval=1)
mult = input.float(2.0, "Multiplier", minval=0.001, maxval=50)

// Calculate the basis, deviation, and upper and lower bands
basis = ta.sma(src, length)
dev = ta.stdev(src, length)
dev2 = mult * dev

upper1 = basis + dev
lower1 = basis - dev
upper2 = basis + dev2
lower2 = basis - dev2

// Define the plot colors and styles
colorBasis = src >= basis ? color.blue : color.orange
colorUpper = color.new(color.blue, 80)
colorLower = color.new(color.orange, 80)
styleCircles = plot.style_circles

// Plot the Bollinger Bands and fill between the bands
pBasis = plot(basis, "Basis", linewidth=2, color=colorBasis)
pUpper1 = plot(upper1, "Upper1", color=colorUpper, style=styleCircles)
pUpper2 = plot(upper2, "Upper2", color=colorUpper)
pLower1 = plot(lower1, "Lower1", color=colorLower, style=styleCircles)
pLower2 = plot(lower2, "Lower2", color=colorLower)

fill(pBasis, pUpper2, color=colorUpper)
fill(pUpper1, pUpper2, color=colorUpper)
fill(pBasis, pLower2, color=colorLower)
fill(pLower1, pLower2, color=colorLower)

// Define the strategy rules
if(close > upper2)
    strategy.entry("Long", strategy.long)

if(close < lower2)
    strategy.entry("Short", strategy.short)

if(close <= lower2)
    strategy.close("Long")

if(close >= upper2)
    strategy.close("Short")
