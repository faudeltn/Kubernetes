echo "Setup kubectl"
if [ ! `which kubectl 2> /dev/null` ]; then
  echo "Install kubectl"
  curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl  > /dev/null
  chmod +x ./kubectl
  sudo mv ./kubectl  /usr/local/bin/kubectl > /dev/null
  kubectl completion bash >>  ~/.bash_completion
fi

if [ ! `which eksctl 2> /dev/null` ]; then
echo "install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp   > /dev/null
sudo mv -v /tmp/eksctl /usr/local/bin > /dev/null
echo "eksctl completion"
eksctl completion bash >> ~/.bash_completion
fi

if [ ! `which helm 2> /dev/null` ]; then
  echo "helm"
  export VERIFY_CHECKSUM=false
  curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi

