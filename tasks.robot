*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
...    
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.PDF
Library    RPA.Archive
Library    RPA.FileSystem

*** Tasks ***
Order robots from RobotSpareBin Industries
    Open RobotSpareBin Industries website
    Download orders excel file
    Create orders
    Create ZIP file from receipts
    Cleanup temporary directories
    

*** Keywords ***
Open RobotSpareBin Industries website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order
    Maximize Browser Window

Close initial modal
    Click Button    OK

Download orders excel file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=${True}

Create orders
    ${orders}=    Read table from CSV    orders.csv    header=${True}
    FOR    ${order}    IN    @{orders}
        Close initial modal
        Fill form for an order    ${order}
        
    END

Fill form for an order
    [Arguments]    ${order}
    Select From List By Value    id:head    ${order}[Head]
    Select Radio Button    body    ${order}[Body]
    Input Text    css:input[type=number]    ${order}[Legs]
    Input Text    id:address    ${order}[Address]
    Retry until successfull submit
    Take screenshot of the robot preview    ${order}[Order number]
    Store the receipt as a PDF file for the order    ${order}[Order number]
    Click Button    id:order-another

Take screenshot of the robot preview
    [Arguments]    ${order_number}
    Sleep    1s
    Wait Until Element Is Visible    id:robot-preview-image
    Screenshot    id:robot-preview-image    ${OUTPUT_DIR}${/}screenshots${/}${order_number}.png

Submit order
    Click Button    id:order    
    Wait Until Element Is Visible    css:.alert-success    timeout=1

Retry until successfull submit
    Wait Until Keyword Succeeds    5x    0.5s    Submit order

Store the receipt as a PDF file for the order
    [Arguments]    ${order_number}
    ${images}=    Create List     ${OUTPUT_DIR}${/}screenshots${/}${order_number}.png
    ${order_result_html}=    Get Element Attribute    id:order-completion    outerHTML
    Html To Pdf    ${order_result_html}    ${OUTPUT_DIR}${/}receipts${/}${order_number}.pdf
    Add Files To Pdf    ${images}    ${OUTPUT_DIR}${/}receipts${/}${order_number}.pdf    append=${True}
    
Create ZIP file from receipts
    ${zip_file_name}=    Set Variable    ${OUTPUT_DIR}${/}receipts.zip
    Archive Folder With Zip    ${OUTPUT_DIR}${/}receipts    ${zip_file_name}

Cleanup temporary directories
    Remove Directory    ${OUTPUT_DIR}${/}receipts    ${True}
    Remove Directory    ${OUTPUT_DIR}${/}screenshots    ${True}