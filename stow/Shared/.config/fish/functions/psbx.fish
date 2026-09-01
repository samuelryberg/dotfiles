function psbx --description 'Manage podman-based agent sandboxes (docker-sandbox style)'
    set -l cmd $argv[1]
    if test -z "$cmd"
        __psbx_help
        return 1
    end
    set -e argv[1]

    switch $cmd
        case create new
            __psbx_create $argv
        case start
            podman start $argv
        case stop
            podman stop $argv
        case rm remove
            podman rm -f $argv
        case exec
            __psbx_exec $argv
        case shell sh
            __psbx_shell $argv
        case cp
            podman cp $argv
        case ls list
            podman ps -a --filter label=psbx=true \
                --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'
        case logs
            podman logs $argv
        case help -h --help
            __psbx_help
        case '*'
            echo "psbx: unknown command '$cmd'" >&2
            __psbx_help
            return 1
    end
end

function __psbx_help
    echo 'psbx - podman sandbox helper (docker-sandbox style)'
    echo ''
    echo 'usage:'
    echo '  psbx create [-n name] [-w workspace] [-i image] [-m memory] [-c cpus]'
    echo '  psbx exec <name> <command...>'
    echo '  psbx shell <name>'
    echo '  psbx cp <src> <dst>            (podman cp syntax, e.g. name:/path)'
    echo '  psbx start|stop|rm <name>'
    echo '  psbx ls'
    echo '  psbx logs <name>'
    echo ''
    echo 'defaults: name=agent-sandbox workspace=$PWD image=ubuntu:24.04 memory=2g cpus=2 network=podman'
end

function __psbx_create
    argparse 'n/name=' 'w/workspace=' 'i/image=' 'm/memory=' 'c/cpus=' 'network=' -- $argv
    or return 1

    set -l name agent-sandbox
    set -q _flag_name; and set name $_flag_name

    set -l workspace $PWD
    set -q _flag_workspace; and set workspace $_flag_workspace
    set workspace (path resolve $workspace)

    set -l image ubuntu:24.04
    set -q _flag_image; and set image $_flag_image

    set -l memory 2g
    set -q _flag_memory; and set memory $_flag_memory

    set -l cpus 2
    set -q _flag_cpus; and set cpus $_flag_cpus

    set -l network podman
    set -q _flag_network; and set network $_flag_network

    if podman container exists $name
        echo "psbx: container '$name' already exists (use 'psbx rm $name' to remove it first)" >&2
        return 1
    end

    podman run -d --name $name \
        --network=$network \
        -v "$workspace:/workspace:Z" \
        --memory=$memory --cpus=$cpus \
        --label psbx=true \
        $image sleep infinity
    or return 1

    echo "psbx: created '$name' from $image, workspace mounted at $workspace -> /workspace"
end

function __psbx_exec
    if test (count $argv) -lt 2
        echo 'usage: psbx exec <name> <command...>' >&2
        return 1
    end
    set -l name $argv[1]
    set -e argv[1]
    podman exec $name $argv
end

function __psbx_shell
    set -l name agent-sandbox
    test (count $argv) -ge 1; and set name $argv[1]
    podman exec -it $name bash
end
