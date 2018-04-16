package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"runtime"

	"github.com/go-gl/gl/v3.3-core/gl"
	"github.com/go-gl/glfw/v3.2/glfw"
)

func init() {
	// GLFW event handling must run on the main OS thread
	runtime.LockOSThread()
}

func main() {
	window := createWindow(800, 600, "GoOpenGL")
	window.SetFramebufferSizeCallback(onFramebufferSizeCallback)

	vSource, err := ioutil.ReadFile("vertex.glsl")
	if err != nil {
		log.Fatal(err)
	}

	fSource, err := ioutil.ReadFile("fragment.glsl")
	if err != nil {
		log.Fatal(err)
	}

	shader, err := createShader(string(vSource), string(fSource))
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(shader)

	for !window.ShouldClose() {
		// Check if any events have been activiated (key pressed, mouse moved
		// etc.) and call corresponding response functions
		glfw.PollEvents()

		// Render
		// Clear the colorbuffer
		gl.ClearColor(0.2, 0.3, 0.3, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		// Swap the screen buffers
		window.SwapBuffers()
	}

	glfw.Terminate()
}

func onFramebufferSizeCallback(w *glfw.Window, width int, height int) {
	gl.Viewport(0, 0, int32(width), int32(height))
}
