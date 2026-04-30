shader_type canvas_item;

uniform float min_y;
uniform float max_y;
uniform float progress: hint_range(0.0, 1.0);

varying vec2 local_pos;

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	float threshold = mix(max_y, min_y, progress);
	if (local_pos.y < threshold) {
		discard;
	}
}
