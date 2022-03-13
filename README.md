# HITSZ-DailyReport

>本脚本仅用作学习交流。

一个实现定时上报疫情信息的bash脚本。

## 初始设置

将`DailyReport.sh`和`user.ini`放在同一目录下，先给`DailyReport.sh`执行权限：
```
chmod +x DailyReport.sh
```

按如下格式填写`user.ini`：

```
username password
```

由于每个人的上报内容各不相同，在此展示如何获得自己的上报内容。

首先打开疫情上报的页面，填好所需上报的内容。

随后按<kbd>F12</kbd>打开开发者工具，然后再点击提交。在开发工具的网络项中找到save项，并复制为cURL(bash):

<div align="center"><img width=50% src="./explain.png"></div>

复制下来的内容中的`--data-raw`一项即为提交的内容。

只需将其中token对应的内容（最后两个%22中间的部分）替换为`$token`，然后整体填入DailReport.sh第146行的双引号之间即可。点击右侧直达[DailyReport.sh](DailyReport.sh#L146)

一个例子：

```bash
info%3D%7B%22model%22%3A%7B%22dqzt%22%3A%2299%22%2C%22gpsjd%22%3A115.85517%2C%22gpswd%22%3A39.05549%2C%22kzl1%22%3A%221%22%2C%22kzl2%22%3A%22%22%2C%22kzl3%22%3A%22%22%2C%22kzl4%22%3A%22%22%2C%22kzl5%22%3A%22%22%2C%22kzl6%22%3A%22%E5%96%B5%E5%96%B5%E7%9C%81%22%2C%22kzl7%22%3A%22%E5%96%B5%E5%96%B5%E5%B8%82%22%2C%22kzl8%22%3A%22%E5%96%B5%E5%96%B5%E5%8C%BA%22%2C%22kzl9%22%3A%22%E5%96%B5%E5%96%B5%E8%B7%AF1%E5%8F%B7%22%2C%22kzl10%22%3A%22%E5%96%B5%E5%96%B5%E7%9C%81%E5%96%B5%E5%96%B5%E5%B8%82%E5%96%B5%E5%96%B5%E5%8C%BA%E5%96%B5%E5%96%B5%E8%B7%AF1%E5%8F%B7%22%2C%22kzl11%22%3A%22%22%2C%22kzl12%22%3A%22%22%2C%22kzl13%22%3A%220%22%2C%22kzl14%22%3A%22%22%2C%22kzl15%22%3A%220%22%2C%22kzl16%22%3A%22%22%2C%22kzl17%22%3A%221%22%2C%22kzl18%22%3A%220%3B%22%2C%22kzl19%22%3A%22%22%2C%22kzl20%22%3A%22%22%2C%22kzl21%22%3A%22%22%2C%22kzl22%22%3A%22%22%2C%22kzl23%22%3A%220%22%2C%22kzl24%22%3A%220%22%2C%22kzl25%22%3A%22%22%2C%22kzl26%22%3A%22%22%2C%22kzl27%22%3A%22%22%2C%22kzl28%22%3A%220%22%2C%22kzl29%22%3A%22%22%2C%22kzl30%22%3A%22%22%2C%22kzl31%22%3A%22%22%2C%22kzl32%22%3A%221%22%2C%22kzl33%22%3A%22%22%2C%22kzl34%22%3A%7B%7D%2C%22kzl38%22%3A%22%E5%96%B5%E5%96%B5%E7%9C%81%22%2C%22kzl39%22%3A%22%E5%96%B5%E5%96%B5%E5%B8%82%22%2C%22kzl40%22%3A%22%E5%96%B5%E5%96%B5%E5%8C%BA%22%7D%2C%22token%22%3A%22$token%22%7D
```

## 运行方式

推荐使用Ubuntu-server已经内置的crontab进行脚本的定时运行。

第一次运行crontab时，在命令行输入`crontab -e`给crontab添加作业，输入后可以选择一种编辑方式，在末尾写入

```
0 */6 * * * cd /your/path/to/DailyReport && ./DailyReport.sh $(cat user.ini) >> ./log 2>&1
```

保存退出后重启crontab：

```
service cron restart
```
即可实现每六小时填报一次，并将结果写入到`log`文件中。

当然，sh脚本已经有了，定时运行的方式都可以自行安排。

## github action

开启 github action ，在 secrets 中加入 `username` 和 `password` 两个 secrets。

action 的触发在早上 7:00 (23:00 UTC)。