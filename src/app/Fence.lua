local Fence = class("Fence")--游戏障碍物,画一个方形


local function fenceGenerator(node,bound,callback)
	
	for i = -bound,bound do
		local sp = cc.Sprite:create("fence.png")
		local posx,posy = callback(i)
		sp:setPosition(posx,posy)
		node:addChild(sp)
	end

end

function Fence:ctor(bound,node)--构造函数
	self.bound = bound
	--上部围墙
	fenceGenerator(node,bound,function (i)
		return Grid2Pos(i,bound)--逻辑坐标转化为实际坐标
	end)

	--下部的墙
	fenceGenerator(node,bound,function (i)
		return Grid2Pos(i,-bound)--逻辑坐标转化为实际坐标
	end)
	--左边的墙
	fenceGenerator(node,bound,function (i)
		return Grid2Pos(bound,i)--逻辑坐标转化为实际坐标
	end)
	--右边的墙
	fenceGenerator(node,bound,function (i)
		return Grid2Pos(-bound,i)--逻辑坐标转化为实际坐标
	end)


end

function Fence:CheckCollide(x,y)--墙壁碰撞检测
	return x == self.bound or x == -self.bound or y == self.bound or y == -self.bound
	--传入坐标和边界比较
	
end



return Fence