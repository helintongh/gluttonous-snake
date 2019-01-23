local Body = class("Body")

local cGridSize = 33
local scaleRate = 1/display.contentScaleFactor

function Grid2Pos(x,y)--把逻辑坐标换成像素中的坐标
	local visibleSize = cc.Director:getInstance():getVisibleSize()
	local origin = cc.Director:getInstance():getVisibleOrigin()--初始点，中心点（0，0）

	local finalX = origin.x + visibleSize.width/2 + x*cGridSize*scaleRate
	local finalY = origin.y + visibleSize.height/2 + y*cGridSize*scaleRate

	return finalX,finalY

end


function Body:ctor(snake,x,y,node,isHead)
	self.snake = snake
	self.X = x--逻辑坐标
	self.Y = y

	if isHead then
		self.sp = cc.Sprite:create("head.png")
	else
		self.sp = cc.Sprite:create("body.png")
	end

	node:addChild(self.sp)
	
	self:Update()

end

function Body:Update()
	local posx,posy = Grid2Pos(self.X,self.Y)

	self.sp:setPosition(posx,posy)

end

return Body