//@version=5
indicator("Golden and Death Crossover with Probability", shorttitle="G/D Crossover", overlay=true, max_bars_back=5000)

// Inputs
lengthLookBack = input.int(100, "Lookback Length for Probability", minval=1)
shortMA = ta.sma(close, 50)
longMA = ta.sma(close, 200)

// Calculating Crossovers
goldenCross = ta.crossover(shortMA, longMA)
deathCross = ta.crossunder(shortMA, longMA)

// Plotting Moving Averages
plot(shortMA, color=color.blue, title="Short-Term MA")
plot(longMA, color=color.red, title="Long-Term MA")

// Initialize a variable to keep track of the current state
var int currentState = 0 // 1 for Golden Cross, -1 for Death Cross, 0 for initial state

// Update the state based on the crossover events
if goldenCross
    currentState := 1
else if deathCross
    currentState := -1

// Apply continuous background color based on the current state
bgcolor(currentState == 1 ? color.new(color.green, 90) : currentState == -1 ? color.new(color.red, 90) : na, title="Crossover Background")

// Function to calculate success rate (simplified for demonstration)
calculateSuccessRate() =>
    successCount = 0.0
    totalCount = 0.0
    adjustedLookBack = bar_index > lengthLookBack ? lengthLookBack : bar_index - 1
    for i = 1 to adjustedLookBack
        if currentState == 1 and goldenCross[i]
            totalCount := totalCount + 1
            successCount := successCount + 1
        else if currentState == -1 and deathCross[i]
            totalCount := totalCount + 1
            successCount := successCount + 1
    successRate = totalCount != 0 ? (successCount / totalCount) * 100 : 0.0
    successRate

// Probabilities calculation (adjusted for the continuous background logic)
goldenCrossProb = currentState == 1 ? calculateSuccessRate() : na
deathCrossProb = currentState == -1 ? calculateSuccessRate() : na

// Display the probabilities on the last bar
if barstate.islast
    var label probLabel = na
    string labelText = currentState == 1 ? "Golden Cross Prob: " + str.tostring(goldenCrossProb, '#.##') + "%" :
                      currentState == -1 ? "Death Cross Prob: " + str.tostring(deathCrossProb, '#.##') + "%" : ""
    label.delete(probLabel)
    probLabel := label.new(x=bar_index, y=high, text=labelText, style=label.style_label_down, color=color.gray, textcolor=color.white, yloc=yloc.abovebar)
