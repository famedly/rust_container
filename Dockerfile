FROM docker.io/rust:bullseye

ARG NIGHTLY_VERSION=nightly-2023-09-10
ENV NIGHTLY_VERSION=${NIGHTLY_VERSION}

RUN apt update -yqq \
     && apt install -yqq --no-install-recommends \
     build-essential cmake libssl-dev pkg-config git musl-tools jq xmlstarlet lcov protobuf-compiler libprotobuf-dev libprotoc-dev \
     && rustup toolchain uninstall /usr/local/rustup/toolchains/* \
     && rustup toolchain add $NIGHTLY_VERSION --component rustfmt --component clippy --component llvm-tools-preview \
     && rustup toolchain add stable --component rustfmt --component clippy --component llvm-tools-preview \
     && rustup default stable \
     && cargo install grcov \
     && cargo install cargo-cache \
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
     && cargo install cargo-audit \
     && cargo install cargo-auditable \
     && cargo install --git https://github.com/kate-shine/cargo-license.git --branch  shine/gitlab_license_scan --force # fix after it gets merged to upstream \
     && cargo cache -a
COPY cobertura_transform.xslt /opt/
