#version 410 core

layout (location = 0) in vec3 a_position;
layout (location = 1) in vec4 a_color;
layout (location = 2) in vec2 a_uv;
layout (location = 3) in float a_texture_index;

uniform mat4 u_projection;

out vec4 vertex_color;
out vec2 uv;
out float texture_index;

void main() {
    gl_Position = u_projection * vec4(a_position, 1.0);
    vertex_color = a_color;
    uv = a_uv;
    texture_index = a_texture_index;
}
