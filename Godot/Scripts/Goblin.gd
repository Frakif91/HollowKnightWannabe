extends CharacterBody2D

class_name Goblin
enum states {V1,V2,V3,V4}
enum estats {MHP,ATK,DEF,SPD,REG}
var og_stats = [900_000,100,100,100,100]
var act_stats = [900_000,850,150,1000]
var affected_by_fruit : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

"""
"""