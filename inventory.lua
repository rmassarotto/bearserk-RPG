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
    local x = i%6
    local y = math.floor((i-1)/5)
    item.y = y*32 + self.y
    if(x==0) then
        x=1
    end
    item.x = x*32 + self.x
    self.lenght = self.lenght+1
end

function Inventory.removeItem(self, i)
    self.items[i] = 0
    self.lenght = self.lenght - 1
end
