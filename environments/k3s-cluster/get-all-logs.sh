# replace <ns> with your namespace (e.g., rook-ceph)

for p in $(kubectl get pods -n $1 -o name); do
  echo "===== $p ====="
  kubectl logs -n <ns> --all-containers "$p"
done
