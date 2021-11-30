FROM docker.io/rust:latest

RUN apt update -yqq \
 && apt install -yqq --no-install-recommends \
      build-essential cmake libssl-dev pkg-config git musl-tools \
 && rustup update \
 && rustup toolchain add nightly --component rustfmt --component clippy \
 && rustup toolchain add stable --component rustfmt --component clippy \
 && rustup default stable \
 && cargo install cargo-tarpaulin \
 && cargo install cargo-llvm-cov \
 && cargo install cargo-deny \
 && cargo install sqlx-cli \
 && cargo install --git https://github.com/paritytech/cachepot

# Allows to add "https://gitlab.com" as well as "ssh://git@gitlab.com" dependencies to Cargo.toml.
RUN git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
