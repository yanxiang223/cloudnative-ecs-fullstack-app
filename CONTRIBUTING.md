# 贡献指南

感谢您对本项目的关注！我们欢迎并感谢社区贡献。

## 行为准则

本项目采用 [Contributor Covenant Code of Conduct v2.1](./CODE_OF_CONDUCT.md)。参与本项目即表示您同意遵守其条款。

## 贡献流程

1. **Fork** 本仓库到您的 GitHub 账号
2. **创建分支**：`git checkout -b feature/your-feature-name`
3. **开发**：进行代码修改或新增
4. **DCO 签名**：所有提交必须包含 `Signed-off-by:` 行
   ```bash
   git commit -s -m "feat: add your feature description"
   ```
5. **发起 PR**：向本仓库 `main` 分支提交 Pull Request
6. **关联 Issue**：在 PR 描述中引用相关 Issue（如 `Closes #123`）
7. **审核**：等待维护者审核，可能请求修改
8. **合并**：审核通过后，由维护者 Squash and Merge

## DCO 签名（Developer Certificate of Origin）

所有提交必须包含 DCO 签名：

```
Signed-off-by: Your Name <your.email@example.com>
```

使用 `git commit -s` 自动添加。DCO 全文见：https://developercertificate.org/

通过提交包含 Signed-off-by 的补丁，贡献者证明其有权根据开源许可证提交该补丁。

## 代码规范

- 遵循项目现有代码风格
- 关键逻辑需有中/英文注释，函数/类必须有文档字符串
- 所有连接信息和密钥必须从环境变量读取，严禁硬编码
- 示例代码中的客户数据、账号信息必须脱敏处理

## Issue / PR 模板

- **Bug 报告**：使用 `.github/ISSUE_TEMPLATE/bug_report.md`
- **功能请求**：使用 `.github/ISSUE_TEMPLATE/feature_request.md`
- **Pull Request**：使用 `.github/PULL_REQUEST_TEMPLATE.md`

## 评审过程

- 维护者将在 **5 个工作日内** 响应您的 PR
- 可能请求修改，请耐心配合
- 合并需至少一名维护者（CODEOWNERS）批准
- CI 检查必须全部通过

## 许可协议

提交贡献即表示您同意，您的贡献将在本仓库所用的许可证（MIT-0）下分发。