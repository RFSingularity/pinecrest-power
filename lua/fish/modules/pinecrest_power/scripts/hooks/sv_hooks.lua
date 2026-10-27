local nextThink = 0

--- @param ent Entity
--- @return boolean
local function endsInResource( ent )
    local rope = constraint.FindConstraintEntity( ent, "Rope" )
    if not IsValid( rope ) then return false end

    local ent1, ent2 = rope:GetConstrainedEntities()
    local other = (ent == ent1 and ent2) or ent1

    if not IsValid( other ) then return false end -- really shouldn't happen

    if other:GetClass() == "pinecrest_resourcenode" then
        return true
    else
        return endsInResource( other )
    end
end

--- @param node Entity
--- @return Entity?
local function getNext( node )
    local rope = constraint.FindConstraintEntity( node, "Rope" )
    if not IsValid( rope ) then return end

    local ent1, ent2 = rope:GetConstrainedEntities()
    local other = (node == ent1 and ent2) or ent1

    if not IsValid( other ) then return end

    return other
end

--- @param prod Entity
--- @param t Entity[]?
--- @return Entity[]?
local function nodesInChain( prod, t )
    local nodes = t or {}

    local other = getNext( prod )
    if IsValid( other ) and other.isNode then
        nodes[#nodes + 1] = other

        nodesInChain( other, nodes )
    end

    return nodes
end

function MODULE.Hooks:Think()
    if CurTime() < nextThink then return end
    nextThink = CurTime() + 5 -- however many seconds

    for _, production in ipairs( ents.FindByClass( "pinecrest_productionnode" ) ) do
        if endsInResource( production ) then
            -- do power transfers
            -- set to green
            return
        elseif production:GetHP() <= 0 then
            -- set production to RED
            production:SetIsOn( false )

            local nodes = nodesInChain( prod )

            for _, node in ipairs( nodes ) do
                -- set node to RED
                node:SetIsOn( false )

            end
            return
        else
            -- set production to ORANGE

            local nodes = nodesInChain( prod )

            for _, node in ipairs( nodes ) do
                -- set node to ORANGE
                node:SetCanTransfer( false )

            end
            return
        end
    end
end






