#### 项目介绍

为酷瓜云网课（腾讯云版） [course-tencent-cloud](https://gitee.com/koogua/course-tencent-cloud) 提供环境支持

#### 安装 docker 和 docker-compose

安装 docker， 官方文档： [install-docker](https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-convenience-script)

下载 docker

```
sudo curl -sSL https://get.daocloud.io/docker | sh
```

更改 docker 仓库的默认地址

修改 /etc/docker/daemon.json 文件（没有请自行创建）

```
{
    "registry-mirrors": [
        "https://mirror.ccs.tencentyun.com"
    ]
}
```

启动 docker

```
sudo service docker start
```

安装 docker-compose，官方文档： [install-compose](https://docs.docker.com/compose/install/#install-compose)

下载 docker-compose

```
sudo curl -L https://get.daocloud.io/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

给 docker-compose 增加执行权限

```
sudo chmod +x /usr/local/bin/docker-compose
```

### 下载相关代码

假定存在目录 `/home/koogua`

通过 git clone 下载构建代码，原名字太长，我们用一个短名字

```
cd /home/koogua
git clone https://gitee.com/koogua/course-tencent-cloud-docker.git ctc-docker
```

通过 git clone 下载项目代码，原名字太长，我们用一个短名字

```
cd /home/koogua/ctc-docker/html
git clone https://gitee.com/koogua/course-tencent-cloud.git ctc
```

### 配置运行环境

（1）修改构建配置

复制生成 .env 并修改相关参数

```
cd /home/koogua/ctc-docker
cp .env.default .env
```

（2）配置 nginx 默认站点

无需HTTPS：复制生成 default.conf 并修改相关参数

```
cd /home/koogua/ctc-docker/nginx/conf.d
cp default.conf.sample default.conf
```

需要HTTPS：复制生成 default.conf 并修改相关参数

```
cd /home/koogua/ctc-docker/nginx/conf.d
cp ssl-default.conf.sample ssl-default.conf
```

### 构建运行

构建镜像

```
cd /home/koogua/ctc-docker
docker-composer build
```
    
运行容器
 
 ```
 cd /home/koogua/ctc-docker
 docker-compose up -d
 ```
   
### 配置应用

进入 php 容器

```
docker exec -it ctc-php bash
```

复制生成 config.php 并修改相关参数

```
cd /var/html/ctc/config
cp config.default.php config.php
```

复制生成 xunsearch 配置文件

```
cd /var/html/ctc/config
cp xs.course.default.ini xs.course.ini
cp xs.group.default.ini xs.group.ini
cp xs.user.default.ini xs.user.ini
```

修改 storage 目录读写权限

```
chmod -R 777 /var/html/ctc/storage
```
   
修改 sitemap.xml 文件读写权限

```
chmod 777 /var/html/ctc/public/sitemap.xml
```

安装依赖包
   
```
cd /var/html/ctc
composer install --no-dev
```

数据库迁移

```
cd /var/html/ctc
vendor/bin/phinx migrate
```
 
访问网站

* 管理帐号：10000@163.com / 123456
* 前台地址：http://{your-domain}.com
* 后台地址：http://{your-domain}.com/admin

后续设置： [腾讯云服务和应用设置](https://gitee.com/koogua/course-tencent-cloud/wikis) 
   
### 测试数据

新装系统一片空白，为了更好的体验系统，我们提供部分测试数据（采集自网络）

**注意：导入操作会把初始化建立的表删除并重新创建表**

管理帐号：100015@163.com / 123456

（1）导入资源文件

在腾讯云存储新建一个存储桶（bucket）, 并在后台->系统配置->存储设置修改相关参数

下载资源文件，解压后使用 COSBrowser 上传 img 等相关目录到新建的存储桶中

[资源文件下载](http://download.koogua.com/ctc-test-cos.zip)

[COSBrowser工具介绍](https://cloud.tencent.com/document/product/436/11366)

（2）导入数据，mysql 容器中没有下载工具，需要安装一下

```
docker exec -it ctc-mysql bash
apt-get update && apt-get install curl
curl -o ctc-test.sql.gz http://download.koogua.com/ctc-test.sql.gz
gunzip < ctc-test.sql.gz | mysql -u ctc -p ctc
```

（3）重建索引

```
docker exec -it ctc-php bash
cd /var/www/html/ctc
php console.php course_index rebuild
php console.php group_index rebuild
php console.php user_index rebuild
php console.php upgrade
```