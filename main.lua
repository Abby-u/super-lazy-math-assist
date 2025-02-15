love.window.setTitle("Silly lazy combination/permutation")
love.window.setMode(200,200)
local debug = false

local a = 0
local b = 0
local margin = 10
local result = 96
local copyPressed = false
local copyTimer = 1
local checkFactor = false

local modeSelected = "C"

local function doFactorial(n)
    local result = 1
    if n < 2 then
        return 1
    else
        return doFactorial(n-1) * n
    end
end

local function doCombination(n,m)
    local result = 1
    local top = doFactorial(n)
    local bottom = doFactorial(m)*doFactorial(n-m)
    local result = top/bottom
    return result
end

local function doPermutation(n,m)
    local result = 1
    local top = doFactorial(n)
    local bottom = doFactorial(n-m)
    local result = top/bottom
    return result
end

local function calculateResult(n,m)
    if modeSelected == "C" then
        return doCombination(n,m)
    elseif modeSelected == "P" then
        return doPermutation(n,m)
    end
end

local tabC = {
    x = 0,
    y = 0,
    w = 0,
    h = 0
}
local tabTextC = {
    x = (tabC.w/2),
    y = (tabC.h/2),
    w = 100,
    h = 72,
    align = "center",
    text = "Comb"
}
local tabF = {
    x = (tabC.w),
    y = 0,
    w = 0,
    h = 36
}
local tabTextF = {
    x = (tabF.w/2),
    y = (tabF.h/2),
    w = 100,
    h = 72,
    align = "center",
    text = "Perm"
}
local modeText = {
    x = margin*2,
    y = tabC.h+margin*2,
    w = 30,
    h = 46,
    s = 3,
    r = 0,
    align = "left",
    text = "C"
}
local aText = {
    x = modeText.x+modeText.w+margin,
    y = modeText.y,
    w = 110,
    h = 18,
    r = 0,
    size = 1.5,
    align = "left",
    text = tostring(a),
    focused = false
}
local aTrash = {
    x = 180,
    y = aText.y,
    w = 20,
    h = 20,
    text = "X"
}
local bText = {
    x = modeText.x+modeText.w+margin,
    y = modeText.y+20,
    w = 120,
    h = 18,
    r = 0,
    size = 1.5,
    align = "left",
    text = tostring(b),
    focused = false
}
local bTrash = {
    x = 180,
    y = bText.y,
    w = 20,
    h = 20,
    text = "X"
}
local resultText = {
    x = 0+margin*2,
    y = 80,
    w = 200,
    s = 1,
    r = 0,
    align = "left",
    text = tostring(result)
}
local copiedText = {
    x = 0,
    y = 170,
    w = 200,
    h = 200,
    align = "center",
    text = "Copied to clipboard"
}

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        if 
        x > modeText.x and 
        x < modeText.x+modeText.w and 
        y > modeText.y and 
        y < modeText.y+modeText.h 
        then
            if modeSelected == "C" then
                modeSelected = "P"
            elseif modeSelected == "P" then
                modeSelected = "C"
            end
            --tabC.selected = true
            --tabF.selected = false
        elseif
        x > 0 and
        x < 0+resultText.w and
        y > resultText.y and
        y < resultText.y+100
        then
            love.system.setClipboardText(result)
            copyTimer = 0
        elseif
        x > aText.x and
        x < aText.x+aText.w and
        y > aText.y+2 and
        y < aText.y+2+aText.h
        then
            aText.focused = true
            bText.focused = false
            love.keyboard.setTextInput(true, aText.x, aText.y, aText.w, aText.h)
        elseif
        x > bText.x and
        x < bText.x+bText.w and
        y > bText.y+2 and
        y < bText.y+2+bText.h
        then
            bText.focused = true
            aText.focused = false
            love.keyboard.setTextInput(true, bText.x, bText.y, bText.w, bText.h)
        elseif
        x > aTrash.x and
        x < aTrash.x+aTrash.w and
        y > aTrash.y and
        y < aTrash.y+aTrash.h
        then
            a = 0
        elseif
        x > bTrash.x and
        x < bTrash.x+bTrash.w and
        y > bTrash.y and
        y < bTrash.y+bTrash.h
        then
            b = 0
        else
            aText.focused = false
            bText.focused = false
            love.keyboard.setTextInput(false)
        end
    end
end

function love.keypressed(key,scancode,isrepeat)
    if key == "backspace" then
        if aText.focused then
            a = string.sub(a, 1, -2)
        elseif bText.focused then
            b = string.sub(b, 1, -2)
        end
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.textinput(t)
    if aText.focused then
        a = a..t
    elseif bText.focused then
        b = b..t
    end
end

function love.update(dt)
    modeText.text = modeSelected
    local testA = tonumber(a)
    local testB = tonumber(b)
    if testA == nil then a = tostring(a) else a = tonumber(a) end
    if testB == nil then b = tostring(b) else b = tonumber(b) end
    if type(a) == "number" and type(b) == "number" then
        if a < 256 and b < 256 then
            result = calculateResult(a,b)
            if result ~= result then
                result = "Factorial/Result too large\nor something went wrong"
            end
        else
            result = "Input too large"
            a = tostring(a)
            b = tostring(b)
        end
    else
        result = "Invalid input"
    end
    aText.text = tostring(a)
    bText.text = tostring(b)
    if type(result) == "number" then
        resultText.text = tostring(result)
    else
        resultText.text = result
    end
    if copyTimer < 1 then
        copyTimer = copyTimer + dt
    end
end

function love.draw()
    -- love.graphics.rectangle("line", tabC.x, tabC.y, tabC.w, tabC.h)
    -- love.graphics.rectangle("line", tabF.x, tabF.y, tabF.w, tabF.h)
    -- love.graphics.printf(tabTextC.text, tabC.x, tabTextC.y-6, tabTextC.w, tabTextC.align)
    -- love.graphics.printf(tabTextF.text, tabF.x, tabTextF.y-6, tabTextF.w, tabTextF.align)
    love.graphics.printf(modeText.text, modeText.x, modeText.y, modeText.w, modeText.align, modeText.r, modeText.s, modeText.s)
    love.graphics.printf(aText.text, aText.x, aText.y, aText.w, aText.align, aText.r, aText.size, aText.size)
    love.graphics.printf(aTrash.text, aTrash.x, aTrash.y, aTrash.w)
    love.graphics.printf(bText.text, bText.x, bText.y, bText.w, bText.align, bText.r, bText.size, bText.size)
    love.graphics.printf(bTrash.text, bTrash.x, bTrash.y, bTrash.w)
    love.graphics.printf(resultText.text, resultText.x, resultText.y, resultText.w, resultText.align, resultText.r, resultText.s)
    if copyTimer < 1 then love.graphics.printf(copiedText.text, copiedText.x, copiedText.y, copiedText.w, copiedText.align) end

    --debug
    if debug then
        love.graphics.rectangle("line",modeText.x,modeText.y,modeText.w,modeText.h)
        love.graphics.rectangle("line",aText.x,aText.y+2,aText.w,aText.h)
        love.graphics.rectangle("line",aTrash.x,aTrash.y,aTrash.w,aTrash.h)
        love.graphics.rectangle("line",bTrash.x,bTrash.y,bTrash.w,bTrash.h)
    end
end