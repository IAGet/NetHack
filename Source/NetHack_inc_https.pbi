; данные для либы WinInet
#INTERNET_OPEN_TYPE_DIRECT = 1
#HTTP_ADDREQ_FLAG_ADD = $20000000
#HTTP_ADDREQ_FLAG_REPLACE = $80000000
#INTERNET_FLAG_SECURE = $800000

#INTERNET_SERVICE_HTTP = 3
; порт (для https стандарт - 443)
#INTERNET_DEFAULT_HTTP_PORT = 443 

Procedure https_post()
 
  ;
  ; Do NOT include http:// or any other protocol indicator here
  ;
  host.s = "raw.githubusercontent.com"
  
  ;
  ; Everything after the hostname of the server
  ;
  get_url.s = "/IAGet/NetHack/master/Source/nh_editor_version"
  
  ;
  ; Holds the result from the CGI/page 
  ;
  result.s = ""
  
  ;
  ; All from the wininet DLL
  ;
  ; Be sure your Internet Explorer is up to date!
  ;
  open_handle = InternetOpen_("Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.12 (KHTML, like Gecko) Maxthon/3.0 Chrome/22.0.1229.79 Safari/535.122",#INTERNET_OPEN_TYPE_DIRECT,"","",0)
  
  connect_handle = InternetConnect_(open_handle,host,#INTERNET_DEFAULT_HTTP_PORT,"","",#INTERNET_SERVICE_HTTP,0,0)
  
  request_handle = HttpOpenRequest_(connect_handle,"POST",get_url,"","",0,#INTERNET_FLAG_SECURE,0)
  
  headers.s = "Content-Type: application/x-www-form-urlencoded" +Chr(13)+Chr(10)  
  
  HttpAddRequestHeaders_(request_handle,headers,Len(headers), #HTTP_ADDREQ_FLAG_REPLACE | #HTTP_ADDREQ_FLAG_ADD)
  
  post_data.s = ""
  
  post_data_len = Len(post_data)
  
  send_handle = HttpSendRequest_(request_handle,"",0,post_data,post_data_len)
  
  buffer.s = Space(1024) 
  
  bytes_read.l
  
  total_read.l 
  
  total_read = 0
  
  ;
  ; Read until we can't read anymore.. 
  ; The string "result" will hold what ever the server pushed at us.
  ;
  Repeat
    
    InternetReadFile_(request_handle,@buffer,1024,@bytes_read)
    
    result + Left(buffer,bytes_read)
    
    buffer = Space(1024)
    
  Until bytes_read=0
  
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 10
; Folding = -
; EnableXP