# 运营分析
---

## 基本信息

- **插件名称**: 运营分析
- **包名**: com.coolxer.plugin.operation
- **版本**: 1.0.0
- **作者**: CoolXer
- **描述**: 通过收集用户行为数据为数字化运营分析提供数据支撑。
---


## 功能介绍
---

### 插件外部依赖

运营分析服务（需要单独部署）
---

### 元数据配置

本文档对 `zenvis` 库下 10 张行为事件表的字段、类型、含义、支持操作符及默认展示规则进行统一说明，方便研发、数据、运营快速查阅。
---

---

#### 1. 事件表总览

| 实体(entity) | 中文名 | 表名 | 核心场景 |
|---|---|---|---|
| operation_start_event | 启动事件 | zenvis.operation_start_event | 应用启动 |
| operation_click_event | 点击事件 | zenvis.operation_click_event | 组件点击 |
| operation_page_event | 页面访问事件 | zenvis.operation_page_event | 页面浏览 & 跳转 |
| operation_api_call_event | 函数调用事件 | zenvis.operation_api_call_event | 内部/外部 API 调用 |
| operation_network_event | 网络请求事件 | zenvis.operation_network_event | HTTP/TCP 网络交互 |
| operation_extend_event | 用户拓展事件 | zenvis.operation_extend_event | 自定义埋点 |
| operation_performance_event | 资源利用状态 | zenvis.operation_performance_event | 性能采样 |
| operation_location_event | 位置信息状态 | zenvis.operation_location_event | 实时地理位置 |
| operation_crash_event | 崩溃事件 | zenvis.operation_crash_event | 崩溃 & 异常 |
| operation_anr_event | 无响应事件 | zenvis.operation_anr_event | ANR（卡死） |

---

#### 2. 公共字段（所有表通用）

| 字段 | 类型 | 含义 | 支持操作符 | 默认展示 |
|---|---|---|---|---|
| id | String | 事件唯一编号 | =, ≠, in | ✔ |
| user_id | String | 用户唯一标识 | =, ≠, in | ✔ |
| start_id | String | 一次启动会话 ID | =, ≠, in | ✔ / ‑ |
| longitude / latitude | Float64 | 经纬度 | 数值类* | ✔ |
| country / province / city / county | String | 行政区划 | =, ≠, in | ✔ |
| location | String(派生) | 完整位置（country+province+city+county） | =, ≠, in | ✔ |
| net_type | String | 网络类型（WiFi/4G…） | =, ≠, in | ✔ |
| lan_ip / wan_ip | String | 局域网/公网 IP | =, ≠, in | ✔ |
| update_time | DateTime64(3) | 记录更新时间 | 日期类* | ✔ |
| insert_time | DateTime64(3) | 记录入库时间 | 日期类* | △ |
| event_time | DateTime64(3) | 客户端真实发生时间 | 日期类* | ✔ |

> 数值类：支持 `>, <, ≥, ≤, between`  
> 日期类：支持 `>, <, ≥, ≤, between`

---

#### 3. 各事件特有字段

##### 3.1 启动事件 operation_start_event
| 字段 | 类型 | 含义 |
|---|---|---|
| device_id | String | 设备唯一 ID |
| device_model | String | 设备型号 |
| device_os | String | 操作系统 |
| app_id | String | 应用 ID |
| app_name | String | 应用名称 |
| package_name | String | 包名 |

##### 3.2 点击事件 operation_click_event
| 字段 | 类型 | 含义 |
|---|---|---|
| click_x / click_y | Float64 | 点击坐标 |
| component_type | String | 组件类型（Button、Image…） |
| component_name | String | 组件名称/ID |
| page_path | String | 页面路由 |
| page_name | String | 页面中文名 |

##### 3.3 页面访问事件 operation_page_event
| 字段 | 类型 | 含义 |
|---|---|---|
| page_path | String | 页面路由 |
| page_name | String | 页面名称 |
| referrer | String | 来源页面/URL |

##### 3.4 函数调用事件 operation_api_call_event
| 字段 | 类型 | 含义 |
|---|---|---|
| caller | String | 调用者 |
| callee | String | 被调用者 |
| function_name | String | 函数名 |
| function_params | String | 入参快照 |
| function_return | String | 返回值快照 |

##### 3.5 网络请求事件 operation_network_event
| 字段 | 类型 | 含义 |
|---|---|---|
| source_ip / source_port | String | 源 IP/端口 |
| target_ip / target_port | String | 目标 IP/端口 |
| protocol | String | 协议（TCP/UDP/HTTP） |
| request_time / response_time | DateTime64(3) | 请求/响应时间 |
| request_content / response_content | String | 请求/响应报文（JSON 或文本） |

##### 3.6 用户拓展事件 operation_extend_event
| 字段 | 类型 | 含义 |
|---|---|---|
| extend | String | 自定义扩展消息（JSON 或 KV 串） |

##### 3.7 性能事件 operation_performance_event
| 字段 | 类型 | 含义 |
|---|---|---|
| cpu_usage / cpu_user / cpu_system / cpu_idle | Float64 | CPU 利用率细分 |
| memory_total / memory_used / memory_usage | Int64 / Float64 | 物理内存（KB）& 利用率 |
| virtual_memory_total / virtual_memory_used | Int64 | 虚拟内存（KB） |
| swap_total / swap_used | Int64 | 交换分区（KB） |
| disk_read_speed / disk_write_speed / disk_throughput | Float64 | 磁盘读写速率（KB/s） |
| disk_iops | Int32 | 磁盘 IOPS |
| network_send_rate / network_receive_rate | Float64 | 网络收发速率（KB/s） |
| network_packet_loss / network_latency | Float64 | 丢包率 & 延迟(ms) |

##### 3.8 位置信息事件 operation_location_event
> 仅记录实时定位快照，无额外字段。

##### 3.9 崩溃事件 operation_crash_event
| 字段 | 类型 | 含义 |
|---|---|---|
| message | String | 崩溃摘要 |
| stack_trace | String | 完整堆栈 |

##### 3.10 ANR 事件 operation_anr_event
| 字段 | 类型 | 含义 |
|---|---|---|
| page_path | String | 卡死页面路由 |
| page_name | String | 卡死页面名称 |
| anr_gap | Int64 | 无响应持续时长(ms) |


### 数据推送服务

支持 
---

### API接口

无
---

### 可视化配置

支持
---

### 菜单项

插件提供以下菜单项：

1. 运营可视化配置（配置菜单）
2. 运营分析（应用app）
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
