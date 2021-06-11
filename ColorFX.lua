--DEV VERSION

local clrAmt
local exec

function main()
    clrAmt = 12 --tonumber(gma.textinput('Enter the first color here'))
    exec = 101 --tonumber(gma.textinput('Enter the first executor here')) --First executor the cues should be made, will automatically append 1.
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
    for i = clrAmt, clrAmt, 1 do
        gma.cmd('Assign Cue 1 /cmd="Copy Preset 4.' ..i.. 'At Preset 4.13 /m" Executor 1.' ..exec)
    end

end


return main