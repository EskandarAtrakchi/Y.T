//@version=5
 
//  CONTRIBUTIONS:
//    - Tip/Idea: Add higher timeframe analysis for bearish/bullish patterns at the current timeframe.
//    + Bearish/Bullish FLAG:
//      - MFI+RSI Area are RED (Below 0).
//      - Wavetrend waves are above 0 and crosses down.
//      - VWAP Area are below 0 on higher timeframe.
//      - This pattern reversed becomes bullish.
//    - Tip/Idea: Check the last heikinashi candle from 2 higher timeframe
//    + Bearish/Bullish DIAMOND:
//      - HT Candle is red
//      - WT > 0 and crossed down
 
indicator(title='Market cipher B', shorttitle='MCB')
 
// PARAMETERS {
 
// WaveTrend
wtShow = input.bool(true, title='Show WaveTrend', group='WaveTrend Settings')
wtBuyShow = input.bool(true, title='Show Buy dots', group='WaveTrend Settings')
wtGoldShow = input.bool(true, title='Show Gold dots', group='WaveTrend Settings')
wtSellShow = input.bool(true, title='Show Sell dots', group='WaveTrend Settings')
wtDivShow = input.bool(true, title='Show Div. dots', group='WaveTrend Settings')
vwapShow = input.bool(true, title='Show Fast WT', group='WaveTrend Settings')
wtChannelLen = input.int(9, title='WT Channel Length', group='WaveTrend Settings')
wtAverageLen = input.int(12, title='WT Average Length', group='WaveTrend Settings')
wtMASource = input.source(ohlc4, title='WT MA Source', group='WaveTrend Settings')
wtMALen = input.int(3, title='WT MA Length', group='WaveTrend Settings')
 
// WaveTrend Overbought & Oversold lines
obLevel = input.int(64, title='WT Overbought Level 1', group='WaveTrend Settings')
obLevel2 = input.int(75, title='WT Overbought Level 2', group='WaveTrend Settings')
obLevel3 = input.int(103, title='WT Overbought Level 3', group='WaveTrend Settings')
osLevel = input.int(-57, title='WT Oversold Level 1', group='WaveTrend Settings')
osLevel2 = input.int(-65, title='WT Oversold Level 2', group='WaveTrend Settings')
osLevel3 = input.int(-75, title='WT Oversold Level 3', group='WaveTrend Settings')
 
// Divergence WT
wtShowDiv = input.bool(true, title='Show WT Regular Divergences', group='WaveTrend Settings')
wtShowHiddenDiv = input.bool(false, title='Show WT Hidden Divergences', group='WaveTrend Settings')
showHiddenDiv_nl = input.bool(true, title='Not apply OB/OS Limits on Hidden Divergences', group='WaveTrend Settings')
wtDivOBLevel = input.int(45, title='WT Bearish Divergence min', group='WaveTrend Settings')
wtDivOSLevel = input.int(-69, title='WT Bullish Divergence min', group='WaveTrend Settings')
 
// Divergence extra range
wtDivOBLevel_addshow = input.bool(true, title='Show 2nd WT Regular Divergences', group='WaveTrend Settings')
wtDivOBLevel_add = input.int(15, title='WT 2nd Bearish Divergence', group='WaveTrend Settings')
wtDivOSLevel_add = input.int(-40, title='WT 2nd Bullish Divergence 15 min', group='WaveTrend Settings')
 
// RSI+MFI
rsiMFIShow = input.bool(true, title='Show MFI', group='MFI Settings')
rsiMFIperiod = input.int(65, title='MFI Period', group='MFI Settings')
rsiMFIMultiplier = input.float(280, title='MFI Area multiplier', group='MFI Settings')
rsiMFIPosY = input.float(1, title='MFI Area Y Pos', group='MFI Settings')
OC(tf)=>
    request.security(ticker.heikinashi(syminfo.tickerid), tf, (close-open))
 
HL(tf)=>
    request.security(ticker.heikinashi(syminfo.tickerid), tf, (high-low))
 
m = ta.sma(ohlc4, 5)
f = ta.sma(math.abs(ohlc4 - m), 5)
i = (ohlc4 - m) / (0.015 * f)
mf = ta.sma(i, 60)
 
// RSI
rsiShow = input.bool(true, title='Show RSI', group='RSI Settings')
rsiSRC = input.source(close, title='RSI Source', group='RSI Settings')
rsiLen = input.int(14, title='RSI Length', group='RSI Settings')
rsiOversold = input.int(28, title='RSI Oversold', minval=0, maxval=100, group='RSI Settings')
rsiOverbought = input.int(74, title='RSI Overbought', minval=0, maxval=100, group='RSI Settings')
 
// Divergence RSI
rsiShowDiv = input.bool(false, title='Show RSI Regular Divergences', group='RSI Settings')
rsiShowHiddenDiv = input.bool(false, title='Show RSI Hidden Divergences', group='RSI Settings')
rsiDivOBLevel = input.int(74, title='RSI Bearish Divergence min', group='RSI Settings')
rsiDivOSLevel = input.int(28, title='RSI Bullish Divergence min', group='RSI Settings')
 
// RSI Stochastic
stochShow = input.bool(true, title='Show Stochastic RSI', group='Stoch Settings')
stochUseLog = input.bool(true, title=' Use Log?', group='Stoch Settings')
stochAvg = input.bool(false, title='Use Average of both K & D', group='Stoch Settings')
stochSRC = input.source(close, title='Stochastic RSI Source', group='Stoch Settings')
stochLen = input.int(14, title='Stochastic RSI Length', group='Stoch Settings')
stochRsiLen = input.int(14, title='RSI Length ', group='Stoch Settings')
stochKSmooth = input.int(3, title='Stochastic RSI K Smooth', group='Stoch Settings')
stochDSmooth = input.int(3, title='Stochastic RSI D Smooth', group='Stoch Settings')
 
// Divergence stoch
stochShowDiv = input.bool(false, title='Show Stoch Regular Divergences', group='Stoch Settings')
stochShowHiddenDiv = input.bool(false, title='Show Stoch Hidden Divergences', group='Stoch Settings')
 
// Schaff Trend Cycle
tcLine = input.bool(false, title='Show Schaff TC line', group='Schaff Settings')
tcSRC = input.source(close, title='Schaff TC Source', group='Schaff Settings')
tclength = input.int(10, title='Schaff TC', group='Schaff Settings')
tcfastLength = input.int(23, title='Schaff TC Fast Lenght', group='Schaff Settings')
tcslowLength = input.int(50, title='Schaff TC Slow Length', group='Schaff Settings')
tcfactor = input.float(0.5, title='Schaff TC Factor', group='Schaff Settings')
 
// Sommi Flag
sommiFlagShow = input.bool(false, title='Show Sommi flag', group='Sommi Settings')
sommiShowVwap = input.bool(false, title='Show Sommi F. Wave', group='Sommi Settings')
sommiVwapTF = input.string('720', title='Sommi F. Wave timeframe', group='Sommi Settings')
sommiVwapBearLevel = input.int(0, title='F. Wave Bear Level (less than)', group='Sommi Settings')
sommiVwapBullLevel = input.int(0, title='F. Wave Bull Level (more than)', group='Sommi Settings')
soomiFlagWTBearLevel = input.int(0, title='WT Bear Level (more than)', group='Sommi Settings')
soomiFlagWTBullLevel = input.int(0, title='WT Bull Level (less than)', group='Sommi Settings')
soomiRSIMFIBearLevel = input.int(0, title='Money flow Bear Level (less than)', group='Sommi Settings')
soomiRSIMFIBullLevel = input.int(0, title='Money flow Bull Level (more than)', group='Sommi Settings')
 
// Sommi Diamond
sommiDiamondShow = input.bool(false, title='Show Sommi diamond', group='Sommi Settings')
sommiHTCRes = input.string('60', title='HTF Candle Res. 1', group='Sommi Settings')
sommiHTCRes2 = input.string('240', title='HTF Candle Res. 2', group='Sommi Settings')
soomiDiamondWTBearLevel = input.int(0, title='WT Bear Level (More than)', group='Sommi Settings')
soomiDiamondWTBullLevel = input.int(0, title='WT Bull Level (Less than)', group='Sommi Settings')
 
// macd Colors
macdWTColorsShow = input.bool(false, title='Show MACD Colors', group='MACD Settings')
macdWTColorsTF = input.string('240', title='MACD Colors MACD TF', group='MACD Settings')
 
darkMode = input.bool(false, title='Dark mode', group='Mode Settings')
 
 
// Colors
colorRed = #ff0000
colorPurple = #e600e6
colorGreen = #3fff00
colorOrange = #e2a400
colorYellow = #ffe500
colorWhite = #ffffff
colorPink = #ff00f0
colorBluelight = #31c0ff
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
f_fractalize(src) =>
     src[4] < src[2] and src[3] < src[2] and src[2] > src[1] and src[2] > src[0] ? 1 : src[4] > src[2] and src[3] > src[2] and src[2] < src[1] and src[2] < src[0] ? -1 : 0
 
f_findDivs(src, topLimit, botLimit, useLimits) =>
    fractalTop = f_fractalize(src) > 0 and (useLimits ? src[2] >= topLimit : true) ? src[2] : na
    fractalBot = f_fractalize(src) < 0 and (useLimits ? src[2] <= botLimit : true) ? src[2] : na
    highPrev = ta.valuewhen(not(na(fractalTop)), src[2], 0)[2]
    highPrice = ta.valuewhen(not(na(fractalTop)), high[2], 0)[2]
    lowPrev = ta.valuewhen(not(na(fractalBot)), src[2], 0)[2]
    lowPrice = ta.valuewhen(not(na(fractalBot)), low[2], 0)[2]
    bearSignal = not(na(fractalTop)) and (high[2] > highPrice) and (src[2] < highPrev)
    bullSignal = not(na(fractalBot)) and (low[2] < lowPrice) and (src[2] > lowPrev)
    bearDivHidden = not(na(fractalTop)) and (high[2] < highPrice) and (src[2] > highPrev)
    bullDivHidden = not(na(fractalBot)) and (low[2] > lowPrice) and (src[2] < lowPrev)
    [fractalTop, fractalBot, lowPrev, bearSignal, bullSignal, bearDivHidden, bullDivHidden]
 
// RSI+MFI CALC
f_rsimfi(_period, _multiplier, _tf) =>
    request.security(syminfo.tickerid, _tf, ta.sma((close - open) / (high - low) * _multiplier, _period) - rsiMFIPosY)
 
// WaveTrend
f_wavetrend(src, chlen, avg, malen, tf) =>
    tfsrc = request.security(syminfo.tickerid, tf, src)
    esa = ta.ema(tfsrc, chlen)
    de = ta.ema(math.abs(tfsrc - esa), chlen)
    ci = (tfsrc - esa) / (0.015 * de)
    wt1 = request.security(syminfo.tickerid, tf, ta.ema(ci, avg))
    wt2 = request.security(syminfo.tickerid, tf, ta.sma(wt1, malen))
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
rsiobcolor = input.color(color.new(#e13e3e, 0), 'RSI OverBought', group='Color Settings')
rsioscolor = input.color(color.new(#3ee145, 0), 'RSI OverSold', group='Color Settings')
rsinacolor = input.color(color.new(#c33ee1, 0), 'RSI InBetween', group='Color Settings')
rsiColor = rsi <= rsiOversold ? rsioscolor : rsi >= rsiOverbought ? rsiobcolor : rsinacolor
 
// RSI + MFI Area
rsiMFI = mf
rsiMFIColorAbove = input.color(color.new(#3ee145, 0), 'MFI Color > 0', group='Color Settings')
rsiMFIColorBelow = input.color(color.new(#ff3d2e, 0), 'MFI Color < 0', group='Color Settings')
rsiMFIColor = rsiMFI > 0 ? rsiMFIColorAbove : rsiMFIColorBelow
 
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
 
WTBearDivColorDown = input.color(color.new(#e60000, 0), 'WT Bear Div', group='Color Settings')
wtBullDivColorUp = input.color(color.new(#00e676, 0), 'WT Bull Div', group='Color Settings')
 
wtBearDivColor = wtShowDiv and wtBearDiv or wtShowHiddenDiv and wtBearDivHidden_ ? WTBearDivColorDown : na
wtBullDivColor = wtShowDiv and wtBullDiv or wtShowHiddenDiv and wtBullDivHidden_ ? wtBullDivColorUp : na
 
wtBearDivColor_add = wtShowDiv and wtDivOBLevel_addshow and wtBearDiv_add or wtShowHiddenDiv and wtDivOBLevel_addshow and wtBearDivHidden_add ? WTBearDivColorDown : na
wtBullDivColor_add = wtShowDiv and wtDivOBLevel_addshow and wtBullDiv_add or wtShowHiddenDiv and wtDivOBLevel_addshow and wtBullDivHidden_add ? wtBullDivColorUp : na
 
// RSI Divergences
[rsiFractalTop, rsiFractalBot, rsiLow_prev, rsiBearDiv, rsiBullDiv, rsiBearDivHidden, rsiBullDivHidden] = f_findDivs(rsi, rsiDivOBLevel, rsiDivOSLevel, true)
[rsiFractalTop_nl, rsiFractalBot_nl, rsiLow_prev_nl, rsiBearDiv_nl, rsiBullDiv_nl, rsiBearDivHidden_nl, rsiBullDivHidden_nl] = f_findDivs(rsi, 0, 0, false)
 
rsiBearDivHidden_ = showHiddenDiv_nl ? rsiBearDivHidden_nl : rsiBearDivHidden
rsiBullDivHidden_ = showHiddenDiv_nl ? rsiBullDivHidden_nl : rsiBullDivHidden
 
rsiBearColor = color.new(#e60000, 0)  //input(color.new(#e60000, 0), 'RSI Bear Div', group = 'Color Settings')
rsiBullColor = color.new(#38ff42, 0)  //input(color.new(#38ff42, 0), 'RSI Bull Div', group = 'Color Settings')
 
rsiBearDivColor = rsiShowDiv and rsiBearDiv or rsiShowHiddenDiv and rsiBearDivHidden_ ? rsiBearColor : na
rsiBullDivColor = rsiShowDiv and rsiBullDiv or rsiShowHiddenDiv and rsiBullDivHidden_ ? rsiBullColor : na
 
// Stoch Divergences
[stochFractalTop, stochFractalBot, stochLow_prev, stochBearDiv, stochBullDiv, stochBearDivHidden, stochBullDivHidden] = f_findDivs(stochK, 0, 0, false)
 
stochbearcolor = color.new(#e60000, 0)  //input(color.new(#e60000, 0), 'Stoch Bear Div', group = 'Color Settings')
stochbullcolor = color.new(#38ff42, 0)  //input(color.new(#38ff42, 0), 'Stoch Bull Div', group = 'Color Settings')
 
stochBearDivColor = stochShowDiv and stochBearDiv or stochShowHiddenDiv and stochBearDivHidden ? stochbearcolor : na
stochBullDivColor = stochShowDiv and stochBullDiv or stochShowHiddenDiv and stochBullDivHidden ? stochbullcolor : na
 
 
// Small Circles WT Cross
signalcolorup = input.color(color.new(#00e676, 0), 'WT Buy Dot', group='Color Settings')
signalcolordown = input.color(color.new(#ff5252, 0), 'WT Sell Dot', group='Color Settings')
 
signalColor = wt2 - wt1 > 0 ? signalcolordown : signalcolorup
 
// Buy signal.
buySignal = wtCross and wtCrossUp and wtOversold
 
buySignalDiv = wtShowDiv and wtBullDiv or wtShowDiv and wtBullDiv_add or stochShowDiv and stochBullDiv or rsiShowDiv and rsiBullDiv
 
buySignalDiv_color = wtBullDiv ? colorGreen : wtBullDiv_add ? color.new(colorGreen, 60) : rsiShowDiv ? colorGreen : na
 
// Sell signal
sellSignal = wtCross and wtCrossDown and wtOverbought
 
sellSignalDiv = wtShowDiv and wtBearDiv or wtShowDiv and wtBearDiv_add or stochShowDiv and stochBearDiv or rsiShowDiv and rsiBearDiv
 
sellSignalDiv_color = wtBearDiv ? colorRed : wtBearDiv_add ? color.new(colorRed, 60) : rsiBearDiv ? colorRed : na
 
// Gold Buy 
lastRsi = ta.valuewhen(not(na(wtFractalBot)), rsi[2], 0)[2]
wtGoldBuy = (wtShowDiv and wtBullDiv or rsiShowDiv and rsiBullDiv) and wtLow_prev <= osLevel3 and wt2 > osLevel3 and wtLow_prev - wt2 <= -7 and lastRsi < 25
 
// } CALCULATE INDICATORS
 
 
// DRAW {
bgcolor(darkMode ? color.new(#000000, 90) : na)
zLine = plot(0, color=color.new(colorWhite, 50))
 
//  MFI BAR
rsiMfiBarTopLine = plot(rsiMFIShow ? -95 : na, title='MFI Bar TOP Line', color=color.new(#2196f3, 100))
rsiMfiBarBottomLine = plot(rsiMFIShow ? -99 : na, title='MFI Bar BOTTOM Line', color=color.new(#2196f3, 100))
fill(rsiMfiBarTopLine, rsiMfiBarBottomLine, title='MFI Bar Colors', color=color.new(rsiMFIColor, 75))
 
// WT Areas
colorWT1blue = input.color(color.new(#4994ec, 0), 'WT1 Fill', group='Color Settings')
colorWT2purple = input.color(color.new(#1f1559, 0), 'WT2 Fill', group='Color Settings')
plot(wtShow ? wt1 : na, style=plot.style_area, title='WT Wave 1', color=color.new(colorWT1blue, 30))
 
// plot(wtShow ? wt2 : na, style=plot.style_area, title='WT Wave 2', color=darkMode ? color.new(colorWT2_,25) : color.new(colorWT2purple,25))
plot(wtShow ? wt2 : na, style=plot.style_area, title='WT Wave 2', color=color.new(colorWT2purple, 25))
 
// VWAP
VWAPColor = input.color(color.new(#ffffff, 50), 'VWAP', group='Color Settings')
plot(vwapShow ? wtVwap : na, title='VWAP', color=color.new(VWAPColor, 45), style=plot.style_area, linewidth=2)
 
// MFI AREA
// rsiMFIplot = plot(rsiMFIShow ? rsiMFI : na, title='RSI+MFI Area', color=color.new(rsiMFIColor,90))
// fill(rsiMFIplot, zLine, color.new(rsiMFIColor,50))
plot(rsiMFIShow ? rsiMFI : na, style=plot.style_area, title='rsiMFI', color=color.new(rsiMFIColor, 50))
 
 
// WT Div
 
plot(not(na(wtFractalTop)) ? wt2[2] : na, title='WT Bearish Divergence', color=wtBearDivColor, linewidth=2, offset=-2)
plot(not(na(wtFractalBot)) ? wt2[2] : na, title='WT Bullish Divergence', color=wtBullDivColor, linewidth=2, offset=-2)
 
// WT 2nd Div
plot(not(na(wtFractalTop_add)) ? wt2[2] : na, title='WT 2nd Bearish Divergence', color=wtBearDivColor_add, linewidth=2, offset=-2)
plot(not(na(wtFractalBot_add)) ? wt2[2] : na, title='WT 2nd Bullish Divergence', color=wtBullDivColor_add, linewidth=2, offset=-2)
 
// RSI
plot(rsiShow ? rsi : na, title='RSI', color=color.new(rsiColor, 25), linewidth=2)
 
// RSI Div
plot(not(na(rsiFractalTop)) ? rsi[2] : na, title='RSI Bearish Divergence', color=rsiBearDivColor, linewidth=1, offset=-2)
plot(not(na(rsiFractalBot)) ? rsi[2] : na, title='RSI Bullish Divergence', color=rsiBullDivColor, linewidth=1, offset=-2)
 
// Stochastic RSI
stochkcolor = input.color(color.new(#21baf3, 70), 'Stoch K', group='Color Settings')
stochdcolor = input.color(color.new(#673ab7, 90), 'Stoch D', group='Color Settings')
 
stochKplot = plot(stochShow ? stochK : na, title='Stoch K', color=stochkcolor, linewidth=2)
stochDplot = plot(stochShow ? stochD : na, title='Stoch D', color=stochdcolor, linewidth=1)
stochFillColor = stochK >= stochD ? color.new(#21baf3, 95) : color.new(#673ab7, 90)
fill(stochKplot, stochDplot, title='KD Fill', color=color.new(stochFillColor, 90))
 
// Stoch Div
plot(not(na(stochFractalTop)) ? stochK[2] : na, title='Stoch Bearish Divergence', color=stochBearDivColor, linewidth=1, offset=-2)
plot(not(na(stochFractalBot)) ? stochK[2] : na, title='Stoch Bullish Divergence', color=stochBullDivColor, linewidth=1, offset=-2)
 
// Schaff Trend Cycle
plot(tcLine ? tcVal : na, color=color.new(#673ab7, 25), linewidth=2, title='Schaff Trend Cycle 1')
plot(tcLine ? tcVal : na, color=color.new(colorWhite, 50), linewidth=1, title='Schaff Trend Cycle 2')
 
 
// Draw Overbought & Oversold lines
oblvl2color = color.new(#ffffff, 0)  //input(color.new(#ffffff, 0), "OB LVL 2", group = 'Color Settings')
oblvl3color = color.new(#ffffff, 0)  //input(color.new(#ffffff, 0), "OB LVL 3", group = 'Color Settings')
oslvl2color = color.new(#ffffff, 0)  //input(color.new(#ffffff, 0), "OS LVL 2", group = 'Color Settings')
 
//plot(obLevel, title = 'Over Bought Level 1', color = colorWhite, linewidth = 1, style = plot.style_circles, transp = 85)
plot(obLevel2, title='Over Bought Level 2', color=color.new(oblvl2color, 20), linewidth=1, style=plot.style_stepline)
plot(obLevel3, title='Over Bought Level 3', color=color.new(oblvl3color, 0), linewidth=1, style=plot.style_circles)
 
//plot(osLevel, title = 'Over Sold Level 1', color = colorWhite, linewidth = 1, style = plot.style_circles, transp = 85)
plot(osLevel2, title='Over Sold Level 2', color=color.new(oslvl2color, 0), linewidth=1, style=plot.style_stepline)
 
// Sommi flag
plotchar(sommiFlagShow and sommiBearish ? 108 : na, title='Sommi bearish flag', char='⚑', color=color.new(colorPink, 0), location=location.absolute, size=size.tiny)
plotchar(sommiFlagShow and sommiBullish ? -108 : na, title='Sommi bullish flag', char='⚑', color=color.new(colorBluelight, 0), location=location.absolute, size=size.tiny)
plot(sommiShowVwap ? ta.ema(hvwap, 3) : na, title='Sommi higher VWAP', color=color.new(colorYellow, 55), linewidth=2, style=plot.style_line)
 
// Sommi diamond
plotchar(sommiDiamondShow and sommiBearishDiamond ? 113 : na, title='Sommi bearish diamond', char='◆', color=color.new(colorPink, 0), location=location.absolute, size=size.tiny)
plotchar(sommiDiamondShow and sommiBullishDiamond ? -113 : na, title='Sommi bullish diamond', char='◆', color=color.new(colorBluelight, 0), location=location.absolute, size=size.tiny)
 
// Circles
plot(wtCross ? wt2 : na, title='Buy and sell circle', color=color.new(signalColor, 15), style=plot.style_circles, linewidth=3)
 
plotchar(wtBuyShow and buySignal ? -107 : na, title='Buy circle', char='·', color=color.new(colorGreen, 50), location=location.absolute, size=size.small)
plotchar(wtSellShow and sellSignal ? 105 : na, title='Sell circle', char='·', color=color.new(colorRed, 50), location=location.absolute, size=size.small)
 
plotchar(wtDivShow and buySignalDiv ? -106 : na, title='Divergence buy circle', char='•', color=color.new(buySignalDiv_color, 15), location=location.absolute, size=size.small, offset=-2)
plotchar(wtDivShow and sellSignalDiv ? 106 : na, title='Divergence sell circle', char='•', color=color.new(sellSignalDiv_color, 15), location=location.absolute, size=size.small, offset=-2)
 
plotchar(wtGoldBuy and wtGoldShow ? -106 : na, title='Gold  buy gold circle', char='•', color=color.new(colorOrange, 15), location=location.absolute, size=size.normal, offset=-2)
 
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