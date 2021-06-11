--DEV VERSION

local clrAmt
local exec
local grpAmt
local startMacro
local grp

function macLine(macroNum, lineNum, command)
    gma.cmd('Store Macro 1.'..macroNum..'.'..lineNum)
    gma.cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/cmd = \"'..command..'\"')
end

function macStore(macroNum)
    gma.cmd('Store Macro 1.'..macroNum)
  end

function main()
    clrAmt = 12 --tonumber(gma.textinput('Enter the first color here'))
    exec = 101 --tonumber(gma.textinput('Enter the first executor here')) --First executor the cues should be made, will automatically append 1.
    grpAmt = 6 --tonumber(gma.textinput('Enter the amount of groups here,they have to be in order'))
    grp = 1 --tonumer(gma.textinput('Enter your first group here'))
    startMacro = 11 --tonumber(gma.textinput('Enter your starting macro here'))
    startFX = 10 --tonumbber(gma.textinput('Enter your first effect here'))
    createCues()
end

function createCues()
    local subExec = exec
    for i = 1, 2, 1 do
        for p = 1, clrAmt, 1 do
            gma.cmd('Store Cue ' ..p.. ' Executor 1.' ..subExec)
            
        end
        subExec = subExec + 1
    end
    cmdCues()
end

function cmdCues()
    local subExec = exec
    for i = 1, clrAmt, 1 do
        gma.cmd('Assign Cue ' ..i.. '/cmd="Copy Preset 4.' ..i.. ' At Preset 4.13 /m" Executor 1.' ..subExec)
    end
    createMacros()
end

function createMacros()
    --ON MACROS
    local subStartMacro = startMacro
    local Grp = grp
    local MacGrp = startMacro
    local fxNum = startFX
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


end

return main