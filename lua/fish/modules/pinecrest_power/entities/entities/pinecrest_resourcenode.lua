AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Resource Node"
ENT.Author = "The Singularity"
ENT.Category = "Pinecrest"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.maxHealth = 5000
ENT.maxPower = 5000
ENT.transferRate = 1
ENT.isNode = true

function ENT:SetupDataTables()

    self:NetworkVar( "Int", 0, "HP")
    self:NetworkVar( "Bool", 1, "IsOn")
    self:NetworkVar( "Int", 2, "PowerLevel" )
    self:NetworkVar( "Bool", 3, "CanTransfer")
    self:NetworkVar( "Bool", 4, "ConnectedNode")

end

if SERVER then
   
    function ENT:OnTakeDamage( dmginfo )
        local damage = dmginfo:GetDamage()
        self:SetHP(self:GetHP() - damage)
        if self:GetHP() <= 0 then
            self:SetIsOn( false )
        end
    end

    function ENT:Initialize()
        self:SetModel( "models/props_combine/combine_intwallunit.mdl" )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
        self:DrawShadow( true )
        self:SetHP( self.maxHealth )
        self:SetPowerLevel( 0 )
        self:SetIsOn( false )
        self:SetCanTransfer( false )
        local phys = self:GetPhysicsObject()
        phys:EnableMotion( false )

    end

    function ENT:Think()

    
        local rope = constraint.FindConstraintEntity(self, "Rope")
        if IsValid( rope ) then
        
            local other = rope:GetConstrainedEntities()

            if IsValid( other ) and other.isNode and other.canTransfer then

                if other.canTransfer and other.connectedNode then -- Connected Node = Production Node is in series.
                    self:SetIsOn( true )
                    if self:GetPowerLevel() < self.maxPower then
                        self:SetPowerLevel(self:GetPowerLevel() + self.transferRate)
                    end

                end
            end

        elseif self:GetIsOn() then
            self.connectedNode = false
            self.canTransfer = false
            self:SetIsOn( false )
        end
    end

    function ENT:Use( client )

    end
end

if CLIENT then

    local red = Color( 255, 0, 0 )
    local green = Color( 0, 255, 0 )
    local material = Material( "sprites/glow04_noz" )
    function ENT:Draw( flags )
        self:DrawModel( flags )
        local lightColor = self:GetIsOn() and green or red
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
        render.SetMaterial(material)
        render.DrawSprite( lightPos, 10, 10, lightColor)

    end
end