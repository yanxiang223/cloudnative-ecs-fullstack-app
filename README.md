# 云原生全栈应用 - CCE容器部署与DevOps实践

[![License: MIT-0](https://img.shields.io/badge/License-MIT--0-green.svg)](https://github.com/hsahbi/nolicense-mit-0)
[![Huawei Cloud](https://img.shields.io/badge/华为云-Solutions-blue.svg)](https://github2.com/huaweicloud-samples)
[![Incubating](https://img.shields.io/badge/status-incubating-orange.svg)](https://github.com/huaweicloud-samples)

---

## 简介

使用华为云CCE（云容器引擎）部署全栈应用，结合CodeArts实现DevOps流水线。展示如何通过Terraform管理基础设施、CodeArts Pipeline实现CI/CD、CCE实现容器化部署与自动弹性伸缩。

---

## 目录

- [简介](#简介)
- [架构图](#架构图)
- [方案亮点](#方案亮点)
- [涉及云服务与费用](#涉及云服务与费用)
- [前置条件](#前置条件)
- [快速开始](#快速开始)
- [分步部署](#分步部署)
- [使用方法/验证](#使用方法验证)
- [清理资源](#清理资源)
- [详细说明](#详细说明)
- [FAQ/故障排除](#faq故障排除)
- [贡献指南](#贡献指南)
- [许可证](#许可证)
- [联系方式/维护者](#联系方式维护者)

---

## 架构图

![基础设施架构](./docs/infrastructure-architecture.png)

**基础设施架构：**
- VPC网络（高可用设计，多可用区）
- CCE集群 + 2个工作负载（前端/后端）
- ELB（公网应用负载均衡）
- OBS桶（静态资源 + 流水线制品）
- GaussDB NoSQL（应用数据存储）
- SMN主题（部署通知）

**CI/CD架构：**
- CodeArts Repo（代码托管）
- CodeArts Build（构建）
- CodeArts Deploy（部署，蓝绿发布）

---

## 方案亮点

- **基础设施即代码**：Terraform管理所有华为云资源，一键部署/销毁
- **蓝绿部署**：CodeArts Deploy实现零停机发布
- **自动弹性伸缩**：CCE工作负载基于CPU/内存指标自动扩缩容
- **全栈DevOps**：代码→构建→部署全流水线自动化
- **多语言应用**：Vue.js前端 + Node.js后端

---

## 涉及云服务与费用

| 华为云服务 | 用途 | 计费方式 |
|-----------|------|----------|
| CCE | 容器集群与工作负载 | 按需/包周期 |
| ELB | 应用负载均衡 | 按需计费 |
| VPC | 网络隔离 | 免费（NAT网关按需） |
| EVS | 云硬盘（CCE节点存储） | 按需计费 |
| OBS | 静态资源与制品存储 | 按需计费 |
| GaussDB NoSQL | 应用数据存储 | 按需/包周期 |
| SMN | 部署通知 | 按需计费 |
| CodeAr@ts | CI/CD流水线 | 免费额度+按需 |
| IAM | 权限管理 | 免费 |
| CES | 云监控与告警 | 免费 |

> **费用提醒：** 本示例会产生华为云资源费用，请在体验后及时清理资源，避免持续计费。
>
> **清理提示：** 请参见 [清理资源](#清理资源) 章节。

---

## 前置条件

| 项目 | 要求 |
|------|------|
| 华为云账号 | 已注册并完成实名认证 |
| AK/SK | 已获取访问密钥：[我的凭证](https://console.huaweicloud.com/iam/#/myCredential) |
| Terraform | >= 1.0 |
| 华为云CLI | hcloud 最新版 |
| kubectl | 与CCE集群版本匹配 |
| Docker | Docker Desktop |
| Node.js | >= 18.x |
| Git | >= 2.x |

---

## 快速开始

```bash
git clone https://github.com/huaweicloud-samples/cloudnative-ecs-fullstack-app.git
cd cloudnative-ecs-fullstack-app/deploy/terraform
terraform init && terraform apply -auto-approve
```

---

## 分步部署

### 步骤 1：配置认证

```bash
export HUAWEICLOUD_SDK_AK="your_access_key"
export HUAWEICLOUD_SDK_SK="your_secret_key"
export HUAWEICLOUD_SDK_PROJECT_ID="your_project_id"
```

### 步骤 2：初始化Terraform

```bash
cd deploy/terraform
terraform init
```

### 步骤 3：规划并部署

```bash
terraform plan -var region="cn-north-4" -var environment_name="dev"
terraform apply -var region="cn-north-4" -var environment_name="dev"
```

### 步骤 4：配置kubectl

```bash
# 从CCE集群获取kubeconfig
hcloud cce get-kubeconfig --cluster-name <cluster-name> --region cn-north-4
```

### 步骤 5：验证部署

```bash
# 获取应用URL
terraform output application_url
# 在浏览器中打开该URL
```

---

## 使用方法/验证

### 访问应用

部署完成后，通过 `terraform output application_url` 获取前端访问地址。

### API端点

| 端点 | 说明 |
|------|------|
| `/status` | 健康检查 |
| `/api/getAllProducts` | 获取产品列表 |
| `/api/docs` | Swagger API文档 |

### 压测测试

```bash
# 前端压测
artillery run app/client/src/tests/stresstests/stress_client.yml
# 后端压测
artillery run app/server/src/tests/stresstests/stress_server.yml
```

---

## 清理资源

> **重要：** 为避免持续计费，请在体验完成后及时清理所有华为云资源。

```bash
cd deploy/terraform
terraform destroy -var region="cn-north-4" -var environment_name="dev"
```

---

## 详细说明

### Terraform资源清单

| 资源 | 数量 | 说明 |
|------|------|------|
| VPC + 子网 | 1套 | 高可用多可用区网络 |
| CCE集群 | 1 | 容器编排集群 |
| CCE工作负载 | 2 | 前端+后端 |
| ELB | 2 | 公网负载均衡 |
| OBS桶 | 2 | 制品+静态资源 |
| GaussDB NoSQL | 1 | 应用数据表 |
| SMN主题 | 1 | 部署通知 |
| IAM角色 | 多个 | CCE/CodeArts权限 |
| CES告警 | 4 | 弹性伸缩告警 |

### 配置项

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| `region` | 部署区域 | `cn-north-4` |
| `environment_name` | 环境名（资源前缀） | `dev` |
| `cce_node_count` | CCE节点数 | `2` |
| `cce_node_flavor` | 节点规格 | `s6.large.2` |

---

## FAQ/故障排除

| 问题 | 解决方案 |
|------|----------|
| CCE集群创建失败 | 检查账号是否开通CCE服务，配额是否充足 |
| Terraform init失败 | 确认Terraform >= 1.0，网络可访问华为云API |
| 镜像拉取失败 | 确认SWR镜像仓库权限配置正确 |
| ELB健康检查失败 | 检查安全组是否放行健康检查端口 |

> 更多问题请提交 [Issue](https://github.com/huaweicloud-samples/cloudnative-ecs-fullstack-app/issues)

---

## 贡献指南

欢迎贡献！请阅读 [CONTRIBUTING.md](./CONTRIBUTING.md) 了解贡献流程。

- 所有提交必须包含 DCO 签名：`git commit -s`
- PR 需至少一名 CODEOWNERS 审批
- 首次响应 SLA：5 个工作日内

---

## 许可证

本项目基于 [MIT-0 (MIT No Attribution)](https://github.com/hsahbi/nolicense-mit-0) 许可证开源。

---

## 联系方式/维护者

| 角色 | 联系方式 |
|------|----------|
| 维护者 | 华为云云原生解决方案团队 |
| 邮箱 | huaweiclouddeveloper-solution@huawei.com |

- GitHub 主页：[huaweicloud-samples](https://github.com/huaweicloud-samples)
- 开发者社区：[华为云开发者社区](https://developer.huaweicloud.com)