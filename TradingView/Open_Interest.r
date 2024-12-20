// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © LeviathanCapital

//@version=5

indicator("Open Interest Suite [Aggregated] - By Leviathan", format = format.volume)

g1 = 'General'
g2 = 'Thresholds'
g3 = 'Additional Settings'
g5 = 'Screener'
g4 = 'Distribution profile '
g6 = 'Data Sources and Aggregation'

// User inputs - Data Source Settings
maindisp = input.string('Open Interest', 'Display', options = ['Open Interest', 'Open Interest Delta', 'OIΔ x rVOL', 'Open Interest RSI'])
quotecur = input.string('USD', 'Quoted in', options = ['USD', 'COIN'])
upcol    = input.color(#d1d4dc, 'Color                ▲', inline = 'udcol')
downcol  = input.color(#9598a1f6, '▼', inline = 'udcol')

// User inputs - Data Sources
binance   = input.bool(true, 'Binance USDT.P_OI', inline = 'src',  group = g6)
binance2  = input.bool(true, 'Binance USD.P_OI',  inline = 'src',  group = g6)
binance3  = input.bool(true, 'Binance BUSD.P_OI', inline = 'src2', group = g6)
bitmex    = input.bool(true, 'BitMEX USD.P_OI',   inline = 'src2', group = g6)
bitmex2   = input.bool(true, 'BitMEX USDT.P_OI ', inline = 'src3', group = g6)
kraken    = input.bool(true, 'Kraken USD.P_OI',   inline = 'src3', group = g6)

// User Inputs - Thresholds
d_mult      = input.float(5, 'Threshold Multiplier', step = 0.1, group = g2)
show_loi    = input.bool(false, 'Highlight Large OI Increase ', inline = 'loi', group = g2)
show_lod    = input.bool(false, 'Highlight Large OI Decrease', inline = 'lod', group = g2)
upoicol     = input.color(#a5d6a7, '', inline = 'loi', group = g2)
dwoicol     = input.color(#fe5f6d, '', inline = 'lod', group = g2)
col_cha     = input.bool(false, 'Color Chart Bars', group = g2)
col_bg      = input.bool(false, 'Color Background', group = g2)
show_thresh = input.bool(false, 'Show Thresholds', group = g2)

// User Inputs - Additional Settings
show_ema  = input.bool(false, 'OI EMA', group = g3, inline = 'ema')
ema_len   = input.int(50, '', group = g3, inline = 'ema')
ema_col   = input.color(color.gray, '', group = g3, inline = 'ema')
rsi_len   = input.int(20, 'OI RSI      ', group = g3, inline = 'rsi')
rsi_col   = input.color(color.gray, '', inline = 'rsi', group = g3)

// User Inputs - Screener
lookback      = input.int(200, 'Lookback (bars)', group = g5)
show_screener = input.bool(false, 'Show Screener', group = g5)
show_OI       = input.bool(true, ' ● Open Interest', group = g5)
show_rekt     = input.bool(true, ' ● Rekt Longs & Shorts', group = g5)
show_agg      = input.bool(true, ' ● Aggressive Longs & Shorts', group = g5)

// User inputs - Profile settings
prof     = input.bool  (false, 'Generate a profile', group=g4)
vapct    = input.float (70, 'Value Area %', minval = 5, maxval = 95,         group = g4)
profSize = input.int   (2, 'Node Size', minval = 1,                          group = g4)
rows     = input.int   (40, 'Rows', minval = 6, maxval = 500, step = 25,     group = g4) - 1
vancol   = input.color (color.new(color.blue, 75), 'Node Colors         ', group = g4, inline = 'nc')
nvancol  = input.color (color.new(color.gray, 75), '━',             group = g4, inline = 'nc')
poc      = input.bool  (false, 'POC',                                 group = g4, inline = 'POC'), 
poccol   = input.color (color.new(color.red, 50), '            ',   group = g4, inline = "POC")
val      = input.bool  (false, 'VA',                                  group = g4, inline = "VA")
vafill   = input.color (color.new(color.blue, 95), '             ', group = g4, inline = 'VA')

// 
pc   = maindisp=='Open Interest'
pd   = maindisp=='Open Interest Delta'
prdv = maindisp=='OIΔ x rVOL'
poir = maindisp=='Open Interest RSI'
ori  = 'Left'

// Getting OI data
mex = syminfo.basecurrency=='BTC' ? 'XBT' : string(syminfo.basecurrency)
[oid1, oic1, oio1, oih1, oil1] = request.security('BINANCE' + ":" + string(syminfo.basecurrency) + 'USDT.P_OI',  timeframe.period,  [close-close[1], close, open, high, low], ignore_invalid_symbol = true)
[oid2, oic2, oio2, oih2, oil2] = request.security('BINANCE' + ":" + string(syminfo.basecurrency) + 'USD.P_OI',   timeframe.period,  [close-close[1], close, open, high, low], ignore_invalid_symbol = true)
[oid3, oic3, oio3, oih3, oil3] = request.security('BINANCE' + ":" + string(syminfo.basecurrency) + 'BUSD.P_OI',  timeframe.period,  [close-close[1], close, open, high, low], ignore_invalid_symbol = true)
[oid4, oic4, oio4, oih4, oil4] = request.security('BITMEX'  + ":" + mex                          + 'USD.P_OI',   timeframe.period,  [close-close[1], close, open, high, low], ignore_invalid_symbol = true)
[oid5, oic5, oio5, oih5, oil5] = request.security('BITMEX'  + ":" + mex                          + 'USDT.P_OI',  timeframe.period,  [close-close[1], close, open, high, low], ignore_invalid_symbol = true)
[oid6, oic6, oio6, oih6, oil6] = request.security('KRAKEN'  + ":" + string(syminfo.basecurrency) + 'USD.P_OI',   timeframe.period,  [close-close[1], close, open, high, low], ignore_invalid_symbol = true)

deltaOI = (binance ? nz(oid1,0) : 0)   +   (binance2 ? nz(oid2,0)/close : 0)   +    (binance3 ? nz(oid3,0) : 0)    +   (bitmex ? nz(oid4,0)/close : 0)   +   (bitmex2 ? nz(oid5,0)/close : 0)   +   (kraken ? nz(oid6,0)/close : 0)

// Thresholds, conditions
p_delta_thresh = ta.sma(deltaOI>0 ? deltaOI : 0, 300) * d_mult
n_delta_thresh = ta.sma(deltaOI<0 ? deltaOI : 0, 300) * d_mult
large_oi_up = deltaOI > p_delta_thresh
large_oi_dw = deltaOI < n_delta_thresh

// OHLC values for plotting candles
O = (binance ? nz(oio1, 0) : 0) + (binance2 ? nz(oio2/close, 0) : 0) + (binance3 ? nz(oio3, 0) : 0) + (bitmex ? nz(oio4/close, 0) : 0) + (bitmex2 ? nz(oio5/close, 0) : 0) + (kraken ? nz(oio6/close, 0) : 0)
H = (binance ? nz(oih1, 0) : 0) + (binance2 ? nz(oih2/close, 0) : 0) + (binance3 ? nz(oih3, 0) : 0) + (bitmex ? nz(oih4/close, 0) : 0) + (bitmex2 ? nz(oih5/close, 0) : 0) + (kraken ? nz(oih6/close, 0) : 0) 
L = (binance ? nz(oil1, 0) : 0) + (binance2 ? nz(oil2/close, 0) : 0) + (binance3 ? nz(oil3, 0) : 0) + (bitmex ? nz(oil4/close, 0) : 0) + (bitmex2 ? nz(oil5/close, 0) : 0) + (kraken ? nz(oil6/close, 0) : 0) 
C = (binance ? nz(oic1, 0) : 0) + (binance2 ? nz(oic2/close, 0) : 0) + (binance3 ? nz(oic3, 0) : 0) + (bitmex ? nz(oic4/close, 0) : 0) + (bitmex2 ? nz(oic5/close, 0) : 0) + (kraken ? nz(oic6/close, 0) : 0)

O_ = (quotecur=='COIN' ? O : O * close)
H_ = (quotecur=='COIN' ? H : H * close)
L_ = (quotecur=='COIN' ? L : L * close)
C_ = (quotecur=='COIN' ? C : C * close)

// Conditions for coloring
rvol = volume/ta.sma(volume, 20)

if prdv
    deltaOI := deltaOI * rvol
    pd := true

pccol = C_>O_ ? upcol : downcol
pdcol = deltaOI > 0 ? upcol : downcol

if show_loi and large_oi_up
    pccol := upoicol
    pdcol := upoicol
if show_lod and large_oi_dw
    pccol := dwoicol
    pdcol := dwoicol

// Plotting data
plotcandle(pc ? C_[1] : na, pc ? H_ : na, pc ? L_ : na, pc ? C_ : na, color = pccol, wickcolor = pccol, bordercolor = pccol, title = 'Open Interest Candles', editable = false)
plot      (pd ? deltaOI : na, style = plot.style_columns, color = pdcol, title = 'Open Interest Delta')
plot      (show_ema and pc ? ta.ema(C_, ema_len) : na, color = ema_col, editable = false)
plot      (poir ? ta.rsi(C, rsi_len) : na, color = rsi_col, editable = false)
hline     (poir ? 30 : na, editable = false)
hline     (poir ? 70 : na, editable = false)
hline     (poir ? 50 : na, editable = false)
bgcolor   (col_bg and show_loi and large_oi_up ? color.new(pdcol, 85) : na, editable = false)
bgcolor   (col_bg and show_lod and large_oi_dw ? color.new(pdcol, 85) : na, editable = false)
barcolor  (col_cha and show_loi and large_oi_up ? color.new(pdcol, 0) : na, editable = false)
barcolor  (col_cha and show_lod and large_oi_dw ? color.new(pdcol, 0) : na, editable = false)
plot      (show_thresh ? p_delta_thresh : na, color = color.gray, editable = false)
plot      (show_thresh ? n_delta_thresh : na, color = color.gray, editable = false)


// Generating a profile - Code from @KioseffTrading's "Profile Any Indicator" script (used with their permission)
srcp = C_

var int   [] timeArray  = array.new_int()
var float [] dist       = array.new_float()
var int   [] x2         = array.new_int(rows + 1, 5)
var          vh         = matrix.new<float>(1, 1)

array.unshift(timeArray, math.round(time)) 

if prof and (poir or pc) and time >= chart.left_visible_bar_time and time <= chart.right_visible_bar_time
    matrix.add_col(vh)
    matrix.set(vh, 0, matrix.columns(vh) - 1, srcp)


if prof and (poir or pc) and barstate.islast

    [pos, n] = switch ori
        "Left" =>  [chart.left_visible_bar_time , array.indexof(timeArray,  chart.left_visible_bar_time)]
        =>         [chart.right_visible_bar_time, array.indexof(timeArray, chart.right_visible_bar_time)]


    calc = (matrix.max(vh) - matrix.min(vh)) / (rows + 1)

    for i = 0 to rows
        array.push(dist, matrix.min(vh) + (i * calc))
    

    for i = 1 to matrix.columns(vh) - 1
        for x = 0 to array.size(dist) - 1
            if matrix.get(vh, 0, i) >= matrix.get(vh, 0, i - 1)
                if array.get(dist, x) >= matrix.get(vh, 0, i - 1) and array.get(dist, x) <= matrix.get(vh, 0, i)
                    array.set(x2, x, array.get(x2, x) + profSize)
            
            else 
                
                if array.get(dist, x) >= matrix.get(vh, 0, i) and array.get(dist, x) <= matrix.get(vh, 0, i - 1)
                    array.set(x2, x, array.get(x2, x) + profSize)

    boc = array.new_box()
    for i = 1 to rows
        
        right = array.get(timeArray, n + array.get(x2, i))
        
        if ori == "Left"
            switch math.sign(n - array.get(x2, i))

                -1 => right := chart.right_visible_bar_time
                =>    right := array.get(timeArray, n - array.get(x2, i))



        array.push(boc, box.new(pos, array.get(dist, i - 1), 
             right, array.get(dist, i), xloc = xloc.bar_time, border_color = 
             nvancol, bgcolor = nvancol
             ))
        if i == rows 
            array.push(boc, box.new(pos, array.get(dist, array.size(dist) - 1), 
                     right, array.get(dist, array.size(dist) - 1) + calc, xloc = xloc.bar_time, border_color = 
                     nvancol, bgcolor = nvancol
                     ))


    array.shift(x2), nx = array.indexof(x2, array.max(x2))
    nz = nx - 1, nz2 = 0, nz3 = 0, nz4 = 0
    for i = 0 to array.size(x2) - 1
        if nz > -1 and nx <= array.size(x2) - 1
            switch array.get(x2, nx) >= array.get(x2, nz)
                true => nz2 += array.get(x2, nx), nx += 1
                =>      nz2 += array.get(x2, nz), nz -= 1
                
        else if nz <= -1
            nz2 += array.get(x2, nx), nx += 1
        else if nx >= array.size(x2)
            nz2 += array.get(x2, nz), nz -= 1
        if nz2 >= array.sum(x2) * (vapct / 100)
            nz3 := nx <= array.size(x2) - 1 ? nx : array.size(x2) - 1, nz4 := nz <= -1 ? 0 : nz
            break

    for i = nz3 to nz4
        box.set_border_color(array.get(boc, i), vancol)
        box.set_bgcolor(array.get(boc, i), vancol)
    if poc 
        var pocL = line(na)
        y = math.avg(box.get_top(array.get(boc, array.indexof(x2, array.max(x2)))), box.get_bottom(array.get(boc, array.indexof(x2, array.max(x2)))))
        if na(pocL)
            pocL := line.new(chart.left_visible_bar_time, y, chart.right_visible_bar_time, y, xloc = xloc.bar_time, color = poccol, width = 1)
        else 
            line.set_xy1(pocL, chart.left_visible_bar_time, y)
            line.set_xy2(pocL, chart.right_visible_bar_time, y)
    if val 
        var vaup = line(na), var vadn = line(na)
        ydn = box.get_bottom(array.get(boc, nz3)), yup = box.get_top(array.get(boc, nz4))

        if na(vaup)

            vadn := line.new(chart.left_visible_bar_time, ydn, chart.right_visible_bar_time, ydn, xloc = xloc.bar_time, color = vancol, width = 1)
            vaup := line.new(chart.left_visible_bar_time, yup, chart.right_visible_bar_time, yup, xloc = xloc.bar_time, color = vancol, width = 1)

        else 

            line.set_xy1(vadn, chart.left_visible_bar_time, ydn), line.set_xy2(vadn, chart.right_visible_bar_time, ydn)
            line.set_xy1(vaup, chart.left_visible_bar_time, yup), line.set_xy2(vaup, chart.right_visible_bar_time, yup)

        linefill.new(vadn, vaup, vafill)

// Screener
if show_screener
    table = table.new(position.top_right, 2, 6, color.rgb(120, 123, 134, 82))

    float rekt_longs  = 0
    float rekt_shorts = 0
    float aggressive_longs = 0
    float aggressive_shorts = 0

    for i = 0 to lookback - 1
        if large_oi_dw[i] and close[i]<open[i]
            rekt_longs := rekt_longs + math.abs(deltaOI[i] * close[i])
        if large_oi_dw[i] and close[i]>open[i]
            rekt_shorts := rekt_shorts + math.abs(deltaOI[i] * close[i])
        if large_oi_up[i] and close[i]>open[i]
            aggressive_longs  := aggressive_longs + math.abs(deltaOI[i] * close[i])
        if large_oi_up[i] and close[i]<open[i]
            aggressive_shorts := aggressive_shorts + math.abs(deltaOI[i] * close[i])
    
    if show_OI
        table.cell(table, 0, 0, 'Open Interest:', text_halign = text.align_left, text_color = chart.fg_color)
        table.cell(table, 1, 0,  (quotecur=='COIN' ? (str.tostring(C, format.volume) + ' BTC') : '$' + str.tostring(C*close, format.volume)) + ' ', text_halign = text.align_left, text_color = chart.fg_color)
    if show_rekt
        table.cell(table, 0, 2, 'Rekt Longs:', text_halign = text.align_left, text_color = chart.fg_color)
        table.cell(table, 0, 3, 'Rekt Shorts:', text_halign = text.align_left, text_color = chart.fg_color)
        table.cell(table, 1, 2, '$' + str.tostring(rekt_longs, format.volume) + ' ', text_halign = text.align_left, text_color = chart.fg_color)
        table.cell(table, 1, 3,  '$' + str.tostring(rekt_shorts, format.volume) + ' ', text_halign = text.align_left, text_color = chart.fg_color)
    if show_agg
        table.cell(table, 0, 4, 'Aggressive Longs:', text_halign = text.align_left, text_color = chart.fg_color)
        table.cell(table, 0, 5, 'Aggressive Shorts:', text_halign = text.align_left, text_color = chart.fg_color)
        table.cell(table, 1, 4,  '$' + str.tostring(aggressive_longs, format.volume) + ' ', text_halign = text.align_left, text_color = chart.fg_color)
        table.cell(table, 1, 5,  '$' + str.tostring(aggressive_shorts, format.volume) + ' ', text_halign = text.align_left, text_color = chart.fg_color)
