#!/usr/bin/env sh

show_usage() {
    echo "usage: $(basename $0) document.md [document2.md [document3.md [...]]]"
    exit 84
}

function clean_file() {
    rm -f .err
    exit 84
}

if [ $# -lt 1 ]; then
    show_usage
fi

exit_status=0

for file in "$@"; do
    filename=$(echo "$file" | cut -d'.' -f1)
    if [ -f "$filename.pdf" ] && [ "$filename.pdf" -nt "$file" ]; then
	echo "Converting $file to pdf: ALREADY UP-TO-DATE"
    else
	/template/Epitech_md-compilation.sh "$file" &>.err
        error_code=$?
	if [ $error_code -eq 0 ]; then
	    echo "Converting $file to pdf: OK"
	else
            exit_status=$error_code
	    echo "Converting $file to pdf: KO"
	    tail -n15 .err >&2
	fi
    fi
done

exit $exit_status
