function macStore(macroNum, label) --generate macro
  gma.cmd('Store Macro 1.'..macroNum) --create macro
  gma.cmd('Label Macro 1.'..macroNum..' \"'..label..'\"') --label the macro
end

function macLine(macroNum, lineNum, command) --generate new line within macro
  gma.cmd('Store Macro 1.'..macroNum..'.'..lineNum)
  gma.cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/cmd = \"'..command..'\"')
  if wait then cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/wait = \"'..wait..'\"') end
end

function test()
  local startNumber = tonumber(gma.textinput('Insert starting macro number here'))
  local colorAmount = tonumber(gma.textinput('Insert amount of colors here'))
  local startSequence = tonumber(gma.textinput('Insert starting sequence number here'))
  local fixVar = gma.textinput('Insert fixture variable here')
  local imageNumber = tonumber(gma.textinput('Insert first image number here'))
  local top = tonumber(gma.textinput('Is this the top row? (1/0'))
  local pool = 47
  local columns = {$WhiteColumn, $RedColumn, $OrangeColumn, $YellowColumn, $GreenColumn, $SGreenColumn, $CyanColumn, $BlueColumn, $LavenderColumn, $VioletColumn, $MagentaColumn, $Pink}
  colorAmount = colorAmount - 1 
  for i = startNumber,startNumber + colorAmount, 1 do
    macStore(i, i)
    macLine(i, 1, 'Go Sequence ' ..startSequence)
    startSequence = startSequence + 1
    macLine(i, 2, 'Copy $EmptyColours At ' ..fixVar.. ' /m')
    macLine(i, 3, 'Copy Image ' ..pool.. ' At ' ..imageNumber.. ' /o')
    pool = pool + 1
    if top == 0 then
      macLine(i, 4, 'Copy $EmptyColours At $AllColours /m')
    else then
      macLine(i,4, 'Copy ' ..imageNmber.. 'At' columns[i]
    imageNumber = imageNumber + 1
    end
  end  
end

return test