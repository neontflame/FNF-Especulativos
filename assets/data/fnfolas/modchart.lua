function start(song) 
end

function update (elapsed)
end

function stepHit(step) 
end

function arrowFunny(yeah, timer, tween)
	if centeredNotes == 0 then
		if yeah == 'remove' then
			for i=0,3 do
				tweenPos(i, _G['defaultStrum'.. i ..'X'] + 325, getActorY(2), timer, tween)
				tweenFade(i, 0, timer, tween)
			end
			
			for i=4,7 do
				tweenPos(i, _G['defaultStrum'.. i ..'X'] - 325, getActorY(2), timer, tween)
			end
			
		end
		
		if yeah == 'restore' then
			for i=0,3 do
				tweenPos(i, _G['defaultStrum'.. i ..'X'], getActorY(2), timer, tween)
				tweenFade(i, 1, timer, tween)
			end
			
			for i=4,7 do
				tweenPos(i, _G['defaultStrum'.. i ..'X'], getActorY(2), timer, tween)
			end
		end
	end
end

function beatHit(beat) 
    if curBeat == 96 then
		arrowFunny('remove', 2.4, 'cubeInOut')
		tweenCameraZoom(1.125, 14)
    end

    if curBeat == 256 then
		arrowFunny('remove', 1.2, 'cubeOut')
		tweenCameraZoom(0.9, 14)
    end
	
    if curBeat == 128 or curBeat == 288 then
		arrowFunny('restore', 0.5, 'cubeOut')
		tweenCameraZoom(0.7, 0.5, 'cubeOut')
    end
end



