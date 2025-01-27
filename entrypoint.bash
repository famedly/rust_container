#!/bin/bash

# Famedly Rust Container entrypoint.
#
# Configures the runtime to be used for various CI jobs.

echo "Preparing Rust build environment"


if [ -n "${FCR_SSH_KEY}" ]; then
    echo "Setting up SSH"

    # Get an ssh agent running
    USER="$(whoami)"
    SSH_HOME="$(getent passwd "$USER" | cut -d: -f6)" # Is different from $HOME in docker containers, because github CI..
    eval "$(ssh-agent)" # This exports the socket to `SSH_AUTH_SOCK`

    # Import the SSH key from the secret
    ssh-add -vvv - <<< "${FCR_SSH_KEY}"$'\n' # ensure newline at the end of key

    # Import host keys for GitHub and Gitlab
    mkdir -p "$SSH_HOME/.ssh"
    (
        ssh-keyscan -H gitlab.com
        ssh-keyscan -H github.com
    ) >> "$SSH_HOME/.ssh/known_hosts"
fi


if [ -n "${FCR_ADDITIONAL_RUST_PACKAGES}" ]; then
    echo "Installing additional packages: ${FCR_ADDITIONAL_RUST_PACKAGES}"
    # shellcheck disable=SC2086
    apt-get install -yqq --no-install-recommends ${FCR_ADDITIONAL_RUST_PACKAGES}
fi


echo "Configuring cargo"

CARGO_HOME="${HOME}/${CARGO_HOME}"
mkdir -p "${CARGO_HOME}"
cat << EOF >> "${CARGO_HOME}/config.toml"
[net]
git-fetch-with-cli = true
EOF

# Don't write anything for crates-io, since it is baked-in and cargo
# special cases on it so configuring it works differently anyway.
if [ -n "${FCR_CRATES_REGISTRY}" ] &&  [ "${FCR_CRATES_REGISTRY}" != "crates-io" ]; then
    case "${FCR_CRATES_REGISTRY}" in
        "famedly")
            FCR_CRATES_REGISTRY_INDEX="${FCR_CRATES_REGISTRY_INDEX:-ssh://git@ssh.shipyard.rs/famedly/crate-index.git}"
            ;;
        "")
            if [ -z "${FCR_CRATES_REGISTRY_INDEX}" ]; then
                echo "Error: Crate registry index URL not known for ${FCR_CRATES_REGISTRY}. Configure it using \$FCR_CRATES_REGISTRY_INDEX." > /dev/stderr
                exit 1
            fi
            ;;
    esac

    cat << EOF >> "${CARGO_HOME}/config.toml"
[registries.${FCR_CRATES_REGISTRY}]
index = "${FCR_CRATES_REGISTRY_INDEX}"
EOF
fi


if [ -n "${GITHUB_ENV}" ]; then
    # TODO(tlater): Check if this is even necessary; AIUI we should
    # remain in the container env and therefore these variables should
    # already be set.
    echo "Exporting created environment variables"

    (
        echo "CARGO_HOME=${CARGO_HOME}"
        echo "SSH_AUTH_SOCK=${SSH_AUTH_SOCK}"
    ) >> "$GITHUB_ENV"
fi


echo "Preparations finished"
"$@"
