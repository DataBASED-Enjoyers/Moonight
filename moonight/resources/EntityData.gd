# resources/EntityData.gd
class_name EntityData extends Resource

@export_category("Base Properties")
@export var id: String = "entity"
@export var display_name: String = "Entity"
@export var texture: Texture2D
@export var health: int = 100
@export var speed: int = 200

@export_category("Combat")
@export var base_damage: int = 10
@export var attack_cooldown: float = 1.0
@export var attack_range: float = 50.0

@export_category("Visuals")
@export var animations: AnimationLibrary
@export var scale: float = 1.0
@export var color: Color = Color.WHITE

@export_category("Behavior Flags")
@export var is_playable: bool = false
@export var ai_behavior: Script
