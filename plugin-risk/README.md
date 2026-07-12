# 风险监控
--- 

## 基本信息

- **插件名称**: 风险监控
- **包名**: com.coolxer.plugin.risk
- **版本**: 1.0.0
- **作者**: CoolXer
- **描述**: 通过收集外部威胁以及脆弱性等问题，综合分析安全风险事件。
--- 


## 功能介绍
--- 

### 插件外部依赖

风险分析服务（需要单独部署）

--- 

### 元数据配置
--- 

#### 1. 数据表总览

| 实体(entity) | 中文名 | 表名 | 场景 |
| --- | --- | --- | --- |
| risk_event | 风险事件汇总 | zenvis.risk_event | 多类威胁统一入口 |
| risk_data | 数据风险详情 | zenvis.risk_data | 泄露、篡改等 |
| risk_vulnerability | 漏洞风险 | zenvis.risk_vulnerability | CVE/系统漏洞 |
| risk_baseline | 基线风险 | zenvis.risk_baseline | 配置不合规 |
| risk_weak | 弱口令风险 | zenvis.risk_weak | 弱口令检测 |
| risk_attack | 攻击风险 | zenvis.risk_attack | 攻击行为 |

---

#### 2. 公共字段（所有表通用）

| 字段 | 类型 | 含义 | 支持操作符 | 默认展示 |
| --- | --- | --- | --- | --- |
| id | String | 唯一标识 | =, ≠, in | ✔ |
| user_id | String | 用户唯一标识 | =, ≠, in | ✔ |
| start_id | String | 启动会话 ID | =, ≠, in | ✔ |
| asset_id | String | 资产唯一标识 | =, ≠, in | ✔ |
| type | String | 威胁类型 | =, ≠, in | ✔ |
| detail | String | 威胁详情 | =, ≠, in | ✔ |
| label | String | 标签(逗号拼接) | =, ≠, in | ✔ |
| risk_level | String | 风险等级(High/Medium/Low) | =, ≠, in | ✔ |
| net_type | String | 网络类型(WiFi/4G…) | =, ≠, in | ✔ |
| lan_ip / wan_ip | String | 局域网/公网 IP | =, ≠, in | ✔ |
| update_time | DateTime64(3) | 更新时间 | 日期类* | ✔ |
| insert_time | DateTime64(3) | 创建时间 | 日期类* | ✔ |

> 日期类：支持 `>, <, ≥, ≤, between`

---

#### 3. 各表特有字段

##### 3.1 risk_data 数据风险
| 字段 | 类型 | 含义 |
| --- | --- | --- |
| verification_method | String | 验证方法 |
| verification_result | String | 验证结果 |

##### 3.2 risk_vulnerability 漏洞风险
| 字段 | 类型 | 含义 |
| --- | --- | --- |
| vulnerability_name | String | 漏洞名称 |
| vulnerability_id | String | CVE/Bugtraq 等编号 |
| vulnerability_category | String | 分类(Web/系统…) |
| vulnerability_description | String | 详细描述 |
| cvss_score | Float64 | CVSS 分数(0–10) |
| cvss_vector | String | CVSS 向量 |
| affected_scope | String | 影响范围 |
| affected_component | String | 受影响组件 |
| affected_version | String | 受影响版本 |
| fixed_version | String | 修复版本 |
| fix_suggestion | String | 修复建议 |
| vulnerability_status | String | 状态(New/Fixed/Ignore) |
| verification_method | String | 验证方法 |
| verification_result | String | 验证结果 |

##### 3.3 risk_baseline 基线风险
| 字段 | 类型 | 含义 |
| --- | --- | --- |
| configuration_name | String | 配置项名称 |
| expected_value | String | 预期值 |
| current_value | String | 当前值 |
| verification_method | String | 验证方法 |
| verification_result | String | 验证结果 |

##### 3.4 risk_weak 弱口令风险
| 字段 | 类型 | 含义 |
| --- | --- | --- |
| username | String | 检测到的用户名 |
| password | String | 弱口令(默认不展示) |
| password_type | String | 口令类别(SSH/DB/…) |
| verification_method | String | 验证方法 |
| verification_result | String | 验证结果 |

##### 3.5 risk_attack 攻击风险
| 字段 | 类型 | 含义 |
| --- | --- | --- |
| verification_method | String | 攻击验证方法 |
| verification_result | String | 验证结果 |


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

1. 风险评级策略（配置菜单）
2. 风控可视化配置（配置菜单）
3. 风险监控（app）
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
