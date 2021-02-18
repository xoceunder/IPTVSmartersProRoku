sub Main()
    m.su = "http://api.whmcssmarters.com/?/Roku/"
    m.c = "IPTVSmartersh23aa1s1399381"
    m.v = "1.0.0"
    ss()
end sub

sub di() as string
    return CreateObject("roDeviceInfo").GetDeviceUniqueId().tostr()
end sub

Function dv()
    device = CreateObject("roDeviceInfo")
    km = {}
    km["N1050"] = "RokuSD"
    km["N1000"] = "RokuHD"
    km["N1100"] = "RokuHD"
    km["2000C"] = "RokuHD" 
    km["2050N"] = "RokuXD"
    km["2050X"] = "RokuXD"
    km["N1101"] = "RokuXD|S"
    km["2100X"] = "RokuXD|S"
    km["2400X"] = "RokuLT"
    km["2450X"] = "RokuLT"
    km["2400SK"] = "NowTV"
    km["2500X"] = "RokuHD"
    km["2700X"] = "RokuLT"
    km["2710X"] = "Roku1"
    km["2720X"] = "Roku2"
    km["3000X"] = "Roku2HD"
    km["3050X"] = "Roku2XD"
    km["3100X"] = "Roku2XS"
    km["3400X"] = "RokuStick"
    km["3420X"] = "RokuStick"
    km["3500X"] = "RokuStick"
    km["4200R"] = "Roku3"
    km["4200X"] = "Roku3"
    km["4400X"] = "Roku4"
    km["5000X"] = "RokuTv"
    model = fo(km[device.GetModel()], "Roku"+ device.GetModel())
    
    return model
End Function

sub gu()  as string
    param = "INVALID"
    k = KY()
    If (k <> "")
        arg = m.su + "?m=gp&k="+m.c+"&av=" +m.v+"&d=" + di()+"&ac="+k+"&df=" + fv()+"&dv=" + dv() + "&f=s.zip"
        param = arg.EncodeUri()
    End If    
    return param
end sub

Function fv() as string
    return CreateObject("roDeviceInfo").GetVersion()
End Function

Function fo(first, second, third=invalid, fourth=invalid)
    if first <> invalid then return first
    if second <> invalid then return second
    if third <> invalid then return third
    return fourth
End Function

sub ss()
    screen = CreateObject("roSGScreen")
    m.o = CreateObject("roMessagePort")
    screen.setMessagePort(m.o)
    scene = screen.CreateScene("LoadingScene")
    screen.show():scene.mk= gu()
    while(true)
        msg = wait(0, m.o)
	msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

sub KY()  as string
    i = CreateObject("roUrlTransfer")
    i.SetCertificatesFile("common:/certs/ca-bundle.crt")
    i.AddHeader("X-Roku-Reserved-Dev-Id", "sThismustbethis121021")
    i.InitClientCertificates()
    o = CreateObject("roMessagePort")
    i.SetMessagePort(o)
    i.SetUrl(m.su)
    i.AddHeader("Content-Type", "application/x-www-form-urlencoded")
    arg = "m=cd&k="+m.c+"&av=" + m.v +"&d=" + di()+"&df=" + fv()+"&dv=" + dv() 
    param = arg.EncodeUri()
    If (i.AsyncPostFromString(param))
        While (true)
            msg = wait(0, o)
            If (type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                dataString = msg.GetString()
                If (code = 200 and dataString <> "")
                    contentxml = createObject("roXMLElement")
                    contentxml.parse(dataString)                    
                     If contentxml.getName() = "xml"
                        For Each item in contentxml.GetNamedElements("status")
                           If item.GetText() = "1"
                                For Each itemCode in contentxml.GetNamedElements("u")
                                    return itemCode.GetText()
                                End For
                           End If
                        End For
                     End If
                End If
                return ""
            Else If (event = invalid)
                i.AsyncCancel()
                return ""
            End If
        End While
    End If
end sub