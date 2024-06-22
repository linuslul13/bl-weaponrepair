RegisterNetEvent('bl_core:repairWeapon', function(slot, durability)
  exports.ox_inventory:SetDurability(source, slot, durability)
end)