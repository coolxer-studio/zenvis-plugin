# 扩展API接口模块

## 项目简介

这是一个基于Spring Boot的插件式API扩展模块，允许通过加载外部jar包来动态扩展接口功能。该模块提供了基础的用户管理API接口，包括添加用户和分页查询用户列表功能，可作为插件模板进行二次开发。

## 技术栈

- Java 17
- Spring Boot 3.2.0
- Maven 3.x
- Lombok

## 项目结构

```
src/main/java/com/coolxer/plugin/
├── PluginApplication.java          # Spring Boot启动类
├── controller/                     # 控制层，处理HTTP请求
│   ├── UserController.java         # 用户相关接口控制器
│   ├── UserDto.java                # 用户数据传输对象
│   ├── UserSearchDto.java          # 用户查询参数对象
│   ├── UserVo.java                 # 用户视图对象
│   ├── ResponseWrap.java           # 统一响应封装类
│   ├── ResultCodeEnum.java         # 响应码枚举类
│   └── PageRowsVo.java             # 分页数据封装类
├── servicer/                       # 服务层接口
│   ├── UserService.java            # 用户服务接口
│   └── impl/                       # 服务层实现
│       └── UserServiceImpl.java    # 用户服务实现类
└── util/                           # 工具类
    ├── NameGenerate.java           # 名称生成工具类
    └── CardGenerate.java           # 卡号生成工具类
```

## 使用场景

针对需要复杂接口的需求场景，可以在插件的api目录下放置生成好的jar包，插件安装后即可加载自定义的接口。

## 快速开始

### 环境要求

- JDK 17或更高版本
- Maven 3.x

### 构建项目

```bash
mvn clean package
```

### 运行项目

```bash
mvn spring-boot:run
```

或者

```bash
java -jar target/extend-api-0.0.1-SNAPSHOT.jar
```

## API接口说明

### 添加用户接口

#### 请求

```bash
curl -X POST http://localhost:8080/plugin/user/add \
-H "Content-Type: application/json" \
-d '{"id": "12345", "name": "John Doe", "card": "1234567890123456"}'
```

#### 响应

```json
{
  "status": 0,
  "msg": "请求成功",
  "data": "添加成功John Doe"
}
```

### 查询用户列表接口

#### 请求

```bash
curl http://localhost:8080/plugin/user/list?page=1&perPage=5
```

#### 响应

```json
{
  "status": 0,
  "msg": "请求成功",
  "data": {
    "rows": [
      {
        "id": "id0",
        "user": "name9",
        "card": "card4"
      },
      {
        "id": "id1",
        "user": "name4",
        "card": "card2"
      }
    ],
    "total": 3
  }
}
```

## 核心组件说明

### 统一响应格式

项目使用ResponseWrap类封装统一的API响应格式，包含以下字段：
- `status`: 响应状态码
- `msg`: 响应消息
- `data`: 响应数据

### 响应码定义

ResultCodeEnum枚举类定义了系统中使用的响应码：
- `SUCCESS(0, "请求成功")`
- `UNKNOWN_ERROR(-1, "未知错误")`
- `INNER_ERROR(1, "请求失败")`
- `NO_AUTHORITY(100, "您没有权限进行此操作！")`

### 分页数据封装

PageRowsVo用于封装分页查询结果，包含数据列表和总记录数。

## 开发指南

1. 实现自己的业务逻辑，修改UserServiceImpl中的方法
2. 添加新的Controller类实现其他接口
3. 打包成jar文件并放置到插件目录下

## 注意事项

- 当前实现为示例代码，实际使用时需要替换为真实的业务逻辑
- 数据库访问层需要根据实际需求进行实现
- 建议在生产环境中添加参数校验、异常处理等机制