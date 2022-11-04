extends Resource

var area: Area2D = null:
	set(value):
		if area:
			area.disconnect("changed_state", emit_changed)
		area = value
		if area:
			value.connect("changed_state", emit_changed)
		emit_changed()
