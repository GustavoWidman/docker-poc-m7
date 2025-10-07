#!/usr/bin/env nu

const LOG_COLORS = {
    info: "blue"
    success: "green"
    warn: "yellow"
    error: "red"
    debug: "dark_gray"
    host: "magenta_bold"
    path: "cyan"
    cmd: "white_dimmed"
}

def log [
    level: string
    message: string
    --exit (-e)
    --no-newline (-n)
    --return-instead
] {
    let color = ($LOG_COLORS | get $level)
    let prefix = match $level {
        "info" => "›"
        "success" => "✓"
        "warn" => "⚠"
        "error" => "✗"
        "debug" => "•"
        _ => "›"
    }

    let msg = $"[(ansi $color)($prefix)(ansi reset)] ($message)"

    if $return_instead {
        return $msg
    }

    if $exit {
        error make -u {
            msg: $msg
        }
    }

    if $no_newline {
        print -n $msg
    } else {
        print $msg
    }
}

export def main []: nothing -> nothing {
    print $"(ansi green)docker-poc-m7 toolkit(ansi reset)\n"
    print $"(ansi green)Subcommands(ansi reset):"
    print $"  (ansi cyan)build(ansi reset)  - Build the docker image"
    print $"  (ansi cyan)run(ansi reset)    - Build and run the docker image locally"
    print $"  (ansi cyan)push(ansi reset)   - Build and push the docker image to DockerHub"
    print $"\n(ansi green)Use (ansi yellow)toolkit <subcommand> --help(ansi green) for more information on a command(ansi reset)"
}

# Build the docker image
export def build [
    --tag (-t): string = "docker-poc-m7:latest"  # Docker image tag
]: nothing -> nothing {
    log info $"building docker image: (ansi ($LOG_COLORS.path))($tag)(ansi reset)..."

    try {
        docker build -t $tag .
        log success $"successfully built image: (ansi ($LOG_COLORS.path))($tag)(ansi reset)"
    } catch {
        log error "failed to build docker image" --exit
    }
}

# Build and then run the docker image locally
export def run [
    --tag (-t): string = "docker-poc-m7:latest"  # Docker image tag
    --port (-p): int = 8080  # Host port to bind to
    --name (-n): string = "docker-poc-m7"  # Container name
    --detach (-d)  # Run container in background
]: nothing -> nothing {
    build --tag $tag

    log info $"starting container in foreground..."

    # Stop and remove existing container if it exists
    try {
        docker stop $name err> /dev/null | ignore
        docker rm $name err> /dev/null | ignore
    }

    let detach_flag = if $detach { ["-d"] } else { [] }

    try {
        if not $detach {
            log info $"access the application at: (ansi ($LOG_COLORS.host))http://127.0.0.1:($port)(ansi reset)"
        }
        docker run ...$detach_flag --name $name -p $"($port):80" $tag

        if $detach {
            log success $"container started in background"
            log info $"access the application at: (ansi ($LOG_COLORS.host))http://127.0.0.1:($port)(ansi reset)"
        } else {
            docker stop $name err> /dev/null | ignore
            docker rm $name err> /dev/null | ignore
        }
    } catch {
        log error "failed to run docker container" --exit
    }
}

# Build and then push the docker image to DockerHub
export def push [
    --tag (-t): string = "docker-poc-m7:latest"  # Docker image tag
    --registry (-r): string  # Registry to push to (e.g., username/repo:tag)
]: nothing -> nothing {
    if ($registry == null) {
        log error $"registry is required. use (ansi $LOG_COLORS.path)--registry \(-r\)(ansi reset) to specify the target \(e.g., username/repo:tag\)" --exit
    }

    log info $"building docker image with tag: (ansi ($LOG_COLORS.path))($tag)(ansi reset)"
    build --tag $tag

    log info $"tagging image for registry: (ansi ($LOG_COLORS.path))($registry)(ansi reset)"
    try {
        docker tag $tag $registry
    } catch {
        log error "failed to tag image for registry" --exit
    }

    log info $"Pushing to registry: (ansi ($LOG_COLORS.path))($registry)(ansi reset)"
    try {
        docker push $registry
        log success $"successfully pushed image to (ansi ($LOG_COLORS.path))($registry)(ansi reset)"
    } catch {
        log error $"failed to push to registry. make sure you're logged in with '(ansi ($LOG_COLORS.path))docker login(ansi reset)'" --exit
    }
}
