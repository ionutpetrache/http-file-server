*** Settings ***
Documentation  robot suite to validate the http file server
Resource  ../keywords/httpserver_keywords.robot
Force Tags  file_server
Suite Setup   Suite Setup Keyword
Suite Teardown   Suite Teardown Keyword

*** Test Cases ***
Scenario 01: list endpoint should return files and directories
    [Tags]  file_server_01
    [Setup]  Test Setup Keyword
    [Teardown]  Test Teardown Keyword
    Given the http file server is running
    When i list the files inside the server working folder
    Then i should get a list for files
    And i should get a list for directories

Scenario 02: upload a new file to server working folder
    [Tags]  file_server_02
    [Setup]  Test Setup Keyword
    [Teardown]  Test Teardown Keyword
    Given the http file server is running
    When i upload a new file to server working folder
    Then i should be see the new file on the list

Scenario 03: delete all files and directories from server working folder
    [Tags]  file_server_03
    [Setup]  Test Setup Keyword
    [Teardown]  Test Teardown Keyword
    Given the http file server is running
    When i cleanup server working folder
    Then there should be no file left
    And there should be no directory left

Scenario 04: get a specific file from server working folder
    [Tags]  file_server_04
    [Setup]  Test Setup Keyword
    [Teardown]  Test Teardown Keyword
    Given the http file server is running
    When i upload a new file to server working folder
    Then i should be able to download the correct file from server

Scenario 05: replace an existing file from server working folder
    [Tags]  file_server_05
    [Setup]  Test Setup Keyword
    [Teardown]  Test Teardown Keyword
    Given i upload a new file to server working folder
    When i replace a file on server working folder
    Then the content should be replaced

Scenario 06: delete a specific file from server working folder
    [Tags]  file_server_06
    [Setup]  Test Setup Keyword
    [Teardown]  Test Teardown Keyword
    Given i upload a new file to server working folder
    When i delete a specific file from server working folder
    Then the file should not be listed anymore

Scenario 07: path to server working folder
    [Tags]  file_server_06
    [Setup]  Test Setup Keyword
    [Teardown]  Test Teardown Keyword
    Given the http file server is running
    When i request server information
    Then i should get server working folder


*** Keywords ***
Suite Setup Keyword
    Create Session    server_session    ${HTTP_FILE_SERVER_URI}  debug=5

Suite Teardown Keyword
    Comment  to be implemented

Test Setup Keyword
    Comment  to be implemented

Test Teardown Keyword
    Comment  to be implemented