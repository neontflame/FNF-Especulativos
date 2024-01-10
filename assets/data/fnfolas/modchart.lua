function start(song) 
end

function update (elapsed)
end

function stepHit(step) 
end

function beatHit(beat) 
    if curBeat == 96 then
		tweenCameraZoom(1.125, 14)
    end

    if curBeat == 256 then
		tweenCameraZoom(0.9, 14)
    end
	
    if curBeat == 128 or curBeat == 288 then
		tweenCameraZoom(0.7, 0.5, 'cubeOut')
    end
end



