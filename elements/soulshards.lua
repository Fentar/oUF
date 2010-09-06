local CC = select(4, GetBuildInfo()) == 4e4
if(not CC) then return end

if(select(2, UnitClass('player')) ~= 'WARLOCK') then return end

local parent, ns = ...
local oUF = ns.oUF

local SHARD_BAR_POWER_INDEX = SHARD_BAR_POWER_INDEX
local SHARD_BAR_NUM_SHARDS = SHARD_BAR_NUM_SHARDS

local Update = function(self, event, unit)
	if(self.unit ~= unit or powerType ~= 'SOUL_SHARDS') then return end

	local ss = self.SoulShards
	if(ss.PreUpdate) then ss:PreUpdate(unit) end

	local num = UnitPower(unit, SHARD_BAR_POWER_INDEX)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if(i <= num) then
			ss[i]:SetAlpha(1)
		else
			ss[i]:SetAlpha(0)
		end
	end

	if(ss.PostUpdate) then
		return ss:PostUpdate(unit)
	end
end

local Path = function(self, ...)
	return (self.SoulShards.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'SOUL_SHARDS')
end

local function Enable(self)
	local ss = self.SoulShards
	if(ss) then
		ss.__owner = self
		ss.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)

		return true
	end
end

local function Disable(self)
	local ss = self.SoulShards
	if(ss) then
		self:UnregisterEvent('UNIT_POWER', Path)
	end
end

oUF:AddElement('SoulShards', Path, Enable, Disable)
