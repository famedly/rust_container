FROM docker.io/rust:bullseye

RUN apt update -yqq \
 && apt install -yqq --no-install-recommends \
      build-essential cmake libssl-dev pkg-config git musl-tools jq xmlstarlet lcov \
 && rustup update \
 && rustup toolchain add nightly --component rustfmt --component clippy --component llvm-tools-preview \
 && rustup toolchain add nightly-2022-02-22 --component rustfmt --component clippy --component llvm-tools-preview \
 && rustup toolchain add nightly-2022-04-14 --component rustfmt --component clippy --component llvm-tools-preview \
 && rustup toolchain add stable --component rustfmt --component clippy --component llvm-tools-preview \
 && rustup default stable \
 && cargo install grcov \
 && cargo install cargo-tarpaulin \
 && cargo install cargo-llvm-cov \
 && cargo install cargo-deny \
 && cargo install sqlx-cli \
 && cargo install --git https://github.com/paritytech/cachepot \
 && cargo install --git https://github.com/FlixCoder/cargo-lints.git \
 && cargo install typos-cli \
 && cargo install conventional_commits_linter \
 && cargo install cargo-udeps --locked \
 && cargo install cargo-nextest \
 && cargo install cargo-readme \
 && cargo install gitlab-report \
 && cargo install cargo-audit
COPY cobertura_transform.xslt /opt/
