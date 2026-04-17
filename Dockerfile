FROM ubuntu:24.04

RUN apt-get update -qq && \
    apt-get install -y -qq curl git zsh sudo >/dev/null 2>&1 && \
    rm -rf /var/lib/apt/lists/*

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# Create test user
RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Usage:
#   docker build -t dotfiles-test .
#   docker run -it --rm dotfiles-test chezmoi init --apply openjny/dotfiles --exclude=scripts
#   docker run -it --rm dotfiles-test zsh
