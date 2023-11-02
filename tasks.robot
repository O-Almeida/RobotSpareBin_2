*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
...    
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.HTTP

*** Tasks ***
Order robots from RobotSpareBin Industries
    Open RobotSpareBin Industries website
    
    

*** Keywords ***
Open RobotSpareBin Industries website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

   