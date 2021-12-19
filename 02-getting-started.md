# Getting Started

To get started using `embedded-wasm` you need to find a suitable platform or runtime and the appropriate hardware abstraction layer to write applications your language of choice.

If your language or platform isn't supported, check out the [porting](./06-porting.md) documentation.
For more information on building/testing `embedded-wasm` components, see [contributing](./03-contributing.md)


## Specification

The [embedded-wasm/spec](https://github.com/embedded-wasm/spec) project provides the `witx` API specification as well as helper abstractions for platform implementations and standard tests for HAL/runtime interoperability.

## Runtimes:

#### [wasm-embedded-rt](./06-runtime.md)

An embedded-wasm runtime for execution on linux / macOS / windows, wrapping specific runtime implementations to provide a ready-to-go binary.
This supports mocking on all platforms, with physical hardware access only on linux (for now?).

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-rt.svg)](https://crates.io/crates/wasm-embedded-rt)
[![Docs.rs](https://docs.rs/wasm-embedded-rt/badge.svg)](https://docs.rs/wasm-embedded-rt)

You can install this with `cargo install wasm-embedded-rt` or grab a binary from the [releases](https://github.com/ryankurte/embedded-wasm/releases/latest) page.


#### [wasm-embedded-rt-wasm3](./runtimes/wasm3)

A C/wasm3 based runtime designed for embedding, built into `wasm-embedded-rt`, see the [rt-wasm3](./07-library.md) section for usage.

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-lib.svg)](https://crates.io/crates/wasm-embedded-lib)
[![Docs.rs](https://docs.rs/wasm-embedded-lib/badge.svg)](https://docs.rs/wasm-embedded-lib)

Typically you'll want to embed this library in your project, either as a git submodule or by copying out the `lib` directory.


## Language Bindings / HALs

#### Rust

Rust bindings based on [embedded-hal](https://github.com/rust-embedded/embedded-hal).

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-hal.svg)](https://crates.io/crates/wasm-embedded-hal)
[![Docs.rs](https://docs.rs/wasm-embedded-hal/badge.svg)](https://docs.rs/wasm-embedded-hal)

### AssemblyScript

Bindings for [AssemblyScript](https://www.assemblyscript.org), compiled with `asc`.

[![npm](https://img.shields.io/npm/v/wasm-embedded-hal)](https://npmjs.com/package/wasm-embedded-hal)


## Tools

#### [wasm-embedded-cli]()

A command line interface for interacting with embedded-wasm capable devices.

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-cli.svg)](https://crates.io/crates/wasm-embedded-cli)
[![Docs.rs](https://docs.rs/wasm-embedded-cli/badge.svg)](https://docs.rs/wasm-embedded-cli)

