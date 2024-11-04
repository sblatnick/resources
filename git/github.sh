#!/bin/bash

#Using .ghrc:
  #Auth with:
    gh tok #app
    gh usr #user
    gh svc #service account

  #GET:
    gh get ${ENDPOINT}
    #alias to:
    gh api --method GET -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" ${ENDPOINT}
  #PUT:
    gh put ${ENDPOINT}
    #alias to:
    gh api --method PUT -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" ${ENDPOINT}

  #Get rate limit usage for the current hour:
    gh get rate_limit

#Examples:
  #Get repo alerts:
    gh get /repos/${ORG}/${REPO}/dependabot/alerts
    gh get /repos/${ORG}/${REPO}/code-scanning/alerts
  #Get repo variables:
    gh get /repos/${ORG}/${REPO}/actions/variables
  #Get file locations of secrets found:
    gh get /repos/${ORG}/${REPO}/secret-scanning/alerts/1/locations

  #Get details of codeql scans:
    gh get /repos/${ORG}/${REPO}/code-scanning/analyses
  #Get repo activity:
    gh get /repos/${ORG}/${REPO}/activity

  #Get teams:
    gh get /repos/${ORG}/${REPO}/teams
  #Get team's repos:
    gh get /orgs/${ORG}/teams/${TEAM}/repos | jq -r ".[] .name"
  #Get Advisory details:
    gh get /advisories/GHSA-jfh8-c2jp-5v3q
