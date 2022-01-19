
RE="${YAML_RUNTIMES[@]}"
RE="${RE// /\|}"
PREFIX=yamlio

imageformat="{{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"
get-images() {
    docker images --format "$imageformat" "yamlio/alpine-r*" | grep -v '<none>' | grep -v -- '-all' | cut -d$'\t' -f1 | grep -E "($RE)" | cut -d/ -f2
}

get-containers() {
#    docker ps -a --filter name=runtime- --format="{{.ID}}\t{{.Image}}\t{{.Names}}"
    docker ps -a --filter name=runtime- --format="{{.Names}}"
}

get-not-running() {
    local re_running
    running=($(get-containers))
    re_running="${running[@]}"
    re_running="${re_running// /|}"
    get-images | grep -v -E "^($re_running)$"
}

get-running() {
    local re_running
    running=($(get-containers))
    re_running="${running[@]}"
    re_running="${re_running// /|}"
    get-images | grep -E "^($re_running)$"
}

get-runtime-args() {
    args=()
    local possible given
    for possible in "${YAML_RUNTIMES[@]}"; do
        for given in "$@"; do
            if [[ $possible == "alpine-runtime-$given" ]]; then
                args+=("alpine-runtime-$given")
            elif [[ $possible == $given ]]; then
                args+=("$given")
            fi
        done
    done
}

status-running() {
    local args re cmd runtime
    get-runtime-args $*
    notrunning=($(get-not-running))
    re="${notrunning[@]}"
    re="${re// /\|}"
    running=($(get-running))
    rre="${running[@]}"
    rre="${rre// /\|}"
    printf "%-30s Status\n" "Runtime"
    for runtime in "${args[@]}"; do
        if echo "$runtime" | grep -qE "^($re)$"; then
            printf "%-30s -\n" "$runtime"
        elif echo "$runtime" | grep -qE "^($rre)$"; then
            printf "%-30s X\n" "$runtime"
        else
            printf "%-30s ?\n" "$runtime"
        fi
    done
}

start-not-running() {
    local args re cmd runtime
    get-runtime-args $*
    notrunning=($(get-not-running))
    re="${notrunning[@]}"
    re="${re// /\|}"
    for runtime in "${args[@]}"; do
        if echo "$runtime" | grep -qE "^($re)$"; then
            echo "starting $runtime..."
            cmd=(
                 docker run -d -it --rm --user $UID --name "$runtime" \
                     -v "$YAML_RUNTIMES_ROOT"/shared:/shared
                     -v "$YAML_RUNTIMES_ROOT"/scripts:/scripts
                     $PREFIX/$runtime /scripts/run.sh
            )
            "${cmd[@]}"
        fi
    done
}

stop-running() {
    local args re cmd runtime
    get-runtime-args $*

    echo "notifying runtimes to stop..."
    running=($(get-containers))
    re="${running[@]}"
    re="${re// /\|}"
    for runtime in "${args[@]}"; do
        if echo "$runtime" | grep -qE "^($re)$"; then
            touch "$YAML_RUNTIMES_ROOT/shared/${runtime/alpine-runtime-/}.stop"
            sleep 0.2
        fi
    done

    sleep 0.2
    running=($(get-containers))
    [[ "${#running[@]}" -gt 0 ]] || return
    echo "still running: ${running[@]}"
    re="${running[@]}"
    re="${re// /\|}"
    for runtime in "${args[@]}"; do
        if echo "$runtime" | grep -qE "^($re)$"; then
            echo "killing $runtime..."
            rc=0
            out="$(docker kill $runtime 2>&1 || rc=$?)"
            [[ $rc -eq 0 ]] && [[ $out =~ No[[:blank:]]such[[:blank:]]container ]] || echo "ERROR: $out" >&2 && continue
        fi
    done
}

pull-images() {
    local args re cmd runtime
    get-runtime-args $*
    for runtime in "${args[@]}"; do
        if echo "$runtime" | grep -qE "$re"; then
            echo "pulling $runtime..."
            cmd=(docker pull yamlio/$runtime)
            echo "${cmd[@]}"
            set -x
            "${cmd[@]}"
            set +x
        fi
    done
}

push-images() {
    local args re cmd runtime
    get-runtime-args $*
    for runtime in "${args[@]}"; do
        if echo "$runtime" | grep -qE "$re"; then
            echo "pushing $runtime..."
            cmd=(docker push yamlio/$runtime)
            echo "${cmd[@]}"
            set -x
            "${cmd[@]}"
            set +x
        fi
    done
}

