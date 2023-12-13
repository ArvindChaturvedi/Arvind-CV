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

# Read the system namespaces from the file
readarray -t SYSTEM_NAMESPACES < "$SYSTEM_NAMESPACES_FILE"

# Iterate through namespaces
for NAMESPACE in $(kubectl get namespaces -o=jsonpath='{.items[*].metadata.name}'); do
    # Check if the current namespace is a system namespace to be excluded
    if [[ " ${SYSTEM_NAMESPACES[@]} " =~ " ${NAMESPACE} " ]]; then
        echo "Skipping system namespace: $NAMESPACE"
    else
        # Retrieve the status of pods in the current namespace
        echo "Namespace: $NAMESPACE"
        kubectl get pods --namespace="$NAMESPACE" --no-headers=true
        echo "-------------------------"
    fi
done
