#!/bin/bash

# This script is here because sometimes the apt tasks in the play hang (for some unclear reason), so timeouts and retries are needed but ansible doesn't support that (on a task or play level). See links in the playbook.yaml about this

trap "echo 'Ctrl+C pressed. Exiting...'; exit 1" SIGINT

# Using the environment variable works around this directory being world-writable (which doesn't really seem like a concern in a codespace), see https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-writable-dir for more details
ANSIBLE_CONFIG=./ansible.cfg
export ANSIBLE_CONFIG
# "adminuser" here is duplicated in "main.tf"
command="ansible-playbook playbook.yaml -vv -i inventory.ini -u adminuser"

timeout_duration=90  
max_retries=10        
retry_count=0

# Relying on the idempotency/re-entrancy of playbook tasks here

while (( retry_count < max_retries )); do
    echo "Playbook attempt #$(( retry_count + 1 ))"

    # --foreground is here so timeout can receive the SIGINT and forward it. See https://ss64.com/bash/timeout.html
    if timeout --foreground "$timeout_duration" $command; then
        echo "Playbook succeeded after $(( retry_count + 1 )) attempts"
        exit 0
    else
        echo "Playbook timed out or failed, retrying..."
    fi

    # Increment retry count
    ((retry_count++))
done

echo "Playbook failed after $max_retries retries."
exit 1