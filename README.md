# ZenVis 插件包

本仓库维护 ZenVis 当前内置插件包，插件目录已按首个正式版本的包结构组织。每个 `plugin-*` 目录都可以独立打包上传到后端插件管理页。

## 当前插件

| 目录 | 包名 | 说明 |
| --- | --- | --- |
| `plugin-asset` | `com.coolxer.plugin.asset` | 资产管理插件 |
| `plugin-integrated` | `com.coolxer.plugin.integrated` | 探针集成插件 |
| `plugin-operation` | `com.coolxer.plugin.operation` | 运营分析插件 |
| `plugin-probe` | `com.coolxer.plugin.probe` | 数据采集插件 |
| `plugin-risk` | `com.coolxer.plugin.risk` | 风险监控插件 |
| `plugin-sta` | `com.coolxer.plugin.sta` | STA 数据插件 |
| `plugin-user-event` | `com.coolxer.plugin.user.event` | 用户事件分析示例插件 |

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

- `05_dashboard/config.json` 可按 `DashboardDto` 数组补充内置数据看板；HTML 看板页面放在 `05_dashboard/html-page/` 下。
- `06_mcp/config.json` 当前为空数组，表示插件暂未内置 MCP 服务；后续可按 `McpServerDto` 数组补充。
- `07_skill/` 当前仅保留目录占位；后续可放入一个或多个 Skill 目录。
- `08_menu/config.json` 为菜单配置，安装生命周期中最后写入。

## 打包

macOS/Linux：

```bash
bash build.sh plugin-asset plugin-risk
```

Windows PowerShell：

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1 plugin-asset plugin-risk
```

打包产物位于仓库根目录，文件名来自插件 `index.json` 中的 `package_name`，例如 `com-coolxer-plugin-asset.tar.gz`。
