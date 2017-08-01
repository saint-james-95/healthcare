#do this in your bashrc and source it first
#export KUBECONFIG=$HOME/admin.conf
sudo kubeadm reset
sudo systemctl restart kubelet

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --token-ttl 0

sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/monitoring-standalone/v1.6.0.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.6.0.yaml
