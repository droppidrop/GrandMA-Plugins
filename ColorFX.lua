--DEV VERSION

local clrAmt
local exec
local grpAmt
local startMacro
local grp
local startFX
local colLabel = {}
local endFX

function macLine(macroNum, lineNum, command)
    gma.cmd('Store Macro 1.'..macroNum..'.'..lineNum)
    gma.cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/cmd = \"'..command..'\"')
end

function macStore(macroNum)
    gma.cmd('Store Macro 1.'..macroNum)
end

function main()
    clrAmt = 12 --tonumber(gma.textinput('Enter the amount of colours here'))
    exec = 101 --tonumber(gma.textinput('Enter the first executor here')) --First executor the cues should be made, will automatically append 1.
    grpAmt = 6 --tonumber(gma.textinput('Enter the amount of groups here,they have to be in order'))
    grp = 1 --tonumer(gma.textinput('Enter your first group here'))
    startMacro = 11 --tonumber(gma.textinput('Enter your starting macro here'))
    startFX = 1 --tonumbber(gma.textinput('Enter your first effect here'))
    endFX = startFX + grpAmt
    getLabels()
end


function getLabels()
    local col = 1
    for i = 1, clrAmt, 1 do
        local tempTemp = gma.show.getobj.handle("Preset 4." ..col)
        colLabel[i] = gma.show.getobj.label(tempTemp)
        print(colLabel[i])
        col = col + 1
    end  
    createCues()
end

function createCues()
    local subExec = exec
    local string = 'Lo'
    for i = 1, 2, 1 do
        for p = 1, clrAmt, 1 do
            gma.cmd('Store Cue ' ..p.. ' Executor 1.' ..exec)
            gma.cmd('Label Executor 1.' ..exec.. '"' ..string.. '"'  )
        end
        exec = exec + 1
        string = 'Hi'
    end
    cmdCues()
end

function cmdCues()
    exec = exec - 2
    local beep = 3
    for p = 1, 2, 1 do
        for i = 1, clrAmt, 1 do
            gma.cmd('Assign Cue ' ..i.. '/cmd="Copy Preset 4.' ..i.. ' At Preset 4.1' ..beep.. '/m" Executor 1.' ..exec)
            gma.cmd('Label Cue ' ..i.. ' Executor 1.' ..exec.. ' "' ..colLabel[i].. '"')
        end
        exec = exec + 1
        beep = beep + 1
    end
    createMacros()
end

function createMacros()
    --ON MACROS
    local subStartMacro = startMacro
    local Grp = grp
    local MacGrp = startMacro
    local fxNum = startFX
    local fxNum2 = startFX
    for i = 1, grpAmt, 1 do
        macStore(MacGrp)
        MacGrp = MacGrp + 1
    end
    for i = 1, grpAmt, 1 do
        macLine(subStartMacro, 1, 'BlindEdit On')
        macLine(subStartMacro, 2, 'ClearSelection')
        macLine(subStartMacro, 3, 'Group ' ..Grp)
        macLine(subStartMacro, 4, 'Store Effect 1.' ..fxNum.. '.1 Thru 1.' ..fxNum.. '.9' )
        macLine(subStartMacro, 5, 'clearAll')
        macLine(subStartMacro, 6, 'BlindEdit Off')
        Grp = Grp + 1
        fxNum = fxNum + 1
        subStartMacro = subStartMacro + 1
    end

    for i = 1, grpAmt, 1 do
        macStore(MacGrp)
        MacGrp = MacGrp + 1
    end
    for i = 1, grpAmt, 1 do
        macLine(subStartMacro, 1, 'BlindEdit On')
        macLine(subStartMacro, 2, 'ClearSelection')
        macLine(subStartMacro, 3, 'Group 8')
        macLine(subStartMacro, 4, 'Store Effect 1.' ..fxNum2.. '.1 Thru 1.' ..fxNum2.. '.9' )
        macLine(subStartMacro, 5, 'clearAll')
        macLine(subStartMacro, 6, 'BlindEdit Off')
        
        fxNum2 = fxNum2 + 1
        subStartMacro = subStartMacro + 1
    end

    createFX()
end

function createFX()
    subFX = startFX
    local line = 1
    local fx = 1
    for i = 1, grpAmt, 1 do
       gma.cmd('Store Effect ' ..subFX.. '/m')
       subFX = subFX + 1 
    end

    for o = 1, grpAmt, 1 do
        for p = 1, 9, 1 do
            gma.cmd('Store Effect 1.' ..fx.. '.' ..line.. '/m')
            line = line + 1
        end
        fx = fx + 1
        line = 1
    end

    fx = 1
    for e = 1, grpAmt, 1 do
    gma.cmd('Assign Attribute COLOR1 At Effect 1.' ..fx.. '.1 /m')
    gma.cmd('Assign Attribute COLORRGB1 At Effect 1.' ..fx.. '.2 /m')
    gma.cmd('Assign Attribute COLORRGB2 At Effect 1.' ..fx.. '.3 /m')
    gma.cmd('Assign Attribute COLORRGB3 At Effect 1.' ..fx.. '.4 /m')
    gma.cmd('Assign Attribute COLORRGB4 At Effect 1.' ..fx.. '.5 /m')
    gma.cmd('Assign Attribute COLORRGB5 At Effect 1.' ..fx.. '.6 /m')
    gma.cmd('Assign Attribute COLORRGB15 At Effect 1.' ..fx.. '.7 /m')
    gma.cmd('Assign Attribute EFFECTMACROCOLOUR At Effect 1.' ..fx.. '.8 /m')
    gma.cmd('Assign Attribute COLORMIXER At Effect 1.' ..fx.. '.9 /m')
    fx = fx + 1
    end
    waveform()
end

--TODO , wings, direction, groups, blocks

function waveform()
    local formAmount = 15
    for p = 1, formAmount, 1 do
        gma.cmd('Store Cue ' ..p.. ' Executor 1.' ..exec)
        gma.cmd('Label Executor 1.' ..exec.. '"waveform"')
    end
    local forms = {3, 4, 5, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19}
    local formString = {'Random', 'Pwm', 'Chase', 'Sin', 'Cos', 'Ramp+', 'Ramp-', 'Ramp', 'Phase 1', 'Phase 2', 'Phase 3', 'Bump 16', 'Swing 17', 'Ramp 50', 'Circle'}
    for i = 1, formAmount, 1 do
        gma.cmd('Assign Cue ' ..i.. '/cmd="Assign Form ' ..forms[i].. ' At Effect ' ..startFX.. ' Thru ' ..endFX.. '" /m Executor 1.' ..exec)
        gma.cmd('Label Cue ' ..i.. ' Executor 1.' ..exec.. ' "' ..formString[i].. '"')
    end
    exec = exec + 1
    --Random 3, Pwm 4, Chase 5, Sin 8, Cos 9, Ramp+ 10, Ramp- 11, Ramp 12, Phase 1 13, Phase 2 14, Phase 3 15, Bump 16, Swing 17, Ramp 50 18, Circle 19
    wings()
end

function wings()
    for i = 0, 5, 1 do
        b = i + 1
        gma.cmd('Store Cue ' ..b.. ' Executor 1.' ..exec)
        gma.cmd('Assign Cue ' ..b.. ' Executor 1.' ..exec.. '/cmd="Assign Effect ' ..startFX.. ' Thru ' ..endFX.. ' /wings='..i..'"')
        gma.cmd('Label Cue ' ..b.. ' Executor 1.' ..exec.. ' "'..i.. '"')
    end
    gma.cmd('Label Executor 1.' ..exec.. '"wings"')
    exec = exec + 1
    direction()
end

function direction()
    dirArray = {'>', '<', '>bounce', '<bounce'}
    for i = 1, 4, 1 do
        gma.cmd('Store Cue ' ..i.. ' Executor 1.' ..exec)
        gma.cmd('Assign Cue ' ..i.. ' Executor 1.' ..exec.. '/cmd="Assign Effect ' ..startFX.. ' Thru ' ..endFX.. '/dir='..dirArray[i].. '"')
        gma.cmd('Label Cue ' ..i.. ' Executor 1.' ..exec.. ' "' ..dirArray[i].. '"')
    end
    gma.cmd('Label Executor 1. ' ..exec.. '"direction"')
    exec = exec + 1
    groups()
end

function groups()
    for i = 0, 7, 1 do
        b = i + 1
        gma.cmd('Store Cue ' ..b.. ' Executor 1.' ..exec)
        gma.cmd('Assign Cue ' ..b.. ' Executor 1.' ..exec.. '/cmd="Assign Effect ' ..startFX.. ' Thru ' ..endFX.. '/groups='..i.. '"')
        gma.cmd('Label Cue ' ..b.. ' Executor 1.' ..exec.. ' "' ..i.. '"')
    end
    gma.cmd('Label Executor 1. ' ..exec.. '"groups"')
    exec = exec + 1
    blocks()
end

function blocks()
    for i = 0, 7, 1 do
        b = i + 1
        gma.cmd('Store Cue ' ..b.. ' Executor 1.' ..exec)
        gma.cmd('Assign Cue ' ..b.. ' Executor 1.' ..exec.. '/cmd="Assign Effect ' ..startFX.. ' Thru ' ..endFX.. '/blocks=' ..i.. '"')
        gma.cmd('Label Cue ' ..b.. ' Executor 1.' ..exec.. ' "' ..i.. '"')
    end
    gma.cmd('Label Executor 1. ' ..exec.. '"blocks"')
    exec = exec + 1

end

return main