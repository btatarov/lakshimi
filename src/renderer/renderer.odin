package renderer

import "core:fmt"
import "core:image/png"

import "vendor:OpenGL"

import Camera "camera"
import Shader "shader"
import Sprite "sprite"

@private camera         : Camera.Camera
@private main_shader    : Shader.Shader
@private img1, img2     : Sprite.Sprite

Init :: proc(width, height : i32) {
    OpenGL.BlendFunc(OpenGL.SRC_ALPHA, OpenGL.ONE_MINUS_SRC_ALPHA)
    OpenGL.Enable(OpenGL.BLEND)

    // Testing: wireframe mode
    // OpenGL.PolygonMode(OpenGL.FRONT_AND_BACK, OpenGL.LINE)

    // camera
    ratio := f32(width) / f32(height)
    camera = Camera.Init(-ratio, ratio, -1, 1)
    camera->set_position({0.5, 0.5, 0})
    camera->set_rotation(30)

    // shader
    main_shader = Shader.Init()

    // sprites
    img1 = Sprite.Init("test/lakshmi.png")
    img2 = Sprite.Init("test/lakshmi.png")
    img2->set_position(0, 0)

    RefreshViewport(width, height)
}

Destroy :: proc() {
    Shader.Destroy(&main_shader)
    Sprite.Destroy(&img1)
    Sprite.Destroy(&img2)
}

RefreshViewport :: proc(width, height : i32) {
    OpenGL.Viewport(0, 0, width, height)

    ratio := f32(width) / f32(height)
    camera->set_projection_matrix(-ratio, ratio, -1, 1)
}

Render :: proc() {
    OpenGL.ClearColor(0.3, 0.3, 0.3, 1.0)
    OpenGL.Clear(OpenGL.COLOR_BUFFER_BIT | OpenGL.DEPTH_BUFFER_BIT)

    main_shader->bind()
    main_shader->apply_projection(camera->get_vp_matrix())

    img1->render()
    img2->render()
}
