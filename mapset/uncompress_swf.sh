#!/bin/bash
for swf in "$@"
do
    signature=$(dd if="$swf" bs=1 count=3 2> /dev/null)
    case "$signature" in
        FWS)
            echo -e "uncompressed\t$swf"
            ;;
        CWS)
            targetname="$(dirname "$swf")/uncompressed_$(basename "$swf")"
            echo "uncompressing to $targetname"

            dd if="$swf" bs=1 skip=8 2>/dev/null |
                (echo -n 'FWS';
                 dd if="$swf" bs=1 skip=3 count=5 2>/dev/null;
                 zlib-flate -uncompress) > "$targetname"
            ;;
        *)
            {
                echo -e "unrecognized\t$swf"
                file "$swf"
            } > /dev/stderr
            ;;
    esac

done
