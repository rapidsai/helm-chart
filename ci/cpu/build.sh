#!/usr/bin/env bash -ex

export PATH=/conda/bin:/usr/local/cuda/bin:$PATH:$WORKSPACE
export HOME=$WORKSPACE

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" != "main" ]]; then
  echo 'Branch release not main, exiting...';
  exit 1;
fi

cat <<EOF > credentials.sh
#!/bin/bash
echo username=$GIT_USERNAME
echo password=$GIT_PASSWORD
EOF

git config --global user.email "gputester@rapids.ai"
git config --global user.name "GPU Tester"
git config --global credential.helper "/bin/bash $WORKSPACE/credentials.sh"

source activate rapids
pip install chartpress
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | env USE_SUDO=false HELM_INSTALL_DIR=$WORKSPACE bash

cd $WORKSPACE
chartpress --publish
