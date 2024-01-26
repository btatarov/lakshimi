package shader

import "core:math/linalg"

import "vendor:OpenGL"

Shader :: struct {
    program : u32,

    apply_projection : proc(shader: ^Shader, projection: ^linalg.Matrix4f32),
}

Init :: proc() -> (shader: Shader) {
    ok : bool
    vertex_shader := string(#load("glsl/vertex.glsl"))
    fragment_shader := string(#load("glsl/fragment.glsl"))
    shader.program, ok = OpenGL.load_shaders_source(vertex_shader, fragment_shader)
    assert(ok, "Failed to load and compile shaders.")
    OpenGL.UseProgram(shader.program)

    shader.apply_projection = shader_apply_projection

    return
}

Destroy :: proc(shader: ^Shader) {
    OpenGL.DeleteProgram(shader.program)
}

shader_apply_projection :: proc(shader: ^Shader, projection: ^linalg.Matrix4f32) {
    uniform_location := OpenGL.GetUniformLocation(shader.program, "u_projection")
    OpenGL.UniformMatrix4fv(uniform_location, 1, false, &projection[0][0])
}
