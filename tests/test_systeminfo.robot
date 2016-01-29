*** Settings ***
Documentation          This suite is used for testing system information
...                    capability from the openbmc host

Resource        ../lib/rest_client.robot


*** Variables ***


*** Test Cases ***
Get the location
    ${resp} =   openbmc get request     /org/openbmc/information
    ${json} =   to json                 ${resp.content}
    list should contain value           ${json['data']}         Message

Write some information
    ${TEXT} =       Set Variable    OpenPower system
    ${data} =       Create Data for action    ${TEXT}
    ${resp} =       openbmc post request    /org/openbmc/information/action/MessageCreate      data=${data}
    ${content}=     Read Attribute       /org/openbmc/information     Message
    Should Be Equal     ${content}      ${TEXT}

Write some information 3 times
    ${TEXT} =       Set Variable    OpenPower system
    ${data} =       Create Data for action    ${TEXT}
    ${resp} =       openbmc post request    /org/openbmc/information/action/MessageCreate      data=${data}
    ${resp} =       openbmc post request    /org/openbmc/information/action/MessageCreate      data=${data}
    ${resp} =       openbmc post request    /org/openbmc/information/action/MessageCreate      data=${data}
    ${content}=     Read Attribute       /org/openbmc/information     Message
    Should Be Equal     ${content}      ${TEXT}

Append some information
    ${TEXT1} =      Set Variable    Part of a
    ${data} =       Create Data for action    ${TEXT1}
    ${resp} =       openbmc post request    /org/openbmc/information/action/MessageCreate      data=${data}
    ${content}=     Read Attribute       /org/openbmc/information     Message
    Should Be Equal     ${content}      ${TEXT1}
    ${TEXT2} =      Set Variable    \sentence
    ${data} =       Create Data for action   ${SPACE}${TEXT2}
    ${resp} =       openbmc post request    /org/openbmc/information/action/MessageAppend      data=${data}
    ${content}=     Read Attribute       /org/openbmc/information     Message
    ${str} =        catenate  ${TEXT1}     ${TEXT2}
    Should Be Equal     ${content}      ${str}

Clear the information
    ${TEXT} =       Set Variable    OpenPower system
    ${data} =       Create Data for action    ${TEXT}
    ${resp} =       openbmc post request    /org/openbmc/information/action/MessageCreate      data=${data}
    ${content}=     Read Attribute       /org/openbmc/information     Message
    Should Be Equal     ${content}      ${TEXT}
    ${data} =       create dictionary   data=@{EMPTY}
    ${resp} =       openbmc post request    /org/openbmc/information/action/Clear      data=${data}
    ${content}=     Read Attribute       /org/openbmc/information     Message
    Should Be Equal     ${content}      \

Clear 3 times
    ${TEXT} =       Set Variable    OpenPower system
    ${data} =       Create Data for action    ${TEXT}
    ${resp} =       openbmc post request    /org/openbmc/information/action/MessageCreate      data=${data}
    ${content}=     Read Attribute       /org/openbmc/information     Message
    Should Be Equal     ${content}      ${TEXT}
    ${data} =       create dictionary   data=@{EMPTY}
    ${resp} =       openbmc post request    /org/openbmc/information/action/Clear      data=${data}
    ${resp} =       openbmc post request    /org/openbmc/information/action/Clear      data=${data}
    ${resp} =       openbmc post request    /org/openbmc/information/action/Clear      data=${data}
    ${content}=     Read Attribute       /org/openbmc/information     Message
    Should Be Equal     ${content}      \

*** Keywords ***
Create Data for Action
    [arguments]     ${var}
    @{list} =   Create List     ${var}
    ${data} =   create dictionary   data=@{list}
    [return]    ${data}
