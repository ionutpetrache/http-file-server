*** Settings ***
Documentation  global variables to be use for http server validation

*** Variables ***
${HTTP_FILE_SERVER_PROTOCOL}  http
${HTTP_FILE_SERVER_IP}  localhost
${HTTP_FILE_SERVER_PORT}  8000
${HTTP_FILE_SERVER_URI}  ${HTTP_FILE_SERVER_PROTOCOL}://${HTTP_FILE_SERVER_IP}:${HTTP_FILE_SERVER_PORT}
${FILES_ENDPOINT}  ${HTTP_FILE_SERVER_URI}/files
${ATEST_ROOT}  ${CURDIR}${/}..
${TEST_DATA}  ${ATEST_ROOT}${/}data
