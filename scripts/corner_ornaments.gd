@tool
extends Control
## Ornamen sudut merah gelap (jaring segitiga) di kanan atas dan kanan bawah,
## disambung garis vertikal tipis. Digambar lewat kode, tanpa aset gambar.

@export var color: Color = Color(0.26, 0.07, 0.08, 0.95):
	set(v):
		color = v
		queue_redraw()
## Jarak sudut ornamen dari tepi kanan dan tepi atas/bawah layar.
@export var margin: Vector2 = Vector2(24.0, 24.0):
	set(v):
		margin = v
		queue_redraw()
## Panjang kaki segitiga ornamen.
@export var leg: float = 84.0:
	set(v):
		leg = v
		queue_redraw()
@export var line_width: float = 2.0:
	set(v):
		line_width = v
		queue_redraw()


func _draw() -> void:
	var x: float = size.x - margin.x
	var top := Vector2(x, margin.y)
	var bottom := Vector2(x, size.y - margin.y)
	# Garis vertikal penghubung, lebih redup dari ornamen.
	draw_line(top, bottom, Color(color, color.a * 0.55), line_width * 0.75, true)
	_draw_web(top, Vector2(-1.0, 0.0), Vector2(0.0, 1.0))
	_draw_web(bottom, Vector2(-1.0, 0.0), Vector2(0.0, -1.0))


## Jaring segitiga: dua kaki dari sudut, sisi miring melengkung ke dalam,
## jari-jari dari sudut, dan dua "cincin" zig-zag di antaranya.
func _draw_web(corner: Vector2, dir_a: Vector2, dir_b: Vector2) -> void:
	var a_end: Vector2 = corner + dir_a * leg
	var b_end: Vector2 = corner + dir_b * leg
	draw_line(corner, a_end, color, line_width * 1.5, true)
	draw_line(corner, b_end, color, line_width * 1.5, true)

	const SPOKES: int = 5
	var rim: PackedVector2Array = []
	for i: int in SPOKES + 1:
		var t: float = float(i) / SPOKES
		var p: Vector2 = a_end.lerp(b_end, t)
		# Lengkung sisi miring sedikit masuk ke arah sudut.
		p = p.lerp(corner, 0.18 * sin(t * PI))
		rim.append(p)
	draw_polyline(rim, color, line_width * 1.2, true)

	for i: int in range(1, SPOKES):
		draw_line(corner, rim[i], color, line_width, true)

	for ring: float in [0.38, 0.68]:
		var pts: PackedVector2Array = []
		for i: int in SPOKES + 1:
			# Titik cincin selang-seling sedikit maju-mundur agar terkesan jaring.
			var k: float = ring + (0.06 if i % 2 == 0 else -0.04)
			pts.append(corner.lerp(rim[i], k))
		draw_polyline(pts, color, line_width, true)
