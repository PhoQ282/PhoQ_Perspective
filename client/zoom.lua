local cfg = require('config')

local cam = nil
local zooming = false

local function isFirstPerson()
    return GetFollowPedCamViewMode() == 4
end

local function createZoomCam()
    local ped = PlayerPedId()
    local rot = GetGameplayCamRot(2)
    local coords
    if isFirstPerson() then
        local forward = GetEntityForwardVector(ped)
        local pos = GetEntityCoords(ped)
        coords = pos + forward * 1.0
    else
        coords = GetGameplayCamCoord()
    end
    cam = CreateCamWithParams(
        "DEFAULT_SCRIPTED_CAMERA",
        coords.x, coords.y, coords.z,
        rot.x, rot.y, rot.z,
        cfg.zoomFov,
        true, 2
    )
    SetCamActive(cam, true)
    RenderScriptCams(true, true, cfg.ease, true, true)
end

local function disableZoomCam()
    if cam then
        local easeOut = isFirstPerson() and 0 or cfg.ease
        SetCamActive(cam, false)
        RenderScriptCams(false, true, easeOut, true, true)
        DestroyCam(cam, true)
        cam = nil
    end
end

lib.addKeybind({
    name = 'phoq_perspective',
    description = 'Hold to Zoom Camera',
    defaultKey = cfg.key or 'MOUSE_MIDDLE',
    defaultMapper = 'MOUSE_BUTTON',
    onPressed = function()
        if IsPlayerFreeAiming(PlayerId()) then return end
        zooming = true
        createZoomCam()
    end,
    onReleased = function()
        zooming = false
        disableZoomCam()
    end
})

CreateThread(function()
    while true do
        Wait(0)
        if zooming and cam then
            local ped = PlayerPedId()
            local rot = GetGameplayCamRot(2)
            local coords
            if isFirstPerson() then
                local forward = GetEntityForwardVector(ped)
                local pos = GetEntityCoords(ped)
                coords = pos + forward * 1.0
            else
                coords = GetGameplayCamCoord()
            end
            SetCamCoord(cam, coords.x, coords.y, coords.z)
            SetCamRot(cam, rot.x, rot.y, rot.z, 2)
        end
    end
end)
