function param1()
return "Minimum width", 0, 50, 15
end

function param2()
return "Sharpness", 0, 20, 10
end

function param3()
return "Opacity", 0, 1, 1
end


function main( x, y, p )

  if firstDraw then
    firstDrawX = x
    firstDrawY = y
  end

  local w = bs_width_max()

  local updateDist = w / 9
  if w > 20 then
    updateDist = w/13
  end
  if w > 100 then
    updateDist = w/15
  end

  if not firstDraw then
    local distance = bs_distance( lastDrawX - x, lastDrawY - y )
    if distance < updateDist then
      return 0
    end
  end

  table.insert( pts, { x = x, y = y } );

  local r,g,b = bs_fore()
  local a = bs_opacity() * 255

  bs_ellipse( x, y, w, w, 0, r, g, b, a )

  lastDrawX = x
  lastDrawY = y
  firstDraw = false

  return 1

end

function last( x, y, p )

  bs_reset()

  local strokeSize = tablelength(pts)
  local r,g,b = bs_fore()
  

  local minimum = (bs_param1() / 100) * bs_width_max()
  local currentW = 0
  for index, point in ipairs( pts ) do
     --ignore below:
       local a = bs_opacity() * 255
	local strokeCompletion = index / strokeSize
	currentW = width_eq(strokeCompletion) * bs_width_max()
	currentW = math.max(currentW, minimum)
	if currentW < 1 then currentW = 0 end
       if bs_param3() == 1 then a = a * width_eq(strokeCompletion) end 
     bs_ellipse(point.x, point.y, currentW, currentW, 0, r, g, b, a )
    --ignore above.
  end

end

function width_eq(x)
local pow = bs_param2() / 10  * rand_factor
return math.sin(x*math.pi)^pow
end


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

pts = {}
math.randomseed(bs_ms()*100000000000)
lastDrawX = 0
lastDrawY = 0
bs_setmode(1)
rand_factor = math.random(75,100) / 100
firstDraw = true
