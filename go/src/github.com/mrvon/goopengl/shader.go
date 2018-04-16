package main

import (
	"fmt"

	"github.com/go-gl/gl/v3.3-core/gl"
)

type Shader struct {
	program uint32
}

func (s *Shader) Use() {
	gl.UseProgram(s.program)
}

func createShader(vSource string, fSource string) (*Shader, error) {
	newShader := func(shaderSource string, shaderType uint32) (uint32, error) {
		var shader uint32 = gl.CreateShader(shaderType)

		src, free := gl.Strs(shaderSource)
		defer free()

		length := int32(len(shaderSource))

		gl.ShaderSource(shader, 1, src, &length)
		gl.CompileShader(shader)

		var success int32
		gl.GetShaderiv(shader, gl.COMPILE_STATUS, &success)
		if success == gl.FALSE {
			var logLen int32
			gl.GetShaderiv(shader, gl.INFO_LOG_LENGTH, &logLen)

			infoLog := make([]byte, logLen)
			gl.GetShaderInfoLog(shader, logLen, nil, &infoLog[0])
			return 0, fmt.Errorf("error compiling vertex shader: %s", string(infoLog))
		}

		return shader, nil
	}
	var program uint32 = gl.CreateProgram()
	vshader, err := newShader(vSource, gl.VERTEX_SHADER)
	if err != nil {
		return nil, err
	}
	defer gl.DeleteShader(vshader)
	fshader, err := newShader(fSource, gl.FRAGMENT_SHADER)
	if err != nil {
		return nil, err
	}
	defer gl.DeleteShader(fshader)
	gl.AttachShader(program, vshader)
	gl.AttachShader(program, fshader)
	gl.LinkProgram(program)

	var success int32
	gl.GetProgramiv(program, gl.LINK_STATUS, &success)
	if success == gl.FALSE {
		var logLen int32
		gl.GetProgramiv(program, gl.INFO_LOG_LENGTH, &logLen)

		infoLog := make([]byte, logLen)
		gl.GetProgramInfoLog(program, logLen, nil, &infoLog[0])
		return nil, fmt.Errorf("error linking shader program: %s", string(infoLog))
	}

	return &Shader{program: program}, nil
}
