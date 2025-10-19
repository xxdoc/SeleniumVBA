Attribute VB_Name = "test_Authentication"
Option Explicit
Option Private Module
'@folder("SeleniumVBA.Testing")

Sub test_LoginWithSendKeys()
    'an example of how to authenticate using SendKeys
    Dim driver As SeleniumVBA.WebDriver
    Dim userName As String
    Dim pw As String
    
    'substitute your own User Name and Password for this example to work
    userName = "MyUserName"
    pw = "MyPassword"
    
    Set driver = SeleniumVBA.New_WebDriver

    driver.StartChrome
    driver.OpenBrowser
    
    driver.ImplicitMaxWait = 2000
    
    driver.NavigateTo "https://www.vbforums.com"
    
    driver.FindElement(By.CssSelector, "#navbar_username").SendKeys userName
    driver.FindElement(By.CssSelector, "#navbar_password_hint").Click
    driver.FindElement(By.CssSelector, "#navbar_password").SendKeys pw
    driver.FindElement(By.CssSelector, "#logindetails > div > div > input.loginbutton").Click

    driver.Wait 2000
    
    driver.CloseBrowser
    driver.Shutdown
End Sub

Sub test_LoginWithInjectedScript()
    'an example of how to authenticate using a hidden form submital with an injected script
    Dim driver As SeleniumVBA.WebDriver
    Dim params As New Dictionary
    Dim javaScript As String
    Dim userName As String
    Dim pw As String
    
    'substitute your own User Name and Password for this example to work
    userName = "MyUserName"
    pw = "MyPassword"
    
    Set driver = SeleniumVBA.New_WebDriver
    
    driver.StartChrome
    driver.OpenBrowser

    javaScript = "function submitLoginForm(usr, pwd){" & vbCrLf
    javaScript = javaScript & "   var f = document.forms[0]" & vbCrLf
    javaScript = javaScript & "       f.elements['vb_login_username'].value= usr" & vbCrLf
    javaScript = javaScript & "       f.elements['vb_login_password'].value= pwd" & vbCrLf
    javaScript = javaScript & "       f.submit()" & vbCrLf
    javaScript = javaScript & "}"
    
    params.Add "source", javaScript
    driver.ExecuteCDP "Page.addScriptToEvaluateOnNewDocument", params
    
    driver.NavigateTo "https://www.vbforums.com/"
    
    params.RemoveAll
    params.Add "expression", "submitLoginForm('" & userName & "','" & pw & "');"
    driver.ExecuteCDP "Runtime.evaluate", params
    
    driver.Wait 2000
    
    driver.CloseBrowser
    driver.Shutdown
End Sub

Sub test_BasicAuthentication()
    Dim driver As SeleniumVBA.WebDriver
    Dim elem As SeleniumVBA.WebElement
    Dim userName As String
    Dim pw As String
    
    Set driver = SeleniumVBA.New_WebDriver
    
    driver.StartChrome
    driver.OpenBrowser
    
    userName = "admin"
    pw = "admin"
    
    driver.NavigateTo "http://" & userName & ":" & pw & "@the-internet.herokuapp.com/basic_auth"
  
    If driver.IsPresent(By.CssSelector, "#content > div > p", elemFound:=elem) Then
        Debug.Assert elem.GetText = "Congratulations! You must have the proper credentials."
    End If
    
    driver.CloseBrowser
    driver.Shutdown
End Sub
