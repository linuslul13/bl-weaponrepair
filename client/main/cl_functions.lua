function HelpUI(key, msg)
	TriggerEvent("rs_hud:pushInteraction", msg, key)
end

function Notify(title, msg, type)
    lib.notify({title = title, description = msg, type = type, position = 'bottom', duration = 5000})
end