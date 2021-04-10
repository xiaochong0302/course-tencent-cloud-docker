### 项目介绍

为酷瓜云课堂（腾讯云版） [course-tencent-cloud](https://gitee.com/koogua/course-tencent-cloud) 提供环境支持

### 安装指南

下载安装脚本

```
cd ~ && curl http://download.koogua.com/install.sh -o install.sh
```

增加执行权限

```
chmod +x install.sh
```

根据实际情况修改配置

```
nano install.sh
```

可选配置项目如下：

```
#是否安装测试数据(on:是，off:否)
SITE_DEMO=off

#站点域名(不包括http)
SITE_DOMAIN=abc.com

#站点密钥(数字字母组合，不要用特殊字符)
SITE_KEY=1qaz2wsx3edc

#mysql超级用户密码（数字字母组合，不要用特殊字符）
MYSQL_ROOT_PASSWORD=1qaz2wsx3edc

#mysql项目数据库名称（数字字母组合，不要用特殊字符）
MYSQL_DATABASE=ctc

#mysql项目数据库用户（数字字母组合，不要用特殊字符）
MYSQL_USER=ctc

#mysql项目数据库密码（数字字母组合，不要用特殊字符）
MYSQL_PASSWORD=1qaz2wsx3edc

#redis访问密码（数字字母组合，不要用特殊字符）
REDIS_PASSWORD=1qaz2wsx3edc
```

执行安装，快慢取决于网络，当有错误或者超时请重试

```
sudo bash install.sh
```

### 访问网站

* 管理账号：10000@163.com / 123456
* 前台地址：http://{your-domain}.com
* 后台地址：http://{your-domain}.com/admin

后续设置： [系统设置](https://gitee.com/koogua/course-tencent-cloud/wikis) 
   
### 测试数据

管理账号：100015@163.com / 123456

### 结束安装

安装完成，请删除安装脚本

```
rm install.sh
```