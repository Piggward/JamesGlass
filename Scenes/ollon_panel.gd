extends PanelContainer

var flickering = false
var flicker_time = 0

func flicker():
	flickering = true
	var styleBox: StyleBoxFlat = get_theme_stylebox("panel")
	styleBox.set("bg_color", Color(1.0, 0.0, 0.0, 0.3))
	add_theme_stylebox_override("panel", styleBox)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flickering:
		flicker_time += delta
		if flicker_time > 1.5:
			flickering = false
			flicker_time = 0
			var styleBox: StyleBoxFlat = get_theme_stylebox("panel")
			styleBox.set("bg_color", Color(1.0, 0.0, 0.0, 0.0))
			add_theme_stylebox_override("panel", styleBox)
	pass
