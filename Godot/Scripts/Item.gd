extends Node

enum item_type {WEAPON,MATERIAL}

class Item:
    var name : String = ""
    var description : String = ""
    var item_icon : Texture2D
    var type : item_type
    
    func _init(_name : String = "", _description : String = "", _item_icon : Texture2D = PlaceholderTexture2D.new(), _type : item_type = item_type.MATERIAL):
        name = _name
        description = _description
        item_icon = _item_icon
        type = _type
