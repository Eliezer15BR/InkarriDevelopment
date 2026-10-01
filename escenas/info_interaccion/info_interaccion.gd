extends PanelContainer

@export var label_nombre: Label
@export var label_tipo: Label
@export var label_descripcion: Label
func _ready() -> void: visible = false

func mostrar_recompensa(recompensa: RecompensaResource) -> void:
	if recompensa == null:
		ocultar()
		return
	visible = true
	if recompensa is ItemResource: mostrar_item(recompensa)
	elif recompensa is RecompensaBuild: mostrar_build(recompensa)
	else:
		label_nombre.text = recompensa.nombre
		label_tipo.text = ""
		label_descripcion.text = ""

func mostrar_item(item: ItemResource) -> void:
	label_nombre.text = item.nombre_item
	label_tipo.text = "Objeto - Tier " + str(item.tier)
	label_descripcion.text = item.descripcion

func mostrar_build(recompensa_build: RecompensaBuild) -> void:
	var build := recompensa_build.build
	if build == null:
		return
	label_nombre.text = build.nombre
	label_tipo.text = "Build"

	label_descripcion.text = (
		"Vida: " + str(build.vida)
		+ "\nDaño: " + str(build.dano)
		+ "\nMovimiento: " + str(build.velocidad_movimiento)
		+ "\nAtaque: " + str(build.velocidad_ataque)
		+ "\nDefensa: " + str(build.defensa)
		+ "\nFortuna: " + str(build.fortuna)
	)

func ocultar() -> void: visible = false
