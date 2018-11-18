Item = {}
Item.__index = Item

function Item.new (name, caracteristcs, description, path)
    local self = setmetatable({},Item)
    self.name = name
    self.caracteristcs = caracteristcs
    self.description = description
    self.path = path
    return self
end
