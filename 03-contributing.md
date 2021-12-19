# Contributing

First make sure you've got the tools installed per [Getting Started](./02-getting-started.md).

Heads up that there are a lot of moving parts, and it's definitely not a _simple_ process (sorry!). We hope that in future more of this will be generated / automated, but we're waiting for the [WITX](https://github.com/WebAssembly/WASI/blob/main/docs/witx.md) specification to stabilise before this is likely. If you have any ideas for simplifying the process please do let us know!

**Please note these instructions were moved from a prior monorepo version of this project, the _concept_ is the same but the links and components are yet to be updated. You can see the original docs [here](https://ryan.kurte.nz/embedded-wasm)**

## Updating the docs

[embedded-wasm/book](https://github.com/embedded-wasm/book) contains these docs, please feel free to open a PR!

## Proposing an API

So recon we're missing a useful API? (you're probably right). Before going down the implementation path you may wish to open an [issue]() for discussion.

Once you're ready to implement, there are a few steps to the process. You'll need to be familiar with building rust and C projects, and you'll need to setup a workspace to coordinate these changes between components. If you run into any roadblocks please open an issue!

### Updating the [specification](https://github.com/embedded-wasm/spec)

- Add a [witx]() specification for the protocol to the `witx` folder (see [witx/spi.witx](https://github.com/embedded-wasm/spec/blob/main/witx/spi.witx) for an example)
- Update the list of specs in `lib/api.rs` to tell `wiggle` where to find the document
- Add rust platform API to `src/` (see [src/spi.rs](https://github.com/embedded-wasm/spec/blob/main/src/spi.rs) for an example)
- Add C platform API to `lib/` (see [inc/wasm_embedded/spi.h](https://github.com/embedded-wasm/spec/blob/main/inc/wasm_embedded/spi.h) for an example)
- Add a test definition to `tests/` for qualification of runtimes / HALs

### Updating the runtimes

You will first need to implement each of your API for the underlying `rt-wasm3` or `rt-wasmtime` runtime, then in `wasm-embedded-rt`:

- Add a mock implementation to `src/mock/` for mock execution, see [src/mock/i2c.rs](https://github.com/ryankurte/embedded-wasm/rt/tree/main/src/mock/i2c.rs) for an example
- Add a linux implementation to `src/linux/` for runtime use, see [src/linux/i2c.rs](https://github.com/ryankurte/embedded-wasm/rt/tree/main/src/linux/i2c.rs) for an example


### Updating rt-wasm3

The `rt-wasm3` C library is designed to simplify porting and embedding. A simple Object Oriented C / VTable style object is defined in the spec for each API, hiding the runtime implementation from the user and supporting dependency injection and other useful testing tricks.

To add an API:

- Create new source and header files for your API
- Add the new source file to [CMakeLists.txt](https://github.com/embedded-wasm/rt_wasm3/tree/main/lib/CMakeLists.txt) to add it to the build
- Add the new header file to [build.rs](https://github.com/embedded-wasm/rt_wasm3/blob/main/lib/build.rs) with appropriate allow-listing to support rust binding generation
  - Ensure you block generation of driver types from the `spec` package (eg, `spi_drv_t`) to avoid generating conflicting incompatible symbols
- Create C function declarations for the new methods and a container object (vtable-esque) to hold these
- Add m3 calls for each new method, deferring to the container object
- Add a helper function to bind an instance of this API to the wasme runtime (see `WASME_bind_i2c`).
- Add C bindings to the rust runtime, see [rt/src/wasm3/](https://github.com/ryankurte/embedded-wasm/tree/main/rt/src/wasm3) for examples.

Explaining all of this is more difficult than showing so, see [lib/src/i2c.c](https://github.com/ryankurte/embedded-wasm/tree/main/lib/src/i2c.c) and [lib/inc/wasme/i2c.h](https://github.com/ryankurte/embedded-wasm/tree/main/lib/inc/wasme/i2c.h) for an example.

When working with the library you can build with `make lib`, or use the classic CMake approach from `lib/` of:
- `mkdir build && cd build` to create and switch to a build directory
- `cmake ..` to setup the project
- `make` to perform a build

When the runtime is built with `--features=wasm3` the `ewasm` library will also be included. You can use this instead however, the logs exposed when building under cargo leave a lot to be desired.


### Updating the HAL (rust)

This HAL exposes the API to rust users, providing an implementation of [embedded-hal](https://github.com/rust-embedded/embedded-hal).

- Create a new source file in [hal_rs/src/]() for the new API
- Create an API module with `extern` definitions for the WASI interface
- Create a wrapper type for the API object, using the handle and `extern` functions, see [hal_rs/src/i2c.rs](https://github.com/ryankurte/embedded-wasm/blob/main/hal_rs/src/i2c.rs) for an example


### Updating the HAL (AssemblyScript)

This HAL exposes the API to AssemblyScript users. 

- Create a new source file in [hal_rs/src/]() for the new API
- Create an API module with `extern` definitions for the WASI interface
- Create a wrapper type for the API object, using the handle and `extern` functions, see [hal_rs/src/i2c.rs](https://github.com/ryankurte/embedded-wasm/blob/main/hal_rs/src/i2c.rs) for an example

### Testing your changes

TODO


## Hints

- All APIs use integer handles for each device/peripheral to avoid passing around opaque objects
  - On initialisation a positive handle should be returned
  - These handles are managed by the runtime and should be closed or will be cleaned-up on exit
- Remember that the WASM runtime has it's own address space
  - Function calls with objects will resolve to an integer address that must be translated before access
  - If an object contains a pointer you will also need to translate this prior to accessing containing data
- The WASM call ABI is not yet stable / widely supported
  - WITX allows multiple returns, in practice this _may_ resolve to an extra argument in the function call (eg. `fn do(a) -> Result<b, c>` becomes `fn do(a, &mut b) -> c` in WASM)
- The makefile re-maps a bunch of generated file paths to approximate using a workspace, this is helpful because workspaces do not support multiple targets
