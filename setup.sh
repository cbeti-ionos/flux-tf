# For setting up locally, tested using KinD (https://kind.sigs.k8s.io/)
# local variant, not in gitlab
NS=infrastructure

kubectl create namespace $NS
kubectl create -n $NS secret generic ionos-token --from-literal=credentials="{\"token\":\"${IONOS_TOKEN}\"}"

helm upgrade --install fluxcd -n $NS fluxcd-community/flux2
helm upgrade --install tofu-controller -n $NS tofu-controller/tf-controller
helm upgrade --install resources -n $NS charts

sleep 120

helm upgrade --install resources -n $NS charts