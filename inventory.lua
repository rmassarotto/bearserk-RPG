Inventory = {}
Inventory.__index = Inventory

function Inventory.new ()
    local self = setmetatable({},Inventory)
    self.items = {0,0,0,0,0,
                  0,0,0,0,0,
                  0,0,0,0,0}
    self.x = 352
    self.y = 608
    self.lenght = 0
    return self
end

function Inventory.findVoid(self)
    for i=1,15 do
        if(self.items[i]==0) then
            return i
        end
    end
    return 0
end

function Inventory.addItem(self, item)
    local i = self.findVoid(self)
    if i == 0 then
        return
    end
    self.items[i] = item
    i = i*32
    item.x = i%(32*5) + self.x
    item.y = math.floor(i/(32*5)) + self.y
    self.lenght = self.lenght+1
end

function Inventory.removeItem(self, i)
    self.items[i] = 0
    self.lenght = self.lenght - 1
end
