vPlayer = of.VideoPlayer()
image = of.Image()
imageMask = of.Image()
shader = of.Shader()
fboWidth = 0
fboHeight = 0
-- empty template script with event callbacks
function setup()
    of.enableAlphaBlending();
   
    image:load("images/A.jpg")

    imageMask:load("images/oceanMask.png")

    shader:load("shadersGL2/alphamask")
    vPlayer:load("videos/ocean.mov")
    vPlayer:setLoopState(of.LOOP_NORMAL)
    vPlayer:play()
    fboWidth = vPlayer:getWidth()
    fboHeight = vPlayer:getHeight()
    fbo = of.Fbo()
    fbo:allocate(fboWidth, fboHeight, of.TEXTURE_RGBA);
    fboComposite = of.Fbo()
    fboComposite:allocate(fboWidth, fboHeight, of.TEXTURE_RGBA);

end

function update()
vPlayer:update()
end

function draw()
   
    of.clear(0,0,0,0)
	fbo:beginFbo()
    of.clear(0,0,0,0)
	shader:beginShader();
	shader:setUniformTexture("imageMask", imageMask:getTexture(), 1);

	vPlayer:draw(0, 0);
	
	shader:endShader();
    fbo:endFbo()
    
    fboComposite:beginFbo()
    of.clear(0,0,0,0)

    of.pushMatrix()
    of.translate(fboWidth/2, fboHeight/2)
    fbo:draw(-fboWidth/2,-fboHeight/3,fboWidth, fboHeight)
    of.rotateDeg(120,0,0,1)
    fbo:draw(-fboWidth/2,-fboHeight/3,fboWidth, fboHeight)

    of.rotateDeg(120,0,0,1)
    fbo:draw(-fboWidth/2,-fboHeight/3,fboWidth, fboHeight)

    of.popMatrix()
    fboComposite:endFbo()

    fboComposite:draw(0,0,of.getWidth(), of.getHeight())


end

function exit()

end

function keyPressed(key)

end

function keyReleased(key)

end

function mouseMoved(x, y)

end

function mouseDragged(x, y, button)

end

function mousePressed(x, y, button)

end

function mouseReleased(x, y, button)

end

function mouseEntered(x, y)

end

function mouseExited(x, y)

end

function windowResized(w, h)

end

function dragEvent(dragInfo)

end

function gotMessage(msg)

end

-- loaf OSC callback
function oscReceived(msg)

end
