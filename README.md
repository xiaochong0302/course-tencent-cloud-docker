#### 项目介绍

为酷瓜云网课（腾讯云版） [course-tencent-cloud](https://gitee.com/koogua/course-tencent-cloud) 提供环境支持

#### 安装 docker 和 docker-compose

安装 docker， 官方文档： [install-docker](https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-convenience-script)

1. 下载 docker

    ```
    sudo curl -sSL https://get.daocloud.io/docker | sh
    ```
2. 更改 docker 仓库的默认地址
   
   修改 /etc/docker/daemon.json 文件（没有请自行创建）
   
   ```
   {
        "registry-mirrors": [
            "https://mirror.ccs.tencentyun.com"
        ]
    }
   ```
   
3. 启动 docker

    ```
    sudo service docker start
    ```

非 root 身份管理 docker，官方文档： [manage-docker-as-a-non-root-user](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user)

1. 创建用户组

    ```
    sudo groupadd docker
    ```

2. 当前用户加入 docker 组 

    ```
    sudo usermod -aG docker $USER
    ```

3. 激活用户组更改

    ```
    sudo newgrp docker
    ```

4. 非 root 身份运行 hello world

    ```
    docker run hello-world
    ```

安装 docker-compose，官方文档： [install-compose](https://docs.docker.com/compose/install/#install-compose)

1. 下载 docker-compose

    ```
    sudo curl -L https://get.daocloud.io/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ```

2. 给 docker-compose 增加执行权限
 
    ```
    sudo chmod +x /usr/local/bin/docker-compose
    ```

### 下载相关代码

假定存在目录 /home/koogua（可自定义）

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

1、修改构建配置

复制生成 .env 并修改相关参数

```
cd /home/koogua/ctc-docker
cp .env.default .env
```

2、配置 nginx 默认站点

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
 
3、修改项目配置

1. 复制生成 config.php 并修改相关参数

    ```
    cd /home/koogua/ctc-docker/html/ctc/config
    cp config.default.php config.php
    ```

2. 复制生成 xunsearch 配置文件

    ```
    cd /home/koogua/ctc-docker/html/ctc/config
    cp xs.course.default.ini xs.course.ini
    cp xs.group.default.ini xs.group.ini
    cp xs.user.default.ini xs.user.ini
    ```
    
3. 修改 storage 目录读写权限

    ```
    cd /home/koogua/ctc-docker/html/ctc
    chmod -R 777 storage
    ```
   
4. 修改 sitemap.xml 读写权限

   ```
   cd /home/koogua/ctc-docker/html/ctc/public
   chmod 777 sitemap.xml
   ```

### 构建运行

1. 构建镜像

    ```
    cd /home/koogua/ctc-docker
    docker-composer build
    ```
    
2. 运行容器
 
     ```
     cd /home/koogua/ctc-docker
     docker-compose up -d
     ```
   
3. 安装依赖包，初始化数据库

    ```
    docker exec -it ctc-php /bin/bash
    cd /var/html/ctc
    composer install --no-dev
    vendor/bin/phinx migrate
    ```
     
4. 访问网站

   * 管理帐号：10000@163.com / 123456
   * 前台地址：http://{your-domain}.com
   * 后台地址：http://{your-domain}.com/admin
   
### 测试数据

新装系统一片空白，为了更好的体验系统，我们提供部分测试数据（采集自网络）

**注意：导入操作会把初始化建立的表删除重新创建表**

管理帐号：100015@163.com / 123456

导入数据，mysql 容器中没有下载工具，需要安装一下

```
docker exec -it ctc-mysql /bin/bash
apt-get update && apt-get install curl
curl -o test.sql.gz http://download.koogua.com/ctc/test.sql.gz
gunzip < test.sql.gz | mysql -u ctc -p ctc
```

生成索引

```
docker exec -it ctc-php /bin/bash
cd /var/www/html/ctc
php console.php course_index rebuild
php console.php group_index rebuild
php console.php user_index rebuild
```