from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import sys


#driver = webdriver.Chrome()
url  = sys.argv[1] 
options = webdriver.ChromeOptions()
#There is a conflict wiht your current session and the session that you want to use for selenium
#To solve it run the ($cp -r ~.config/google-chrome/Default Automations) 
options.add_argument("user-data-dir=~/.config/google-chrome/Automations")
#log manually with email and password and 
options.add_experimental_option("detach", True)


driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()),options=options,keep_alive=True)
print('I\'m here')
driver.get(url)
element =  driver.find_elements(by='css selector',value='.css-17jso0u.e1dvqv261')
print(element)
print(element[0])
element[0].click()
