#!/bin/bash

# Create embedded-wasm dir
mkdir -p embedded-wasm
cd embedded-wasm

# Clone repositories
REPOS=(spec rt rt_wasm3 rt_wasmtime hal_rs hal_as)

for R in $REPOS; do
    if [ ! -d $R ]; then
        git clone git@github.com:embedded-wasm/$R
    fi
done

# Setup workspace
echo '[workspace]' > Cargo.toml
echo 'members = [ "rt", "rt_wasm3", "hal_rs" ]' >> Cargo.toml
echo 'exclude = [ "spec" ]' >> Cargo.toml
echo '' >> Cargo.toml
echo '[patch.crates-io]' >> Cargo.toml
echo '#wasm-embedded-spec = { path = "./spec" }' >> Cargo.toml
echo 'wasm-embedded-rt_wasm3 = { path = "./rt_wasm3" }' >> Cargo.toml
