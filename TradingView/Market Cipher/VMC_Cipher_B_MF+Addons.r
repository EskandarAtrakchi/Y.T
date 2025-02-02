//@version=5
indicator(title='Cipher B (MFI)', shorttitle='MCB (fixed)')
 
// PARAMETERS {
 
// WaveTrend
wtShow = input(true, title='Show WaveTrend')
wtBuyShow = input(true, title='Show Buy dots')
wtGoldShow = input(true, title='Show Gold dots')
wtSellShow = input(true, title='Show Sell dots')
wtDivShow = input(true, title='Show Div. dots')
vwapShow = input(true, title='Show Fast WT')
wtChannelLen = input(9, title='WT Channel Length')
wtAverageLen = input(12, title='WT Average Length')
wtMASource = input(hlc3, title='WT MA Source')
wtMALen = input(3, title='WT MA Length')
 
// WaveTrend Overbought & Oversold lines
obLevel = input(60, title='WT Overbought Level 1')
obLevel2 = input(53, title='WT Overbought Level 2')
obLevel3 = input(100, title='WT Overbought Level 3')
osLevel = input(-60, title='WT Oversold Level 1')
osLevel2 = input(-53, title='WT Oversold Level 2')
osLevel3 = input(-100, title='WT Oversold Level 3')
 
// Divergence WT
wtShowDiv = input(true, title='Show WT Regular Divergences')
wtShowHiddenDiv = input(false, title='Show WT Hidden Divergences')
showHiddenDiv_nl = input(true, title='Not apply OB/OS Limits on Hidden Divergences')
wtDivOBLevel = input(45, title='WT Bearish Divergence min')
wtDivOSLevel = input(-65, title='WT Bullish Divergence min')
 
// Divergence extra range
wtDivOBLevel_addshow = input(true, title='Show 2nd WT Regular Divergences')
wtDivOBLevel_add = input(15, title='WT 2nd Bearish Divergence')
wtDivOSLevel_add = input(-40, title='WT 2nd Bullish Divergence 15 min')
 
// Money flow
rsiMFIShow = input(true, title='Show MFI')
rsiMFIsrc = input(close, title='Money Flow Source')
rsiMFIperiod = input(60, title='MFI Period')
rsiMFIMultiplier = input.float(175, title='MFI Area multiplier')
rsiMFIPosY = input(2.5, title='MFI Area Y Pos')
 
// RSI
rsiShow = input(false, title='Show RSI')
rsiSRC = input(close, title='RSI Source')
rsiLen = input(14, title='RSI Length')
rsiOversold = input.int(30, title='RSI Oversold', minval=0, maxval=100)
rsiOverbought = input.int(60, title='RSI Overbought', minval=0, maxval=100)
 
// Divergence RSI
rsiShowDiv = input(false, title='Show RSI Regular Divergences')
rsiShowHiddenDiv = input(false, title='Show RSI Hidden Divergences')
rsiDivOBLevel = input(60, title='RSI Bearish Divergence min')
rsiDivOSLevel = input(30, title='RSI Bullish Divergence min')
 
// RSI Stochastic
stochShow = input(true, title='Show Stochastic RSI')
stochUseLog = input(true, title=' Use Log?')
stochAvg = input(false, title='Use Average of both K & D')
stochSRC = input(close, title='Stochastic RSI Source')
stochLen = input(14, title='Stochastic RSI Length')
stochRsiLen = input(14, title='RSI Length ')
stochKSmooth = input(3, title='Stochastic RSI K Smooth')
stochDSmooth = input(3, title='Stochastic RSI D Smooth')
 
// Divergence stoch
stochShowDiv = input(false, title='Show Stoch Regular Divergences')
stochShowHiddenDiv = input(false, title='Show Stoch Hidden Divergences')
 
// Schaff Trend Cycle
tcLine = input(false, title='Show Schaff TC line')
tcSRC = input(close, title='Schaff TC Source')
tclength = input(10, title='Schaff TC')
tcfastLength = input(23, title='Schaff TC Fast Lenght')
tcslowLength = input(50, title='Schaff TC Slow Length')
tcfactor = input(0.5, title='Schaff TC Factor')
 
// Sommi Flag
sommiFlagShow = input(false, title='Show Sommi flag')
sommiShowVwap = input(false, title='Show Sommi F. Wave')
sommiVwapTF = input('720', title='Sommi F. Wave timeframe')
sommiVwapBearLevel = input(0, title='F. Wave Bear Level (less than)')
sommiVwapBullLevel = input(0, title='F. Wave Bull Level (more than)')
soomiFlagWTBearLevel = input(0, title='WT Bear Level (more than)')
soomiFlagWTBullLevel = input(0, title='WT Bull Level (less than)')
soomiRSIMFIBearLevel = input(0, title='Money flow Bear Level (less than)')
soomiRSIMFIBullLevel = input(0, title='Money flow Bull Level (more than)')
 
// Sommi Diamond
sommiDiamondShow = input(false, title='Show Sommi diamond')
sommiHTCRes = input('60', title='HTF Candle Res. 1')
sommiHTCRes2 = input('240', title='HTF Candle Res. 2')
soomiDiamondWTBearLevel = input(0, title='WT Bear Level (More than)')
soomiDiamondWTBullLevel = input(0, title='WT Bull Level (Less than)')
 
// macd Colors
macdWTColorsShow = input(false, title='Show MACD Colors')
macdWTColorsTF = input('240', title='MACD Colors MACD TF')
 
darkMode = input(false, title='Dark mode')
 
 
// Colors
colorRed = #ff0000
colorPurple = #e600e6
colorGreen = #3fff00
colorOrange = #e2a400
colorYellow = #ffe500
colorWhite = #ffffff
colorPink = #ff00f0
colorBluelight = #31c0ff
 
colorWT1 = #90caf9
colorWT2 = #0d47a1
 
colorWT2_ = #131722
 
colormacdWT1a = #4caf58
colormacdWT1b = #af4c4c
colormacdWT1c = #7ee57e
colormacdWT1d = #ff3535
 
colormacdWT2a = #305630
colormacdWT2b = #310101
colormacdWT2c = #132213
colormacdWT2d = #770000
 
// } PARAMETERS
 
 
// FUNCTIONS {
 
// Divergences 
f_top_fractal(src) =>
    src[4] < src[2] and src[3] < src[2] and src[2] > src[1] and src[2] > src[0]
f_bot_fractal(src) =>
    src[4] > src[2] and src[3] > src[2] and src[2] < src[1] and src[2] < src[0]
f_fractalize(src) =>
    f_top_fractal(src) ? 1 : f_bot_fractal(src) ? -1 : 0
 
f_findDivs(src, topLimit, botLimit, useLimits) =>
    fractalTop = f_fractalize(src) > 0 and (useLimits ? src[2] >= topLimit : true) ? src[2] : na
    fractalBot = f_fractalize(src) < 0 and (useLimits ? src[2] <= botLimit : true) ? src[2] : na
    highPrev = ta.valuewhen(fractalTop, src[2], 0)[2]
    highPrice = ta.valuewhen(fractalTop, high[2], 0)[2]
    lowPrev = ta.valuewhen(fractalBot, src[2], 0)[2]
    lowPrice = ta.valuewhen(fractalBot, low[2], 0)[2]
    bearSignal = fractalTop and high[2] > highPrice and src[2] < highPrev
    bullSignal = fractalBot and low[2] < lowPrice and src[2] > lowPrev
    bearDivHidden = fractalTop and high[2] < highPrice and src[2] > highPrev
    bullDivHidden = fractalBot and low[2] > lowPrice and src[2] < lowPrev
    [fractalTop, fractalBot, lowPrev, bearSignal, bullSignal, bearDivHidden, bullDivHidden]
 
// Money flow
f_rsimfi(_period, _multiplier, _tf) =>
    request.security(ticker.heikinashi(syminfo.tickerid), _tf, ta.sma((close - open) / (high - low) * _multiplier, _period) - rsiMFIPosY)
 
// WaveTrend
f_wavetrend(src, chlen, avg, malen, tf) =>
    tfsrc = request.security(ticker.heikinashi(syminfo.tickerid), tf, src)
    esa = ta.ema(tfsrc, chlen)
    de = ta.ema(math.abs(tfsrc - esa), chlen)
    ci = (tfsrc - esa) / (0.015 * de)
    wt1 = request.security(ticker.heikinashi(syminfo.tickerid), tf, ta.ema(ci, avg))
    wt2 = request.security(ticker.heikinashi(syminfo.tickerid), tf, ta.sma(wt1, malen))
    wtVwap = wt1 - wt2
    wtOversold = wt2 <= osLevel
    wtOverbought = wt2 >= obLevel
    wtCross = ta.cross(wt1, wt2)
    wtCrossUp = wt2 - wt1 <= 0
    wtCrossDown = wt2 - wt1 >= 0
    wtCrosslast = ta.cross(wt1[2], wt2[2])
    wtCrossUplast = wt2[2] - wt1[2] <= 0
    wtCrossDownlast = wt2[2] - wt1[2] >= 0
    [wt1, wt2, wtOversold, wtOverbought, wtCross, wtCrossUp, wtCrossDown, wtCrosslast, wtCrossUplast, wtCrossDownlast, wtVwap]
 
// Schaff Trend Cycle
f_tc(src, length, fastLength, slowLength) =>
    ema1 = ta.ema(src, fastLength)
    ema2 = ta.ema(src, slowLength)
    macdVal = ema1 - ema2
    alpha = ta.lowest(macdVal, length)
    beta = ta.highest(macdVal, length) - alpha
    gamma = (macdVal - alpha) / beta * 100
    gamma := beta > 0 ? gamma : nz(gamma[1])
    delta = gamma
    delta := na(delta[1]) ? delta : delta[1] + tcfactor * (gamma - delta[1])
    epsilon = ta.lowest(delta, length)
    zeta = ta.highest(delta, length) - epsilon
    eta = (delta - epsilon) / zeta * 100
    eta := zeta > 0 ? eta : nz(eta[1])
    stcReturn = eta
    stcReturn := na(stcReturn[1]) ? stcReturn : stcReturn[1] + tcfactor * (eta - stcReturn[1])
    stcReturn
 
// Stochastic RSI
f_stochrsi(_src, _stochlen, _rsilen, _smoothk, _smoothd, _log, _avg) =>
    src = _log ? math.log(_src) : _src
    rsi = ta.rsi(src, _rsilen)
    kk = ta.sma(ta.stoch(rsi, rsi, rsi, _stochlen), _smoothk)
    d1 = ta.sma(kk, _smoothd)
    avg_1 = math.avg(kk, d1)
    k = _avg ? avg_1 : kk
    [k, d1]
 
// MACD
f_macd(src, fastlen, slowlen, sigsmooth, tf) =>
    fast_ma = request.security(syminfo.tickerid, tf, ta.ema(src, fastlen))
    slow_ma = request.security(syminfo.tickerid, tf, ta.ema(src, slowlen))
    macd = fast_ma - slow_ma
    signal = request.security(syminfo.tickerid, tf, ta.sma(macd, sigsmooth))
    hist = macd - signal
    [macd, signal, hist]
 
// MACD Colors on WT    
f_macdWTColors(tf) =>
    hrsimfi = f_rsimfi(rsiMFIperiod, rsiMFIMultiplier, tf)
    [macd, signal, hist] = f_macd(close, 28, 42, 9, macdWTColorsTF)
    macdup = macd >= signal
    macddown = macd <= signal
    macdWT1Color = macdup ? hrsimfi > 0 ? colormacdWT1c : colormacdWT1a : macddown ? hrsimfi < 0 ? colormacdWT1d : colormacdWT1b : na
    macdWT2Color = macdup ? hrsimfi < 0 ? colormacdWT2c : colormacdWT2a : macddown ? hrsimfi < 0 ? colormacdWT2d : colormacdWT2b : na
    [macdWT1Color, macdWT2Color]
 
// Get higher timeframe candle
f_getTFCandle(_tf) =>
    _open = request.security(ticker.heikinashi(syminfo.tickerid), _tf, open, barmerge.gaps_off, barmerge.lookahead_on)
    _close = request.security(ticker.heikinashi(syminfo.tickerid), _tf, close, barmerge.gaps_off, barmerge.lookahead_on)
    _high = request.security(ticker.heikinashi(syminfo.tickerid), _tf, high, barmerge.gaps_off, barmerge.lookahead_on)
    _low = request.security(ticker.heikinashi(syminfo.tickerid), _tf, low, barmerge.gaps_off, barmerge.lookahead_on)
    hl2 = (_high + _low) / 2.0
    newBar = ta.change(_open)
    candleBodyDir = _close > _open
    [candleBodyDir, newBar]
 
// Sommi flag
f_findSommiFlag(tf, wt1, wt2, rsimfi, wtCross, wtCrossUp, wtCrossDown) =>
    [hwt1, hwt2, hwtOversold, hwtOverbought, hwtCross, hwtCrossUp, hwtCrossDown, hwtCrosslast, hwtCrossUplast, hwtCrossDownlast, hwtVwap] = f_wavetrend(wtMASource, wtChannelLen, wtAverageLen, wtMALen, tf)
 
    bearPattern = rsimfi < soomiRSIMFIBearLevel and wt2 > soomiFlagWTBearLevel and wtCross and wtCrossDown and hwtVwap < sommiVwapBearLevel
 
    bullPattern = rsimfi > soomiRSIMFIBullLevel and wt2 < soomiFlagWTBullLevel and wtCross and wtCrossUp and hwtVwap > sommiVwapBullLevel
 
    [bearPattern, bullPattern, hwtVwap]
 
f_findSommiDiamond(tf, tf2, wt1, wt2, wtCross, wtCrossUp, wtCrossDown) =>
    [candleBodyDir, newBar] = f_getTFCandle(tf)
    [candleBodyDir2, newBar2] = f_getTFCandle(tf2)
    bearPattern = wt2 >= soomiDiamondWTBearLevel and wtCross and wtCrossDown and not candleBodyDir and not candleBodyDir2
    bullPattern = wt2 <= soomiDiamondWTBullLevel and wtCross and wtCrossUp and candleBodyDir and candleBodyDir2
    [bearPattern, bullPattern]
 
// } FUNCTIONS  
 
// CALCULATE INDICATORS {
 
// RSI
rsi = ta.rsi(rsiSRC, rsiLen)
rsiColor = rsi <= rsiOversold ? colorGreen : rsi >= rsiOverbought ? colorRed : colorPurple
 
// Money flow
rsiMFI = f_rsimfi(rsiMFIperiod, rsiMFIMultiplier, timeframe.period)
rsiMFIColor = rsiMFI > 0 ? #3ee145 : #ff3d2e
 
// Calculates WaveTrend
[wt1, wt2, wtOversold, wtOverbought, wtCross, wtCrossUp, wtCrossDown, wtCross_last, wtCrossUp_last, wtCrossDown_last, wtVwap] = f_wavetrend(wtMASource, wtChannelLen, wtAverageLen, wtMALen, timeframe.period)
 
// Stochastic RSI
[stochK, stochD] = f_stochrsi(stochSRC, stochLen, stochRsiLen, stochKSmooth, stochDSmooth, stochUseLog, stochAvg)
 
// Schaff Trend Cycle
tcVal = f_tc(tcSRC, tclength, tcfastLength, tcslowLength)
 
// Sommi flag
[sommiBearish, sommiBullish, hvwap] = f_findSommiFlag(sommiVwapTF, wt1, wt2, rsiMFI, wtCross, wtCrossUp, wtCrossDown)
 
//Sommi diamond
[sommiBearishDiamond, sommiBullishDiamond] = f_findSommiDiamond(sommiHTCRes, sommiHTCRes2, wt1, wt2, wtCross, wtCrossUp, wtCrossDown)
 
// macd colors
[macdWT1Color, macdWT2Color] = f_macdWTColors(macdWTColorsTF)
 
// WT Divergences
[wtFractalTop, wtFractalBot, wtLow_prev, wtBearDiv, wtBullDiv, wtBearDivHidden, wtBullDivHidden] = f_findDivs(wt2, wtDivOBLevel, wtDivOSLevel, true)
 
[wtFractalTop_add, wtFractalBot_add, wtLow_prev_add, wtBearDiv_add, wtBullDiv_add, wtBearDivHidden_add, wtBullDivHidden_add] = f_findDivs(wt2, wtDivOBLevel_add, wtDivOSLevel_add, true)
[wtFractalTop_nl, wtFractalBot_nl, wtLow_prev_nl, wtBearDiv_nl, wtBullDiv_nl, wtBearDivHidden_nl, wtBullDivHidden_nl] = f_findDivs(wt2, 0, 0, false)
 
wtBearDivHidden_ = showHiddenDiv_nl ? wtBearDivHidden_nl : wtBearDivHidden
wtBullDivHidden_ = showHiddenDiv_nl ? wtBullDivHidden_nl : wtBullDivHidden
 
wtBearDivColor = wtShowDiv and wtBearDiv or wtShowHiddenDiv and wtBearDivHidden_ ? colorRed : na
wtBullDivColor = wtShowDiv and wtBullDiv or wtShowHiddenDiv and wtBullDivHidden_ ? colorGreen : na
 
wtBearDivColor_add = wtShowDiv and wtDivOBLevel_addshow and wtBearDiv_add or wtShowHiddenDiv and wtDivOBLevel_addshow and wtBearDivHidden_add ? #9a0202 : na
wtBullDivColor_add = wtShowDiv and wtDivOBLevel_addshow and wtBullDiv_add or wtShowHiddenDiv and wtDivOBLevel_addshow and wtBullDivHidden_add ? #1b5e20 : na
 
// RSI Divergences
[rsiFractalTop, rsiFractalBot, rsiLow_prev, rsiBearDiv, rsiBullDiv, rsiBearDivHidden, rsiBullDivHidden] = f_findDivs(rsi, rsiDivOBLevel, rsiDivOSLevel, true)
[rsiFractalTop_nl, rsiFractalBot_nl, rsiLow_prev_nl, rsiBearDiv_nl, rsiBullDiv_nl, rsiBearDivHidden_nl, rsiBullDivHidden_nl] = f_findDivs(rsi, 0, 0, false)
 
rsiBearDivHidden_ = showHiddenDiv_nl ? rsiBearDivHidden_nl : rsiBearDivHidden
rsiBullDivHidden_ = showHiddenDiv_nl ? rsiBullDivHidden_nl : rsiBullDivHidden
 
rsiBearDivColor = rsiShowDiv and rsiBearDiv or rsiShowHiddenDiv and rsiBearDivHidden_ ? colorRed : na
rsiBullDivColor = rsiShowDiv and rsiBullDiv or rsiShowHiddenDiv and rsiBullDivHidden_ ? colorGreen : na
 
// Stoch Divergences
[stochFractalTop, stochFractalBot, stochLow_prev, stochBearDiv, stochBullDiv, stochBearDivHidden, stochBullDivHidden] = f_findDivs(stochK, 0, 0, false)
 
stochBearDivColor = stochShowDiv and stochBearDiv or stochShowHiddenDiv and stochBearDivHidden ? colorRed : na
stochBullDivColor = stochShowDiv and stochBullDiv or stochShowHiddenDiv and stochBullDivHidden ? colorGreen : na
 
 
// Small Circles WT Cross
signalColor = wt2 - wt1 > 0 ? color.red : color.lime
 
// Buy signal.
buySignal = wtCross and wtCrossUp and wtOversold
 
buySignalDiv = wtCross and wtCrossUp and wtOversold
 
 
buySignalDiv_color = wtShowDiv and wtBullDiv and rsiShowDiv and rsiBullDiv ? colorGreen : wtBullDiv_add ? color.new(colorGreen, 60) : rsiShowDiv ? colorGreen : na
 
// Sell signal
sellSignal = wtCross and wtCrossDown and wtOverbought
 
sellSignalDiv = wtShowDiv and wtBearDiv and rsiOverbought
 
sellSignalDiv_color = wtBearDiv ? colorRed : wtBearDiv_add ? color.new(colorRed, 60) : rsiBearDiv ? colorRed : na
 
// Gold Buy 
wtGoldBuy = wtShowDiv and wtBullDiv and rsiOversold
 
 
// } CALCULATE INDICATORS
 
 
// DRAW {
bgcolor(darkMode ? color.new(#000000, 80) : na, transp=90)
zLine = plot(0, color=color.new(colorWhite, 50))
 
// MFI BAR
//rsiMfiBarTopLine = plot (rsiMFIShow ? -95 : na, title='MFI Bar TOP Line', color=rsiMFIColor, transp=100)
//rsiMfiBarBottomLine = plot(rsiMFIShow ? -105 : na, title='MFI Bar BOTTOM Line', color=rsiMFIColor, transp=100)
//fill(rsiMfiBarTopLine, rsiMfiBarBottomLine, title='MFI Bar Colors', color=rsiMFIColor, transp=75)
 
// WT Div
 
 
 
// WT 2nd Div
 
 
// RSI
plot(rsiShow ? rsi : na, title='RSI', color=rsiColor, linewidth=2, transp=25)
 
// RSI Div
 
// Stochastic RSI
// stochKplot = plot(stochShow ? stochK : na, title='Stoch K', color=color.new(#21baf3, 0), linewidth=2)
// stochDplot = plot(stochShow ? stochD : na, title='Stoch D', color=color.new(#673ab7, 60), linewidth=1)
// stochFillColor = stochK >= stochD ? color.new(#21baf3, 75) : color.new(#673ab7, 60)
// fill(stochKplot, stochDplot, title='KD Fill', color=stochFillColor, transp=90)
 
// Stoch Div
// WT Areas
plot(wtShow ? wt1 : na, style=plot.style_area, title='WT Wave 1', color=macdWTColorsShow ? macdWT1Color : colorWT1, transp=0)
plot(wtShow ? wt2 : na, style=plot.style_area, title='WT Wave 2', color=macdWTColorsShow ? macdWT2Color : darkMode ? colorWT2_ : colorWT2, transp=20)
// VWAP
plot(vwapShow ? wtVwap : na, title='VWAP', color=color.new(colorYellow, 45), style=plot.style_area, linewidth=2)
plot(vwapShow ? wtVwap : na, title='VWAP', color=color.new(colorBluelight, 45), style=plot.style_line, linewidth=2)
// MFI AREA
//rsiMFIplot = plot(rsiMFIShow ? rsiMFI : na, title='Money flow Area', color=rsiMFIColor, transp=2)
//rsiplot = plot(rsiMFIShow ? rsiMFI : na, title='Money flow outline', color=rsiMFIColor, transp=2)
//fill(rsiMFIplot, zLine, rsiMFIColor, transp=2)
// Sommi flag
// plotchar(sommiFlagShow and sommiBearish ? 108 : na, title='Sommi bearish flag', char='⚑', color=color.new(colorPink, 0), location=location.absolute, size=size.tiny)
// plotchar(sommiFlagShow and sommiBullish ? -108 : na, title='Sommi bullish flag', char='⚑', color=color.new(colorBluelight, 0), location=location.absolute, size=size.tiny)
plot(sommiShowVwap ? ta.ema(hvwap, 3) : na, title='Sommi higher VWAP', color=color.new(colorYellow, 15), linewidth=2, style=plot.style_line)
// Draw Overbought & Oversold lines
plot(obLevel, title='Over Bought Level 1', color=color.new(colorWhite, 35), linewidth=1, style=plot.style_stepline)
plot(obLevel2, title='Over Bought Level 2', color=color.new(colorWhite, 35), linewidth=1, style=plot.style_stepline)
plot(obLevel3, title='Over Bought Level 3', color=color.new(colorWhite, 35), linewidth=2, style=plot.style_circles)
plot(osLevel, title='Over Sold Level 1', color=color.new(colorWhite, 35), linewidth=1, style=plot.style_cross)
plot(osLevel2, title='Over Sold Level 2', color=color.new(colorWhite, 35), linewidth=1, style=plot.style_stepline)
// Sommi diamond
 
 
// Circles
plot(wtCross ? wt2 : na, title='Buy and sell circle', color=signalColor, style=plot.style_circles, linewidth=3, transp=15)
plot(wtCross ? wt2 : na, title='Buy and sell circle outline', color=signalColor, style=plot.style_circles, linewidth=3, transp=15)
 
plotchar(wtBuyShow and buySignal ? -107 : na, title='Buy circle', char='•', color=color.new(colorGreen, 50), location=location.absolute, size=size.small)
plotchar(wtSellShow and sellSignal ? 105 : na, title='Sell circle', char='•', color=color.new(colorRed, 50), location=location.absolute, size=size.small)
 
plotchar(wtDivShow and buySignalDiv ? -106 : na, title='Divergence buy circle', char='•', color=buySignalDiv_color, location=location.absolute, size=size.small, offset=-2, transp=15)
plotchar(wtDivShow and sellSignalDiv ? 118 : na, title='Divergence sell circle', char='•', color=sellSignalDiv_color, location=location.absolute, size=size.small, offset=-2, transp=15)
 
plotchar(wtGoldBuy and wtGoldShow ? -107 : na, title='Gold  buy gold circle', char='•', color=color.new(colorOrange, 15), location=location.absolute, size=size.small, offset=-2)
 
// } DRAW
 
 
// ALERTS {
 
// BUY
alertcondition(buySignal, 'Buy (Big green circle)', 'Green circle WaveTrend Oversold')
alertcondition(buySignalDiv, 'Buy (Big green circle + Div)', 'Buy & WT Bullish Divergence & WT Overbought')
alertcondition(wtGoldBuy, 'GOLD Buy (Big GOLDEN circle)', 'Green & GOLD circle WaveTrend Overbought')
alertcondition(sommiBullish or sommiBullishDiamond, 'Sommi bullish flag/diamond', 'Blue flag/diamond')
alertcondition(wtCross and wtCrossUp, 'Buy (Small green dot)', 'Buy small circle')
 
// SELL
alertcondition(sommiBearish or sommiBearishDiamond, 'Sommi bearish flag/diamond', 'Purple flag/diamond')
alertcondition(sellSignal, 'Sell (Big red circle)', 'Red Circle WaveTrend Overbought')
alertcondition(sellSignalDiv, 'Sell (Big red circle + Div)', 'Buy & WT Bearish Divergence & WT Overbought')
alertcondition(wtCross and wtCrossDown, 'Sell (Small red dot)', 'Sell small circle')
 
// } ALERTS
 
// Pseudo Double RSI's - From Original Market Cipher
 
DoubleRSI_K_Fast = request.security(ticker.heikinashi(syminfo.tickerid), timeframe.period, ta.sma(ta.stoch(close, high, low, 40), 2))
DoubleRSI_K_Slow = request.security(ticker.heikinashi(syminfo.tickerid), timeframe.period, ta.sma(ta.stoch(close, high, low, 81), 2))
DoubleRSICrossOver = DoubleRSI_K_Slow < DoubleRSI_K_Fast ? 1 : 0
 
//
lengthrsi = input(13, title='TDI Length')
lengthrsipl = input(2, title='RSI Price Line')
rsiOSL = input.int(22, minval=0, maxval=49, title='RSI Oversold Level')
rsiOBL = input.int(78, minval=51, maxval=100, title='RSI Overbought Level')
r = ta.rsi(close, lengthrsi)
mab = ta.sma(r, lengthrsipl)
 
lengthband = input(34, title="Volatility Band Length")
ma = ta.sma(r, lengthband)
offs = 1.6185 * ta.stdev(r, lengthband)
upZone = ma + offs
dnZone = ma - offs
mid = (upZone + dnZone) / 2
upl = plot(upZone, color=color.blue, title='High Band', linewidth=1)
dnl = plot(dnZone, color=color.white, title='Low band', linewidth=1)
midl = plot(mid, color=color.orange, linewidth=1, title='Middle Bolinger Band')
fill(upl, dnl, title='Low band High band Fill', color=color.orange)
mabl = plot(mab, title='TDI', color=mab > 68 ? color.purple : mab < 32 ? color.red : color.yellow)
 
//MoneyFlow
OC(tf)=>
    request.security(ticker.heikinashi(syminfo.tickerid),timeframe.period,(close-open))
HL(tf)=>
    request.security(ticker.heikinashi(syminfo.tickerid),timeframe.period,(high-low))
m= request.security(ticker.heikinashi(syminfo.tickerid),timeframe.period,ta.sma(hlc3,5))
f= request.security(ticker.heikinashi(syminfo.tickerid),timeframe.period,ta.sma(math.abs(hlc3-m),5))
i= request.security(ticker.heikinashi(syminfo.tickerid),timeframe.period,(hlc3-m)/(0.015*f))
mf=request.security(ticker.heikinashi(syminfo.tickerid),timeframe.period,ta.sma(i,60))
//><
p=plot(-95,color=color.new(#000000,100))
p2=plot(-105,color=color.new(#000000,100))
fill(p,p2,color=mf>0 ? color.new(#ffffff,40):color.new(#00def6,40))
plot(mf,'Money Flow MCB',mf>0?color.new(#00ff0a,50):color.new(#ff0015,50),style=plot.style_area,linewidth=1)
plot(mf,'Money Flow Outline',mf>0?color.new(#00ff0a,50):color.new(#ff0015,50),style=plot.style_area,linewidth=1)
stochKplot = plot(stochShow ? DoubleRSI_K_Fast : na, title='Rsi', color=color.new(#21baf3, 0), linewidth=2)
stochDplot = plot(stochShow ? DoubleRSI_K_Slow : na, title='***', color=DoubleRSI_K_Slow > 70 ? color.new(#673ab7, 60) : DoubleRSI_K_Slow < 30 ? color.red : color.yellow, linewidth=1)
Color = DoubleRSI_K_Slow < DoubleRSI_K_Fast ? color.green : color.red
plot(stochShow ? DoubleRSI_K_Slow : na, title='Stoch', color=Color , linewidth=1)