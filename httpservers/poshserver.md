
# PoshServer: light-weight opensource http server in Powershell


### ReAdABLE Source [(What is the ReAdABLE Human Format?)](http://readablehumanformat.com)

[http://quickrun.red/httpservers/poshserver.red](https://github.com/lepinekong/mymementos/blob/master/httpservers/poshserver.red)


### Pre-Requisites

For PHP test, you should have PHP server installed.
Goto:
- [http://www.poshserver.net/](http://www.poshserver.net/)
                        
![https://i.imgur.com/ViFrpIV.png](https://i.imgur.com/ViFrpIV.png)
                    
Download:
>PoSH Server Standalone

- [http://www.poshserver.net/files/PoSHServer-Standalone.v3.7.zip](http://www.poshserver.net/files/PoSHServer-Standalone.v3.7.zip)
                        

### Install

Unzip the download
![https://i.imgur.com/0FGYGTI.png](https://i.imgur.com/0FGYGTI.png)
                    
Run with Admin Right:
>PoSHServer-Standalone.exe

![https://i.imgur.com/2OwcCOi.png](https://i.imgur.com/2OwcCOi.png)
                    
Browse to:
- [http://localhost:8080/](http://localhost:8080/)
                        
Your server should be ready:
![https://i.imgur.com/ACj4LPw.png](https://i.imgur.com/ACj4LPw.png)
                    

### Test PHP CGI Server

Create info.php in sub-folder:
>http

with this code snippet:


```php

<?PHP
    phpinfo();
?>
        
```


![https://i.imgur.com/jRfHwvh.png](https://i.imgur.com/jRfHwvh.png)
                    
browse to:
- [http://localhost:8080/info.php](http://localhost:8080/info.php)
                        
You should see this php info page:
![https://i.imgur.com/q4YoKny.png](https://i.imgur.com/q4YoKny.png)
                    
Warning: currently only get requests are supported in this early version, post requests are not yet.

### Configuration

Configuration file is available in:
>config.ps1

![https://i.imgur.com/dGjz9WX.png](https://i.imgur.com/dGjz9WX.png)
                    
