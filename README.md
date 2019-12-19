# course-tencent-cloud-docker

#### 介绍

为 course-tencent-cloud 提供环境支持

#### 安装 docker 和 docker-compose

安装 docker， 官方文档： [install-docker](https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-convenience-script)

1. 下载 docker

    ```
    sudo curl -sSL https://get.daocloud.io/docker | sh
    ```
2. 启动 docker

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
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ```

2. 给 docker-compose 增加执行权限
 
    ```
    sudo chmod +x /usr/local/bin/docker-compose
    ```

### 下载相关代码

假定存在目录 `/home/koogua`（可自定义）

通过 `git clone` 下载部署代码，原名字太长，我们用一个短名字

```
cd /home/koogua
git clone https://gitee.com/koogua/course-tencent-cloud-docker.git ctc-docker
```

通过 `git clone` 下载项目代码，原名字太长，我们用一个短名字

```
cd /home/koogua/ctc-docker/html
git clone https://gitee.com/koogua/course-tencent-cloud.git ctc
```

### 配置运行环境

1、修改 `/home/koogua/ctc-docker/docker-compose.yml` 中的相关参数

修改 mysql `MYSQL_ROOT_PASSWORD` 和 `MYSQL_PASSWORD` 其他参数默认。密码不要用特殊字符（使用字母+数字） 

```
MYSQL_ROOT_PASSWORD: 1qaz2wsx3edc
MYSQL_DATABASE: ctc
MYSQL_USER: ctc
MYSQL_PASSWORD: 1qaz2wsx3edc
```

2、配置 nginx 默认站点

复制生成 `default.conf` 并修改相关参数

```
cd /home/koogua/ctc-docker/nginx/conf.d
cp default.conf.sample default.conf
```
 
3、修改项目配置

1. 复制生成 `config.php` 并修改相关参数

    ```
    cd /home/koogua/ctc-docker/html/ctc/config
    cp config.default.php config.php
    ```
    
2. 修改存储目录权限

    ```
    cd /home/koogua/ctc-docker/html/ctc
    chmod -R 777 storage
    ```

### 构建运行站点

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
     
3. 访问网站

   - 前台：http://{your-domain}.com/
   - 后台：http://{your-domain}.com/admin
