#@version=5

# Define the strategy settings
strategy(shorttitle="MBB", title="Bollinger Bands", overlay=true)

# Define the input options
src = input(close, "Source")
length = input.int(34, "Length", minval=1)
mult = input.float(2.0, "Multiplier", minval=0.001, maxval=50)

# Calculate the basis, deviation, and upper and lower bands
basis = ta.sma(src, length)
dev = ta.stdev(src, length)
dev2 = mult * dev

upper1 = basis + dev
lower1 = basis - dev
upper2 = basis + dev2
lower2 = basis - dev2

# Define the plot colors and styles
colorBasis = src >= basis ? color.blue : color.orange
colorUpper = color.new(color.blue, 80)
colorLower = color.new(color.orange, 80)

# Plot the Bollinger Bands
pBasis = plot(basis, "Basis", linewidth=2, color=colorBasis)
pUpper1 = plot(upper1, "Upper1", color=colorUpper, style=plot.style_circles)
pUpper2 = plot(upper2, "Upper2", color=colorUpper)
pLower1 = plot(lower1, "Lower1", color=colorLower, style=plot.style_circles)
pLower2 = plot(lower2, "Lower2", color=colorLower)

# Fill the area between the bands
fill(pBasis, pUpper2, color=colorUpper)
fill(pUpper1, pUpper2, color=colorUpper)
fill(pBasis, pLower2, color=colorLower)
fill(pLower1, pLower2, color=colorLower)

# Define the buy and sell zones
buyZone = ta.crossover(src, lower2)
sellZone = ta.crossunder(src, upper2)

# Add plot shapes for entry signals
plotshape(buyZone, title="Long Entry", color=color.green, style=shape.triangleup, location=location.belowbar)
plotshape(sellZone, title="Short Entry", color=color.red, style=shape.triangledown, location=location.abovebar)

# Add background color to indicate buy and sell zones
bgcolor(buyZone ? color.new(color.green, 90) : na)
bgcolor(sellZone ? color.new(color.red, 90) : na)

# Add plot for source data
plot(src, title="Source", color=color.gray, linewidth=1)

# Define the strategy rules

# Buy when price crosses above the lower band
if (buyZone)
    strategy.entry("Long", strategy.long)

# Sell when price crosses below the upper band
if (sellZone)
    strategy.entry("Short", strategy.short)

# Exit long position when price crosses below the 1st lower band
if (ta.crossunder(src, lower1))
    strategy.close("Long")

# Exit short position when price crosses above the 1st upper band
if (ta.crossover(src, upper1))
    strategy.close("Short")
