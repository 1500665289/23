--鲸吞
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Magic_BeiMingJingTun");

function tbMagic:Init()
end

function tbMagic:TargetCheck(k, t)	
	local npc = t;
	if npc.IsPuppet or npc.IsZombie or not npc:CanResurrection()then
		return false;
	end
	if npc.IsDeath or npc.IsLingering then
		return true;
	end
	return false;
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
		if target ~= nil and not target:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_NOSOUL) then
			target:DestroySelf();
			self.bind.Needs:AddNeedValue("Practice", self.magic.Param2);
			WorldLua:PlayEffect("Effect/A/Prefabs/Projectiles/Fire/FireImpactNormal", target.Pos, 5);	
		end
	end	
end

function tbMagic:OnGetSaveData()
	return nil;	
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)	
	self.TargetID = IDs[0]
end
