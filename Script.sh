#!/bin/bash

# Specify the path to the file containing system namespaces to exclude
SYSTEM_NAMESPACES_FILE="system_namespaces.txt"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found. Please make sure kubectl is installed and in your PATH."
    exit 1
fi

# Check if the system namespaces file exists
if [ ! -f "$SYSTEM_NAMESPACES_FILE" ]; then
    echo "System namespaces file '$SYSTEM_NAMESPACES_FILE' not found."
    exit 1
fi

# Iterate through namespaces
while IFS= read -r NAMESPACE; do
    # Trim leading and trailing whitespaces from the namespace
    NAMESPACE=$(echo "$NAMESPACE" | tr -d '[:space:]')

    # Check if the current namespace is a system namespace to be excluded
    if [ -n "$NAMESPACE" ]; then
        echo "Namespace: $NAMESPACE"
        # Retrieve the status of pods in the current namespace
        kubectl get pods --namespace="$NAMESPACE" --no-headers=true
        echo "-------------------------"
    fi
done < "$SYSTEM_NAMESPACES_FILE"
