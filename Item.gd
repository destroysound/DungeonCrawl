extends Resource
class_name ItemResource

export var name : String
export var stackable : bool = false
export var max_stack_size : int = 1

#examples of more properties we could store
enum ItemType { GENERIC, CONSUMABLE, QUEST, EQUIPTMENT }
export(ItemType) var type
export var texture : Texture
export var mesh : Mesh