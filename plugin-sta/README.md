# 数据采集插件
---

## 插件说明

用于接收多源异构数据，当前数据源包含探针（agent）、网关（syslog）、日志文件等，接收结果存储到数据库。
--- 

## 基本信息

- **插件名称**: 数据采集插件
- **包名**: com.coolxer.plugin.sta
- **版本**: 1.0.0
- **作者**: CoolXer
- **描述**: 用于接收多源异构数据，当前数据源包含探针（agent）、网关（syslog）、日志文件等，接收结果存储到数据库。
--- 

## 功能介绍

### 插件外部依赖

- 探针数据依赖数据接收器服务（需要自行安装）
- 网关数据需要在网关中配置syslog数据接收（需要自行配置）
- 日志数据接收需要配置正确的日志文件目录（需要自行配置）
--- 

### 元数据配置

构建了用于测试的元数据信息，包含以下内容：

#### 数据初始化
配置未开启autoCreate，不会自动根据meta创建库表， 需要手动创建表和视图：
```
-- 创建基础消息表
CREATE TABLE IF NOT EXISTS zenvis.msg (
  user_id String,
  guid String NOT NULL,
  start_id UInt64 NOT NULL,
  sdk_version String,
  app_id UInt16,
  app_name String,
  app_package String,
  app_version String,
  platform String,
  manufacturer String,
  model String,
  system_name String,
  system_version String,
  net_type String,
  lan_ip IPv4,
  wan_ip IPv4,
  latitude Float64,
  longitude Float64,
  country String,
  province String,
  city String,
  county String,
  thoroughfare String,
  client_time DateTime,
  server_time DateTime,
  rule String,
  fact_type String NOT NULL,
  fact JSON,
  agenda_tags Array(String),
  agendas Array(String),
  punish_types Array(UInt8),
  punishes Array(String),
  insert_time DateTime DEFAULT now(),
  CONSTRAINT guid_startId_factType_not_empty CHECK guid != '' and start_id > 0 and fact_type != ''
) ENGINE = MergeTree()
ORDER BY
  (
    guid, start_id, client_time, fact_type
  );
```
--- 

#### 实体名称


| 实体 id | 实体名 | 表名 | 业务含义 |
|---|---|---|---|
| 1 | msg | msg | 每一条探针上报的**原始消息**（最细粒度） |

三个实体共享了大量字段（设备、应用、网络、位置、标签、处置等），但粒度不同：
- 一条 msg 对应一次探针上报；  
--- 


#### 数据库说明
以下是基于提供的建表语句生成的Markdown格式的库表说明：
--- 

#### `msg` 表说明

##### 表结构

| 字段名          | 数据类型          | 是否可空 | 默认值    | 约束条件                                                                 | 字段说明                                                                 |
|:----------------|:------------------|:---------|:----------|:-------------------------------------------------------------------------|:-------------------------------------------------------------------------|
| `user_id`       | String            | 是       | -         | -                                                                        | 用户ID                                                                   |
| `guid`          | String            | 否       | -         | `guid != ''`                                                             | 全局唯一标识符                                                           |
| `start_id`      | UInt64            | 否       | -         | `start_id > 0`                                                           | 开始ID                                                                   |
| `sdk_version`   | String            | 是       | -         | -                                                                        | SDK版本号                                                                |
| `app_id`        | UInt16            | 是       | -         | -                                                                        | 应用ID                                                                   |
| `app_name`      | String            | 是       | -         | -                                                                        | 应用名称                                                                 |
| `app_package`   | String            | 是       | -         | -                                                                        | 应用包名                                                                 |
| `app_version`   | String            | 是       | -         | -                                                                        | 应用版本号                                                               |
| `platform`      | String            | 是       | -         | -                                                                        | 平台类型                                                                 |
| `manufacturer`  | String            | 是       | -         | -                                                                        | 设备制造商                                                               |
| `model`         | String            | 是       | -         | -                                                                        | 设备型号                                                                 |
| `system_name`   | String            | 是       | -         | -                                                                        | 系统名称                                                                 |
| `system_version`| String            | 是       | -         | -                                                                        | 系统版本号                                                               |
| `net_type`      | String            | 是       | -         | -                                                                        | 网络类型                                                                 |
| `lan_ip`        | IPv4              | 是       | -         | -                                                                        | 局域网IP                                                                 |
| `wan_ip`        | IPv4              | 是       | -         | -                                                                        | 广域网IP                                                                 |
| `latitude`      | Float64           | 是       | -         | -                                                                        | 纬度                                                                     |
| `longitude`     | Float64           | 是       | -         | -                                                                        | 经度                                                                     |
| `country`       | String            | 是       | -         | -                                                                        | 国家                                                                     |
| `province`      | String            | 是       | -         | -                                                                        | 省份                                                                     |
| `city`          | String            | 是       | -         | -                                                                        | 城市                                                                     |
| `county`        | String            | 是       | -         | -                                                                        | 区/县                                                                   |
| `thoroughfare`  | String            | 是       | -         | -                                                                        | 街道                                                                     |
| `client_time`   | DateTime          | 是       | -         | -                                                                        | 客户端时间                                                               |
| `server_time`   | DateTime          | 是       | -         | -                                                                        | 服务器时间                                                               |
| `rule`          | String            | 是       | -         | -                                                                        | 规则                                                                     |
| `fact_type`     | String            | 否       | -         | `fact_type != ''`                                                        | 事实类型                                                                 |
| `fact`          | JSON              | 是       | -         | -                                                                        | 事实内容（JSON格式）                                                     |
| `agenda_tags`   | Array(String)     | 是       | -         | -                                                                        | 议程标签数组                                                             |
| `agendas`       | Array(String)     | 是       | -         | -                                                                        | 议程数组                                                                 |
| `punish_types`  | Array(UInt8)      | 是       | -         | -                                                                        | 惩罚类型数组                                                             |
| `punishes`      | Array(String)     | 是       | -         | -                                                                        | 惩罚内容数组                                                             |
| `insert_time`   | DateTime          | 否       | `now()`   | -                                                                        | 数据插入时间（默认为当前时间）                                           |

##### 表约束

- `guid_startId_factType_not_empty`：确保 `guid` 不为空，`start_id` 大于0，`fact_type` 不为空。

##### 表存储

- 存储引擎：`MergeTree`
- 主键排序：`(guid, start_id, client_time, fact_type)`
--- 


### 数据推送服务

以下是基于你提供的配置生成的推送服务说明：
--- 

# 推送服务说明

- 探针日志收集：继承了探针的应用和终端会上报采集日志到Kafka队列，当前服务作为消费端实现数据解析存储。

- 网关日志收集：通过开放Syslog接口用于接收网关日志，需要在网关配置中主动配置。

- 业务日志收集：以文件日志作为数据源，收集业务日志。
--- 

### API接口

无
--- 

### 可视化配置

无

### 菜单项

插件提供以下菜单项：

1. 探针信息配置（数据接收器服务提供）
2. 探针采集策略（数据接收器服务提供）
3. 识别标记策略（数据接收器服务提供）
4. 响应处置策略（数据接收器服务提供）
--- 

## 使用说明

1. 创建插件：登录->系统管理->插件管理->创建插件->上传插件包。
2. 安装插件：插件列表找到已经安装的插件->点击安装
3. 菜单调整：安装完成后自动创建菜单，默认都是一级菜单，可在菜单管理中调整菜单位置。
4. 插件修改：根据业务需求配置相关插件参数即可
5. 插件导出：插件列表找到已经安装的插件->点击导出（包含已经修改后的插件配置文件、元数据文件、API接口文件、可视化页面文件、菜单项文件、插件图标文件）
6. 卸载插件：插件列表找到已经安装的插件->点击卸载
7. 删除插件：插件列表找到已经安装的插件->点击删除
--- 

## 插件包结构

本插件按 ZenVis 首个正式版本插件包结构组织：

```text
00_doc/          文档与 RAG 资料
01_meta/         检索元数据与 ClickHouse 表结构
02_push-task/    数推任务配置
03_api/          API Jar，可为空
04_ui/           低代码 UI 配置
05_dashboard/    数据看板配置，当前 config.json 为空数组
06_mcp/          MCP 服务配置，当前 config.json 为空数组
07_skill/        Skill 目录，当前为空能力占位
08_menu/         菜单配置，安装流程最后写入
```
