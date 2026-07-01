# 数据资产管理
---

## 基本信息

- **插件名称**: 资产管理
- **包名**: com.coolxer.plugin.asset
- **版本**: 1.0.0
- **作者**: CoolXer
- **描述**: 通过自动化手段对接探针采集的资产数据，并对这些资产进行精细化管理。系统涵盖了硬件类资产（如服务器主机、移动端设备、PC机、IOT设备）、软件类资产（如探针SDK、APP应用、系统服务、API接口）以及数据类资产（如日志、文件）。通过资产归类、标记、上下线管理、重要性评定和风险等级评定等功能，系统能够为企业提供全面、清晰且有序的数据资产视图，从而提升数据资产的利用效率和管理效能。
---


## 功能介绍
---

### 插件外部依赖

数据资产分析服务（需要单独部署）

---

### 元数据配置

# 资产数据模型说明文档

本文档基于提供的建表元数据，定义并说明了 ClickHouse 中 10 张核心资产表的字段含义、数据类型、支持的操作符及默认展示行为，便于后续开发、运维与数据分析工作快速查阅。

---

#### 1. 资产总览

| 实体(entity) | 中文名 | 表名 | 数据源 |
| --- | --- | --- | --- |
| asset_host | 主机资产 | asset_host | clickhouse |
| asset_pc | PC终端资产 | asset_pc | clickhouse |
| asset_iot | IoT设备资产 | asset_iot | clickhouse |
| asset_mobile | 移动端设备资产 | asset_mobile | clickhouse |
| asset_probe | 数据探针SDK资产 | asset_probe | clickhouse |
| asset_app | APP应用程序资产 | asset_app | clickhouse |
| asset_service | 系统服务资产 | asset_service | clickhouse |
| asset_api | RESTful API接口资产 | asset_api | clickhouse |
| asset_log | 日志资产 | asset_log | clickhouse |
| asset_file | 文件资产 | asset_file | clickhouse |

> 所有表均包含一组“公共字段”（见下一节），再叠加各实体特有字段。

---

#### 2. 公共字段说明

> 以下字段在 **所有资产表** 中含义一致，便于统一查询与权限控制。

| 字段名 | 类型 | 含义 | 支持操作符 | 默认展示 |
| --- | --- | --- | --- | --- |
| id | String | 主键 | equal / notequal / in | ✔ |
| source | String | 数据来源 | equal / notequal / in | ✔ |
| type | String | 资产类型 | equal / notequal / in | ✔ |
| owner | String | 资产负责人 | equal / notequal / in | ✔ |
| status | String | 资产状态 | equal / notequal / in | ✔ |
| label | String | 业务标签（逗号拼接） | equal / notequal / in | ✔ |
| access | UInt8 | 是否可访问（0/1） | equal / notequal / in | ✔ |
| level | String | 重要等级 | equal / notequal / in | ✔ |
| risk | String | 风险等级 | equal / notequal / in | ✔ |
| risk_info | String | 风险描述 | equal / notequal / in | ✖ |
| info | json | 扩展信息(json) | equal / notequal / in | ✖ |
| update_time | DateTime64(3) | 记录更新时间 | 日期类操作符* | ✔ |
| insert_time | DateTime64(3) | 记录入库时间 | 日期类操作符* | ✖ |

> 日期类操作符：`greatthan / lessthan / greatequalthan / lessequalthan / between`

---

#### 3. 实体特有字段

##### 3.1 主机资产表 `asset_host`

| 字段名 | 类型 | 含义 | 默认展示 |
| --- | --- | --- | --- |
| area_code | String | 行政区域代码 | ✖ |
| country / province / city / county | String | 国家/省/市/区县 | ✔ / ✔ / ✔ / ✖ |
| net_type | String | 网络类型 | ✔ |
| lan_ip / wan_ip | IPv4 | 内网/外网 IPv4 地址 | ✔ |
| room | String | 所在机房 | ✔ |
| cabinet_no / position_no | String | 机柜号/机柜内位置 | ✖ |
| manufacturer / model | String | 硬件厂商/型号 | ✔ |
| architecture | String | CPU 架构 | ✔ |
| system_name / system_version | String | 操作系统名称/版本 | ✔ |
| cpu_model | String | CPU 型号 | ✔ |
| cpu_cores | UInt32 | CPU 核数 | ✔ |
| memory_size | UInt32 | 内存大小(MB) | ✔ |
| disk_size | UInt32 | 磁盘大小(GB) | ✔ |

##### 3.2 PC终端资产表 `asset_pc`

除公共字段外，额外包含：

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| gpu_model / gpu_brand / gpu_memory_size / gpu_memory_type |  | GPU 相关信息 |
| monitor_brand / monitor_model / monitor_resolution / monitor_interface |  | 显示器相关信息 |
| 其余字段与主机资产一致（如 cpu_cores、memory_size 等） |

##### 3.3 IoT设备资产表 `asset_iot`

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| device_name | String | 设备名称/别名 |
| device_type | String | IoT设备分类（传感器、摄像头…） |
| serial_number | String | 设备序列号 |
| firmware_version | String | 当前固件版本 |
| firmware_update_time | DateTime64(3) | 最近一次固件升级时间 |
| power_type | String | 供电方式 |
| battery_level | UInt8 | 电池电量(0-100) |
| sensor_info | String | 传感器列表及状态(json) |
| communication_protocol | String | 通信协议(MQTT/CoAP/…) |

##### 3.4 移动端设备资产表 `asset_mobile`

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| brand / model / manufacturer | String | 设备品牌/型号/制造商 |
| system_name / system_version | String | OS 名称/版本 |
| android_id / imei / imsi | String | Android 设备唯一标识/IMEI/IMSI |
| wifi_mac / bluetooth_mac / network_mac | String | 各类 MAC 地址 |
| screen_resolution | String | 屏幕分辨率 |
| carrier_type | String | 运营商类型 |
| 更多字段如 gyroscope_info、device_fingerprint 等用于刻画设备指纹 |

##### 3.5 数据探针SDK资产表 `asset_probe`

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| probe_name / probe_version | String | 探针名称/版本 |
| probe_type | String | 探针类型(移动端/后端/前端) |
| language / framework | String | 开发语言/框架 |
| data_collection_types | String | 采集数据类型(逗号拼接) |
| encryption_method / authentication_method / data_transmission_protocol | String | 加密、认证、传输协议 |
| file_md5 / certificate_md5 | String | 安装包及证书 MD5 |

##### 3.6 APP应用程序资产表 `asset_app`

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| app_name / app_version | String | 应用名称/版本 |
| app_type | String | 应用分类(原生/H5/小程序) |
| platform | String | 目标平台(iOS/Android/Web) |
| package_name | String | 包名/Bundle ID |
| developer | String | 开发者 |
| publish_time | DateTime64(3) | 发布时间 |
| min_os_version / target_os_version | String | 最低/推荐系统版本 |
| permissions / dependencies | String | 权限清单、依赖库(逗号拼接) |
| file_md5 / certificate_md5 | String | 安装包及证书 MD5 |

##### 3.7 系统服务资产表 `asset_service`

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| service_name / service_version | String | 服务名称/版本 |
| service_type | String | 服务分类(微服务/单体) |
| runtime_environment | String | 运行环境(JVM/容器…) |
| deployment_type | String | 部署方式(K8s/裸机) |
| port | UInt16 | 监听端口 |
| process_name / process_id | String | 进程名/ID |
| dependencies | String | 依赖服务(逗号拼接) |
| resource_usage | String | 资源使用(json) |

##### 3.8 RESTful API接口资产表 `asset_api`

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| api_name / api_version / api_path | String | 接口名称/版本/URL 路径 |
| http_method | String | HTTP 方法(GET/POST/PUT/DELETE) |
| content_type | String | 请求/响应 Content-Type |
| authentication_type | String | 认证方式(OAuth/JWT/…) |
| rate_limit | UInt32 | 每秒最大请求次数(QPS) |
| is_deprecated | UInt8 | 是否已废弃(0/1) |
| service_id | String | 所属服务系统ID |
| documentation_url | String | 在线文档地址 |

##### 3.9 日志资产表 `asset_log`

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| log_name / log_path | String | 日志文件名称/路径 |
| log_type | String | 日志业务类型 |
| log_format | String | 日志格式(JSON/CSV/…) |
| log_time | DateTime64(3) | 日志产生时间 |
| log_level | String | 日志级别(INFO/ERROR/…) |
| process | String | 产生日志的进程或服务 |
| log_message | String | 日志正文 |

##### 3.10 文件资产表 `asset_file`

| 字段名 | 类型 | 含义 |
| --- | --- | --- |
| file_name / file_path | String | 文件名称/存储路径 |
| file_type / file_format | String | 业务类型/文件后缀 |
| file_size | Int64 | 文件大小(字节) |
| creation_time / modification_time | Int64 | 创建/最后修改时间(Unix 时间戳) |
| source_system | String | 来源业务系统 |
| file_owner | String | 文件所有者 |
| permissions | String | 权限/ACL |
| is_encrypted / is_compressed | UInt8 | 是否已加密/压缩(0/1) |
| file_hash | String | 文件哈希(MD5/SHA256) |

---

### 数据推送服务

本系统主要用于测试验证场景，其核心功能是数据的产生与入库。在具体运行过程中，系统能够自动且随机地生成数据，这一过程是完全自动化的，无需人工干预。为了保证数据的持续性和稳定性，系统采用定时触发机制，每隔5秒便会自动生成一组新的数据。这些数据随后会被准确无误地存储到指定的数据库中，以便后续的查询、分析和验证工作。通过这种方式，系统能够有效地模拟真实场景中的数据产生过程，为测试验证工作提供了可靠的数据支持，从而确保整个测试流程的顺利进行和结果的准确性。
---

### API接口

无

---

### 可视化配置

支持

---

### 菜单项

插件提供以下菜单项：

1. 设备指纹策略（配置菜单）
2. 资管可视化配置（配置菜单）
3. 资产管理（应用app）
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


