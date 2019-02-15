
require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
	cc.Director:getInstance():setContentScaleFactor(640/CONFIG_SCREEN_HEIGHT)
    cc.FileUtils:getInstance():addSearchPath("res/")
    --self:enterScene("MainScene")
    self:enterScene("TitleScene")--选择进入时的层
end


return MyApp
