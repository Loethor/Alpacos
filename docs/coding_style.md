# Coding style

Godot documentation recomments the following [coding style](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).

## Summary of these guidelines

```gdscript

class_name StateMachine
extends Node
# Hierarchical State machine for the player.
# Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the state.


signal state_changed(previous, new)

@export var initial_state: Node
var is_active = true:
    set = set_is_active

@onready var _state = initial_state:
    get = set_state
@onready var _state_name = _state.name


func _init():
    add_to_group("state_machine")


func _enter_tree():
    print("this happens before the ready method!")


func _ready():
    state_changed.connect(_on_state_changed)
    _state.enter()


func _unhandled_input(event):
    _state.unhandled_input(event)


func _physics_process(delta):
    _state.physics_process(delta)


func transition_to(target_state_path, msg={}):
    if not has_node(target_state_path):
        return

    var target_state = get_node(target_state_path)
    assert(target_state.is_composite == false)

    _state.exit()
    self._state = target_state
    _state.enter(msg)
    Events.player_state_changed.emit(_state.name)


func set_is_active(value):
    is_active = value
    set_physics_process(value)
    set_process_unhandled_input(value)
    set_block_signals(not value)


func set_state(value):
    _state = value
    _state_name = _state.name


func _on_state_changed(previous, new):
    print("state changed")
    state_changed.emit()


class State:
    var foo = 0

    func _init():
        print("Hello!")
```

## Code order

When creating a script, the order and type of variables and methods is important. Let's fight anarchy.

```gdscript

01. @tool
02. class_name
03. extends
04. # docstring

05. signals
06. enums
07. constants
08. @export variables
09. public variables
10. private variables
11. @onready variables

12. optional built-in virtual _init method
13. optional built-in virtual _enter_tree() method
14. built-in virtual _ready method
15. remaining built-in virtual methods
16. public methods
17. private methods
18. subclasses
```

From official docs:
> We optimized the order to make it easy to read the code from top to bottom, to help developers reading the code for the first time understand how it works, and to avoid errors linked to the order of variable declarations.
>
>This code order follows four rules of thumb:
> 1. Properties and signals come first, followed by methods.
> 2. Public comes before private.
> 3. Virtual callbacks come before the class's interface.
> 4. The object's construction and initialization functions, _init and _ready, come before functions that modify the object at runtime.
