#!/bin/bash

# Create embedded-wasm dir
mkdir -p embedded-wasm
cd embedded-wasm

# Clone repositories
REPOS=("spec" "rt" "rt_wasm3" "rt_wasmtime" "hal_rs" "hal_as" "book")

for R in ${REPOS[*]}; do
    if [ ! -d $R ]; then
        git clone git@github.com:embedded-wasm/$R
    fi
done

# Setup workspace
if [ ! -d "Cargo.toml" ]; then
    echo '[workspace]' > Cargo.toml
    echo 'members = [ "rt", "rt_wasm3", "rt_wasmtime", "hal_rs" ]' >> Cargo.toml
    echo 'exclude = [ "spec" ]' >> Cargo.toml
    echo '' >> Cargo.toml

    echo '[patch.crates-io]' >> Cargo.toml
    echo 'wasm-embedded-spec = { path = "./spec" }' >> Cargo.toml
    echo 'wasm-embedded-rt-wasm3 = { path = "./rt_wasm3" }' >> Cargo.toml
    echo 'wasm-embedded-rt-wasmtime = { path = "./rt_wasmtime" }' >> Cargo.toml
fi
