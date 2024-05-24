extends State


var repid : PackedScene = preload("res://Character/Class/Repid.tscn")

func state_input(event : InputEvent) -> void:
	super(event)
	if event.is_action_pressed(pp.special_2_action) and character.angry >= 5:
		var repid_instance = repid.instantiate()
		character.angry -= 5
		pp.feet_label.set_short_text("REPID")
		repid_instance.global_position = character.global_position
		add_child(repid_instance)
		_return()


func on_enter(lambda = null) -> void:
	playback.travel(pp.flash_end_animation)
	
func _on_flash_end_end() -> void:
	_return()
