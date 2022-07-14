#!/bin/bash
set -ex

# Looks like only able to conditionally decide with CIRCLE_PULL_REQUEST and CIRCLE_BRANCH
# at runtime instead of circleci evaluation time for the workflow we're trying to achieve.
# So will "cancel" workflows that don't really want to run we can see this with the status visually.
#
if [ -n "$CIRCLE_PULL_REQUEST" ]; then
  exec terraspace plan "$@"
else
  if [ "$CIRCLE_BRANCH" == "main" ]; then
    exec terraspace up "$@" -y
  else
    # cancel workflow and set status
    if [ -n "$CIRCLE_TOKEN" ] ; then
      # https://circleci.com/docs/api/v2/index.html#operation/cancelWorkflow
      curl --request POST \
        --header "Circle-Token: $CIRCLE_TOKEN" \
        https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/cancel
      sleep 10 # seems to allow the curl request to cancel consistently
    fi
    # For correct Workflow Cancelled Status also. Correct status only if also cancel via the API
    circleci step halt
  fi
fi
