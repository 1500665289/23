--鲸吸
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Magic_BeiMingJingXi");

function tbMagic:Init()
end

function tbMagic:TargetCheck(k, t)	
	local npc = t;
	if npc.IsPuppet or npc.IsZombie or npc.IsDeath  then
		return false;
	end
	return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
	self.TargetID = IDs[0];
end

function tbMagic:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function tbMagic:MagicLeave(success)	
	if success == true then
		local target = ThingMgr:FindThingByID(self.TargetID)
		if target ~= nil then
            if target.MaxLing > (self.bind.MaxLing - self.bind.LingV) then
                self.bind:AddLing(self.bind.MaxLing - self.bind.LingV);
            else
                self.bind:AddLing(target.MaxLing);
            end
            target:AddLing(-target.LingV)
			self.bind:AddModifier(self.magic.sParam1)
			WorldLua:PlayEffect("Effect/A/Prefabs/Projectiles/Fire/FireImpactNormal", target.Pos, 5);
            target:DestroySelf();
		end
	end	
end

function tbMagic:OnGetSaveData()
	return nil;	
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)	
	self.TargetID = IDs[0]
end
