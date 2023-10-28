xixi = 0

function start(song) 
    background = makeSprite('white','white',true)
    setActorAlpha(0,background)
    setActorX(600,background)
    setActorY(600,background)
    setActorScale(10,background)
end

function beatHit(beat)
	xixi = curBeat / 4
	if xixi == 35 or xixi == 71 or xixi == 103 or xixi == 135 then
	tweenFadeIn(background,0.25,60/bpm*4)
	tweenCameraZoom(1, 60/bpm*4)
	end
	
	if xixi == 36 or xixi == 72 or xixi == 104 or xixi == 136 then
	tweenFadeIn(background,1,0.005)
	tweenFadeOut(background,0,60/bpm*4)
	tweenCameraZoom(0.8, 60/bpm*4)
	end
end