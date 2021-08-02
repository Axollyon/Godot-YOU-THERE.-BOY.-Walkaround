extends "res://Scripts/Room.gd"

var dialogBox = load("res://UI/Dialog Box/Dialog_Player.tscn");

func on_load():
	if (Global.lastScene == "res://Rooms/Stairs/Stairs.tscn" && Global.playerNode):
		Global.playerNode.get_node("AnimationPlayer").play("itoldyoubro");

func on_entry():
	if (Global.lastScene == "res://Rooms/Stairs/Stairs.tscn" && Global.dialogsNode):
		var dialogBoxInstance = dialogBox.instance();
		Global.dialogsNode.add_child(dialogBoxInstance);
		dialogBoxInstance.dialog = "...You ate shit.";
