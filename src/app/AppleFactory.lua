local AppleFactory = class("AppleFactory")

function AppleFactory:ctor(bound,node)--苹果生成范围
	
	self.bound = bound
	self.node = node--图形结点

	math.randomseed(os.time())--随时间随机生成苹果

	self:Generate()--随机生成函数

end

local function getPos(bound)--将一维变为两维刚好作为坐标
	return math.random(-bound,bound)--将苹果生成位置封装
end

function AppleFactory:Generate()--生成苹果函数
	
	if self.appleSprite ~=nil then --防止精灵不断生成，apple不断占用内存
		self.node:removeChild(self.appleSprite)
	end

	local sp = cc.Sprite:create("apple.png")

	local genBoundLimit = self.bound - 1--边界限制,比实际范围少一个

	local x,y = getPos(genBoundLimit),getPos(genBoundLimit)--生成苹果逻辑坐标,在地图之类
 	local finalX,finalY = Grid2Pos(x,y)--生成苹果范围

 	sp:setPosition(finalX,finalY)
 	self.node:addChild(sp)

 	self.appleX = x
 	self.appleY = y

 	self.appleSprite = sp

end

function AppleFactory:CheckCollide( x,y)--检查蛇头是否碰到苹果，蛇是否吃到
	
	if x == self.appleX and y == self.appleY then
		return true
	end

	return false

end

function AppleFactory:Reset()--重置场景，删除苹果
	self.node:removeChild(self.appleSprite)
end

return AppleFactory