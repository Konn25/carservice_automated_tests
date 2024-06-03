*** Settings ***
Suite Setup       Connect To Database    psycopg2    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
Suite Teardown    Disconnect From Database
Library           SeleniumLibrary
Library           DateTime
Library           DatabaseLibrary
Library           Collections

*** Variables ***
${DBHost}         localhost
${DBName}         car_service
${DBUser}         super_admin
${DBPass}         SomeSecretPassword
${DBPort}         5432

*** Keywords ***
Set Date And Verify
    [Arguments]    ${element_id}    ${date}
    Wait Until Element Is Visible    id=${element_id}    10s
    Execute JavaScript    document.getElementById('${element_id}').value = '${date}'
    ${value}=    Get Value    id=${element_id}
    Should Be Equal    ${value}    ${date}

Insert Record
    [Arguments]    ${email}    ${name}    ${nickname}    ${password}
    ${insert_sql}=    Set Variable    INSERT INTO users (email, name, nick_name, password) VALUES ('${email}', '${name}', '${nickname}', '${password}')
    Execute SQL String    ${insert_sql}
    ${get_id_sql}=    Set Variable    SELECT id FROM users WHERE email = '${email}'
    ${new_result}=    Query    ${get_id_sql}
    ${new_id}=    Set Variable    ${new_result}[0][0]
    Log    New User ID: ${new_id}
    RETURN    ${new_id}

Get Record ID
    [Arguments]    ${result}
    ${existing_id}=    Set Variable    ${result}[0][0]
    Log    Found user id: ${existing_id}
    RETURN    ${existing_id}

*** Test Cases ***
OpenBrowser 640 X480
    Open Browser    http://localhost:4200    chrome
    Set Window Size    640    480
    Click Button    class:navbar-toggler
    Set Selenium Implicit Wait    3
    Click Element    xpath: //*[contains(text(), "Registration")]
    Wait Until Page Contains    Registration    4s
    Close Browser

OpenBrowser 1920x1080
    Open Browser    http://localhost:4200    chrome
    Set Window Size    1920    1080
    Click Element    xpath: //*[contains(text(), "Registration")]
    Set Selenium Implicit Wait    3
    Wait Until Page Contains    Registration    4s
    Close Browser

Database Connection
    Table Must Exist    admin
    Table Must Exist    car
    Table Must Exist    picture
    Table Must Exist    refueling
    Table Must Exist    repair
    Table Must Exist    repair_name
    Table Must Exist    users

Get User ID
    ${check_user}    Set Variable    SELECT id FROM users WHERE email = 'test2@test.com'
    ${result}    Query    ${check_user}
    Run Keyword If    '${result}' == '[]'    Insert Record    test2@test.com    test2    testelek2    a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3
    ${user_id}    Get Record ID    ${result}
    Set Global Variable    ${global_user_id}    ${user_id}
    Log    Global id variable set: ${global_user_id}

Login_Registerd_user
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Close Browser

Open Cars Menu
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Click Link    //*[@href="/cars"]
    Wait Until Page Contains    Add new car    4s
    Capture Page Screenshot
    Close Browser

Add new cars
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Click Link    //*[@href="/cars"]
    Wait Until Page Contains    Add new car    4s
    Click Element    xpath: //*[contains(text(), "Add new car")]
    Wait Until Page Contains    Manufacturer
    Click Element    //*[@id="manufacturer"]
    Input Text    //*[@id="manufacturer"]    BMW
    Click Element    //*[@id="type"]
    Input Text    //*[@id="type"]    E36
    Click Element    //*[@id="year"]
    Input Text    //*[@id="year"]    1995
    Click Element    //*[@id="fuels"]
    Select From List By Value    //*[@id="fuels"]    Petrol
    Click Element    //*[@id="kilometer"]
    Input Text    //*[@id="kilometer"]    289000
    Click Element    //*[@id="price"]
    Input Text    //*[@id="price"]    750000
    Click Element    //*[@id="engine"]
    Input Text    //*[@id="engine"]    2.3
    Click Button    //*[@id="saveCarButton"]
    Click Button    xpath: /html/body/ngb-modal-window/div/div/div[1]/button
    Wait Until Page Contains    BMW    4s
    Comment    Add another car
    Click Element    xpath: //*[contains(text(), "Add new car")]
    Wait Until Page Contains    Manufacturer
    Click Element    //*[@id="manufacturer"]
    Input Text    //*[@id="manufacturer"]    Toyota
    Click Element    //*[@id="type"]
    Input Text    //*[@id="type"]    Aygo
    Click Element    //*[@id="year"]
    Input Text    //*[@id="year"]    2004
    Click Element    //*[@id="fuels"]
    Select From List By Value    //*[@id="fuels"]    Petrol
    Click Element    //*[@id="kilometer"]
    Input Text    //*[@id="kilometer"]    123500
    Click Element    //*[@id="price"]
    Input Text    //*[@id="price"]    450000
    Click Element    //*[@id="engine"]
    Input Text    //*[@id="engine"]    1.2
    Click Button    //*[@id="saveCarButton"]
    Click Button    xpath: /html/body/ngb-modal-window/div/div/div[1]/button
    Wait Until Page Contains    Toyota    3s
    Capture Page Screenshot
    Close Browser

Open Car Details
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Click Link    //*[@href="/cars"]
    Wait Until Page Contains    Add new car    4s
    ${car_ids}    Set Variable    Select id From car where user_id = ${global_user_id}
    ${get_user_cars}    Query    ${car_ids}
    Log    User car ids: ${get_user_cars}
    # Random id from the list
    ${random_car_id}=    Evaluate    random.choice(${get_user_cars})    random
    Log    Random car id which is belong to the user: ${random_car_id}
    Click Link    //*[@href="/cars/car/data/${random_car_id}[0]"]
    Wait Until Page Contains    Repairs    4s
    Capture Page Screenshot
    Close Browser

Open Car Repair
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Click Link    //*[@href="/cars"]
    Wait Until Page Contains    Add new car    4s
    ${car_ids}    Set Variable    Select id From car where user_id = ${global_user_id}
    ${get_user_cars}    Query    ${car_ids}
    Log    User car ids: ${get_user_cars}
    # Random id from the list
    ${random_car_id}=    Evaluate    random.choice(${get_user_cars})    random
    Log    Random car id which is belong to the user: ${random_car_id}
    Click Link    //*[@href="/cars/car/data/${random_car_id}[0]"]
    Wait Until Page Contains    Repairs    4s
    Click Element    xpath: //*[contains(text(), "Repairs")]
    Wait Until Page Contains    Add new repair    3s
    Capture Page Screenshot
    Close Browser










Add New Repair
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Click Link    //*[@href="/cars"]
    Wait Until Page Contains    Add new car    4s
    ${car_ids}    Set Variable    Select id From car where user_id = ${global_user_id}
    ${get_user_cars}    Query    ${car_ids}
    Log    User car ids: ${get_user_cars}
    # Random id from the list
    ${random_car_id}=    Evaluate    random.choice(${get_user_cars})    random
    Log    Random car id which is belong to the user: ${random_car_id}
    Click Link    //*[@href="/cars/car/data/${random_car_id}[0]"]
    Wait Until Page Contains    Repairs    4s
    Click Element    xpath: //*[contains(text(), "Repairs")]
    Wait Until Page Contains    Add new repair    3s
    Click Element    xpath: //*[contains(text(), "Add new repair")]
    Click Element    //*[@id="selectRepair"]
    Select From List By Value    //*[@id="selectRepair"]    1
    Click Element    //*[@id="repairPrice"]
    Input Text    //*[@id="repairPrice"]    15789
    Set Date And Verify    selectDate    2024-04-21
    Click Button    //*[@id="saveRepair"]
    Wait Until Page Contains    15789    3s
    Capture Page Screenshot
    Close Browser


Open Car Fuel Consumptions
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Click Link    //*[@href="/cars"]
    Wait Until Page Contains    Add new car    4s
    ${car_ids}    Set Variable    Select id From car where user_id = ${global_user_id}
    ${get_user_cars}    Query    ${car_ids}
    Log    User car ids: ${get_user_cars}
    # Random id from the list
    ${random_car_id}=    Evaluate    random.choice(${get_user_cars})    random
    Log    Random car id which is belong to the user: ${random_car_id}
    Click Link    //*[@href="/cars/car/data/${random_car_id}[0]"]
    Wait Until Page Contains    Repairs    4s
    Click Element    xpath: //*[contains(text(), "Fuel consumption")]
    Wait Until Page Contains    Quantity    3s
    Capture Page Screenshot
    Close Browser

Add New Fuel Consumption
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Click Link    //*[@href="/cars"]
    Wait Until Page Contains    Add new car    4s
    ${car_ids}    Set Variable    Select id From car where user_id = ${global_user_id}
    ${get_user_cars}    Query    ${car_ids}
    Log    User car ids: ${get_user_cars}
    # Random id from the list
    ${random_car_id}=    Evaluate    random.choice(${get_user_cars})    random
    Log    Random car id which is belong to the user: ${random_car_id}
    Click Link    //*[@href="/cars/car/data/${random_car_id}[0]"]
    Wait Until Page Contains    Repairs    4s
    Click Element    xpath: //*[contains(text(), "Fuel consumption")]
    Wait Until Page Contains    Quantity    3s
    Click Element    xpath: //*[contains(text(), "Add new fuel consumption")]
    Click Element    //*[@id="quantity"]
    Input Text    //*[@id="quantity"]    15.6
    Click Element    //*[@id="fuelPrice"]
    Input Text    //*[@id="fuelPrice"]    13000
    Click Element    //*[@id="actualKilometer"]
    Input Text    //*[@id="actualKilometer"]    158765
    Set Date And Verify    fuelDate    2024-06-01
    Click Button    xpath: //*[contains(text(), "Save")]
    Wait Until Page Contains    158765    3s
    Capture Page Screenshot
    Close Browser








Open Car Pictures
    ${email}    Set Variable    test2@test.com
    ${password}    Set Variable    123
    Open Browser    http://localhost:4200    chrome
    Maximize Browser Window
    Click Element    //*[@id="floatingEmail"]
    Input Text    //*[@id="floatingEmail"]    ${email}
    Click Element    //*[@id="floatingPassword"]
    Input Text    //*[@id="floatingPassword"]    ${password}
    Click Button    //*[@class="btn btn-primary"]
    Wait Until Page Contains    ${email}    3s
    Click Link    //*[@href="/cars"]
    Wait Until Page Contains    Add new car    4s
    ${car_ids}    Set Variable    Select id From car where user_id = ${global_user_id}
    ${get_user_cars}    Query    ${car_ids}
    Log    User car ids: ${get_user_cars}
    # Random id from the list
    ${random_car_id}=    Evaluate    random.choice(${get_user_cars})    random
    Log    Random car id which is belong to the user: ${random_car_id}
    Click Link    //*[@href="/cars/car/data/${random_car_id}[0]"]
    Wait Until Page Contains    Repairs    4s
    Click Element    xpath: //*[contains(text(), "Update Picture")]
    Wait Until Page Contains    Pictures    3s
    Capture Page Screenshot
    Close Browser
