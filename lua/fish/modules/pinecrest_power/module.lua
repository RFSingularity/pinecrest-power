MODULE.Dependencies = {
  -- no deps yet
  -- "module_name",
}

function MODULE:PreEnable()
  -- establish namespace
  pinecrest.power = {}
end

function MODULE:PostDisable()
  -- clean up
  pinecrest.power = nil
end