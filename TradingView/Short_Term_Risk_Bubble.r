// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © legroszach

//@version=5
import kaigouthro/hsvColor/15
indicator('Short Term Bubble Risk', overlay=false)

source = close
smaLength = 20

sma = ta.sma(source, smaLength)
outSma = request.security(syminfo.tickerid, 'W', sma)

extension = close * 100 / outSma - 100

inputFillEnabled = input(true, 'Enable Fill', group='Fill')
inputFillDirection = input.string('Vertical', 'Gradient Direction', options=["Vertical", "Horizontal"], group='Fill')
inputSmaEnabled = input(false, 'Enable SMA')
inputSmaLength = input(8, 'SMA Length')
inputEmaEnabled = input(false, 'Enable EMA')
inputEmaLength = input(8, 'EMA Length')

if inputSmaEnabled
    extension := ta.sma(extension, inputSmaLength)

if inputEmaEnabled
    extension := ta.ema(extension, inputEmaLength)

risk_color(data) =>
    if data >= 0
        hsvColor.hsl_gradient(data, 0, 100, hsvColor.hsl(160, 1, 0.5, 1), hsvColor.hsl(0, 1, 0.5, 1))
    else
        hsvColor.hsl_gradient(data, -50, 0, hsvColor.hsl(245, 1, 0.5, 1), hsvColor.hsl(160, 1, 0.5, 1))

ext100 = plot(100, display=display.none)
ext75 = plot(75, display=display.none)
ext50 = plot(50, display=display.none)
ext25 = plot(25, display=display.none)
ext0 = plot(0, display=display.none)
extMinus25 = plot(-25, display=display.none)
extPlot = plot(extension, color=risk_color(extension), display=display.status_line)

displayVertical = inputFillEnabled and inputFillDirection == 'Vertical' ? display.all : display.none
displayHorizontal = inputFillEnabled and inputFillDirection == 'Horizontal' ? display.all : display.none
displayLine = not inputFillEnabled ? display.pane : display.none

// Vertical Gradient
fill(extPlot, ext0, bottom_value=extension >= 0 ? 0 : na, top_value=25, bottom_color=risk_color(0), top_color=risk_color(25), fillgaps=true, display=displayVertical)
fill(extPlot, ext25, bottom_value=extension >= 25 ? 25 : na, top_value=50, bottom_color=risk_color(25), top_color=risk_color(50), fillgaps=true, display=displayVertical)
fill(extPlot, ext50, bottom_value=extension >= 50 ? 50 : na, top_value=75, bottom_color=risk_color(50), top_color=risk_color(75), fillgaps=true, display=displayVertical)
fill(extPlot, ext75, bottom_value=extension >= 75 ? 75 : na, top_value=100, bottom_color=risk_color(75), top_color=risk_color(100), fillgaps=true, display=displayVertical)
fill(extPlot, ext0, bottom_value=extension < 0 ? -25 : na, top_value=0, bottom_color=risk_color(-25), top_color=risk_color(0), fillgaps=true, display=displayVertical)
fill(extPlot, extMinus25, bottom_value=extension <= -25 ? -50 : na, top_value=-25, bottom_color=risk_color(-50), top_color=risk_color(-25), fillgaps=true, display=displayVertical)

// Horizontal Gradient
fill(extPlot, ext0, color = risk_color(extension), fillgaps=true, display=displayHorizontal)

// Line plot
hline(0, display=inputFillEnabled ? display.none : display.all)
plot(extension, color=risk_color(extension), linewidth=2, display=displayLine)