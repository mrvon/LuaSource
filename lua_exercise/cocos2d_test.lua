cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")
-- CC_USE_DEPRECATED_API = true
require "cocos.init"

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
end

local function initGLView()
    local director = cc.Director:getInstance()
    local glView = director:getOpenGLView()
    if nil == glView then
        glView = cc.GLViewImpl:create("Lua Empty Test")
        director:setOpenGLView(glView)
    end

    director:setOpenGLView(glView)

    glView:setDesignResolutionSize(960, 640, cc.ResolutionPolicy.NO_BORDER)

    --turn on display FPS
    director:setDisplayStats(false)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
end

local function __main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    initGLView()

    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    -- add the moving dog
    local function creatDog()
        local frameWidth = 105
        local frameHeight = 95

        -- create dog animate
        local textureDog = cc.Director:getInstance():getTextureCache():addImage("dog.png")
        local rect = cc.rect(0, 0, frameWidth, frameHeight)
        local frame0 = cc.SpriteFrame:createWithTexture(textureDog, rect)
        rect = cc.rect(frameWidth, 0, frameWidth, frameHeight)
        local frame1 = cc.SpriteFrame:createWithTexture(textureDog, rect)

        local spriteDog = cc.Sprite:createWithSpriteFrame(frame0)
        spriteDog.isPaused = false
        spriteDog:setPosition(origin.x, origin.y + visibleSize.height / 4 * 3)
--[[
        local animFrames = CCArray:create()

        animFrames:addObject(frame0)
        animFrames:addObject(frame1)
]]--

        local animation = cc.Animation:createWithSpriteFrames({frame0,frame1}, 0.5)
        local animate = cc.Animate:create(animation)
        spriteDog:runAction(cc.RepeatForever:create(animate))

        -- moving dog at every frame
        local function tick()
            if spriteDog.isPaused then return end
            local x, y = spriteDog:getPosition()
            if x > origin.x + visibleSize.width then
                x = origin.x
            else
                x = x + 1
            end

            spriteDog:setPositionX(x)
        end

        cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)

        return spriteDog
    end

    -- create farm
    local function createLayerFarm()
        local layerFarm = cc.Layer:create()

        -- add in farm background
        local bg = cc.Sprite:create("farm.jpg")
        bg:setPosition(origin.x + visibleSize.width / 2 + 80, origin.y + visibleSize.height / 2)
        layerFarm:addChild(bg)

        -- add land sprite
        for i = 0, 3 do
            for j = 0, 1 do
                local spriteLand = cc.Sprite:create("land.png")
                spriteLand:setPosition(200 + j * 180 - i % 2 * 90, 10 + i * 95 / 2)
                layerFarm:addChild(spriteLand)
            end
        end

        -- add crop
        local frameCrop = cc.SpriteFrame:create("crop.png", cc.rect(0, 0, 105, 95))
        for i = 0, 3 do
            for j = 0, 1 do
                local spriteCrop = cc.Sprite:createWithSpriteFrame(frameCrop)
                spriteCrop:setPosition(10 + 200 + j * 180 - i % 2 * 90, 30 + 10 + i * 95 / 2)
                layerFarm:addChild(spriteCrop)
            end
        end

        -- add moving dog
        local spriteDog = creatDog()
        layerFarm:addChild(spriteDog)

        -- handing touch events
        local touchBeginPoint = nil
        local function onTouchBegan(touch, event)
            local location = touch:getLocation()
            cclog("onTouchBegan: %0.2f, %0.2f", location.x, location.y)
            touchBeginPoint = {x = location.x, y = location.y}
            spriteDog.isPaused = true
            -- CCTOUCHBEGAN event must return true
            return true
        end

        local function onTouchMoved(touch, event)
            local location = touch:getLocation()
            cclog("onTouchMoved: %0.2f, %0.2f", location.x, location.y)
            if touchBeginPoint then
                local cx, cy = layerFarm:getPosition()
                layerFarm:setPosition(cx + location.x - touchBeginPoint.x,
                                      cy + location.y - touchBeginPoint.y)
                touchBeginPoint = {x = location.x, y = location.y}
            end
        end

        local function onTouchEnded(touch, event)
            local location = touch:getLocation()
            cclog("onTouchEnded: %0.2f, %0.2f", location.x, location.y)
            touchBeginPoint = nil
            spriteDog.isPaused = false
        end

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        local eventDispatcher = layerFarm:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layerFarm)

        return layerFarm
    end


    -- create menu
    local function createLayerMenu()
        local layerMenu = cc.Layer:create()

        local menuPopup, menuTools, effectID

        local function menuCallbackClosePopup()
            -- stop test sound effect
            cc.SimpleAudioEngine:getInstance():stopEffect(effectID)
            menuPopup:setVisible(false)
        end

        local function menuCallbackOpenPopup()
            -- loop test sound effect
            local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
            effectID = cc.SimpleAudioEngine:getInstance():playEffect(effectPath)
            menuPopup:setVisible(true)
        end

        -- add a popup menu
        local menuPopupItem = cc.MenuItemImage:create("menu2.png", "menu2.png")
        menuPopupItem:setPosition(0, 0)
        menuPopupItem:registerScriptTapHandler(menuCallbackClosePopup)
        menuPopup = cc.Menu:create(menuPopupItem)
        menuPopup:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
        menuPopup:setVisible(false)
        layerMenu:addChild(menuPopup)

        -- add the left-bottom "tools" menu to invoke menuPopup
        local menuToolsItem = cc.MenuItemImage:create("menu1.png", "menu1.png")
        menuToolsItem:setPosition(0, 0)
        menuToolsItem:registerScriptTapHandler(menuCallbackOpenPopup)
        menuTools = cc.Menu:create(menuToolsItem)
        local itemWidth = menuToolsItem:getContentSize().width
        local itemHeight = menuToolsItem:getContentSize().height
        menuTools:setPosition(origin.x + itemWidth/2, origin.y + itemHeight/2)
        layerMenu:addChild(menuTools)

        return layerMenu
    end

    -- play background music, preload effect
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3")
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)

    -- run
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(createLayerFarm())
    sceneGame:addChild(createLayerMenu())
    cc.Director:getInstance():runWithScene(sceneGame)
end

local function table_visual(t)
    if not t then
        return "nil"
    end

    local get_indent, quote_str, wrap_key, wrap_val, is_array, dump_table

    get_indent = function(level)
        return string.rep("\t", level)
    end

    quote_str = function(str)
        str = string.gsub(str, "[%c\\\"]", {
            ["\t"] = "\\t",
            ["\r"] = "\\r",
            ["\n"] = "\\n",
            ["\""] = "\\\"",
            ["\\"] = "\\\\",
        })
        return '"' .. str .. '"'
    end

    wrap_key = function(val)
        if type(val) == "number" then
            return "[" .. val .. "]"
        elseif type(val) == "string" then
            return "[" .. quote_str(val) .. "]"
        else
            return "[" .. tostring(val) .. "]"
        end
    end

    wrap_val = function(val, level)
        if type(val) == "table" then
            return dump_table(val, level)
        elseif type(val) == "number" then
            return val
        elseif type(val) == "string" then
            return quote_str(val)
        else
            return tostring(val)
        end
    end

    is_array = function(arr)
        local count = 0
        for k, v in pairs(arr) do
            count = count + 1
        end
        for i = 1, count do
            if arr[i] == nil then
                return false
            end
        end
        return true, count
    end

    dump_table = function(t, level)
        if type(t) ~= "table" then
            return wrap_val(t)
        end
        level = level + 1
        local tokens = {}
        tokens[#tokens + 1] = "{"
        local ret, count = is_array(t)
        if ret then
            for i = 1, count do
                tokens[#tokens + 1] = get_indent(level) .. wrap_val(t[i], level) .. ","
            end
        else
            for k, v in pairs(t) do
                tokens[#tokens + 1] = get_indent(level) .. wrap_key(k) .. " = " .. wrap_val(v, level) .. ","
            end
        end
        tokens[#tokens + 1] = get_indent(level - 1) .. "}"
        return table.concat(tokens, "\n")
    end

    return dump_table(t, 0)
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    initGLView()

    local visible_size = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local scene = cc.Scene:create()
    cc.Director:getInstance():runWithScene(scene)


    local function test_1()
        local sprite_1 = cc.Sprite:create("chapter2/Blue_Front1.png", cc.rect(0, 0, 50, 50))
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(100, 100))
        scene:addChild(sprite_1, 1)

        local sprite_2 = cc.Sprite:create("chapter2/LightBlue_Front1.png")
        sprite_2:setAnchorPoint(cc.p(0, 0))
        sprite_2:setPosition(cc.p(200, 200))
        sprite_2:setRotation(10)
        sprite_2:setScale(1.5);
        scene:addChild(sprite_2, 0)

        local sprite_3 = cc.Sprite:create("chapter2/LightBlue_Front1.png")
        sprite_3:setPosition(cc.p(300, 300))
        scene:addChild(sprite_3, 0)

        local sprite_4 = cc.Sprite:create("chapter2/White_Front1.png")
        sprite_4:setPosition(cc.p(400, 400))
        scene:addChild(sprite_4, 0)

        local move_to_1 = cc.MoveTo:create(2, cc.p(0, 0))
        local move_by_1 = cc.MoveBy:create(2, cc.p(100, 100))
        local move_to_2 = cc.MoveTo:create(2, cc.p(0, 0))
        local rotate_by = cc.RotateBy:create(2, 10)
        local scale_by  = cc.ScaleBy:create(2, 1.5)

        local delay = cc.DelayTime:create(2)

        sprite_2:runAction(cc.Sequence:create(move_to_1, delay, move_by_1, delay:clone(), move_to_2))
        sprite_3:runAction(cc.Sequence:create(rotate_by, delay, rotate_by, delay:clone(), rotate_by))
        sprite_4:runAction(cc.Spawn:create(rotate_by, scale_by, move_to_1))
    end
    -- test_1()

    local function test_2()
        local sprite_1 = cc.Sprite:create("chapter2/Blue_Front1.png")
        sprite_1:setPosition(cc.p(100, 100))
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setRotation(-60)
        sprite_1:setScaleX(2);
        sprite_1:setScaleY(2);
        sprite_1:setScale(2);
        sprite_1:setSkewX(20)
        sprite_1:setSkewY(20)
        sprite_1:setColor(cc.c3b(0, 255, 255))
        sprite_1:setOpacity(50)
        scene:addChild(sprite_1, 0)
    end
    -- test_2()

    local function test_3()
        local sprite_1 = cc.Sprite:create("chapter2/Blue_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(200, 200))

        local move_to    = cc.MoveTo:create(2, cc.p(300, sprite_1:getPositionY()))
        local y = sprite_1:getPositionY()
        local move_by    = cc.MoveBy:create(2, cc.p(500, y))
        local move_revert= cc.MoveBy:create(2, cc.p(-500, -y))

        local scale_by_1 = cc.ScaleBy:create(2, 3)
        local revert_1   = cc.ScaleBy:create(2, 1.0/3.0)
        local scale_by_2 = cc.ScaleBy:create(2, 2, 4)
        local revert_2   = cc.ScaleBy:create(2, 1.0/2.0, 1.0/4)
        local scale_by_3 = cc.ScaleBy:create(2, 4, 2)
        local revert_3   = cc.ScaleBy:create(2, 1.0/4.0, 1.0/2)

        local scale_to_1 = cc.ScaleTo:create(2, 3)
        local scale_to_2 = cc.ScaleTo:create(2, 2, 2)
        local scale_to_3 = cc.ScaleTo:create(2, 1)

        local fade_in    = cc.FadeIn:create(2.0)
        local fade_out   = cc.FadeOut:create(2.0)

        local tint_to    = cc.TintTo:create(2, 120, 232, 254)
        local tint_by    = cc.TintBy:create(2, 120, 232, 254)
        local revert_tint= cc.TintTo:create(2, 255, 255, 255)

        sprite_1:runAction(cc.Sequence:create(
        move_to,
        move_by,
        move_revert,
        tint_by,
        tint_to,
        revert_tint,
        fade_out,
        fade_in,
        scale_by_1, revert_1,
        scale_by_2, revert_2,
        scale_by_3, revert_3,
        scale_to_1,
        scale_to_2,
        scale_to_3
        ))

        scene:addChild(sprite_1)
    end
    -- test_3()

    local function test_4()
        local sprite_1 = cc.Sprite:create("chapter4/Blue_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(200, 200))

        local animate_arr = {}
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Front1.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Front2.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Front2.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Left1.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Left2.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Left3.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Back1.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Back2.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Back3.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Right1.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Right2.png", cc.rect(0, 0, 65, 81)))
        table.insert(animate_arr, cc.SpriteFrame:create("chapter4/Blue_Right3.png", cc.rect(0, 0, 65, 81)))

        local animation = cc.Animation:createWithSpriteFrames(animate_arr, 0.1)
        local animate = cc.Animate:create(animation)

        sprite_1:runAction(cc.RepeatForever:create(animate))

        scene:addChild(sprite_1)
    end
    -- test_4()

    local function test_5()
        local sprite_1 = cc.Sprite:create("chapter4/Blue_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(0, 0))

        local move_by = cc.MoveBy:create(2, cc.p(
            200, visible_size.height - sprite_1:getContentSize().height))

        local move_back = move_by:reverse()
        local move_ease_in = cc.EaseBounceIn:create(move_by:clone())
        local delay = cc.DelayTime:create(0.25)

        local seq = cc.Sequence:create(move_ease_in, delay, move_back, delay:clone())

        sprite_1:runAction(cc.RepeatForever:create(seq))
        scene:addChild(sprite_1)
    end
    -- test_5()

    local function test_6()
        local sprite_1 = cc.Sprite:create("chapter4/Blue_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(0, 0))

        local jump = cc.JumpBy:create(0.5, cc.p(0, 0), 100, 1)
        local rotate = cc.RotateTo:create(2.0, 10)
        local callback_jump = cc.CallFunc:create(function()
            print("Jumped!")
        end)
        local callbakc_rotate = cc.CallFunc:create(function()
            print("Rotated!")
        end)

        local sub_seq = cc.Sequence:create(cc.CallFunc:create(function()
            print("Action Start!")
        end))

        local seq = cc.Sequence:create(sub_seq, jump, callback_jump, rotate, callbakc_rotate)

        sprite_1:runAction(seq)
        scene:addChild(sprite_1)
    end
    -- test_6()

    local function test_7()
        local sprite_1 = cc.Sprite:create("chapter4/Blue_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(0, 0))

        local move_by = cc.MoveBy:create(10, cc.p(400, 100))
        local fade_to = cc.FadeTo:create(2.0, 120.0)

        local other_way = false

        if other_way then
            sprite_1:runAction(move_by)
            sprite_1:runAction(fade_to)
        else
            local spawn = cc.Spawn:create(move_by, fade_to)
            sprite_1:runAction(spawn)
        end

        scene:addChild(sprite_1)
    end
    -- test_7()

    local function test_8()
        local sprite_1 = cc.Sprite:create("chapter4/Blue_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(0, 0))

        local move_by = cc.MoveBy:create(10, cc.p(400, 100))
        local fade_to = cc.FadeTo:create(2.0, 120.0)
        local scale_by = cc.ScaleBy:create(2.0, 3.0)

        local spawn = cc.Spawn:create(scale_by, fade_to)
        local seq = cc.Sequence:create(move_by, spawn, move_by)

        sprite_1:runAction(seq)
        scene:addChild(sprite_1)
    end
    -- test_8()

    local function test_9()
        local sprite_1 = cc.Sprite:create("chapter2/Blue_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(200, 200))

        local sprite_2 = cc.Sprite:create("chapter2/White_Front1.png")
        sprite_2:setAnchorPoint(cc.p(0, 0))
        sprite_2:setPosition(cc.p(400, 400))

        local move_by = cc.MoveBy:create(10, cc.p(400, 100))

        sprite_1:runAction(move_by)
        -- Must be clone here
        sprite_2:runAction(move_by:clone())

        scene:addChild(sprite_1)
        scene:addChild(sprite_2)
    end
    -- test_9()

    local function test_10()
        local sprite_1 = cc.Sprite:create("chapter2/White_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(300, 100))

        local move_by = cc.MoveBy:create(2, cc.p(500, 0))
        local scale_by = cc.ScaleBy:create(2, 2.0)
        local delay = cc.DelayTime:create(2.0)

        local delay_sequence = cc.Sequence:create(
            delay,
            delay:clone(),
            delay:clone(),
            delay:clone())

        local sequence = cc.Sequence:create(
            move_by,
            delay,
            scale_by,
            delay_sequence
        )

        sprite_1:runAction(cc.Sequence:create(
            cc.CallFunc:create(function() print("Start") end),
            sequence,
            cc.CallFunc:create(function() print("Reverse") end),
            sequence:reverse(),
            cc.CallFunc:create(function() print("End") end)
        ))
        scene:addChild(sprite_1)
    end
    -- test_10()

    local function test_11()
        local label = cc.Label:createWithTTF("My game", "Marker Felt.ttf", 36)
        label:setPosition(visible_size.width / 2, visible_size.height / 2)

        scene:addChild(label)

        local sprite_1 = cc.Sprite:create("chapter2/White_Front1.png")
        sprite_1:setAnchorPoint(cc.p(0, 0))
        sprite_1:setPosition(cc.p(100, 100))

        scene:addChild(sprite_1)
    end
    -- test_11()

    local function test_12()
        -- bitmap font
        local label_1 = cc.Label:createWithBMFont("chapter6/bitmapRed.fnt", "Bitmap font")
        label_1:setPosition(visible_size.width / 2, visible_size.height / 6 * 4)
        label_1:setScale(3)
        scene:addChild(label_1)

        -- ture type font
        local label_2 = cc.Label:createWithTTF("True type font", "Marker Felt.ttf", 72 * 2)
        scene:addChild(label_2)
        label_2:setPosition(visible_size.width / 2, visible_size.height / 6 * 3)

        local ttf_conf = label_2:getTTFConfig()
        print(table_visual(ttf_conf))

        ttf_conf.fontSize = 72
        label_2:setTTFConfig(ttf_conf)

        -- system font
        local label_3 = cc.Label:createWithSystemFont("System font", "Monaco", 72)
        label_3:setPosition(visible_size.width / 2, visible_size.height / 6 * 2)
        scene:addChild(label_3)
    end
    -- test_12()

    local function test_13()
        local label_0 = cc.Label:createWithTTF("True type font", "Marker Felt.ttf", 72)
        label_0:setPosition(visible_size.width / 2, visible_size.height / 6 * 5)
        scene:addChild(label_0)

        local label_1 = cc.Label:createWithTTF("True type font", "Marker Felt.ttf", 72)
        label_1:setPosition(visible_size.width / 2, visible_size.height / 6 * 4)
        -- shadow effect is supported by all Label types
        label_1:enableShadow()
        scene:addChild(label_1)

        local label_2 = cc.Label:createWithTTF("True type font", "Marker Felt.ttf", 72)
        label_2:setPosition(visible_size.width / 2, visible_size.height / 6 * 3)
        -- outline effect is TTF only, specify the outline color desired
        label_2:enableOutline(cc.RED, 1)
        scene:addChild(label_2)

        local label_3 = cc.Label:createWithTTF("True type font", "Marker Felt.ttf", 72)
        label_3:setPosition(visible_size.width / 2, visible_size.height / 6 * 2)
        -- glow effect is TTF only, specify the glow color desired.
        label_3:enableGlow(cc.RED);
        scene:addChild(label_3)
    end
    -- test_13()

    local function test_14()
        local close_item = cc.MenuItemImage:create("CloseNormal.png", "CloseSelected.png")

        local menu = cc.Menu:create(close_item)

        close_item:registerScriptTapHandler(function()
            -- close_item:unregisterScriptTapHandler()
            print("click key event")
        end)

        scene:addChild(menu)
    end
    -- test_14()

    local function test_15()
        local button = ccui.Button:create(
            "chapter6/Button_Normal.png",
            "chapter6/Button_Press.png",
            "chapter6/Button_Disable.png")

        button:setTitleText("Button")
        button:setPosition(visible_size.width / 2, visible_size.height / 6 * 3)
        button:addTouchEventListener(function(sender, type)
            print("Button Event Type", type)
        end)
        scene:addChild(button)
    end
    -- test_15()

    local function test_16()
        local check_box = ccui.CheckBox:create(
            "chapter6/CheckBox_Normal.png",
            "chapter6/CheckBox_Press.png",
            "chapter6/CheckBoxNode_Normal.png",
            "chapter6/CheckBox_Disable.png",
            "chapter6/CheckBoxNode_Disable.png"
        )

        check_box:addTouchEventListener(function(sender, type)
            print("CheckBox Event Type", type)
        end)
        check_box:setPosition(visible_size.width / 2, visible_size.height / 6 * 3)
        scene:addChild(check_box)
    end
    -- test_16()

    local function test_17()
        local loading_bar = ccui.LoadingBar:create("chapter6/LoadingBarFile.png")
        loading_bar:setPosition(200, 200)
        loading_bar:setDirection(ccui.LoadingBarDirection.RIGHT)
        loading_bar:setPercent(100)

        scene:addChild(loading_bar)
    end
    -- test_17()

    local function test_18()
        local slider = ccui.Slider:create()
        slider:setPosition(200, 200)
        slider:loadBarTexture("chapter6/Slider_Back.png")
        slider:loadSlidBallTextures(
            "chapter6/SliderNode_Normal.png",
            "chapter6/SliderNode_Press.png",
            "chapter6/SliderNode_Disable.png"
        )
        slider:loadProgressBarTexture("chapter6/Slider_PressBar.png")

        slider:addTouchEventListener(function(sender, type)
            print("Slider Event type", type)
        end)

        scene:addChild(slider)
    end
    -- test_18()
    
    local function test_19()
        local text_field_1 = ccui.TextField:create("Username", "Monaco", 30)
        text_field_1:setPosition(visible_size.width / 6 * 3, visible_size.height / 6 * 3)

        text_field_1:addTouchEventListener(function(sender, type)
            print("TextField(Username) Event type", type)
        end)

        scene:addChild(text_field_1)

        local text_field_2 = ccui.TextField:create("Password", "Monaco", 30)
        text_field_2:setPosition(visible_size.width / 6 * 3, visible_size.height / 6 * 2)
        text_field_2:setPasswordEnabled(true)
        text_field_2:setMaxLength(10)   -- FIXME
        text_field_2:addTouchEventListener(function(sender, type)
            print("TextField(Password) Event type", type)
        end)

        scene:addChild(text_field_2)
    end
    -- test_19()

    local function test_20()
        local map = cc.TMXTiledMap:create("chapter7/isometric_grass_and_water.tmx")
        scene:addChild(map, 0, 99)

        local layer = map:getLayer("layer0")
        local tile = layer:getTileAt(cc.p(0, 0))
    end
    -- test_20()

    local function test_21()
        local emitter = cc.ParticleFireworks:create()

        emitter:setDuration(cc.PARTICLE_DURATION_INFINITY)

        scene:addChild(emitter, 10)
    end
    -- test_21()

    local function test_22()
        local emitter = cc.ParticleFireworks:create()

        emitter:setDuration(cc.PARTICLE_DURATION_INFINITY)
        emitter:setEmitterMode(cc.PARTICLE_MODE_RADIUS)

        emitter:setStartRadius(100)
        emitter:setStartRadiusVar(0)
        emitter:setEndRadius(cc.PARTICLE_START_RADIUS_EQUAL_TO_END_RADIUS)
        emitter:setEndRadiusVar(0)

        scene:addChild(emitter, 10)
    end
    -- test_22()

    local function test_23()
        local para_node = cc.ParallaxNode:create()
        
        local verts = 4

        local color_1 = cc.c4f(1, 0.5, 0.3, 1)
        local color_2 = cc.c4f(1, 0.6, 0.4, 1)
        local color_3 = cc.c4f(1, 0.7, 0.5, 1)

        local box_1 = {
            cc.p(0, 0),
            cc.p(0, 200),
            cc.p(600, 200),
            cc.p(600, 0)
        }

        local box_2 = {
            cc.p(0, 0),
            cc.p(0, 300),
            cc.p(800, 300),
            cc.p(800, 0)
        }

        local box_3 = {
            cc.p(0, 0),
            cc.p(0, 500),
            cc.p(1000, 500),
            cc.p(1000, 0)
        }

        local layer_1 = cc.DrawNode:create()
        layer_1:setContentSize(cc.p(600, 200))
        layer_1:drawPolygon(box_1, verts, color_1, 0, color_1)
        layer_1:setPosition(cc.p(visible_size.width / 4, visible_size.height / 6 * 5))

        local layer_2 = cc.DrawNode:create()
        layer_2:setContentSize(cc.p(800, 300))
        layer_2:drawPolygon(box_2, verts, color_2, 0, color_2)
        layer_2:setPosition(cc.p(visible_size.width / 4, visible_size.height / 6 * 3))

        local layer_3 = cc.DrawNode:create()
        layer_3:setContentSize(cc.p(800, 300))
        layer_3:drawPolygon(box_3, verts, color_3, 0, color_3)
        layer_3:setPosition(cc.p(visible_size.width / 4, visible_size.height / 6 * 2))

        para_node:addChild(layer_1, -1, cc.p(0.4, 0.5), cc.p(0, 0))
        para_node:addChild(layer_2, 1, cc.p(2.2, 1.0), cc.p(0, -200))
        para_node:addChild(layer_3, 2, cc.p(3.0, 2.5), cc.p(200, 800))
        -- TODO

        scene:addChild(para_node)
    end
    -- test_23()

    local function test_24()
        local listener_1 = cc.EventListenerTouchOneByOne:create()

        local function on_touch_began(touch, event)
            print("----------------- on_touch_began event -----------------")
            local location = touch:getLocation()
            print(location.x, location.y)
            return true
        end
        local function on_touch_moved(touch, event)
            print("----------------- on_touch_moved event -----------------")
        end
        local function on_touch_ended(touch, event)
            print("----------------- on_touch_ended event -----------------")
        end

        listener_1:registerScriptHandler(on_touch_began, cc.Handler.EVENT_TOUCH_BEGAN)
        listener_1:registerScriptHandler(on_touch_moved, cc.Handler.EVENT_TOUCH_MOVED)
        listener_1:registerScriptHandler(on_touch_ended, cc.Handler.EVENT_TOUCH_ENDED)

        local event_dispatcher = scene:getEventDispatcher()
        event_dispatcher:addEventListenerWithSceneGraphPriority(listener_1, scene)
    end
    -- test_24()

    local function test_25()
        local listener_1 = cc.EventListenerKeyboard:create()

        local function on_key_pressed(key_code, event)
            print("----------------- on_key_pressed event -----------------", key_code)
        end

        local function on_key_released(key_code, event)
            print("----------------- on_key_released event -----------------", key_code)
        end

        listener_1:registerScriptHandler(on_key_pressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
        listener_1:registerScriptHandler(on_key_released, cc.Handler.EVENT_KEYBOARD_RELEASED)

        local event_dispatcher = scene:getEventDispatcher()
        event_dispatcher:addEventListenerWithSceneGraphPriority(listener_1, scene)
    end
    -- test_25()

    local function test_26()
        local listener_1 = cc.EventListenerMouse:create()

        local function on_mouse_down(event)
            print("----------------- on_mouse_down event -----------------")
            print(string.format("K: %d", event:getMouseButton()))
        end

        local function on_mouse_up(event)
            print("----------------- on_mouse_up event -----------------")
            print(string.format("K: %d", event:getMouseButton()))
        end

        local function on_mouse_move(event)
            print("----------------- on_mouse_move event -----------------")
            print(string.format("X: %d Y: %d", event:getCursorX(), event:getCursorY()))
        end

        local function on_mouse_scroll(event)
            print("----------------- on_mouse_scroll event -----------------")
            print(string.format("X: %d Y: %d", event:getScrollX(), event:getScrollY()))

        end

        listener_1:registerScriptHandler(on_mouse_down, cc.Handler.EVENT_MOUSE_DOWN)
        listener_1:registerScriptHandler(on_mouse_up, cc.Handler.EVENT_MOUSE_UP)
        listener_1:registerScriptHandler(on_mouse_move, cc.Handler.EVENT_MOUSE_MOVE)
        listener_1:registerScriptHandler(on_mouse_scroll, cc.Handler.EVENT_MOUSE_SCROLL)

        local event_dispatcher = scene:getEventDispatcher()
        event_dispatcher:addEventListenerWithSceneGraphPriority(listener_1, scene)

        -- event_dispatcher:removeEventListener(listener_1)
    end
    -- test_26()
    
    local function test_27()
        local listener_1 = cc.EventListenerCustom:create("my_custom_event_1", function()
            print("----------------- my_custom_event_1 event -----------------")
        end)

        local event_dispatcher = scene:getEventDispatcher()
        event_dispatcher:addEventListenerWithFixedPriority(listener_1, 1)

        local event = cc.EventCustom:new("my_custom_event_1")
        event_dispatcher:dispatchEvent(event)
    end
    -- test_27()

    local function test_28()
        local audio_system = cc.SimpleAudioEngine:getInstance()
        local is_continuously = true

        local bg_music_path = cc.FileUtils:getInstance():fullPathForFilename("background.mp3")
        audio_system:playMusic(bg_music_path, is_continuously)
        audio_system:stopMusic(true)

        is_continuously = false
        local effect_path = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
        audio_system:playEffect(effect_path, is_continuously)
        audio_system:stopAllEffects()

        -- TODO
    end
    -- test_28()
end

xpcall(main, __G__TRACKBACK__)
