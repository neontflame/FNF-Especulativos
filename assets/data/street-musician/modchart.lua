notePos = {}

function start(song) 
	for i=0,3 do
		notePos[i+1] = getActorX(i)
	end
end

function update (elapsed)
    
  
end

function stepHit(step) 
    if curStep == 444 then
		downArrowFunny('remove')
    end

    if curStep == 508 then
		downArrowFunny('restore')
    end

    if curStep == 540 then
		downArrowFunny('remove')
    end
end      
  
function downArrowFunny(yeah)
	if yeah == 'remove' then
		tweenPosXAngle(2, ((notePos[2] + notePos[3])/2), 0, 0.1, 'boblas')
		
		tweenPosXAngle(1, ((notePos[2] + notePos[3])/2), 0, 0.1, 'boablas')
		tweenFadeOut(1, 0, 0.1, 'boals')
	end
	
	if yeah == 'restore' then
		tweenPosXAngle(2, notePos[3], 0, 0.1, 'boalas')
		
		tweenPosXAngle(1, notePos[2], 0, 0.1, 'boalas2')
		tweenFadeOut(1, 1, 0.1, 'blobas2')
	end
end

function beatHit(beat) 

end



