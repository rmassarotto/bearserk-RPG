Item = {}
Item.__index = Item

function Item.new (name,type, caracteristcs, description, path )
    local self = setmetatable({},Item)
    self.name = "Item"
    self["Nome"] = name
    self.caracteristcs = caracteristcs
    self["Descrição"] = description
    self.path = path
    self.x = 0
    self.y = 0
    self["Tipo"] = type
    return self
end

function Item.swapItemLocations(item1, item2)
    local aux_to_swap = {item1.x, item1.y}
    item1.x = item2.x
    item1.y = item2.y
    item2.x = aux_to_swap[1]
    item2.y = aux_to_swap[2]
end
