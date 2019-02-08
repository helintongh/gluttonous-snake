local cGridSize = 33
local scaleRate = 1/display.contentScaleFactor

function Grid2Pos(x,y)--把逻辑坐标换成像素中的坐标
	local visibleSize = cc.Director:getInstance():getVisibleSize()
	local origin = cc.Director:getInstance():getVisibleOrigin()--初始点，中心点（0，0）

	local finalX = origin.x + visibleSize.width/2 + x*cGridSize*scaleRate
	local finalY = origin.y + visibleSize.height/2 + y*cGridSize*scaleRate

	return finalX,finalY

end

local Snake = require"app.Snake"
local AppleFactory = require"app.AppleFactory"
--local Body = require"app.Body"

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local cMoveSpeed = 0.3
local cBound = 7

function MainScene:onEnter()--MainScene幕布运行的函数
	--self.snake = Body.new(nil,0,0,self,false) --在点(0,0)显示身体
--	self.snake = Snake.new(self)
--	self.appleFactory = AppleFactory.new(cBound,self)

	self:Reset()

	self:ProcessInput()--控制函数

	local tick = function ()

		if self.stage == "running" then

			self.snake:Update()--蛇体更新后
		
			local headX,headY = self.snake:GetHeadGrid()--取出蛇头位置

			if self.appleFactory:CheckCollide(headX,headY) then--判断头的位置与苹果是否碰到

				self.appleFactory:Generate()--若碰到，苹果重生

				self.snake:Grow()--蛇长大
			end

			if self.snake:CheckSelfCollide() then
				self.stage = "dead"
				self.snake:Blink(function ()
					self:Reset()
				end)--死亡特效：闪烁，闪烁完后重置

				--self:Reset()--当蛇碰到自己时，场景重置
			end
		
		end

	end

	cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick,cMoveSpeed,false)--cocos2d的一个调度器

end

function MainScene:Reset()--场景重置，蛇死后操作

	if self.snake ~= nil then
		self.snake:Kill()--杀死蛇
	end

	if self.appleFactory ~= nil then
		self.appleFactory:Reset()
	end

	self.snake = Snake.new(self)
	self.appleFactory = AppleFactory.new(cBound,self)
	self.stage = "running"--RESET以后默认为运行状态

end


local function vector2Dir(x,y)--判断蛇方向
	if math.abs(x) > math.abs(y) then
		if x < 0 then--取x，y绝对值看往那边走，通过中心点判断
			return "left"
		else
			return "right"
		end
	else	
		if y < 0 then
			return "up"
		else
			return "down"
		end

	end		

end



function MainScene:ProcessInput( )--控制并处理输入

	local function onTouchBegan(touch,event)--回调函数
	
		local location = touch:getLocation()

		local visibleSize = cc.Director:getInstance():getVisibleSize()--取可视区域
		local origin = cc.Director:getInstance():getVisibleOrigin()--设置可视区域原点
	--通过与中心点的相对位置来判断方向
		local finaX = location.x-(origin.x + visibleSize.width / 2)--计算屏幕中心
		local finaY = location.y-(origin.y + visibleSize.height / 2)--计算屏幕中心

		local dir = vector2Dir(finaX,finaY)--将方向赋给蛇
		self.snake:SetDir(dir)

	end

	local listener = cc.EventListenerTouchOneByOne:create()--捕获输入
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)--注册一个句柄，通过句柄取访问该事件
	local eventDispatcher = self:getEventDispatcher()--关联listener和event，可以理解为监听事件
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)

end

function MainScene:onExit()
end

return MainScene
