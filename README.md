# Infraestrutura DynamoDB do Execution

Tabela por ambiente, cobrança sob demanda, chave `partId` string; proteção contra exclusão e recuperação pontual em produção. Há custo por requisição, armazenamento e recuperação pontual; consulte preços AWS antes do apply. Não há aplicação automática.

## CI e estado

Terraform >= 1.10, AWS provider 5.x. O estado usa S3 com criptografia e lockfile, chaves `oficina-infra-dynamo/<ambiente>/terraform.tfstate`. Configure em cada GitHub Environment `TF_STATE_BUCKET`, `AWS_REGION` e secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` conforme credenciais disponíveis. O papel deve ter acesso ao bucket e lock, DynamoDB e tags; o serviço Execution precisa somente GetItem e UpdateItem na ARN da tabela. Não versionar credenciais.

Validação local: `terraform init -backend=false && terraform validate`. Para planejar com credenciais e bucket configurados, inicialize o backend com `terraform init -backend-config="bucket=BUCKET" -backend-config="key=oficina-infra-dynamo/homolog/terraform.tfstate" -backend-config="region=us-east-1" -backend-config="use_lockfile=true"` e rode `terraform plan -var-file=envs/homolog.tfvars`. Troque ambiente e chave de estado juntos. O apply é manual e fora desta entrega; revise plano, custos, permissões e estado antes de aplicá-lo.

## Estado da validação da issue #119 — 2026-11-15

- O workflow `Terraform` foi executado manualmente para `homolog` em [43747878264](https://github.com/15SOAT-JVGG/oficina-infra-dynamo/actions/runs/43747878264). `fmt`, `init -backend=false` e `validate` passaram.
- A validação de presença passou para `TF_STATE_BUCKET`, `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`; o workflow resolveu `TF_STATE_BUCKET`. Isso não comprova a validade da sessão temporária. A região usa `AWS_REGION` ou o padrão `us-east-1` definido no workflow; o valor efetivo ainda não foi confirmado.
- O job de plano parou durante `terraform init`: STS retornou `InvalidClientTokenId`. Assim, o backend e o objeto `oficina-infra-dynamo/homolog/terraform.tfstate` ainda não foram verificados, e nenhum `terraform plan` foi gerado.
- O perfil AWS disponível localmente não é a LabRole e não tem `dynamodb:DescribeTable`; ele não serve para validar o acesso da LabRole ou do Execution. Não registrar nem reutilizar esse perfil para contornar a falta de permissões.
- Nenhum recurso AWS foi criado ou alterado. Para retomar, atualizar as credenciais temporárias de homologação (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` e `AWS_SESSION_TOKEN`) no GitHub Environment, confirmar a região e reexecutar o workflow manual. Revisar o plano e as permissões antes de considerar qualquer `apply`; esta etapa foi deixada pronta para aplicação, sem executar `apply`.
