// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © Carlos Humberto Rodríguez Arias

//@version=3
study(title="EMA Crossovers", overlay=true)

// EMA periods
MT_EMA = input(title="Medium term EMA", type=integer, defval=21)
LT_EMA = input(title="Long term EMA", type=integer, defval=55)

// EMA lines plot
Signal_MT_EMA = ema(close, MT_EMA)
Signal_LT_EMA = ema(close, LT_EMA)
plot(Signal_MT_EMA, "Medium term EMA", color = #e65100ff, linewidth=1)
plot(Signal_LT_EMA, "Long term EMA", color = #037cf8ff, linewidth=1)

// EMA trend
TrendingUp() => Signal_MT_EMA > Signal_LT_EMA 
TrendingDown() => Signal_MT_EMA < Signal_LT_EMA

// EMA trend signals
Uptrend() => TrendingUp()[1]
Downtrend() => TrendingDown()[1]
Down = Downtrend() 
Up = Uptrend() 
plotshape(Up, "Uptrend bar signal", color=#15c7844d, style=shape.triangleup, location=location.abovebar)
plotshape(Down, "Downtrend bar signal", color=#ea39434d, style=shape.triangledown, location=location.belowbar)

// EMA crossover siganls
Uppcrossover() => TrendingUp() and TrendingDown()[1]
Downcrossover() => TrendingDown() and TrendingUp()[1]
Downalert = Downcrossover()
Upalert = Uppcrossover()
plotshape(Upalert, "Uptrend start signal", text="Uptrend \n started", color=#15c784ff, textcolor=#15c784ff, style=shape.arrowup, size=size.large, location=location.abovebar)
plotshape(Downalert, "Downtrend start signal", text="Downtrend \n started", color=#ea3943ff, textcolor=#ea3943ff, style=shape.arrowdown, size=size.large, location=location.belowbar)

// Alerts
alertcondition(condition=crossover(Signal_MT_EMA, Signal_LT_EMA), title="Uptrend started", message="Medium term EMA crossed over long term EMA.")
alertcondition(condition=crossunder(Signal_MT_EMA, Signal_LT_EMA),title="Downtrend started", message="Medium term EMA crossed under long term EMA.")