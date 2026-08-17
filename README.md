# x390OS14 — OpenCore EFI scaffold for X390

说明
- 这是一个 EFI scaffold，仅包含 OpenCore 配置模板与下载脚本，不包含任何第三方 kext 二进制文件。
- 目标机器：Lenovo X390 (i3-8th 系列假设)。
- OpenCore 版本：请在本地替换为你实际使用的版本并下载对应驱动/工具/ACPI。

主要文件
- EFI/OC/config.plist — 注释版模板（含占位 PlatformInfo，请本地替换序列号/MLB/ROM/SmUUID）
- download-kexts.ps1 — PowerShell 脚本：从官方 GitHub releases 拉取常用 kext 并放到 EFI/OC/Kexts（需在 PowerShell 环境运行）
- EFI/OC/ACPI/ — 占位 SSDT 文件
- EFI/BOOT/BOOTx64.efi — 占位说明（请用你下载或编译的实际 OpenCore BOOTx64.efi 替换）

安全与注意
- config.plist 中所有 Apple 序列号/MLB/ROM/SmUUID 都使用占位值。请在本地用合法值替换（切勿在公开仓库发布真实 Apple 序列号）。
- 我不会上传受限或非开源二进制。download-kexts.ps1 会从各项目 Releases 下载官方打包文件（脚本仅为辅助，你可自行验证来源后运行）。
- 在推送前请自行检查并替换所有占位值与对应 OpenCore 驱动版本。

本地提交 & 创建 PR（示例命令）
1) 克隆并创建分支：
   git clone git@github.com:chen57/x390OS14.git
   cd x390OS14
   git checkout -b OC/efi-x390os14
2) 将本仓 scaffold 写入后：
   git add .
   git commit -m "Add OpenCore EFI scaffold for X390 (i3-8th, Intel)"
   git push -u origin OC/efi-x390os14
3) 创建 PR（使用 gh CLI）：
   gh pr create --fill --base main --head OC/efi-x390os14
