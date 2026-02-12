#!/bin/bash

EXPECTED_OUTPUT="$1"
STUDENT_OUTPUT="$2"

while read -r STUDENT_KEY; do
    git clone "https://github.com/CSE2307SP26/${STUDENT_KEY}.git" "$STUDENT_KEY" > /dev/null 2>&1

    cd "$STUDENT_KEY"

    git checkout cipher > /dev/null 2>&1

    LAST_COMMIT=$(git log --before="2026-02-12T10:00:00-06:00" -1 --format="%H")
    git checkout "$LAST_COMMIT" > /dev/null 2>&1

    javac Cipher.java
    java Cipher > /dev/null 2>&1

    if [ -f "$STUDENT_OUTPUT" ]; then
        if diff -q "$STUDENT_OUTPUT" "../$EXPECTED_OUTPUT" > /dev/null 2>&1; then
            SCORE=1
        else
            SCORE=0
        fi
    else
        SCORE=0
    fi

    echo "$STUDENT_KEY $SCORE"

    cd ..
    rm -rf "$STUDENT_KEY"
done