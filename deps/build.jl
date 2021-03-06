using CMake
using Libdl

QHULL_WRAPPER_FOUND    = true

QHULL_WRAPPER_SOURCES  = joinpath(@__DIR__, "MiniQhullWrapper")
QHULL_WRAPPER_BUILD    = joinpath(QHULL_WRAPPER_SOURCES, "build")
QHULL_WRAPPER_LIB_DIR  = joinpath(QHULL_WRAPPER_BUILD,"lib")

QHULL_WRAPPER_LIB_NAME    = ""
QHULL_WRAPPER_LIB_PATH    = ""
QHULL_WRAPPER_LIB_NAMES   = ["libMiniQhullWrapper.$(Libdl.dlext)"]

QHULL_ROOT_DIR = "/usr"
if haskey(ENV,"QHULL_ROOT_DIR") 
    QHULL_ROOT_DIR = ENV["QHULL_ROOT_DIR"]
elseif VERSION >= v"1.3"
    using Qhull_jll
    QHULL_ROOT_DIR = Qhull_jll.artifact_dir
end


# Check QHULL_WRAPPER_SOURCES dir exists
if isdir(QHULL_WRAPPER_SOURCES)
    @info "MiniQhullWrapper root directory at: $QHULL_WRAPPER_SOURCES"

    # Check QHULL_WRAPPER_BUILD exists
    if isdir(QHULL_WRAPPER_BUILD)
        rm(QHULL_WRAPPER_BUILD, recursive=true)
    end
    mkdir(QHULL_WRAPPER_BUILD)

    # Configure MiniQhullWrapper cmake project
    try
        configure  = run(`$cmake -DQHULL_ROOT_DIR=$QHULL_ROOT_DIR -B $QHULL_WRAPPER_BUILD -S $QHULL_WRAPPER_SOURCES`)
        if configure.exitcode != 0
            @warn "MiniQhullWrapper configure step fail with code: $(configure.exitcode)"
            global QHULL_WRAPPER_FOUND=false
        else
            # Build MiniQhullWrapper cmake project
            build  = run(`$cmake --build $QHULL_WRAPPER_BUILD`)
            if build.exitcode != 0
                @warn "MiniQhullWrapper build step fail with code: $(build.exitcode)"
                global QHULL_WRAPPER_FOUND=false
            else
                # Test MiniQhullWrapper cmake project
                test  = run(`$cmake --build $QHULL_WRAPPER_BUILD --target test`)
                if test.exitcode != 0
                    @warn "MiniQhullWrapper test step fail with code: $(build.exitcode)"
                    global QHULL_WRAPPER_FOUND=false
                end
            end
        end
    catch e
        @warn "Something wrong has happened while building MiniQhullWrapper"
        global QHULL_WRAPPER_FOUND=false
    end
else
    @warn "MiniQhullWrapper root directory not found at: $QHULL_WRAPPER_SOURCES"
    global QHULL_WRAPPER_FOUND=false
end

if QHULL_WRAPPER_FOUND
    # Check QHULL_LIB_DIR (.../lib directory) exists
    if isdir(QHULL_WRAPPER_LIB_DIR)
        @info "MiniQhullWrapper lib directory found at: $QHULL_WRAPPER_LIB_DIR"
    else
        QHULL_WRAPPER_LIB_DIR = ""
        @warn "MiniQhullWrapper lib directory not found: $QHULL_WRAPPER_LIB_DIR"
    end

    if isempty(QHULL_WRAPPER_LIB_NAME)
        QHULL_WRAPPER_LIB_NAME=Libdl.find_library(QHULL_WRAPPER_LIB_NAMES, [QHULL_WRAPPER_LIB_DIR])
    end

    if isempty(QHULL_WRAPPER_LIB_NAME)
        @warn "MiniQhullWrapper library not found: $QHULL_WRAPPER_LIB_NAMES"
        QHULL_WRAPPER_FOUND = false
    else
        QHULL_WRAPPER_LIB_PATH=Libdl.dlpath(QHULL_WRAPPER_LIB_NAME)
        @info "MiniQhullWrapper library found: $QHULL_WRAPPER_LIB_NAMES"
    end
end


# Write QHULL configuration to deps.jl file
deps_jl = "deps.jl"

if isfile(deps_jl)
  rm(deps_jl)
end

open(deps_jl,"w") do f
  println(f, "# This file is automatically generated")
  println(f, "# Do not edit")
  println(f)
  println(f, :(const QHULL_WRAPPER_FOUND    = $QHULL_WRAPPER_FOUND))
  println(f, :(const QHULL_WRAPPER_LIB_DIR  = $QHULL_WRAPPER_LIB_DIR))
  println(f, :(const QHULL_WRAPPER_LIB_NAME = $QHULL_WRAPPER_LIB_NAME))
  println(f, :(const QHULL_WRAPPER_LIB_PATH = $QHULL_WRAPPER_LIB_PATH))
end

@info """
QHULL configuration:
==============================================
  - QHULL_WRAPPER_FOUND    = $QHULL_WRAPPER_FOUND
  - QHULL_WRAPPER_LIB_DIR  = $QHULL_WRAPPER_LIB_DIR
  - QHULL_WRAPPER_LIB_NAME = $QHULL_WRAPPER_LIB_NAME
  - QHULL_WRAPPER_LIB_PATH = $QHULL_WRAPPER_LIB_PATH
"""

