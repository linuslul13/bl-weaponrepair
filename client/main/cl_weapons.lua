
Citizen.CreateThread(function()
    Wait(1000)
    print('^4[BL_CORE] - DEBUG | WEAPON REPAIR LOADED')
    for i = 1, #Config.Weapon.coords do 
        local marker = lib.marker.new({
            type = Config.Weapon.marker.type,
            coords = Config.Weapon.coords[i].coords,
            color = Config.Weapon.marker.color,
        })
        local point = lib.points.new({
            coords = Config.Weapon.coords[i].coords,
            distance = Config.Weapon.marker.DrawDistance,
        })

        function point:nearby()
            marker:draw()
            if self.currentDistance < 1.5 then
                HelpUI('E', Config.Weapon.language.HelpUI)
                if IsControlJustPressed(0, 51) then  
                    if exports.ox_inventory:getCurrentWeapon() == nil then return  Notify('BLACKLINE CITY', 'Du hast keine Waffe in deiner Hand', 'error') end
                    if exports.ox_inventory:getCurrentWeapon().metadata.durability == 100 then return Notify('BLACKLINE CITY', 'Du hast deine Waffe ['..exports.ox_inventory:getCurrentWeapon().name..'] kann nicht Repariert weden da sie nicht kaputt ist!', 'warning') end
                    local getCurrentWeapon = exports.ox_inventory:getCurrentWeapon()
                    local weaponprice = 100 - getCurrentWeapon.metadata.durability
                    local price = weaponprice * 100
                    lib.registerContext({
                        id = 'repair_menu',
                        title = Config.Weapon.language.menu_title,
                        options = {
                          {
                            title = getCurrentWeapon.label,
                            description = 'Repariere deine Waffe für '..price..'$ '..Config.Weapon.coords[i].money_label,
                            progress =getCurrentWeapon.metadata.durability,
                            colorScheme = '#1864AB',
                            icon = 'gun',
                            image = 'nui://ox_inventory/web/images/'..exports.ox_inventory:getCurrentWeapon().name..'.png',
                            onSelect = function()
                                local weapon =getCurrentWeapon.name
                                if lib.progressCircle({
                                    duration = Config.Weapon.progressbar.duration,
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        car = true,
                                        move = true,
                                    },
                                    anim = {
                                        dict = 'mini@repair',
                                        clip = 'fixing_a_player'
                                    },
                                }) then 
                                    local account = lib.callback.await('bl_core:getMoney', false, Config.Weapon.coords[i].money)
                                    if account == nil then return Notify('BLACKLINE CITY', 'Es gab einen Fehler!', 'error') end
                                    if account.money >= price then 
                                        TriggerServerEvent('bl_core:repairWeapon', getCurrentWeapon.slot, 100)
                                        TriggerServerEvent('bl_core:removeMoney', Config.Weapon.coords[i].money, price)
                                        Notify('BLACKLINE CITY', 'Du hast deine Waffe ['..exports.ox_inventory:getCurrentWeapon().name..'] für '..price..'$ '..Config.Weapon.coords[i].money_label..' Repariert!', 'success')
                                    else
                                        Notify('BLACKLINE CITY', 'Du hast nicht genug Geld bei dir! Dir fehlen '..price-account.money..'$ '..Config.Weapon.coords[i].money_label, 'warning')
                                    end
                                else 
                                    Notify('BLACKLINE CITY', 'Du hast das Reparieren deiner Waffe ['..exports.ox_inventory:getCurrentWeapon().name..'] abgebrochen!', 'error')
                                end
                              end,
                          }
                        }
                    })
                    lib.showContext('repair_menu')
                end
            end
        end
    end
end)

function OpenWeaponMenu(getCurrentWeapon)
    lib.registerContext({
        id = 'repair_menu',
        title = Config.Weapon.language.menu_title,
        options = {
          {
            title =getCurrentWeapon.label,
            description = 'Repariere deine Waffe für '..price..'$ Schwarzgeld',
            progress =getCurrentWeapon.metadata.durability,
            colorScheme = '#1864AB',
            icon = 'gun',
            image = 'nui://ox_inventory/web/images/'..exports.ox_inventory:getCurrentWeapon().name..'.png',
            onSelect = function()
                local weapon =getCurrentWeapon.name
                if lib.progressCircle({
                    duration = Config.Weapon.progressbar.duration,
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                    },
                    anim = {
                        dict = 'mini@repair',
                        clip = 'fixing_a_player'
                    },
                }) then 
                    local account = lib.callback.await('bl_core:getMoney', false, Config.Weapon.money)
                    if account.money >= price then 
                        TriggerServerEvent('bl_core:repairWeapon', getCurrentWeapon.slot, 100)
                        TriggerServerEvent('bl_core:removeMoney', 'black_money', price)
                        Notify('BLACKLINE CITY', 'Du hast deine Waffe ['..exports.ox_inventory:getCurrentWeapon().name..'] für '..price..'$ Schwarzgeld Repariert!', 'success')
                    else
                        Notify('BLACKLINE CITY', 'Du hast nicht genug Geld bei dir! Dir fehlen '..price-account.money..'$ Schwarzgeld', 'warning')
                    end
                else 
                    Notify('BLACKLINE CITY', 'Du hast das Reparieren deiner Waffe ['..exports.ox_inventory:getCurrentWeapon().name..'] abgebrochen!', 'error')
                end
              end,
          }
        }
    })
    lib.showContext('repair_menu')
end

