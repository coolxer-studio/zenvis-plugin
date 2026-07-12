# ZenVis 插件包

**ZenVis Plugin** 是 ZenVis 数据分析应用框架的插件包仓库，用于维护平台当前内置插件及插件扩展示例。插件目录已按正式插件包结构组织，每个 `plugin-*` 目录都可以独立打包，并上传到 ZenVis 后端插件管理页进行安装。

---

## 项目简介

ZenVis 插件包为 ZenVis 平台提供资产管理、探针集成、运营分析、数据采集、风险监控、STA 数据和用户事件分析等业务扩展能力。  
项目详细介绍请参阅后端仓库：[zenvis-backend](https://gitee.com/coolxer-studio/zenvis-backend)

## 技术栈

| 分类 | 技术 | 说明 |
| :--- | :--- | :--- |
| 插件描述 | JSON | 使用 `index.json` 描述插件基础信息 |
| 元数据配置 | JSON | 使用 `01_meta/` 等目录维护插件内置配置 |
| API 扩展 | Java / Spring Boot | `03_api/` 可放置扩展接口 Jar 包 |
| UI 扩展 | HTML / 静态资源 | `04_ui/`、`05_dashboard/html-page/` 可放置页面资源 |
| 打包工具 | Shell / PowerShell | 提供 macOS、Linux、Windows 打包脚本 |
| 归档格式 | tar.gz | 插件上传产物格式 |

## 当前插件

| 目录 | 包名 | 说明 |
| :--- | :--- | :--- |
| `plugin-asset` | `com.coolxer.plugin.asset` | 资产管理插件 |
| `plugin-integrated` | `com.coolxer.plugin.integrated` | 探针集成插件 |
| `plugin-operation` | `com.coolxer.plugin.operation` | 运营分析插件 |
| `plugin-probe` | `com.coolxer.plugin.probe` | 数据采集插件 |
| `plugin-risk` | `com.coolxer.plugin.risk` | 风险监控插件 |
| `plugin-sta` | `com.coolxer.plugin.sta` | STA 数据插件 |
| `plugin-user-event` | `com.coolxer.plugin.user.event` | 用户事件分析示例插件 |

## 项目结构

```text
zenvis-plugin/
├── build.conf              # 打包配置
├── build.sh                # macOS/Linux 打包脚本
├── build.ps1               # Windows PowerShell 打包脚本
├── extend-api/             # 插件 API 扩展示例工程
├── plugin-asset/           # 资产管理插件
├── plugin-integrated/      # 探针集成插件
├── plugin-operation/       # 运营分析插件
├── plugin-probe/           # 数据采集插件
├── plugin-risk/            # 风险监控插件
├── plugin-sta/             # STA 数据插件
└── plugin-user-event/      # 用户事件分析示例插件
```

## 插件包结构

```text
plugin-xxx/
├── index.json
├── README.md
├── icon.png
├── 00_doc/
├── 01_meta/
├── 02_push-task/
├── 03_api/
├── 04_ui/
├── 05_dashboard/
│   ├── config.json
│   └── html-page/
├── 06_mcp/
│   └── config.json
├── 07_skill/
└── 08_menu/
    └── config.json
```

### 目录说明

| 目录/文件 | 说明 |
| :--- | :--- |
| `index.json` | 插件基础信息，包括名称、包名、版本、描述、作者和图标 |
| `README.md` | 插件说明文档 |
| `icon.png` | 插件图标 |
| `00_doc/` | 插件文档目录 |
| `01_meta/` | 元数据配置目录 |
| `02_push-task/` | 推送任务配置目录 |
| `03_api/` | API 扩展 Jar 包目录 |
| `04_ui/` | UI 扩展资源目录 |
| `05_dashboard/config.json` | 内置数据看板配置，可按 `DashboardDto` 数组补充 |
| `05_dashboard/html-page/` | HTML 看板页面目录 |
| `06_mcp/config.json` | MCP 服务配置，可按 `McpServerDto` 数组补充 |
| `07_skill/` | Skill 扩展目录 |
| `08_menu/config.json` | 菜单配置，安装生命周期中最后写入 |

## 快速开始

### 环境要求

- **macOS/Linux**: Bash、tar；macOS 建议安装 GNU tar（`gtar`）
- **Windows**: PowerShell、tar
- **API 扩展示例**: JDK 17 或更高版本、Maven 3.x

### 打包插件

macOS/Linux：

```bash
# 打包一个或多个插件
bash build.sh plugin-asset plugin-risk
```

Windows PowerShell：

```powershell
# 打包一个或多个插件
powershell -ExecutionPolicy Bypass -File build.ps1 plugin-asset plugin-risk
```

打包产物位于仓库根目录，文件名来自插件 `index.json` 中的 `package_name`，例如：

```text
com-coolxer-plugin-asset.tar.gz
```

### 安装插件

1. 执行打包脚本生成 `.tar.gz` 插件包。
2. 登录 ZenVis 后端管理系统。
3. 进入插件管理页面。
4. 上传并安装对应插件包。

## 可用脚本

| 脚本 | 说明 |
| :--- | :--- |
| `bash build.sh plugin-xxx` | 在 macOS/Linux 环境打包指定插件 |
| `powershell -ExecutionPolicy Bypass -File build.ps1 plugin-xxx` | 在 Windows PowerShell 环境打包指定插件 |
| `mvn clean package` | 在 `extend-api/` 目录构建 API 扩展示例 Jar 包 |
| `mvn spring-boot:run` | 在 `extend-api/` 目录运行 API 扩展示例工程 |

## 配置说明

### 插件基础信息

每个插件通过 `index.json` 定义基础信息：

```json
{
  "name": "资产管理",
  "package_name": "com.coolxer.plugin.asset",
  "version": "1.0.0",
  "description": "插件描述",
  "author": "CoolXer",
  "icon": "icon.png"
}
```

### 打包配置

`build.conf` 用于维护打包脚本所需的环境配置；`build.sh` 和 `build.ps1` 会在打包时读取该文件。

### API 扩展

`extend-api/` 是基于 Spring Boot 的插件 API 扩展示例工程。需要复杂接口扩展时，可将构建生成的 Jar 包放入插件的 `03_api/` 目录，插件安装后由平台加载。

## 开发指南

### 新增插件

1. 复制一个已有 `plugin-*` 目录作为模板。
2. 修改 `index.json` 中的插件名称、包名、版本、描述和图标。
3. 按需补充 `01_meta/`、`02_push-task/`、`03_api/`、`04_ui/`、`05_dashboard/`、`06_mcp/`、`07_skill/`、`08_menu/` 等目录内容。
4. 执行打包脚本生成插件包。
5. 上传到 ZenVis 后端插件管理页验证安装效果。

### 命名约定

- 插件目录使用 `plugin-xxx` 格式。
- 插件包名使用 Java 包名风格，例如 `com.coolxer.plugin.asset`。
- 打包产物会将包名中的 `.` 替换为 `-`，并生成 `.tar.gz` 文件。

## 注意事项

- 插件打包时会排除 `.DS_Store`、`*.tar`、`*.tar.gz`、`build.log` 等文件。
- `06_mcp/config.json` 可以为空数组，表示插件暂未内置 MCP 服务。
- `07_skill/` 可以仅保留目录占位，后续可放入一个或多个 Skill 目录。
- 修改插件结构后，建议重新打包并在后端插件管理页完成安装验证。

## 贡献指南

欢迎提交 Issue 和 Pull Request！  
贡献指南参考 [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 许可证

Apache 2.0 License

---

## 联系方式

如有问题或建议，欢迎通过以下方式联系：

- 提交 Issue
- 发送邮件：<coolxer@163.com>

---
