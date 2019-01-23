local Snake = require"app.Snake"
--local Body = require"app.Body"

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local cMoveSpeed = 0.3

function MainScene:onEnter()
	--self.snake = Body.new(nil,0,0,self,false) --在点(0,0)显示身体
	self.snake = Snake.new(self)

	local tick = function ()
		self.snake:Update()
	end

	cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick,cMoveSpeed,false)--cocos2d的一个调度器

end

function MainScene:onExit()
end

return MainScene
