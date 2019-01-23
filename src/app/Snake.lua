--构建完整的蛇的行为
local Snake = class("Snake")--声明蛇类
local Body = require ("app.Body")

local cInitLen = 3--初始长度3



function Snake:ctor(node)--构造函数

	self.BodyArray = {}--保存蛇身,蛇身是长串
	self.node = node
	self.MoveDir = "left"--移动方向

	for i =1,cInitLen do--蛇初始化
		self:Grow(i==1)
	end

end

function Snake:GetTailGrid()--尾巴上的格子:蛇从尾部长长函数
	if #self.BodyArray == 0 then
		return 0,0--蛇身为0时
	end

	local tail = self.BodyArray[#self.BodyArray]--返回最大长度。lua数组从一开始，最大元素是size

	return tail.X,tail.Y--返回蛇的位置

end



function Snake:Grow(isHead)--长长函数，self即是蛇体本身
	local tailX,tailY = self:GetTailGrid()
	local body = Body.new(self,tailX,tailY,self.node,isHead)

	table.insert(self.BodyArray,body)--长长的身体插入蛇类数组里

end

local function OffsetGridByDir(x,y,dir)--根据方向修改坐标的函数
	if dir == "left" then
		return x-1,y
	elseif dir == "right" then
		return x+1,y
	elseif dir == "up" then
		return x,y-1
	elseif dir == "down" then
		return x,y+1--cocos2d下为+
	end

	print("unknown dir",dir)--差错处理

	return x,y--原样返回

end

function Snake:Update()--蛇行为更新：即是蛇的移动函数

	if #self.BodyArray == 0 then
		return --蛇身为0时
	end

	--蛇的身体倒着循环从尾巴开始 YXXX  若Y是蛇头，看着是头先动其实是尾巴先动
	for i = #self.BodyArray,1,-1 do

		local body = self.BodyArray[i]--倒叙取出每一位身体

		if i == 1 then--i=1是为头部，头部直接移动
			body.X,body.Y = OffsetGridByDir(body.X,body.Y,self.MoveDir)--根据方向修改坐标的函数
		else--身体其它部分，取身体前面一个即可

			local font = self.BodyArray[i-1]
			body.X,body.Y = font.X,font.Y

		end

		body:Update()--更新蛇身，从逻辑到现实
	
	end
			
end


return Snake