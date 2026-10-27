local nextThink = 0

--- @param node Entity
--- @param last Entity?
--- @return Entity?
local function getNext( node, last )
    local ropes = constraint.FindConstraints( node, "Rope" )

    for _, rope in ipairs( ropes ) do
        if rope.Ent1 == last or rope.Ent2 == last then continue end

        local other = (node == rope.Ent1 and rope.Ent2) or rope.Ent1

        if not IsValid( other ) then return end

        return other
    end

    return nil
end

--- @param prod Entity
--- @param t Entity[]?
--- @param last Entity?
--- @return Entity[]
local function nodesInChain( prod, t, last )
    local nodes = t or { prod }

    local other = getNext( prod, last )
    if other and IsValid( other ) and other.isNode and other ~= last then
        nodes[#nodes + 1] = other

        nodes = nodesInChain( other, nodes, prod )
    end

    return nodes
end

--- @param chain Entity[]
--- @return boolean
local function endsInResource( chain )
    local last = chain[#chain]
    return
        IsValid( last ) and
        last:GetClass() == "pinecrest_resourcenode"
end

function MODULE.Hooks:Think()
    if CurTime() < nextThink then return end
    nextThink = CurTime() + 5 -- however many seconds

    for _, production in ipairs( ents.FindByClass( "pinecrest_productionnode" ) ) do
        local chain = nodesInChain( production )

        if endsInResource( chain ) then
            for _, node in ipairs( chain ) do
                if node:GetClass() ~= "pinecrest_productionnode" then
                    node:SetCanTransfer( true )
                end
                node:SetIsOn( true )
            end
            continue
        end

        -- red
        if production:GetHP() <= 0 then
            for _, node in ipairs( chain ) do
                node:SetIsOn( false )
            end
            continue
        else
            -- orange
            for _, node in ipairs( chain ) do
                if node:GetClass() ~= "pinecrest_productionnode" then
                    node:SetCanTransfer( false )
                end
                node:SetIsOn( false )
            end
        end
    end
end
