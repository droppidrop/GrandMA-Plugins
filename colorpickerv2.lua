

local getHandle = gma.show.getobj.handle
local subImg
local fillSubImg
local unfillImg = {}
local fillImg = {}
local fixtures = {}
local fixRows = {}

function getLabel(str)
  return gma.show.getobj.label(getHandle(str))
end

function cmdSeq(preset, group, sequence)
	gma.cmd('Group ' ..group)
	gma.cmd('At Preset 4.' ..preset)
	gma.cmd('Store Sequence ' ..sequence)
	gma.cmd('Label Sequence ' ..sequence.. ' \"'..group.. ' ' ..preset..'\"')
end

function cmdImg(image, group, preset, imgNum)
	gma.cmd('Copy Image ' ..image.. ' at ' ..imgNum)
	gma.cmd('Label Image ' ..imgNum.. ' \"'..group.. ' ' ..preset.. '\"')
end

function macStore(macroNum, group, preset)
  gma.cmd('Store Macro 1.'..macroNum)
  gma.cmd('Label Macro 1.'..macroNum..' \"'..group.. ' ' ..preset..'\"')
end

function macLine(macroNum, lineNum, command)
  gma.cmd('Store Macro 1.'..macroNum..'.'..lineNum)
  gma.cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/cmd = \"'..command..'\"')
  if wait then cmd('Assign Macro 1.'..macroNum..'.'..lineNum..'/wait = \"'..wait..'\"') end
end

function input()
	local preNum = {}
	local preName = {}
	local following = tonumber(gma.textinput('Images and colours in order? (1/0?'))
	local startSeq = tonumber(gma.textinput('Enter starting sequence here'))
	local startImg = tonumber(gma.textinput('Enter starting image here'))
	local clrAmt = tonumber(gma.textinput('Enter the amount of colours here'))
	
--COLOURS
	if following == 0 then
		for a = 1, clrAmt, 1 do
			local pre = tonumber(gma.textinput('Enter color ' ..a.. ' here, only numerical'))
			preNum[a] = pre
			preName[a] = getLabel('Preset 4.' ..pre) 
		end
	else 
		local pre = tonumber(gma.textinput('Enter first colour here'))
		for i = 1, clrAmt, 1 do
			preNum[i] = pre
			preName[i] = getLabel('Preset 4.' ..pre)
			pre = pre + 1
		end
	end
		
--IMAGES
	if following == 0 then	
		for d = 1, clrAmt, 1 do 
			subImg = tonumber(gma.textinput('Enter unfilled image ' ..d.. ' here, only numerical'))
			unfillImg[d] = subImg
		end
		for e = 1, clrAmt, 1 do	
			fillSubImg = tonumber(gma.textinput('Enter filled image' ..e.. ' here, only numerical'))
			fillImg[e] = fillSubImg
		end
	else 
		subImg = tonumber(gma.textinput('Enter first unfilled image here'))
		for i = 1, clrAmt, 1 do
			preSubImg = subImg
			unfillImg[i] = preSubImg
			preSubImg = preSubImg + 1
		end
		fillSubImg = tonumber(gma.textinput('Enter first filled image here'))
		for i = 1, clrAmt, 1 do
			fillImg[i] = fillSubImg
			fillSubimg = fillSubImg + 1
		end		
	end
	
--GROUPS
	local grpNum = {}
	local grpName = {}
	local grpAmt = tonumber(gma.textinput('Enter amount of groups here'))
	for b = 1, grpAmt, 1 do
		local grp = tonumber(gma.textinput('Enter group ' ..b.. ' here, only numerical')) --get label for group
		grpNum[b] = grp
		grpName[b] = getLabel('Group '..b)			
	end
	createSequences(preNum, preName, grpNum, grpName, clrAmt, grpAmt, startSeq, unfillImg, startImg)
end

--SEQEUNCES
function createSequences(preNum, preName, grpNum, grpName, clrAmt, grpAmt, subStartSeq, unfillImg, startImg)
	local startSeq = subStartSeq
	local subStartImg = startImg
	subSubImg = subImg
	for c = 1, grpAmt, 1 do
		local subGrp = grpNum[c]
		for d = 1, clrAmt, 1 do
			local subPre = preNum[d]
			local subImg = unfillImg[d]
			cmdSeq(subPre, subGrp, subStartSeq)
			cmdImg(subSubImg, subGrp, subPre, subStartImg)
			subStartSeq = subStartSeq + 1
			subStartImg = subStartImg + 1
			subSubImg = subSubImg + 1
		end
	end
--VARS
	local varStartImg = startImg
	local subSubImg = subImg
	local emptyImgString = 'SetVar $Empty = "Image ' 
	for i = 1, clrAmt, 1 do
		if i < 12 then
			emptyImgString = emptyImgString ..subSubImg.. " + "
			subSubImg = subSubImg + 1
		else
			emptyImgString = emptyImgString .. subSubImg
		end
	end
	emptyImgString = emptyImgString .. '"'
	gma.cmd(emptyImgString)
	for i = 1, grpAmt, 1 do
		local varString = 'SetVar $Grp' .. i .. ' = ' .. '"'
		for j = 1, clrAmt, 1 do
			if j < clrAmt then
				varString = varString .. varStartImg .. " + "
			else 
				varString = varString .. varStartImg
			end
		varStartImg = varStartImg + 1
		end
		varString = varString .. '"'
		gma.cmd(varString)
	end
	createMacros(grpAmt, clrAmt, startSeq, startImg, fillSubImg, subImg)
end

--MACROS
function createMacros(grpAmt, clrAmt, subStartSeq, startImg)
	local startMacro = tonumber(gma.textinput('Enter first macro here'))
	local grp = 0
	local pre = 1
	local subSubFillSubImg = fillSubImg
	local subStartMacro = startMacro -1
	local subFillSubgImg = fillSubImg
	local subStartImg = startImg
	for i = 1, grpAmt do
		grp = grp + 1
		pre = 1
		subFillSubImg = fillSubImg
		if grp == 1 then
			for r = 1, clrAmt do
				macStore(startMacro, grp, pre)
				macLine(startMacro, 1, 'Go Sequence ' ..subStartSeq)
				local restGrps = " "
				local varLine = 2
				local varNumber = 1
				for r = 1, grpAmt do
					macLine(startMacro, varLine, 'Copy $Empty at Image $Grp' ..varNumber.. ' /m')
					varLine = varLine + 1
					varNumber = varNumber + 1
				end
				macLine(startMacro, varLine, 'Copy Image ' ..subFillSubImg.. ' At ' ..startImg.. ' /o')
				subStartSeq = subStartSeq + 1
				startMacro = startMacro + 1
				pre = pre + 1
				startImg = startImg + 1
				subFillSubImg = subFillSubImg + 1
			end
		else
			for e = 1, clrAmt do
			macStore(startMacro, grp, pre)
			macLine(startMacro, 1, 'Go Sequence ' ..subStartSeq)
			macLine(startMacro, 2, 'Copy $Empty At Image $Grp' ..grp.. ' /m')
			macLine(startMacro, 3, 'Copy Image ' ..subFillSubImg.. ' At ' ..startImg.. ' /o')
			subStartSeq = subStartSeq + 1
			startMacro = startMacro + 1
			pre = pre + 1
			startImg = startImg + 1
			subFillSubImg = subFillSubImg + 1
			end
		end
	end
end

return input