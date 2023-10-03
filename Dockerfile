FROM docker.io/rust:bullseye

ARG NIGHTLY_VERSION=nightly-2023-09-10
ENV NIGHTLY_VERSION=${NIGHTLY_VERSION}

RUN apt update -yqq 
RUN apt install -yqq --no-install-recommends \
     build-essential cmake libssl-dev pkg-config git musl-tools jq xmlstarlet lcov protobuf-compiler libprotobuf-dev libprotoc-dev 
RUN rustup toolchain uninstall /usr/local/rustup/toolchains/* 
RUN rustup toolchain add $NIGHTLY_VERSION --component rustfmt --component clippy --component llvm-tools-preview 
RUN rustup toolchain add stable --component rustfmt --component clippy --component llvm-tools-preview 
RUN rustup default stable 
RUN cargo install grcov 
RUN cargo install cargo-cache 
RUN cargo install cargo-llvm-cov 
RUN cargo install cargo-deny 
RUN cargo install sqlx-cli 
RUN cargo install --git https://github.com/paritytech/cachepot 
RUN cargo install --git https://github.com/FlixCoder/cargo-lints.git 
RUN cargo install typos-cli 
RUN cargo install conventional_commits_linter 
RUN cargo install cargo-udeps --locked 
RUN cargo install cargo-nextest 
RUN cargo install cargo-readme 
RUN cargo install gitlab-report 
RUN cargo install cargo-audit 
RUN cargo install cargo-vet 
RUN cargo install --git https://github.com/kate-shine/cargo-license.git --branch  shine/gitlab_license_scan --force # fix after it gets merged to upstream 
RUN cargo cache -a
COPY cobertura_transform.xslt /opt/
