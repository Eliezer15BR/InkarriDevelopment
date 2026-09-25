extends RoomBase
@export var enemigos:Node2D
var enemigos_vivos:int=0
func _ready()->void:
	super._ready()
	for enemigo in enemigos.get_children():
		if enemigo is EnemyBase:
			enemigos_vivos+=1
			enemigo.murio.connect(_on_enemigo_murio)
	if enemigos_vivos==0: resolver_sala()

func _on_enemigo_murio(_enemigo:EnemyBase)->void:
	enemigos_vivos-=1
	if enemigos_vivos<=0: resolver_sala()
