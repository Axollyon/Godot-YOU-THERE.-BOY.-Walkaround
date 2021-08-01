extends Area2D

export var dictKey = "";
export var setOnUse = false;

export (String, MULTILINE) var firstCommand = "";
export var firstWidth = 552;
export var firstIsWarp = false;
export (String, MULTILINE) var firstDialogOrScene = "";
export var firstWarpPos = Vector2.ZERO;
export var firstWarpFlip = false;
export (Texture) var firstZoomImage;

export (String, MULTILINE) var secondCommand = "";
export var secondWidth = 552;
export var secondIsWarp = false;
export (String, MULTILINE) var secondDialogOrScene = "";
export var secondWarpPos = Vector2.ZERO;
export var secondWarpFlip = false;
export (Texture) var secondZoomImage;

var selected = false;

var commandBox = load("res://UI/Command Box/Command_Player.tscn")

func _on_mouse_entered()->void:
	if (!Global.fading):
		Global.hoverNodes.append(self);
		selected = true;

func _on_mouse_exited()->void:
	if (!Global.fading):
		Global.hoverNodes.erase(self);
		selected = false;
	
func _exit_tree():
	Global.hoverNodes.erase(self);	
	
func _process(_delta):
	if (Global.commandsNode && !Global.dialogOpen && !Global.imageOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		if (!Global.warpConds.has(dictKey)):
			Global.warpConds[dictKey] = false;
		
		var commandBoxInstance = commandBox.instance();
		Global.remove_commands();
		Global.commandsNode.add_child(commandBoxInstance);
		var click = get_global_mouse_position();
		var cTrans = get_canvas_transform();
		var cScale = cTrans.get_scale();
		var right = (-cTrans.get_origin() / cScale + get_viewport().size / cScale).x;
		
		var width = firstWidth;
		var command = firstCommand;
		var isWarp = firstIsWarp;
		var warpPos = firstWarpPos;
		var warpFlip = firstWarpFlip;
		var dialogOrScene = firstDialogOrScene;
		var zoomImage = firstZoomImage;
		
		if (Global.warpConds[dictKey]):
			width = secondWidth;
			command = secondCommand;
			isWarp = secondIsWarp;
			warpPos = secondWarpPos;
			warpFlip = secondWarpFlip;
			dialogOrScene = secondDialogOrScene;
			zoomImage = secondZoomImage;
		elif (setOnUse):
			commandBoxInstance.dictKey = dictKey;
		
		if (click.x + width > right):
			click.x = right - width;
		commandBoxInstance.global_position = click;
		commandBoxInstance.command = command;
		commandBoxInstance.get_node("CommandBox").rect_size.x = width;
		commandBoxInstance.get_node("CommandBox/NinePatchRect/MarginContainer/RichTextLabel").bbcode_text = "";
		commandBoxInstance.isWarp = isWarp;
		commandBoxInstance.warpPos = warpPos;
		commandBoxInstance.warpFlip = warpFlip;
		commandBoxInstance.dialogOrScene = dialogOrScene;
		commandBoxInstance.zoomImage = zoomImage;
