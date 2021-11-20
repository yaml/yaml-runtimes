#!/bin/sh

set -e

PROCESS_TIMEOUT="${PROCESS_TIMEOUT:-3}"
SHARE=/shared
INPUT=input.yaml

wait_for_events() {
    # TODO end process when script or container is killed
    inotifywait --quiet --monitor -e moved_to -e close_write "$SHARE" | while read line; do
        f="$(echo $line | cut -d" " -f3)"
#        echo "EVENT: f=$f"
        if [[ "$f" == "$INPUT" ]]; then
            requested_views
            e="$(echo $line | cut -d" " -f2)"
#            echo "EVENT: $e (line: $line)"
            echo "$INPUT changed"
            process
        elif [[ "$f" == "$RUNTIME.stop" ]]; then
            echo "+++ STOP +++"
            killall inotifywait
            rm "$SHARE/$RUNTIME.stop"
            break
        fi
    done
}

process() {
    # Run the requested view on the input file
    local rc i cmd
    for i in $REQUESTED; do
        rc=0
        mv "$SHARE/$i.request" "$SHARE/$i.view"
        echo "Process $i"
        cmd="/yaml/bin/${i/\./-}"
        timeout "$PROCESS_TIMEOUT" nice -n 19 "$cmd" < "$SHARE/$INPUT" >"$SHARE/$i.processing" 2>&1 || rc=$?
        mv "$SHARE/$i.processing" "$SHARE/$i"
        rm "$SHARE/$i.view"
        echo "rc=$rc"
    done
}

provided_views() {
    # Which views does this container provide?
    PROVIDED="$(tail -n +2 /yaml/info/views.csv | cut -d, -f1)"
    re="$(echo "$PROVIDED" | tr '\n' '|')"
    re="${re::-1}"
    echo "REGEX: $re"
    echo -n "Provided views:"
    for i in $PROVIDED; do
        echo -n " $i"
    done
    echo

}
requested_views() {
    # Which views were requested and are provided by this container?
    local views i
    views="$(cd $SHARE; ls *.request | sed -e 's/\.request//' || true)"
    REQUESTED=""
    for i in $views; do
        echo "$i" | grep -q -E $re && REQUESTED="$REQUESTED $i"
    done
    echo -n "Requested views:"
    for i in $REQUESTED; do
        echo -n " $i"
    done
    echo
}

provided_views

wait_for_events

echo "END OF PROGRAM"

exit
