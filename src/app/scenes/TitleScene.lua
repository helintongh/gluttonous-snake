local  TitleScene = class("TitleScene",function ()
	return display.newScene("TitleScene")
	-- body
end)
--对创建按钮进行封装
local function createStaticButton(node,imageName,x,y,callback)
	cc.ui.UIPushButton.new({normal=imageName,pressed=imageName})--插入图片作为按钮
	:onButtonClicked(callback)
	:pos(x,y)
	:addTo(node)
end

function TitleScene:onEnter()
	display.newSprite("bg.png")--创建新的精灵类
	:pos(display.cx,display.cy)--位置在cx，cy即是x，y轴中心
	:addTo(self)--加入一层,self即是TitleScene
	-- 创建按钮
	--[[cc.ui.UIPushButton.new({normal="btn_start.png",pressed="btn_start.png"})--插入图片作为按钮
	:onButtonClicked(function ()
		print("clicked")
		end)
	:pos(display.cx,display.cy)
	:addTo(self)--]]

	createStaticButton(self,"btn_start.png",display.cx,display.cy/2,function ()
		print("start")
		local s = require("app.scenes.MainScene").new()
		--require加载一个文件""代码中便是实现加载到MainScene场景，new（）作用是实例化
		display.replaceScene(s,"fade",0.6,display.COLOR_BLACK)
		--用s替换当前TitleScene场景，“fade”是淡出的意思，0.6s时间切换
	end)
	createStaticButton(self,"btn_option.png",display.cx-200,display.bottom+80,function( ... )
		print("option")
	end)
	createStaticButton(self,"btn_question.png",display.cx,display.bottom+80,function( ... )
		print("question")
	end)
	createStaticButton(self,"btn_exit.png",display.cx+200,display.bottom+80,function( ... )
		print("exit")
	end)
end

return	TitleScene