from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.action_chains import ActionChains
import shutil
import time
from selenium.webdriver.chrome.service import Service

site = "https://aureliennicosiaulaval.github.io/MQT-2101/modules/semaine-09-variables-externes-autocorrelation/"
options = Options()
options.add_argument("--headless=new")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--window-size=1365,900")
def get(page):
    driver.get(site + page + ".html?controle=9867010db7cf92b9d091a21e60b51f053e5b3da2")
    wait.until(lambda d: d.find_elements(By.CSS_SELECTOR,"main"))
def click(el):
    driver.execute_script("arguments[0].scrollIntoView({block:'center',behavior:'instant'})",el)
    el.click()
with webdriver.Chrome(options=options, service=Service(shutil.which("chromedriver"))) as driver:
    wait = WebDriverWait(driver, 15)
    driver.execute_cdp_cmd("Browser.grantPermissions", {"origin":"https://aureliennicosiaulaval.github.io","permissions":["clipboardReadWrite","clipboardSanitizedWrite"]})
    get("index")
    cards = driver.find_elements(By.CSS_SELECTOR, "details.path-card")
    assert len(cards) == 5
    for card in cards:
        summary = card.find_element(By.CSS_SELECTOR,"summary .path-title")
        click(summary)
        wait.until(lambda d: card.get_property("open"))
        click(summary)
        wait.until(lambda d: not card.get_property("open"))
    get("capsules")
    groups = driver.find_elements(By.CSS_SELECTOR, "main .panel-tabset")
    assert len(groups)==5
    for group in groups:
        pdf, html = group.find_elements(By.CSS_SELECTOR, "[role=tab]")
        assert [pdf.text,html.text] == ["PDF","HTML"]
        click(html)
        frame=group.find_element(By.CSS_SELECTOR,"iframe[data-support-src]")
        wait.until(lambda d: frame.get_dom_attribute("src"))
        driver.switch_to.frame(frame)
        wait.until(lambda d: d.execute_script("return !!window.Reveal && Reveal.isReady()"))
        assert len(driver.find_elements(By.CSS_SELECTOR,".slides > section"))==8
        driver.switch_to.default_content()
        click(pdf)
    for page,count in [("capsules",5),("exercices",7)]:
        get(page)
        headers=driver.find_elements(By.CSS_SELECTOR,'main .callout-header[data-bs-toggle="collapse"]')
        assert len(headers)==count
        for header in headers:
            body=driver.find_element(By.CSS_SELECTOR,header.get_dom_attribute("data-bs-target"))
            assert not body.is_displayed()
            click(header)
            wait.until(lambda d: "show" in body.get_attribute("class").split())
            click(header)
            wait.until(lambda d: not body.is_displayed())
    for page in ["demonstrations","exercices","complements"]:
        get(page)
        buttons=driver.find_elements(By.CSS_SELECTOR,"main .code-copy-button")
        assert buttons
        for button in buttons:
            if not button.is_displayed():
                continue
            click(button)
            copied=driver.execute_async_script("const done=arguments[0]; navigator.clipboard.readText().then(done).catch(()=>done(''))")
            assert len(copied.strip())>10, page
    driver.execute_cdp_cmd("Emulation.setDeviceMetricsOverride",{"width":390,"height":844,"deviceScaleFactor":1,"mobile":True})
    for page in ["index","capsules","lectures","demonstrations","exercices","complements"]:
        get(page)
        sizes=driver.execute_script("return [window.innerWidth,document.documentElement.clientWidth,document.documentElement.scrollWidth]")
        print(f"{page} : {sizes}",flush=True)
        assert sizes[2]<=392 and sizes[1]<=392,(page,sizes)
    print("Cartes, onglets, diaporamas intégrés, corrigés, copie de code et affichage à 390 pixels vérifiés.")
