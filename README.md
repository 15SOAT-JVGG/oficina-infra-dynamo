# Infraestrutura DynamoDB do Execution

Tabela por ambiente, cobrança sob demanda, chave `partId` string; proteção contra exclusão e recuperação pontual em produção. Há custo por requisição, armazenamento e recuperação pontual; consulte preços AWS antes do apply. Não há aplicação automática.

## CI e estado

Terraform >= 1.10, AWS provider 5.x. O estado usa S3 com criptografia e lockfile, chaves `oficina-infra-dynamo/<ambiente>/terraform.tfstate`. Configure em cada GitHub Environment `TF_STATE_BUCKET`, `AWS_REGION` e secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` conforme credenciais disponíveis. O papel deve ter acesso ao bucket e lock, DynamoDB e tags; o serviço Execution precisa somente GetItem e UpdateItem na ARN da tabela. Não versionar credenciais.

Validação local: `terraform init -backend=false && terraform validate`. Para planejar com credenciais e bucket configurados, inicialize o backend com `terraform init -backend-config="bucket=BUCKET" -backend-config="key=oficina-infra-dynamo/homolog/terraform.tfstate" -backend-config="region=us-east-1" -backend-config="use_lockfile=true"` e rode `terraform plan -var-file=envs/homolog.tfvars`. Troque ambiente e chave de estado juntos. O apply é manual e fora desta entrega; revise plano, custos, permissões e estado antes de aplicá-lo.
