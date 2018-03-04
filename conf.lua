-- Sets unused modules to false before startup in order to reduce memory usage and startup time

function love.conf(t)
	t.modules.joystick = false
	t.modules.physics = false
	t.modules.audio = false
	t.modules.video = false
	t.modules.sound = false
end

