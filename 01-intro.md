# Introduction

This project defines WASI APIs for embedded devices with the aim of providing common language and platform independent runtimes for embedded use, allowing applications to be abstract from platforms, supporting dynamic discovery and hot reloading of applications, and making it easy to design / share / mess with embedded things.

The WASI APIs are intended to span from basic peripheral drivers like SPI and I2C, to more complex functionality like driving LEDs or displays and publishing or subscribing to data. Everything one could need to write unreasonably portable embedded applications.

The project provides an API specification with runtimes to support the execution of this and Hardware Abstraction Layers (HALs) for application development. To get started using embedded-wasm, grab the relevant components and/or check out the [Getting Started](./02-getting-started) section.

You might also be interested in the [chat](https://app.element.io/#/room/#wasm-embedded:matrix.org) and project [meta issue](https://github.com/embedded-wasm/spec/issues/2).


## Components

## [Specification](https://github.com/embedded-wasm/spec)

The [embedded-wasm/spec](https://github.com/embedded-wasm/spec) project provides the `witx` API specification as well as helper abstractions for platform implementations and standard tests for HAL/runtime interoperability.

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-spec.svg)](https://crates.io/crates/wasm-embedded-spec)
[![Docs.rs](https://docs.rs/wasm-embedded-spec/badge.svg)](https://docs.rs/wasm-embedded-spec)


### Runtimes

#### [wasm-embedded-rt](https://github.com/embedded-wasm/rt)

An embedded-wasm runtime for execution on linux / macOS / windows, wrapping specific runtime implementations to provide a ready-to-go binary. This supports mocking on all platforms, with physical hardware access only on linux (for now?).

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-rt.svg)](https://crates.io/crates/wasm-embedded-rt)
[![Docs.rs](https://docs.rs/wasm-embedded-rt/badge.svg)](https://docs.rs/wasm-embedded-rt)

You can install this with `cargo install wasm-embedded-rt` or grab a binary from the [releases](https://github.com/embedded-wasm/rt/releases/latest) page.


#### [wasm-embedded-rt-wasmtime](https://github.com/embedded-wasm/rt_wasmtime)

A Rust/wasmtime based engine for application use, built into `wasm-embedded-rt` with the `rt_wasmtime` feature.

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-rt-wasmtime.svg)](https://crates.io/crates/wasm-embedded-rt-wasmtime)
[![Docs.rs](https://docs.rs/wasm-embedded-rt-wasmtime/badge.svg)](https://docs.rs/wasm-embedded-rt-wasmtime)

Typically you'll want to embed this library in your project, either as a git submodule or by copying out the `lib` directory.


#### [wasm-embedded-rt-wasm3](https://github.com/embedded-wasm/rt_wasm3)

A C/wasm3 based engine designed for embedding, built into `wasm-embedded-rt-wasm3` with the `rt_wasm3` feature.

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-rt-wasm3.svg)](https://crates.io/crates/wasm-embedded-rt-wasm3)
[![Docs.rs](https://docs.rs/wasm-embedded-rt-wasm3/badge.svg)](https://docs.rs/wasm-embedded-rt-wasm3)

Typically you'll want to embed this library in your project, either as a cargo dependency, git submodule or by copying out the relevant directories (note for C use you will also need headers from `embedded-wasm/spec`).


### Hardware Abstraction Layers (HALs)

#### Rust

Rust bindings based on [embedded-hal](https://github.com/rust-embedded/embedded-hal).

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-hal.svg)](https://crates.io/crates/wasm-embedded-hal)
[![Docs.rs](https://docs.rs/wasm-embedded-hal/badge.svg)](https://docs.rs/wasm-embedded-hal)

Add this to your project with `cargo add wasm-embedded-hal`.

#### AssemblyScript

Bindings for [AssemblyScript](https://www.assemblyscript.org), compiled with `asc`.

[![npm](https://img.shields.io/npm/v/wasm-embedded-hal)](https://npmjs.com/package/wasm-embedded-hal)

Add this to your project with `npm install --save wasm-embedded-hal`.

### Tools

#### [wasm-embedded-cli]()

WIP: A command line interface for interacting with embedded-wasm capable devices.

[![Crates.io](https://img.shields.io/crates/v/wasm-embedded-cli.svg)](https://crates.io/crates/wasm-embedded-cli)
[![Docs.rs](https://docs.rs/wasm-embedded-cli/badge.svg)](https://docs.rs/wasm-embedded-cli)

