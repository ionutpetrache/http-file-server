*** Settings ***
Documentation  robot suite to validate the http file server
Resource  ../keywords/httpserver_keywords.robot
Force Tags  file_server

*** Test Cases ***
Scenario 01: list all files and folders from server working folder
    Comment  to be implemented

Scenario 02: upload a new file to server working folder
    Comment  to be implemented

Scenario 03: delete all files and directories from server working folder
    Comment  to be implemented

Scenario 04: get a specific file from server working folder
    Comment  to be implemented

Scenario 05: replace an existing file from server working folder
    Comment  to be implemented

Scenario 06: delete a specific file from server working folder
    Comment  to be implemented