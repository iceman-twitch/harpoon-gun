
if SERVER then AddCSLuaFile() end

ENT.Base = "base_entity"
ENT.Type = "point"
ENT.Spawnable = true
ENT.PrintName = "Harpoon Gun"
ENT.Category = "Other"
ENT.Prop = ENT.Prop or NULL
ENT.PropPhys = ENT.PropPhys or NULL
ENT.EntityModel = "models/props_junk/harpoon002a.mdl"
ENT.ParticlesList = {
    "blood_zombie_split_spray_tiny2",
	"blood_zombie_split_spray_tiny",
	"blood_zombie_split_spray",
}

function ENT:Initialize()
	if SERVER then
		local prop = ents.Create( "prop_physics" )
		prop:SetModel( self.EntityModel )
		prop:SetPos( self:GetPos() )
		prop:Spawn()
		prop:Activate()
		prop:SetName( "harpoon_gun" )
		prop.PropParent = self:EntIndex()
		local phys = prop:GetPhysicsObject()
		phys:Wake()
		self.Prop = prop
		self.PropPhys = phys
		self:SetParent(prop)

		local function PhysCallback( ent, data ) -- Function that will be called whenever collision happends
			if data and data.HitEntity and data.HitEntity:IsPlayer() and data.Speed > 200 then
				local ply = data.HitEntity
				local boneid = ply:LookupBone( "ValveBiped.Bip01_Head1" )
				ent:EmitSound("npc/stalker/go_alert2.wav")
				ent:SetMoveType( MOVETYPE_NONE )
				ent:SetSolid(0)
				ent:SetPos( ply:GetPos() + Vector( 0, 0, 45 ))
				ent:SetParent( ply, boneid )
				ent:SetColor( Color( 255, 0, 0) )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,0), NULL )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,80), NULL )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,170), NULL )
				ParticleEffect( "blood_zombie_split_spray", ent:GetPos(), Angle(60,0,170), NULL )
				ParticleEffect( "blood_zombie_split_spray", ent:GetPos(), Angle(90,20,190), NULL )
				ParticleEffect( "blood_zombie_split_spray", ent:GetPos(), Angle(60,66,170), NULL )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,0), NULL )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,80), NULL )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,170), NULL )
				ParticleEffect( "blood_zombie_split_spray", ent:GetPos(), Angle(60,0,122), NULL )
				ParticleEffect( "blood_zombie_split_spray", ent:GetPos(), Angle(90,20,144), NULL )
				ParticleEffect( "blood_zombie_split_spray", ent:GetPos(), Angle(60,66,155), NULL )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,33), NULL )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,99), NULL )
				ParticleEffect( "blood_zombie_split_spray_tiny2", ent:GetPos(), Angle(0,0,199), NULL )
				
				timer.Simple( 2, function() ply:Kill() Entity( ent.PropParent ):Remove() end)
			end
		end

		self.Prop:AddCallback( "PhysicsCollide", PhysCallback )
		self.Prop:AddCallback( "GravGunPunt", function( ply )
		end )

	end

	PrecacheParticleSystem( "blood_zombie_split_spray_tiny2" )
	PrecacheParticleSystem( "blood_zombie_split_spray_tiny" )
	PrecacheParticleSystem( "blood_zombie_split_spray" )

end

function ENT:Think()

	if SERVER then -- Only set this stuff on the server

		self:NextThink( CurTime() ) -- Set the next think for the serverside hook to be the next frame/tick
		return true -- Return true to let the game know we want to apply the self:NextThink() call

	end

end

function ENT:OnRemove()

	if SERVER then

		self.Prop:Remove()

	end

end