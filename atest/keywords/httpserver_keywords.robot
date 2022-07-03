*** Settings ***
Documentation  keywords to be use for http server validation
Resource  imports.robot
Resource  variables.robot

*** Keywords ***
the http file server is running
    Comment  to do

i list the files inside the server working folder
    ${response} =  GET On Session  server_session  ${FILES_ENDPOINT}
    Set Test Variable    $result_json   ${response.json()}

i should get a list for files
    Dictionary Should Contain Key    ${result_json}    files

i should get a list for directories
    Dictionary Should Contain Key    ${result_json}    directories

i upload a new file to server working folder
    ${random} =  Generate Random String    12    [LOWER]
    Set Test Variable  $file_content  ${random}
    Set Test Variable  $file_name  example-${random}.txt
    ${path} =  Set Variable  ${TEST_DATA}${/}example-${random}.txt
    Create File  ${path}    ${random}
    ${stream} =  Get File For Streaming Upload   ${path}
    ${files} =  Create Dictionary  file  ${stream}
    ${response} =  POST On Session  server_session  ${FILES_ENDPOINT}  files=${files}
    Set Test Variable    $result_json   ${response.json()}

i should be see the new file on the list
    ${response} =  GET On Session  server_session  ${FILES_ENDPOINT}
    Set Test Variable    $result_json   ${response.json()}
    List Should Contain Value    ${result_json}[files]    ${file_name}

i cleanup server working folder
    ${response} =  DELETE On Session  server_session  ${FILES_ENDPOINT}
    Dictionary Should Contain Key  ${response.json()}  root

there should be no file left
    ${response} =  GET On Session  server_session  ${FILES_ENDPOINT}
    Should Be Empty  ${response.json()}[files]

there should be no directory left
    ${response} =  GET On Session  server_session  ${FILES_ENDPOINT}
    Should Be Empty  ${response.json()}[directories]

i should be able to download the correct file from server
    ${response} =  Get On Session  server_session  ${FILES_ENDPOINT}/${file_name}
    Should Not Be Empty  ${response.text}
    Should Be Equal  ${response.text}  ${file_content}

i replace a file on server working folder
    Set Test Variable  $new_file_content  new file content for test
    Create File   ${TEST_DATA}${/}replace.txt  ${new_file_content}
    ${stream} =  Get File For Streaming Upload   ${TEST_DATA}${/}replace.txt
    ${files} =  Create Dictionary  file  ${stream}
    ${response} =  PUT On Session  server_session  ${FILES_ENDPOINT}/${file_name}  files=${files}
#    Sleep  10s  Wait for async method to be completed

the content should be replaced
    ${response} =  Get On Session  server_session  ${FILES_ENDPOINT}/${file_name}
    Should Not Be Empty  ${response.text}
    Should Be Equal  ${response.text}  ${new_file_content}

i delete a specific file from server working folder
    ${response} =  DELETE On Session  server_session  ${FILES_ENDPOINT}/${file_name}
    Should Not Be Empty  ${response.json()}

the file should not be listed anymore
    ${response} =  GET On Session  server_session  ${FILES_ENDPOINT}
    List Should Not Contain Value    ${response.json()}[files]    ${file_name}