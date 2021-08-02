extends "res://Scripts/Room.gd"

func on_load():
	if (Global.muteAudio):
		$AnimatedSprite.visible = true;
	else:
		$AnimatedSprite.visible = false;

func on_entry():
	$AudioStreamPlayer.play();

func _on_sfx_finished():
	Global.fadeto_scene("res://Rooms/First Floor/First Floor.tscn", Global.warpPos, Global.warpFlip);
