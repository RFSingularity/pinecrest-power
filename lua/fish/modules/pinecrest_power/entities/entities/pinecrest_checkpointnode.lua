AddCSLuaFile()

ENT.Base = "base_anim" -- test
ENT.Type = "anim"
ENT.PrintName = "Checkpoint Node"
ENT.Author = "The Singularity"
ENT.Category = "Pinecrest"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.maxHealth = 150
ENT.isNode = true
ENT.canTransfer = false
ENT.prodConnected = false

function ENT:SetupDataTables()

    self:NetworkVar( "Int", 0, "HP" )
    self:NetworkVar( "Bool", 1, "IsOn" )
    self:NetworkVar( "Bool", 2, "canTransfer" )
    self:NetworkVar( "Bool", 3, "prodConnected")
    
end

if SERVER then

    function ENT:OnTakeDamage( dmginfo )
        local damage = dmginfo:GetDamage()
        self:setHP(self:getHP() - damage)
        if self:GetHP() <= 0 then
            self:SetIsOn( false )
            self.canTransfer = false
            self.prodConnected = false
        end
    end

    function ENT:Initialize()
        self:SetModel( "models/props_junk/TrafficCone001a.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType( SIMPLE_USE )
        self:DrawShadow( true )
        self:SetHP( self.maxHealth )
        self.canTransfer = false
        self.prodConnected = false
        local phys = self:GetPhysicsObject()
        phys:EnableMotion( false )
        
    end

    function ENT:Think()

        local rope = constraint.FindConstraintEntity( self, "Rope" )
        if IsValid( rope ) then

            local other = rope:GetConstrainedEntities()

            if IsValid( other ) and other.isNode and other.canTransfer then
                print("Connected to Node")
                if other.connectedNode and self:GetHP() >= 0 then
                    self:SetIsOn( true )
                    self.connectedNode = true
                    self.canTransfer = true
                end
            end

        elseif self.connectedNode then
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
        render.SetMaterial( material )
        render.DrawSprite( lightPos, 10, 10, lightColor )


    end
end