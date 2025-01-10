//@version=5
indicator(title='Market Cipher B')
 
//OB/OS
plot(60, title='overbought', color=color.new(#000000, 0), linewidth=2)
plot(-60, title='oversold', color=color.new(#000000, 0), linewidth=2)
plot(53, title='trigger 1', color=color.new(#000000, 0), linewidth=1, style=plot.style_circles)
plot(-53, title='trigger 2', color=color.new(#000000, 0), linewidth=1, style=plot.style_circles)
plot(100, title='100%', color=color.new(#000000, 0), linewidth=1, style=plot.style_circles)
//
//Wave
_wave()=>
    s = request.security(ticker.heikinashi(syminfo.tickerid), timeframe.period, hlc3)
    x = ta.ema(s, 9)
    y = ta.ema(math.abs(s-x), 9)
    z = (s-x) / (0.015 * y)
    fast = ta.ema(z, 12)
    slow = ta.sma(fast, 3)
    vwap=fast-slow
    buy=ta.crossover(fast,slow)
    sell=ta.crossunder(fast,slow)
    [fast, slow, buy, sell, vwap]
[fast, slow, buy, sell, vwap] = _wave()
//><
plot(fast, style=plot.style_area, title='fast', color=color.new(#c1cbff, 25), linewidth=1)
plot(slow, style=plot.style_area, title='slow', color=color.new(#0019fa, 32), linewidth=1)
plot(vwap, title='vwap', color=color.new(#ffeb3b,40), style=plot.style_area, linewidth=1)
//
//MoneyFlow
OC(tf)=>
    request.security(ticker.heikinashi(syminfo.tickerid),timeframe.period,(close-open))
HL(tf)=>
    request.security(ticker.heikinashi(syminfo.tickerid),timeframe.period,(high-low))
m= ta.sma(hlc3,5)
f= ta.sma(math.abs(hlc3-m),5)
i= (hlc3-m)/(0.015*f)
mf=ta.sma(i,60)
//><
p=plot(-95,color=color.new(#ffffff,100))
p2=plot(-105,color=color.new(#000000,100))
fill(p,p2,color=mf>0 ? color.new(#3cff00, 70):color.new(#ff1100,70))
plot(mf,'mfi',mf>0?color.new(#53ff1e, 53):color.new(#ff1100,50),style=plot.style_area,linewidth=1)
//
//Zero
plot(0, 'zero',color.new(#ffffff, 0),linewidth=1)
//
//Stochastic
stoch(src,len,k,tf) =>
    request.security(ticker.heikinashi(syminfo.tickerid),tf,ta.sma(ta.stoch(close, high, low, len),k))
rsi =stoch(close,40,2,timeframe.period)
stoch =stoch(close,81,2,timeframe.period)
//><
//plot(rsi, title='plotrsi', color=color.new(#000000,20), linewidth=2)
//plot(stoch, title='plotstoch', color=color.new(#000000,20), linewidth=2)
plot(rsi, title='rsi', color=color.fuchsia, linewidth=1)
plot(stoch, title='stoch', color=stoch < rsi ? color.new(#00e676,0) : color.new(#ff5252,0), linewidth=1)
//fill(r,s,color=color.new(#000000, 85))
//
//Signals
plot(buy ? slow:na, title='crossing up', color=color.new(#00e676,0),style=plot.style_circles, linewidth=2)
plot(sell ? slow:na, title='crossing down', color=color.new(#ff5252,0),style=plot.style_circles, linewidth=2)
//
//Alerts
alertcondition(buy, 'buy')
alertcondition(sell, 'sell')
//