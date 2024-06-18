FROM docker.io/rust:bookworm

ARG NIGHTLY_VERSION=nightly-2024-06-17
ENV NIGHTLY_VERSION=${NIGHTLY_VERSION}

RUN apt update -yqq \
     && apt install -yqq --no-install-recommends \
     build-essential cmake libssl-dev pkg-config git musl-tools jq xmlstarlet lcov protobuf-compiler libprotobuf-dev libprotoc-dev \
     && rustup toolchain add $NIGHTLY_VERSION --component rustfmt --component clippy --component llvm-tools-preview \
     && rustup toolchain add stable --component rustfmt --component clippy --component llvm-tools-preview \
     && rustup default stable \
     && cargo install grcov \
     && cargo install cargo-cache \
     && cargo install cargo-llvm-cov \
     && cargo install cargo-deny \
     && cargo install sqlx-cli \
     && cargo install typos-cli \
     && cargo install conventional_commits_linter \
     && cargo install cargo-udeps --locked \
     && cargo install cargo-nextest \
     && cargo install cargo-readme \
     && cargo install cargo-audit \
     && cargo install cargo-auditable \
     && cargo install cargo-license \
     && cargo cache -a
COPY cobertura_transform.xslt /opt/
