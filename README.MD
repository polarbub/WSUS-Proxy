# WSUS Proxy

This is a workaround for Windows XP to connect Windows Update. This was made because the system that XP used to update was [discontinued in 2019](https://support.microsoft.com/en-us/help/4569557/windows-update-sha-1-based-endpoints-discontinued).

This proxy converts the newer Microsoft Update protocol that uses SHA-2 to checksum to the SHA-1 based protocol that XP uses. It serves the Windows Updates as if it were a Windows Update server for a enterprise that had its own custom updates. This project uses PHP and OpenSSL which allows the proxy to securely connect to Microsoft Update with https.

There are other versions of this proxy floating around on the internet, but those often have links to Google Drive or other user-uploaded sites the extra software they require. They often also bundle PHP binaries. I don't trust random binaries, so I made this repository. It aims to link to only Microsoft or other reputable sources for its Binaries.

All the other versions of this system that I've seen all the proxy on the XP computer, but I didn't want to go through the hassle of finding Windows XP compatible PHP version, so I set it up to have the proxy be served from a separate computer.

## Requirements

- Windows OS: Windows XP / Server 2003 or later.
- Server OS: Something that can run PHP.

polarbub was able to get it working on Windows XP SP3 without the Visual C++ Redistributable, the Root Certificates Update, Internet Explorer 7/8, Microsoft IDN Mitigation APIs, or Windows Update MiniTool. He just used the Windows Update Agent.

If those get taken down they can be acquired from the Microsoft CDN directly through the x86 and x64 links. If those stop working too the Wayback Machine may be helpful. The date to put into the Wayback Machine should be around 25/4/2023.

- Latest Version of [Windows Update Agent](https://learn.microsoft.com/en-us/troubleshoot/windows-client/deployment/update-windows-update-agent) for Windows 7 SP1 or Windows Server 2008 R2 SP1 (Version 7.6.7600.320 works on XP). ([x86](http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/WindowsUpdateAgent-7.6-x86.exe)) ([x64](http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/WindowsUpdateAgent-7.6-x64.exe)).

- [Microsoft Visual C++ 2012 Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2012-vc-110-update-4) ([x86](https://download.microsoft.com/download/1/6/B/X16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe)) ([x64](https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe))

- [Root Certificates Update](https://www.mediafire.com/file/pflkq12ik8tlx5w/jveWB2Qg1Lt9yT5m3CYpZ8b8N4rH.rar/file) Password `S4QH5TIefi7m9n1XLyTIZ3V5hSv4se1XB6jJZpH5TfB6vkJ8hfRxU7DWB2p` or the steps to DIY it can be found [here](https://msfn.org/board/topic/175170-root-certificates-and-revoked-certificates-for-windows-xp/).

- Internet Explorer 7/8, or Microsoft IDN Mitigation APIs
([x86](https://raw.githubusercontent.com/stdin82/htfx/master/NT5/idndl.x86.exe)) ([x64](https://raw.githubusercontent.com/stdin82/htfx/master/NT5/idndl.amd64.exe)) I was unable to find a Microsoft link to the Microsoft IDN Mitigation APIs. Internet Explorer 8 can be found [here](http://www.microsoft.com/en-us/download/internet-explorer-8-details.aspx). The Wayback Machine must be used to download it.

- Windows Update MiniTool version 20.12.2016. This can be found on the [RU-Board](https://forum.ru-board.com/topic.cgi?forum=5&topic=48142#2). Under the large download link there is a [smaller one](https://drive.google.com/file/d/1jjo9UKZVnld-Bymxte6KfJH8yxKut4yD/view) that has version 20.12.2016. There is also an [outdated english thread](https://forums.mydigitallife.net/threads/windows-update-minitool.64939) on the MDL form. You do need to make a free account to read it.

## UPDATES TO NOT INSTALL 
- Internet Explorer 8. It will cause `explorer.exe` to not start correctly on startup. The way to recover from this is detailed [here](https://superuser.com/questions/195163/explorer-exe-ordinal-423-not-found-in-urlmon-dll-after-updates-ie8-install).
- Windows XP EOL Notification. This can just be annoying. It will pop up and tell you to install newer Windows.

## How To Use
1. Navigate to the `Proxy` folder on the server computer.
2. Modify the `extension=` line in the `php.ini` file to have the correct `php_curl` module. The one that is currently there is for Arch Linux.
3. Start the proxy server with `php -c php.ini -S <your pc's ip address>:<port> -t .`. The default port is `8530`. Here is a command that uses that: `php -c php.ini -S <your pc's ip address>:8530 -t .`.
4. In Control Panel -> Automatic Updates. Set it to `Notify me, but don't automatically download or install them.`
4. Install Windows Update Agent on Windows XP system
5. Run `add_wsus.bat <your pc's ip address> [<server port>]`
5. Restart the Windows XP system
6. Run `wuauclt /detectnow` to scan for updates. In the proxy server's log you should be able to see it connecting if it is working.
7. After a while a yellow update shield will appear in the tray.
8. Click on it and install the Update(s). Make sure to not select the updates mentioned [above](#updates-to-not-install)
9. You may have to do multiple rounds of updates if some need to be installed before other.

Instead of step 8-11 you can use the Windows Update MiniTool. I don't recommend it because it seems a little sketch. It is closed-source software that is distributed through a forum in a foreign language for me (Russian).  

8. Start the Windows Update MiniTool (WUMT). It may take a while to open.
9. Make sure that the dropdown on the left is set to `Windows Server Update Service` not `Windows Update`
10. Set the `Automatic Updates` dropdown to `Managed By Administrator`. This lets you control this in Control Panel not WUMT.
10. Press the check for updates button. It is in the top left below the filters and looks like a refresh symbol. In the proxy server's log you should be able to see it connecting if it is working.
11. Once the available updates have been found it will list them. 
12. Select the updates that you want. Make sure to not select the update mentioned [above](#updates-to-not-install)
13. Press `Download and Install` This is a down arrow with a line below it.

## Removal
- You can stop the php server with Ctrl + C
- To stop Windows XP from checking the WSUS Proxy you can run `remove_wsus.bat`
- Restart the XP machine

## Notes
There seems to be someone running this proxy server at `http://wsus.gimme.money:8530`. They might just be hosting this proxy for free, or it might be giving you malware. It seems a little suspect to me so I didn't use it.

## Links that polarbub found useful for research
- [Windows XP Keys](https://gist.github.com/denizssch/72ec2aa1c5d0a84ffb57076f7dbf30d6)

### Guides
- https://msfn.org/board/topic/183498-general-and-specific-solutions-for-problems-regarding-auwumu-in-windows-xp/ A list of different methods that I should have just used in the first place. Just scroll down a bit.
- https://www.youtube.com/watch?v=2IHJBLlW1j8, https://adventuresinnostalgia.blogspot.com/2022/04/automatic-updates-for-windows-xp-in-2021.html, and https://download.ru/files/q1ttVqHt. Self hosted proxy and WUMT. One source for this proxy.
- https://www.youtube.com/watch?v=X_KMOECR7cw, https://docs.google.com/document/d/152geaMY-Ey98CRHX_IGV9vtLvpJloxUa/edit, and
https://docs.google.com/document/d/1A3TrHO_LED06-lmco-yMYRo2J3ZPOi0O/edit. Uses `wsus.gimme.money:8530` and `wuauclt /detectnow`
- https://docs.google.com/document/d/16lsXHuEVpODV8n3C3S7CTZriA2g0ilk1P7bDxBXucs8/edit Uses `wsus.gimme.money:8530` and `wuauclt /detectnow` or WUMT
- https://www.youtube.com/watch?v=vdIVMwV9MCk and http://i430vx.net/files/wsusstuff/ Seems to be the guy that is hosting `wsus.gimme.money:8530`. Uses `wuauclt /detectnow`
- https://www.reddit.com/r/windowsxp/comments/lhtoxa/guide_how_to_fully_update_windows_xp_with_windows/ and https://drive.google.com/file/d/1p80TCHFZcmjWlwXvkM31QpJvj5ioqTsd/view. Self hosted proxy and WUMT. The other source for this proxy.
- https://msfn.org/board/topic/178377-on-decommissioning-of-update-servers-for-2000-xp-and-vista-as-of-july-2019/page/53/#comment-1211932 Other method 1
- https://msfn.org/board/topic/183498-general-and-specific-solutions-for-problems-regarding-auwumu-in-windows-xp/#comment-1216509 Other method 2
- https://msfn.org/board/topic/178377-on-decommissioning-of-update-servers-for-2000-xp-and-vista-as-of-july-2019/page/43/#comment-1211254 Other method 3

### Downloads
- https://www.youtube.com/watch?v=fv5LDGMZRpM Unofficial SP4
- https://drive.google.com/file/d/0BwJH2CazcjsINFZFc1pVdk9mNHM/view?resourcekey=0-LD-TdjUx1rNekTXsKfDCPw and https://drive.google.com/file/d/1t1APf_WMum9LTfYVU850-3druKqUeghv/view sketchier WUMT downloads.
- https://github.com/stdin82/htfx Old Root Certificate Update.

## Credits

- [Dummy WSUS](https://github.com/whatever127/dummywsus)  
That link is broken as the whatever127 has passed away. It seems a few forks were made before the repo was deleted though. [Fork 1](https://github.com/luzea9903/dummywsus). [Fork 2](https://github.com/no127nowand4ever/dummywsus).

- IMI Kurwica WSUS Proxy mod 

- @mspaintmsi

- Project Scripts: abbodi1406 and polarbub

- Readme: polarbub