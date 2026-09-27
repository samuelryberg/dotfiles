if status is-interactive
    # Homebrew
    if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    else if type -q brew
        eval (brew shellenv)
    end

    # Proton Pass SSH agent
    set -x SSH_AUTH_SOCK ~/.ssh/proton-pass-agent.sock

    # -- General --
    # Navigation
    alias .2='cd ../..'
    alias .3='cd ../../..'
    alias ll='ls -lah'
    alias la='ls -A'

    # Network
    alias myip='curl -s ifconfig.me'
    alias myip6='curl -s ifconfig.me/ip6'

    # -- Git --
    alias g='git'
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit -m'
    alias gp='git push'
    alias gpl='git pull'
    alias gst='git stash'
    alias gstp='git stash pop'

    # Undo last commit but keep changes staged
    alias gundo='git reset --soft HEAD~1'

    # -- Kubernetes --
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgn='kubectl get nodes'
    alias kgs='kubectl get svc'
    alias kgd='kubectl get deployments'

    # Describe
    alias kdp='kubectl describe pod'
    alias kdn='kubectl describe node'

    # -- Terraform/OpenTofu --
    set tf tofu
    alias tf='$tf'
    alias tfi='$tf init'
    alias tfp='$tf plan'
    alias tfa='$tf apply'
    alias tfd='$tf destroy'
    alias tfo='$tf output'
    alias tfs='$tf show'
    alias tfv='$tf validate'

    # Fastfetch
    if type -q fastfetch
        fastfetch
    end
end
