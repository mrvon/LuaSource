package main

import (
	"log"

	"github.com/go-gl/gl/v3.3-core/gl"
	"github.com/go-gl/glfw/v3.2/glfw"
)

func createWindow(w int, h int, title string) *glfw.Window {
	err := glfw.Init()
	if err != nil {
		log.Fatal(err)
	}

	glfw.WindowHint(glfw.ContextVersionMajor, 3)
	glfw.WindowHint(glfw.ContextVersionMinor, 3)
	glfw.WindowHint(glfw.OpenGLProfile, glfw.OpenGLCoreProfile)
	glfw.WindowHint(glfw.OpenGLForwardCompatible, gl.TRUE)

	window, err := glfw.CreateWindow(w, h, title, nil, nil)
	if err != nil {
		log.Fatal(err)
	}
	window.MakeContextCurrent()
	err = gl.Init()
	if err != nil {
		log.Fatal(err)
	}
	gl.Enable(gl.DEPTH_TEST)
	gl.Enable(gl.CULL_FACE)
	return window
}
