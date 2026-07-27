# AWS → 华为云 转换报告 - 项目1

## 转换概览

| 项目 | 值 |
|------|-----|
| 源仓 | aws-samples/amazon-ecs-fullstack-app-terraform |
| 目标仓 | huaweicloud-samples/cloudnative-ecs-fullstack-app |
| 转换时间 | 2026-07-27 |
| IaC框架 | Terraform（直接换Provider，无需重写） |
| 源License | MIT-0 |
| 目标License | MIT-0 |

## 服务映射

| AWS服务 | 华为云服务 | 映射完整度 |
|---------|-----------|-----------|
| ECS/Fargate | CCE | 高 |
| ECR | SWR (容器镜像服务) | 高 |
| ALB/NLB | ELB | 高 |
| S3 | OBS | 高 |
| DynamoDB | GaussDB NoSQL | 中 |
| SNS | SMN | 高 |
| CodePipeline | CodeArts Pipeline | 中 |
| CodeBuild | CodeArts Build | 中 |
| CodeDeploy | CodeArts Deploy | 中 |
| CloudWatch | CES | 高 |
| IAM | IAM | 高 |
| VPC | VPC | 高 |
| Security Groups | 安全组 | 高 |

## 文件变更清单

| 文件 | 变更类型 | 说明 |
|------|----------|------|
| README.md | 重写 | AWS格式→华为云17章节标准结构 |
| deploy/terraform/main.tf | 重写 | aws provider→huaweicloud provider |
| LICENSE | 替换 | MIT-0华为云版权 |
| CONTRIBUTING.md | 替换 | 华为云DCO贡献流程 |
| CODE_OF_CONDUCT.md | 替换 | Contributor Covenant v2.1 |
| .github/* | 新增 | Issue/PR模板+CI workflows |

## 未转换项（需人工处理）

| 项目 | 原因 | 建议 |
|------|------|------|
| Infrastructure/Modules/ 下的Terraform模块 | 需逐模块替换aws资源为huaweicloud资源 | 按资源映射表逐个替换 |
| Code/ 应用代码 | Vue.js/Node.js代码中可能有AWS SDK调用 | 检查并替换为华为云SDK |
| taskdef.json 任务定义模板 | ECS任务定义→CCE工作负载YAML | 需重写为Kubernetes Deployment |
| Documentation_assets/ 架构图 | AWS品牌资源 | 需替换为华为云架构图标 |

## 评估：手动改动量 **中低**

Terraform项目只需换Provider和资源名，无需重写IaC框架。主要工作量在Terraform模块逐个替换和任务定义模板重写。