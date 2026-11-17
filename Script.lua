-- ===== CONFIGURACIÓN =====
local TAMANO_HITBOX = 15 -- Un poco más grande para que sea más fácil
local ACTUALIZAR_CADA = 0.5 -- Se ejecuta más rápido para no perder monedas

-- ===== LÓGICA DEL SCRIPT =====
local function esMoneda(objeto)
    if not objeto:IsA("BasePart") and not objeto:IsA("Model") then return false end
    
    local nombre = string.lower(objeto.Name)
    if string.find(nombre, "coin") or string.find(nombre, "moneda") then
        return true
    end
    
    if objeto:IsA("BasePart") and objeto:FindFirstChild("TouchInterest") then
        return true
    end
    
    return false
end

local function expandirYForzarToque()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")

    for _, objeto in pairs(workspace:GetDescendants()) do
        if esMoneda(objeto) then
            -- Verificamos si es un modelo o una sola parte
            local partes = {}
            if objeto:IsA("Model") then
                partes = objeto:GetDescendants()
            elseif objeto:IsA("BasePart") then
                partes = {objeto}
            end

            -- Recorremos todas las partes de la moneda
            for _, parte in pairs(partes) do
                if parte:IsA("BasePart") then
                    pcall(function()
                        -- Hacemos el hitbox gigante
                        parte.Size = Vector3.new(TAMANO_HITBOX, TAMANO_HITBOX, TAMANO_HITBOX)
                        parte.CanTouch = true
                        parte.Transparency = 0.3 -- La ponemos un poco transparente para saber que el hitbox está activo
                        
                        -- EL TRUCO: Forzar el toque al servidor
                        if hrp and firetouchinterest then
                            firetouchinterest(parte, hrp, 0)
                            task.wait(0.05)
                            firetouchinterest(parte, hrp, 1)
                        end
                    end)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        expandirYForzarToque()
        task.wait(ACTUALIZAR_CADA)
    end
end)

print("[Hitbox Coins] Script actualizado. Recolectando monedas.")
