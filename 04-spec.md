# APIs

This project provides a set of platform APIs to support embedded applications, designed to be platform, language, and runtime, independent. APIs are designed to be simple, avoiding the transfer of complex objects over the WASM boundary and leaving the construction and management of objects to the runtime and library. 

Runtime abstractions and libraries mean that most users should not need to interact with these directly so, unless you're planning to implement a runtime or library you may choose to skip this section.

For more information (and the actual specifications), see [embedded-wasm/spec](https://github.com/embedded-wasm/spec).

### Low Level APIs

- [I2C](./spec/i2c.md)
- [SPI](./spec/spi.md)
- [UART](./spec/uart.md)
- [GPIO](./spec/gpio.md)

### High Level APIs

- [LED](./spec/led.md)
- [Display](./spec/display.md)
- [Pub/Sub](./spec/pub_sub.md)
