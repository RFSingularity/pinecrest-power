AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Production Node"
ENT.Author = "The Singularity"
ENT.Category = "Pinecrest"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.powerInterval = 1
ENT.maxPower = 10000
ENT.transferRate = 1
ENT.maxHealth = 10000
ENT.isNode = true
ENT.connectedNode = true
ENT.canTransfer = true

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "HP" ) -- Health
    self:NetworkVar( "Bool", 1, "IsOn" ) -- ON/OFF
    self:NetworkVar( "Int", 2, "PowerLevel") -- PowerLevel

end

if SERVER then

    function ENT:OnTakeDamage( dmginfo )
        local damage = dmginfo:GetDamage()
        self:SetHP(self:GetHP() - damage)
        if self:GetHP() <= 0 then
            self:SetIsOn( false )
            self.connectedNode = false
            self.CanTransfer = false
        end
    end

    function ENT:Initialize()
        self:SetModel( "models/props_combine/combine_generator01.mdl" ) --Model needs to be added to content.
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
        self:DrawShadow( true )
        self:SetHP( self.maxHealth )
        self:SetPowerLevel( 0 )
        self:SetIsOn( true )
        local phys = self:GetPhysicsObject()
        phys:EnableMotion( false )
    end


    -- this is your Update() function, it runs
    -- every frame for this entity.
    function ENT:Think()

        local rope = constraint.FindConstraintEntity( self, "Rope" )

        self:NextThink( CurTime() + self.powerInterval )
        if IsValid( rope ) then
            local other = rope:GetConstrainedEntities()

            if self:GetPowerLevel() < self.maxPower and self:GetIsOn() then
                self:SetPowerLevel(self:GetPowerLevel() + 1 )
                
            end
        
            -- REMINDME: STOP ADDING POWER WHEN CONNECTED!

        end

        return true
    end


    
    function ENT:Use( client )
        
    end
end


if CLIENT then
   

    local red = Color( 255, 0, 0 )
    local green = Color( 0, 255, 0 )
    local material = Material("sprites/glow04_noz")
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
