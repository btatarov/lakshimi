package window

import "core:fmt"
import "core:runtime"

import "vendor:glfw"
import lua "vendor:lua/5.4"
import "vendor:OpenGL"

import Renderer "../renderer"

OPENGL_VERSION_MAJOR :: 3
OPENGL_VERSION_MINOR :: 3

window : glfw.WindowHandle

Init :: proc(title : cstring, width, height : i32) {
    fmt.println("LakshimiWindow: Init")

    assert(bool(glfw.Init()), "GLFW init failed")

    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, OPENGL_VERSION_MAJOR)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, OPENGL_VERSION_MINOR)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    window = glfw.CreateWindow(width, height, title, nil, nil)
    assert(window != nil, "Failed to create GLFW window")

    glfw.SetKeyCallback(window, OnKeyboardCallback)
    glfw.SetFramebufferSizeCallback(window, OnWindowResizeCallback)

    glfw.MakeContextCurrent(window)
    glfw.SwapInterval(1)

    OpenGL.load_up_to(OPENGL_VERSION_MAJOR, OPENGL_VERSION_MINOR, glfw.gl_set_proc_address)

    width, height := glfw.GetFramebufferSize(window)

    Renderer.Init(width, height)
}

Destroy :: proc() {
    fmt.println("LakshimiWindow: Destroy")
    Renderer.Destroy()

    glfw.DestroyWindow(window)
    glfw.Terminate()
}

LuaBind :: proc(L: ^lua.State) {
    reg_table: []lua.L_Reg = {
        { "open", _open },
    }

    lua.newtable(L)
    lua.pushvalue(L, lua.gettop(L))
    lua.setglobal(L, "LakshimiWindow")
    lua.L_setfuncs(L, raw_data(reg_table[:]), 0)
}

LuaUnbind :: proc(L: ^lua.State) {
    Destroy()
}

MainLoop :: proc() {
    fmt.println("LakshimiWindow: MainLoop")
    for ! glfw.WindowShouldClose(window) {
        Renderer.Render()
        glfw.PollEvents()
        glfw.SwapBuffers(window)
    }
}

OnWindowResizeCallback :: proc "c" (window : glfw.WindowHandle, width, height : i32) {
    context = runtime.default_context()

    Renderer.RefreshViewport(width, height)
}

OnKeyboardCallback :: proc "c" (window : glfw.WindowHandle, key, scancode, action, mode : i32) {
    if action == glfw.PRESS && key == glfw.KEY_ESCAPE {
        glfw.SetWindowShouldClose(window, true)
    }
}

_open :: proc "c" (L: ^lua.State) -> i32 {
    context = runtime.default_context()

    title := lua.L_checkstring(L, 1)
    width := i32(lua.L_checkinteger(L, 2))
    height := i32(lua.L_checkinteger(L, 3))
    Init(title, width, height)
    MainLoop()

    return 0
}
