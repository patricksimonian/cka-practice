#!/bin/bash
NAME=$1
NAMESPACE=$2
REVISION=$3

DEPLOYMENT_HISTORY=$(kubectl rollout history deployment/"$NAME" -n "$NAMESPACE")

echo "deployment/$NAME history"


TITLE=$(echo "$DEPLOYMENT_HISTORY" | sed -n "2p")

REVISIONS=$(echo "$DEPLOYMENT_HISTORY" | tail -n +2 | awk 'NR > 1 {printf "%-5d   %s\n", NR-2, $0}')


echo "INDEX   $TITLE"
echo "$REVISIONS"

if [ -z "$REVISION" ]; then
 echo "Positional Argument 2 was not set to select a revision. Use the index to select the revision you want to rollback to"
 exit 0
fi

REVISION_NO=""
IFS=' ' read -r -a REVISION_NO <<< "${REVISIONS[$REVISION]}"
DESIRED_REVISION=${REVISION_NO[1]}
echo -n -e "\e[33mRevision selected ${DESIRED_REVISION}\e[0m\n"

kubectl rollout undo "deployment/$NAME" -n "$NAMESPACE" --to-revision="$DESIRED_REVISION"

