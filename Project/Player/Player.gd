extends KinematicBody2D

const ACCELERATION = 100
const MAX_SPEED = 400
const FRICTION = 600

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var facing = "Front";
var last_mouse_pos = null

var mainCommands = [
	"> Who's this?", 
	"> Who's \"you\"?", 
	"> Nope. Not at all.", 
	"> No.", 
	"> I choose for you to tell me what to do.",
	"> Why?",
	"> I have no idea what you're talking about."
];
var mainWidths = [135, 145, 185, 70, 360, 80, 375];
var mainDialogs = [
	"It's you!\n\nWhy don't you try interacting with some of the other things around here?", 
	"Oh, come on. Nate \"Pissy Emodick\" Rogers. Seventh grader, FOSSIL\nenthusiast, and PAPER AIRPLANE extraordinaire.\n\nDoes that not ring any bells?",
	"Well, it looks like *somebody* sure loves making my job harder.\n\nDo you really need to know who you are? Can't you just go around\nclicking random things that AREN'T yourself?",
	"We're at a standstill, then. We could sit here forever, with you not\nknowing what you're supposed to be doing. Or, you could click onto\nthe next page, with not a clue as to how you got to that point.\n\nThe choice is yours.",
	"If it gets you to actually progress, then so be it.\n\nYour friend requested that you locate a COMPUTER in your school's\nlibrary. She acquired a piece of software that she wants you to\ninstall, which will in some way help with your apocalypse situation.",
	"Why would I tell you?! I'm sure you can figure it out!\n\nThere aren't that many programs out there that can magically save\nyou from the end of the world!",
	"Right. I forgot. You know nothing. Just get to the library."
];

var stairsCommand = "> Is he going to be okay?";
var stairsWidth = 230;
var stairsDialog = "Maybe he just needs a moment, give him some space. It's not every\nday a kid's dreams of being a professional railing slider are\ncrushed.\n\nAnd his bones, too, of course.";

func _ready():
	$PlayerArea2D.isPlayer = true;

func _process(_delta):
	if ($PlayerArea2D.command != stairsCommand && $AnimationPlayer.current_animation == "itoldyoubro"):
		$PlayerArea2D.command = stairsCommand;
		$PlayerArea2D.width = stairsWidth;
		$PlayerArea2D.dialogOrScene = stairsDialog;
	elif ($PlayerArea2D.command != mainCommands[Global.playerDialog] && $AnimationPlayer.current_animation != "itoldyoubro"):
		$PlayerArea2D.command = mainCommands[Global.playerDialog];
		$PlayerArea2D.width = mainWidths[Global.playerDialog];
		$PlayerArea2D.dialogOrScene = mainDialogs[Global.playerDialog];

func _physics_process(_delta):
	movement()
	velocity = move_and_slide(velocity)

func movement():
	if (Global.fading || Global.imageOpen):
		direction = Vector2.ZERO;
	else:
		keyMovement();
		mouseMovement();
	
	if (direction != Vector2.ZERO):
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	# Controls player right and left animation sprites using velocity.
	if (velocity == Vector2.ZERO):
		if ($AnimationPlayer.current_animation != "itoldyoubro"):
			$AnimationPlayer.play("still" + facing)
	else:
		if !(Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_right")) || (velocity.x != 0 && last_mouse_pos != null):
			if Input.is_action_pressed("ui_right") || (velocity.x > 0 && last_mouse_pos != null):
				$AnimationPlayer.play("run" + facing)
				$Sprite.flip_h = false
				$PlayerArea2D.scale.x = 1;
			elif Input.is_action_pressed("ui_left") || (velocity.x < 0 && last_mouse_pos != null):
				$AnimationPlayer.play("run" + facing)
				$Sprite.flip_h = true
				$PlayerArea2D.scale.x = -1;
		if !(Input.is_action_pressed("ui_up") && Input.is_action_pressed("ui_down")) || (velocity.y != 0 && last_mouse_pos != null):
			if Input.is_action_pressed("ui_up") || (velocity.y < 0 && last_mouse_pos != null):
				if facing != "Back":
					facing = "Back";
				$AnimationPlayer.play("run" + facing)
			elif Input.is_action_pressed("ui_down") || (velocity.y > 0 && last_mouse_pos != null):
				if facing != "Front":
					facing = "Front";
				$AnimationPlayer.play("run" + facing) 

func keyMovement():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	input_vector = input_vector.normalized();
	
	direction = input_vector;
	
	if input_vector != Vector2.ZERO:
		last_mouse_pos = null;

# Moves character to where mouse clicked. 
# Please refer to 
# https://www.youtube.com/watch?v=5bxys-Zo_jk&list=PLllc6qRBTEefSTIsPZVqhhuGNMc-5kOS6&index=16
func _input(event):
	if Global.mouseMove && event.is_action_pressed("mouse_move"):
		Global.remove_commands();
		last_mouse_pos = get_global_mouse_position()

func mouseMovement():
	if last_mouse_pos:
		var input_vector = (last_mouse_pos - global_position)

		if input_vector.length() < 5 || (get_slide_count() > 0 && velocity != Vector2.ZERO):
			last_mouse_pos = null;
			return 

		direction = input_vector.normalized();
