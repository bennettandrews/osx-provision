#!/bin/bash

PROVISION_DIR=/tmp/provision
GITHUB_REPO=https://github.com/bennettandrews/osx-provision.git

function pause(){
    printf "\n%b\n" "$*"
    read -p ""
}

xcode_cli_tools() {
    xcode_status=$(xcode-select --print 2> /dev/null)
    if [ $? -gt 0 ]; then
        info "Installing command line tools"
    else
        warn "Command line tools are already installed"
        return
    fi
    xcode-select --install 2> /dev/null
    pause "Press return once the command line tools are installed."
}

ansible_deps() {
    info "Installing python dependencies"
    if [ ! -x /usr/local/bin/pip ]; then
        sudo easy_install -q pip
        sudo pip -q install virtualenv
    fi
    mkdir -p $PROVISION_DIR
    virtualenv $PROVISION_DIR
    /tmp/provision/bin/pip -q install ansible
}

clone_repo() {
    git clone -q  $PROVISION_DIR/repo
}

main() {
    xcode_cli_tools
    clone_repo
    ansible_deps
    ansible
}

if [ $# -eq 0 ]; then
    main
fi
