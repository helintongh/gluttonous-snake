--构建完整的蛇的行为
local Snake = class("Snake")--声明蛇类
local Body = require ("app.Body")

local cInitLen = 3--初始长度3



function Snake:ctor(node)--构造函数

	self.BodyArray = {}--保存蛇身,蛇身是长串
	self.node = node
	--self.MoveDir = "left"--移动方向

	for i =1,cInitLen do--蛇初始化
		self:Grow(i==1)
	end

	self:SetDir("left")--用函数封装性更高

end

function Snake:GetTailGrid()--尾巴上的格子:蛇从尾部长长函数
	if #self.BodyArray == 0 then
		return 0,0--蛇身为0时
	end

	local tail = self.BodyArray[#self.BodyArray]--返回最大长度。lua数组从一开始，最大元素是size

	return tail.X,tail.Y--返回蛇的位置

end

function Snake:GetHeadGrid( ... )--蛇头吃苹果
	if #self.BodyArray == 0 then
		return nil--蛇头为0时，直接报错
	end

	local head = self.BodyArray[1]--返回最大长度。lua数组从一开始，最大元素是size

	return head.X,head.Y--返回蛇的位置

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

local hvTable = {--用来限制蛇的行为，蛇不能穿越自己的身体，h代表横着走，v代表纵
	["left"] = "h",
	["right"] = "h",
	["up"] = "v",
	["down"] = "v",
}

local rotTable = {--调整蛇的头
	["left"] = 90,
	["right"] = -90,
	["up"] = 0,
	["down"] = 180,
	
}

function Snake:SetDir(dir)

	if hvTable[dir] == hvTable[self.MoveDir] then
		return
	end

	self.MoveDir = dir

	local head = self.BodyArray[1]
	head.sp:setRotation(rotTable[self.MoveDir])
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

function Snake:CheckSelfCollide()--判断是否碰撞到自己
	-- body
	if #self.BodyArray <2 then--小于两节，仅有头是不能碰撞到自己的
		return
	end

	local headX,headY = self:GetHeadGrid()

	for i = 2,#self.BodyArray do--将身体和头部坐标比较，若相同则碰撞到了

		local body = self.BodyArray[i]
		if body.X == headX and body.Y == headY then
			return true
		end	

	end

	return false

end

function Snake:Kill()--重置场景删除蛇
	
	for _,body in ipairs(self.BodyArray) do--用迭代器遍历数组

		self.node:removeChild(body.sp)--删除body的精灵，杀死蛇
	end

end

function Snake:Blink(callback)--死亡闪烁特效，函数结束后调用callback

	for index,body in ipairs(self.BodyArray) do

		local blink = cc.Blink:create(3,5)--Blink是cocos2d中提供的一种动作,第一个参数是闪烁时间，第二个为闪烁次数

		if index == 1 then --判断是蛇头时
			local a = cc.Sequence:create(blink,cc.CallFunc:create(callback))--创建一个序列的动作，把blink和callback调用和在一起顺序执行
			body.sp:runAction(a)
		else
			body.sp:runAction(blink)

		end	
	end

	
end


return Snake