aws_identity:
	aws sts get-caller-identity

install_kubectl:	
	curl -fsSL -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
	kubectl version --short --client

install_helm:
	export VERIFY_CHECKSUM=false
	curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

install_eksctl:
	curl -fsSL  "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/eksctl /usr/bin
	eksctl version

create_cluster:
	eksctl create cluster -f cluster.yaml

get_clusters:
	eksctl get cluster