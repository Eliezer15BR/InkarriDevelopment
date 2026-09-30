extends RoomBase

func _ready() -> void:
	super._ready()
	for pedestal in get_tree().get_nodes_in_group("item_room"):
		if is_ancestor_of(pedestal):
			pedestal.recompensa_elegida.connect(_on_recompensa_elegida)

func _on_recompensa_elegida() -> void:
	resolver_sala()
