-- create new images
outputFbo = of.Fbo()

serverTemp = syphon.Server()
serverOutput = syphon.Server()

outputWidth = 1280
outputHeight = 720
previewWidth = 400
previewHeight = 300

colorFoo = of.Color()
colorBar = of.Color()

layerFoo = of.Fbo()
layerBar = of.Fbo()
plane = of.PlanePrimitive()

client = syphon.Client()

rotateFoo = 0
expandFoo = 0.01

vPlayer = of.VideoPlayer()
imageMask = of.Image()
shader = of.Shader()
videofboWidth = 0
videofboHeight = 0
videofbo = of.Fbo()
videofboComposite = of.Fbo()

----------------------------------------------------
function setup()

    of.setWindowTitle("MEJERIET")
    of.setWindowShape(previewWidth, previewHeight)
    of.setFrameRate(19)
    of.setVerticalSync(true);
    -- of.disableArbTex();
    of.enableAlphaBlending();

    outputFbo:allocate(outputWidth, outputHeight, of.TEXTURE_RGBA);
    outputFbo:beginFbo()

    of.setColor(0, 0, 0, 255)
    of.drawRectangle(0, 0, outputWidth, outputHeight)
    outputFbo:endFbo()
    layerFoo:allocate(outputWidth, outputHeight, of.TEXTURE_RGBA);
    layerBar:allocate(outputWidth, outputHeight, of.TEXTURE_RGBA);

    serverOutput:setName("output")
    serverTemp:setName("temp")
    client:setup()
    client:set("temp", "loaf")

    imageMask:load("images/oceanMask.png")

    shader:load("shadersGL2/alphamask")
    vPlayer:load("videos/ocean.mov")
    vPlayer:setLoopState(of.LOOP_NORMAL)
    vPlayer:play()
    videofboWidth = vPlayer:getWidth()
    videofboHeight = vPlayer:getHeight()
    videofbo:allocate(videofboWidth, videofboHeight, of.TEXTURE_RGBA);
    videofboComposite:allocate(videofboWidth, videofboHeight, of.TEXTURE_RGBA);
    -- vPlayer1:load("videos/wave.mp4")
    -- vPlayer1:setLoopState(of.LOOP_NORMAL)
    -- vPlayer1:play()

    -- bikers:load("images/bikers.jpg")

end

----------------------------------------------------
function update()
    -- vplayer:update()

    layerBar:allocate(of.random(1, 500), of.random(1, 500), of.TEXTURE_RGBA, of.random(1, 4))

end

----------------------------------------------------
function draw()

    outputFbo:beginFbo()
    of.enableBlendMode(of.BLENDMODE_DISABLED)
    of.setColor(0, 0, 0, 255)
    of.drawRectangle(0,0,outputWidth,2)
    of.drawRectangle(0,outputHeight-2,outputWidth,2)

    of.setColor(255, 0, 0, 255)

    outputFbo:draw(-10, 1, outputWidth + 20, outputHeight - 2)

    of.pushMatrix()
    of.translate(outputWidth/2, outputHeight/2)
    halfwidth=expandFoo*(outputWidth/2)
    of.setColor(255, 255, 0, 255)
    of.enableBlendMode(of.BLENDMODE_MULTIPLY)

    outputFbo:draw(-halfwidth, -(outputHeight/2-5), halfwidth*2, outputHeight-23)
    of.enableBlendMode(of.BLENDMODE_ADD)
    of.setColor(colorFoo)

    client:draw(-halfwidth, -(outputHeight/2-5), halfwidth*2, outputHeight-23)

    of.rotateDeg(90,0,0,1)
    client:draw(-halfwidth, -(outputHeight/2-5), halfwidth*2, outputHeight-23)
    of.popMatrix()

    of.setColor(255, 255, 0, 255)
    -- client:draw(10, 0,outputWidth-20, outputHeight)

    outputFbo:endFbo()

    serverTemp:publishTexture(layerBar:getTexture())
    serverOutput:publishTexture(outputFbo:getTexture())
    outputFbo:draw(0, 0, previewWidth, previewHeight)

end

function oscReceived(message)
    -- , of.random(1,5))

    -- print received message
    -- print(tostring(message))
    if message:getAddress() == "/toggle" then

        -- outputFbo:beginFbo()
        -- of.setColor(colorFoo)
        -- -- print(tostring(color))

        -- of.drawRectangle(of.random(0, outputWidth), of.random(0, outputHeight), 100, 100)
        -- -- client:draw(of.random(0, outputWidth), of.random(0, outputHeight), 100, 100)
        -- outputFbo:endFbo()
    elseif message:getAddress() == "/color/foo" then
        hue = message:getArgAsFloat(0)
        colorFoo = of.Color.fromHsb(hue, 255, 255, 210)
        -- colorFoo = of.Color(math.floor(num / 2 ^ 24), math.floor((num % 2 ^ 24) / 2 ^ 16),
        --     math.floor((num % 2 ^ 16) / 2 ^ 8), num % 2 ^ 8)
        -- print(tostring(colorFoo))

    elseif message:getAddress() == "/color/bar" then
        num = message:getArgAsRgbaColor(0)
        colorBar = of.Color(math.floor(num / 2 ^ 24), math.floor((num % 2 ^ 24) / 2 ^ 16),
            math.floor((num % 2 ^ 16) / 2 ^ 8), num % 2 ^ 8)
        -- print(tostring(colorBar))

    elseif message:getAddress() == "/clear/foo" then
        -- layerFoo = of.Fbo()
        layerFoo:allocate(outputWidth, outputHeight, of.TEXTURE_RGBA);
        print(tostring(message))

    elseif message:getAddress() == "/rotate/foo" then
        rotateFoo = message:getArgAsFloat(0)
    elseif message:getAddress() == "/expand/foo" then
        expandFoo = message:getArgAsFloat(0)
    end

end
