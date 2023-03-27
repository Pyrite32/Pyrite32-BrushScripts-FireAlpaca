-- variation refers to the number of eap subdivisions to be created.


function param1()
return "Minimum Width", 0, 100, 10
end


-- refers to the number of divisions performed on Eaps.
-- the more divisions, the more wobbly the brush may become, as interpolations from
-- one point to the next are shorter.
function param2()
return "Wobbliness", 1, 10, 2
end

-- performs a leveling operation on each eap.
-- this creates two clones of the eap, on each side of the original, separated by a distance
-- determined by this parameter.
-- min : 0
-- max: 25%

function param3()
return "Sharpness", 0, 10, 8
end

-- randomizes each initialized point's value within a certain bracket.
-- min : 0
-- max: 0.1

function param4()
return "Randomness", 0, 10, 3
end

function param5()
return "Opacity from Width", 0, 1, 0
end



function main( x, y, p )

  local w = bs_width_max()
  local updateDist = w / 15
  if not firstDraw then
    local distance = bs_distance( lastDrawX - x, lastDrawY - y )
    if distance < updateDist then return 0 end
  end
  table.insert( hits, { x = x, y = y } );
  local r,g,b = bs_fore()
  local a = bs_opacity() * 255
  bs_ellipse( x, y, w, w, 0, r, g, b, a )
  lastDrawX = x
  lastDrawY = y
  firstDraw = false
  return 1

end

function draw(x, y, percent_width)
	local r,g,b = bs_fore()
	local width = percent_width * bs_width_max()
	
       local alpha = bs_opacity() * 255
	if bs_param5() == 1 then
 			alpha = alpha * percent_width
		 end 

	bs_ellipse(x, y, width, width, 0, r, g, b, alpha )
end

function last( x, y, p )

	bs_reset()

	local pointCount = #hits
	bs_debug_log("hits : " .. pointCount)

	--instead of using sin^2 x to make the stroke, use easing points instead.
	-- percent_width is an eased interpolation between two easing points.
	-- if connections is enabled, set the value of the start and end easing points to be 1 instead of zero if a pixel is read there.

	-- add start and finish
	local startval = 0

	min_width = bs_param1() / 100
	bs_debug_log(min_width)

	-- position is progress basically,
	-- value is the value to which to interpolate
	-- control is the easing value.

	table.insert( eaps, { pos = 0, value = min_width} )
	table.insert( eaps, { pos = 0.5, value = 1 } )
	table.insert( eaps, { pos = 1, value = min_width} )

	
	if pointCount > 250 then
		shape_stroke()
	end

  	local currentW = 0



  	for index , point in ipairs( hits ) do
		local location = index / pointCount
		-- first, get the base fade.
		local percent_width = get_eaps_interpolant_val(location)
     		--next, multiply it by the natural stroke variance.
		percent_width = math.max ( math.min ( percent_width, 1) , min_width)
		draw(point.x, point.y, percent_width)
    --ignore above.
  	end

end

function shape_stroke()

	-- create eaps according to divisions:
	-- 1 - 3 eaps
	-- 2 - 4 eaps
	-- 3 - 5 eaps
	-- 4 - 6 eaps...
	local divs = bs_param2()
	local div_delta = 1 / (divs+1)

	-- deaping should be done BEFORE everything to ensure real stability
	-- since everything is still centered around the shitty default curve, you need stability to ensure more maximums.
	-- deaping is global.

	-- todo : edit wobbliness so that it adds more divisions the higher the hit count is.


	divs = divs + math.floor ( (#hits -400) / 400 )

	local deapwidth =  lerp(0, 0.40, 1 - (bs_param3() / 10) )
	bs_debug_log("deaw ==  " .. deapwidth)
	table.insert( eaps, { pos = 0.5 - deapwidth, value = 1 } )
	table.insert( eaps, { pos = 0.5 + deapwidth, value = 1 } )
	
	table.sort(eaps , function (a, b) return a.pos < b.pos end)

	for i = 1 , divs do
		local location = div_delta * i
		local new_val = get_eaps_interpolant_val(location)

		if bs_param4() > 0 then
			local bracket = bs_param4() / 15
			local rvalue = 2 * bracket * math.random()

			new_val = new_val - bracket + rvalue
		end
		table.insert( eaps, { pos = location, value = new_val } )
	end
	-- the midpoint was just around to assist with initializing values.
	-- we don't need it anymore.
	
		table.sort(eaps , function (a, b) return a.pos < b.pos end)
	flag_for_deletion = {}
	local leap = nil
	for i = 2 , #eaps do
		leap = eaps[i-1]
		 if eaps[i].pos - 0.02 <= leap.pos and
		    eaps[i].pos + 0.02 >= leap.pos then
			table.insert( flag_for_deletion, i )
		end	
	end
	for _, point in ipairs( flag_for_deletion ) do
		table.remove( eaps, point )
	end
	deleap(1)
	table.insert( eaps, {pos = 1, value = 0 } )
	
end

-- edit an eap according to its progress
function eapset( location, new_value)
	for idx , eap in ipairs( eaps ) do
		if eap.pos == location then
			eap.value = new_value
			break
		end
	end
end

function deleap( location)
	for idx , eap in ipairs( eaps ) do
		if eap.pos == location then
			table.remove(eaps, idx)
			break
		end
	end
end

function get_eaps_interpolant_val(progress)
--scan through the eaps table, find the first eap (make sure that:
-- eap < progress < eapnext
	local max = #eaps
	local eval_first = 0
	local eval_end = 0
	local eval_end_pos = 0
	local eval_start_pos = 0
	--bs_debug_log("Eap count == " .. max)
	--bs_debug_log("progress == " .. progress)
	local leap = eaps[1]
	for idx , eap in ipairs( eaps ) do
		-- if the index is equal to max, get out of the thing
		if idx >=  max then
			--bs_debug_log("eapv reached")
			eval_first = eaps[idx-1].value	
			eval_end = eap.value
			eval_start_pos = eaps[idx-1].pos
			eval_end_pos = eap.pos
			break
		end		
		
		--bs_debug_log("index is " .. idx .. " and its progress is " .. eap.pos )
		if eap.pos >= progress then
			--bs_debug_log("this pos is greater than prog")
			eval_end = eap.value
			eval_end_pos = eap.pos
			if idx <= 1 then
				eval_first = eap.value
				eval_start_pos = eap.pos
			else
				--bs_debug_log("prev_vals")
				eval_first = leap.value	
				eval_start_pos = leap.pos
			end
			break
		end
		
		leap = eap

	end
	-- ignore the easing for now, just interpolate.
	-- value is equal to progress / (eval_end_pos - eval_end_start)
	--bs_debug_log("start pos ==" .. eval_end_pos)
	--bs_debug_log("end pos ==" .. eval_end_pos)
	local val = (progress - eval_start_pos) / (eval_end_pos - eval_start_pos)
	if eval_start_pos == eval_end_pos then
		val = 1
	end
	--bs_debug_log(" value interpreted as " .. val )
	local result = lerp (eval_first, eval_end, val )
	--bs_debug_log("Lerped result = " .. result)
	return result
	-- do the interpolation

end

function lerp( start, ending, value)
	return value * (ending-start) + start
end


-- pre-draw
hits = {}
eaps = {}

lastDrawX = 0
lastDrawY = 0
firstDraw = true

--post-draw
math.randomseed(bs_ms()*999999)
bs_setmode(1)
rand_factor = math.random(75,100) / 100

