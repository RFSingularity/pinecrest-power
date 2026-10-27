AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Checkpoint Node"
ENT.Author = "The Singularity"
ENT.Category = "Pinecrest"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.maxHealth = 1500
ENT.isNode = true
ENT.canTransfer = false
ENT.prodConnected = false --[[ TODO: Will be put through a check
to see if this node is connected to a Production Node.]]

function ENT:SetupDataTables()

    self:NetworkVar( "Int", 0, "HP" ) -- Health Amount
    self:NetworkVar( "Bool", 1, "IsOn" ) -- Node on or off
    self:NetworkVar( "Bool", 2, "CanTransfer" ) -- Can it transfer power
    
end

if SERVER then

    function ENT:OnTakeDamage( dmginfo )
        local damage = dmginfo:GetDamage()
        self:GetHP(self:GetHP() - damage)
        if self:GetHP() <= 0 then
            self:SetIsOn( false )
            self:SetCanTransfer( false )
        end
    end

    function ENT:Initialize()
        self:SetModel( "models/vehicles/inner_pod_arm.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
        self:DrawShadow( true )
        self:SetHP( self.maxHealth )
        self.canTransfer = false
        local phys = self:GetPhysicsObject()
        phys:EnableMotion( false )
        
    end

end

if CLIENT then

    local red = Color( 255, 0, 0 )
    local green = Color( 0, 255, 0 )
    local yellow = Color( 255, 255, 0 )
    local material = Material("sprites/glow04_noz")
    function ENT:Draw( flags )
        self:DrawModel( flags )
        local lightColor = self:GetIsOn() and green or red
        lightColor = self:GetCanTransfer() and yellow or lightColor
        local lightPos = self:GetPos()
        local ang = self:GetAngles()

        lightPos:Add( ang:Forward() * -5 ) -- move it forward by X units
        lightPos:Add( ang:Right() * -10 ) -- move it right by X units
        lightPos:Add( ang:Up() * 20 )  -- move it up by X units
        local dlight = DynamicLight( self:EntIndex() )
	    if ( dlight ) then
		    dlight.pos = lightPos
		    dlight.r = lightColor.r
		    dlight.g = lightColor.g
		    dlight.b = lightColor.b
		    dlight.brightness = 1
		    dlight.decay = 1000
		    dlight.size = 256
		    dlight.dietime = CurTime() + 1
	    end
        render.SetMaterial( material )
        render.DrawSprite( lightPos, 10, 10, lightColor )


    end
end