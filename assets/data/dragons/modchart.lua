xixi = 0

function start(song) 
    background = makeSprite('white','white',false)
    setActorAlpha(0,background)
    setActorX(600,background)
    setActorY(600,background)
    setActorScale(10,background)
	
    blackground = makeSprite('black','black',false)
    setActorAlpha(0,blackground)
    setActorX(600,blackground)
    setActorY(600,blackground)
    setActorScale(10,blackground)
end

function beatHit(beat)
	xixi = (beat/4) + 1 --fl studio porque nao usas beats com base no 0
	print(xixi)
	
	if xixi == 56.25 or xixi == 88 or xixi == 122 or beat == 676 then
		tweenFade(background,0.75,60/bpm*4,'cubeIn')
		tweenCameraZoom(1, 60/bpm*4,'cubeIn')
	end
	
	if xixi == 57 or xixi == 89 or xixi == 123 or beat == 680 then
		setHealth(1)
		setActorAlpha(1,background)
		tweenFade(background,0,60/bpm*4,'cubeOut')
		tweenCameraZoom(0.8, 60/bpm*4,'cubeOut')
	end
	
	if beat == 916 then
		tweenCameraZoom(1, 13,'cubeInOut')
	end
	
	if beat == 944 then
		tweenFade(blackground,1,4,'linear')
	end
end