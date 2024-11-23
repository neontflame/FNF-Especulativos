jiggy = false
strumOffset = 325
strumVertOffset = 0

healthbarShits = {0, 0, 0, 0, 0}

ogGfPos = 0
ogOpponentPos = 0
function start(song) 	
	ogGfPos = getActorX("girlfriend")
	ogOpponentPos = getActorY("dad")
	setActorX(5000, "girlfriend")
	tweenCameraZoom(1.5, 0.001, 'cubeOut')
    blackground = makeSprite('black','black',false)
    setActorAlpha(0,blackground)
    setActorX(0,blackground)
    setActorY(0,blackground)
    setActorScale(10,blackground)
	
	healthbarShits[0] = getActorY("healthBar")
	healthbarShits[1] = getActorY("healthBarBG")
	healthbarShits[2] = getActorY("iconP1")
	healthbarShits[3] = getActorY("iconP2")
	healthbarShits[4] = getActorY("scoreTxt")
	
	if centeredNotes == 1 then
		strumOffset = 0
	end
	
	tweenFade("healthBar", 0, 0.001, 'linear')
	tweenFade("healthBarBG", 0, 0.001, 'linear')
	tweenFade("iconP1", 0, 0.001, 'linear')
	tweenFade("iconP2", 0, 0.001, 'linear')
	tweenFade("scoreTxt", 0, 0.001, 'linear')
	for i=0,7 do
		tweenFade(i, 0.25, 0.001, 'linear')
	end
	
	tweenFade(blackground,1,0.001,'linear')
end

function songStart(song)
	tweenFade(blackground,0.001,4,'linear')
end

function lerp(a, b, t)
	aTen = a*10
	bTen = b*10
	tTen = t/10
	return (aTen + tTen * (bTen - aTen)) / 10
end

fuck = 0
piss = 0
function update(elapsed)
	if curBeat > 351 then
		fuck = fuck + 1
		
		if piss < 10 then
			piss = piss + 0.025
		end
		setActorY(ogOpponentPos + (math.sin(fuck * 0.025) * 40), "dad")
		
		for i=0,3 do
			setActorX(getActorX(i) - piss, i)
			if getActorX(i) < -110 then
				setActorX(1280, i)
			end
		end
	end
end
	
function playerTwoSing(note, pos)
end


function stepHit(step) 
	if step == 112 then
		tweenFade("healthBar", 1, 0.001, 'linear')
		tweenFade("healthBarBG", 1, 0.001, 'linear')
		tweenFade("iconP1", 1, 0.001, 'linear')
		tweenFade("iconP2", 1, 0.001, 'linear')
		tweenFade("scoreTxt", 1, 0.001, 'linear')
	end
	
	if step == 118 then
		for i=0,3 do
			tweenFade(i, 1, 0.001, 'linear')
		end
	end
	
	if step == 124 then
		for i=4,7 do
			tweenFade(i, 1, 0.001, 'linear')
		end
	end
end      
  
jigDir = false

function doTheJig(force, other)
	jigDir = not jigDir
	if other then
		for i=4,7 do
			if jigDir then
				tweenPos(i, _G['defaultStrum'.. (11 - i) ..'X'] - strumOffset, _G['defaultStrum'.. (11 - i) ..'Y'] + strumVertOffset, 0.25, 'cubeOut')
			else
				tweenPos(i, _G['defaultStrum'.. i ..'X'] - strumOffset, _G['defaultStrum'.. i ..'Y'] + strumVertOffset, 0.25, 'cubeOut')
			end
		end
	else
		for i=4,7 do
			if jigDir then
				setActorX((_G['defaultStrum'..i..'X'] - strumOffset) - (force * (i-2)) - force, i)
				setActorY((_G['defaultStrum'..i..'Y'] + strumVertOffset) - (force * (i-3)) + (force * 2), i)
			else
				setActorX((_G['defaultStrum'..i..'X'] - strumOffset) + (force * (i-3)), i)
				setActorY((_G['defaultStrum'..i..'Y'] + strumVertOffset) + (force * (i-3)) - (force * 2), i)
			end
			
			tweenPos(i, (_G['defaultStrum'..i..'X'] - strumOffset), _G['defaultStrum'.. i ..'Y'] + strumVertOffset, 0.25, 'cubeOut')
		end
	end
end

scroll = false
gottenJiggy = false

function switchScroll()
	scroll = not scroll
	gottenJiggy = jiggy
	
	jiggy = false
	
	if scroll then
		for i=4,7 do
			setStrumAngle(180, i)
		end
	else
		for i=4,7 do
			setStrumAngle(0, i)
		end
	end
	if downscroll == 1 then
		if scroll then
			strumVertOffset = -550
		else
			strumVertOffset = 0
		end
	else
		if scroll then
			strumVertOffset = 550
		else
			strumVertOffset = 0
		end
	end
	
	tweenPos("healthBar", getActorX("healthBar"), healthbarShits[0] - (strumVertOffset * 1.1), 0.25, 'cubeOut')
	tweenPos("healthBarBG", getActorX("healthBarBG"), healthbarShits[1] - (strumVertOffset * 1.1), 0.25, 'cubeOut')
	tweenPos("iconP1", getActorX("iconP1"), healthbarShits[2] - (strumVertOffset * 1.1), 0.25, 'cubeOut')
	tweenPos("iconP2", getActorX("iconP2"), healthbarShits[3] - (strumVertOffset * 1.1), 0.25, 'cubeOut')
	tweenPos("scoreTxt", getActorX("scoreTxt"), healthbarShits[4] - (strumVertOffset * 1.1), 0.25, 'cubeOut')
	
	for i=4,7 do
		setActorAngle(720, i)
		tweenPos(i, getActorX(i), _G['defaultStrum'.. i ..'Y'] + strumVertOffset, 0.25, 'cubeOut', 'jiggy = gottenJiggy')
		tweenAngle(i, 0, 0.5, 'cubeOut')
	end
	jigDir = not jigDir
end

function beatHit(beat) 
	if beat == 8 then
		tweenCameraZoom(0.8, 2, 'cubeOut')
	end
	
	if beat == 15 then
		tweenPos("girlfriend", ogGfPos, getActorY("girlfriend"), 5, 'cubeOut')
	end
	
	if beat == 124 then
		for i=4,7 do
			tweenPos(i, _G['defaultStrum'.. i ..'X'] - strumOffset, _G['defaultStrum'.. i ..'Y'] + strumVertOffset, 1, 'linear')
			tweenFade((i-4), 0, 1, 'linear')
		end
	end
	if beat > 127 and beat < 193 then
		jiggy = true
	else
		jiggy = false
	end
	
	if beat == 160 then
		switchScroll()
	end
	
	if beat == 192 then
		switchScroll()
	end
	
	if beat == 193 then
		for i=4,7 do
			tweenPos(i, _G['defaultStrum'.. i ..'X'], _G['defaultStrum'.. i ..'Y'] + strumVertOffset, 1, 'linear')
			tweenFade((i-4), 1, 1, 'linear')
		end
	end
	
	if jiggy then
		if beat % 16 > 13 then
			doTheJig(30, true)
		else 
			doTheJig(30, false)
		end
	end
	
	if beat == 352 then
		setActorX(5000, "girlfriend")
	end
end
