# Getting Started

To get started using `embedded-wasm` you need to find a suitable runtime for your platform, and the appropriate Hardware Abstraction Layer (HAL) to write applications in your language of choice. 
If your language or platform isn't supported, check out the [porting](./06-porting.md) documentation, and for more information on building/testing `embedded-wasm` components, see [contributing](./03-contributing.md)

For the purposes of this guide, we're going to use the `wasm-embedded-rt` the linux runtime on a Raspberry Pi, as it's a common platform with useful physical interfaces, and the rust HAL. 
You're going to need [rust](https://rustup.rs) installed, and may find it useful to set `$PROJECT` as an environmental variable while following along.

_Please note this is very much a work in progress, expect some hickups / bugs / sharp edges that are yet-to-be resolved_

### Installing the runtime

First we need to install the runtime. The most straightfoward approach is to fetch a precompiled binary from the [releases](https://github.com/embedded-wasm/rt/releases/latest) page.

For aarch64 (64-bit):
```
wget https://github.com/embedded-wasm/rt/releases/download/v0.1.2/wasm-embedded-rt-aarch64-unknown-linux-gnu.tgz
tar -xvf wasm-embedded-rt-aarch64-unknown-linux-gnu.tgz
sudo cp wasm-embedded-rt /usr/local/bin
```

For armv7 (32-bit), note this only supports the `wasm3` engine:
```
wget https://github.com/embedded-wasm/rt/releases/download/latest/wasm-embedded-rt-armv7-unknown-linux-gnueabihf.tgz
tar -xvf wasm-embedded-rt-armv7-unknown-linux-gnueabihf.tgz
sudo cp wasm-embedded-rt /usr/local/bin
```

Alternately you can use: 
- `cargo binstall wasm-embedded-rt` to install the precompiled binary via [`cargo-binstall`](https://github.com/ryankurte/cargo-binstall)
- `cargo install wasm-embedded-rt` to build from source (note you may need to set [features](https://github.com/embedded-wasm/rt/blob/main/.github/workflows/ci.yml#L21) appropriate to your platform)

Once you have this installed you should be able to invoke `wasm-embedded-rt`:
```
> wasm-embedded-rt --help
wasm-embedded-rt 0.1.2

USAGE:
    wasm-embedded-rt [OPTIONS] <bin>

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

OPTIONS:
        --config <config>          Configuration file (toml)
        --log-level <log-level>    Configure app logging levels (warn, info, debug, trace) [default: info]
        --mode <mode>              Operating mode [default: dynamic]
        --runtime <runtime>        Runtime [default: wasmtime]

ARGS:
    <bin>    WASM binary to execute
```

### Building an application

To get started with the rust HAL you will need to setup a new cargo binary project (where `$PROJECT` is your project name). You can do this on the Raspberry Pi, or another machine (though you will need to copy binaries to the RPi).

1. `cargo new --bin $PROJECT && cd $PROJECT` to create the project and change to the new directory
2. `rustup target add wasm32-wasi` to add the `wasm32-wasi` target
3. `mkdir .cargo && echo '[build]\r\ntarget = "wasm32-wasi"' > .cargo/config` to set the default build target
  - note this can also be set using `forced-target = "wasm32-wasi"` in `Cargo.toml`
4. `cargo add wasm-embedded-hal` to add the `wasm-embedded-hal` dependency (via [`cargo-edit`](https://github.com/killercup/cargo-edit/))
5. `cargo build` to build the application

Once you've setup your project you can use the provided APIs to talk to physical peripherals, add the following to your `src/main.rs` and build with `cargo build`.

```rust
//! An I2C detect example using wasm-embedded-hal
//!
// Copyright 2020 Ryan Kurte

use embedded_hal::i2c::blocking::*;
use wasm_embedded_hal::i2c::I2c;

/// Default I2C bus to poll (must be enabled via `raspi-config`)
const BUS: u32 = 1;

fn main() {
    // Connect to I2C device
    let mut i2c = match I2c::init(BUS, 0, -1, -1) {
        Ok(v) => v,
        Err(_e) => return,
    };

    println!("Scanning addresses on bus: {}", BUS);

    // For each possible address
    for i in 0..128 {
        // Print the address every line
        if i % 16 == 0 {
            print!("0x{:02x}: ", i);
        }

        // Attempt a read
        let mut d = [0u8; 1];
        match i2c.read(i, &mut d) {
            Ok(_) => print!("{:02x} ", d),
            Err(_) => print!("-- "),
        }

        // Line break every 16 addresses
        if i % 16 == 15 {
            print!("\r\n");
        }
    }

    // Shutdown the I2C device
    i2c.deinit();

    return;
}
```

For more examples check out [`hal_rs/examples`](https://github.com/embedded-wasm/hal_rs/tree/main/examples).


### Running your application

If you're working remotely, copy your new binary to the RPi with `scp target/debug/$PROJECT.wasm pi@raspberrypi` (replacing `raspberrypi` with a different hostname if required).

You can then run your new application on the RPi:

```
> wasm-embedded-rt --mode linux --log-level error --runtime wasm3 $PROJECT.wasm
Loading WebAssembly (mod: wasme, p: 0x7fb90bb010, 1950651 bytes)...
Initialising I2C device: 1
Received I2C handle: 0
Scanning addresses on bus: 1
0x00: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
0x10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
0x20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
0x30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
0x40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
0x50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
0x60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
0x70: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
```

_Note we're using `--runtime wasm3` here due to a bug in the `wasmtime` runtime error codes, this will be removed when resolved_
