# Opengauss Db project: Self-made Multi-music-app Compatible Music App 
<hr/>

# 0, Background
This project is an assignment project based on the opengauss database in a Chinese university. 
In the actual implementation, it does not consider too many engineering problems, 
and only implements the basic functions. Just having fun.

# 1, Supported App
QQ music:
- https://github.com/rain120/qq-music-api
- https://github.com/jsososo/QQMusicApi

Netease music: 
- https://github.com/Binaryify/NeteaseCloudMusicApi 

**To get more app support, we should get another node-js-based opensource music api.** 
Then we should make corresponding adaptation on the server.

# 2, Code Structure
```
├─client  # client ui
├─musicplayer  # music player script
├─db  # opengauss db init
├─docs
└─server  # server
```

# 3, How to use
1, centos server install. Or use docker then jump to 5: registry.cn-beijing.aliyuncs.com/db-ass3-wzg/db-ass3-wzg-server:1.0.1

2, opengauss db install
- https://opengauss.org/zh/docs/3.1.0/docs/installation/installation.html

3, init database using DbInit.sql. 

4, compile server-code into jar, then run

5, compile delphi client ui and playUrlMusic.py into exe. 
The music player folder and delphi client.exe must be in the same level.

6, run client. **At the beginning, we should specify the server IP**

# 4, Issues

1, opengauss may disconnect when we have not called it for several minutes

2, instable 

