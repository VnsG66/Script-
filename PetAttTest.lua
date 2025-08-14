-- PetAttractor.lua (Standalone with RefreshPets)
local RunService = game:GetService("RunService")

local PetAttractor = {}
PetAttractor.__index = PetAttractor

function PetAttractor.new(originPart, petFolder, radius, pulseInterval, overrideCooldown)
	local self = setmetatable({}, PetAttractor)
	self.Origin = originPart
	self.PetFolder = petFolder
	self.Pets = petFolder:GetChildren()
	self.Radius = radius or 18
	self.PulseInterval = pulseInterval or 25
	self.OverrideCooldown = overrideCooldown or false
	self.LastPulse = 0
	self._conn = nil
	return self
end

function PetAttractor:RefreshPets()
	self.Pets = self.PetFolder:GetChildren()
end

function PetAttractor:Pulse()
	local now = tick()
	if now - self.LastPulse < self.PulseInterval then return end
	self.LastPulse = now

	for _, pet in ipairs(self.Pets) do
		if pet:IsA("Model") and pet:FindFirstChild("PrimaryPart") then
			local distance = (pet.PrimaryPart.Position - self.Origin.Position).Magnitude
			if distance <= self.Radius then
				if self.OverrideCooldown then
					pet:SetAttribute("Cooldown", 0)
				end
				self:Attract(pet)
			end
		end
	end
end

function PetAttractor:Attract(pet)
	local humanoid = pet:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:MoveTo(self.Origin.Position)
	end
end

function PetAttractor:Start()
	self._conn = RunService.Heartbeat:Connect(function()
		self:Pulse()
	end)
end

function PetAttractor:Stop()
	if self._conn then
		self._conn:Disconnect()
		self._conn = nil
	end
end

return PetAttractor