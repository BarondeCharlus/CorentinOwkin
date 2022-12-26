#!/usr/bin/env sh

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

cd "$(dirname "$0")"

main() {
    while :; do
      performance=0

      res=$(curl -s -X GET http://192.168.49.2/api/v1/status | jq '[.[] | select (.status=="init")][0]')
      id=$(echo ${res} | jq -r .id)
      name=$(echo ${res} | jq -r .name)
      dockerfile=$(echo ${res} | jq -r .dockerfile)

      payload=$(cat << EOF
      {
      "id": "${id}",
      "name": "${name}",
      "dockerfile": "${dockerfile}",
      "status": "processing"
      }
EOF
      )
      curl -s -X PUT -H "Content-Type: application/json" http://192.168.49.2/api/v1/status/${id} --data-binary "${payload}"

      temp_path=".${id}-tf-templates"
      cp -r tf-templates/ ${temp_path}
      sed -i "s/{{ID}}/${id}/g" ${temp_path}/namespace.tf
      sed -i "s/{{ID}}/${id}/g" ${temp_path}/deployment.tf
      sed -i "s/{{ID}}/${id}/g" ${temp_path}/networkpolicy.tf

      echo ${dockerfile} | base64 -d | gunzip > ${temp_path}/Dockerfile
      MKD="RUN mkdir -p /run"
      COPY="COPY ./go-bin/main /run"
      CHM="RUN chmod +x /run/main"
      RUN="RUN ./run/main"
      sed "\$i $MKD" ${temp_path}/Dockerfile
      sed "\$i $COPY" ${temp_path}/Dockerfile
      sed "\$i $CHM" ${temp_path}/Dockerfile
      sed "\$i $RUN" ${temp_path}/Dockerfile

      report=$(lynis audit dockerfile ${temp_path}/Dockerfile)
      warns=$(grep -i 'warning' ~/lynis-report.dat | wc -l) ||:
      if [ ${warns} -gt 0 ] ; then
         perf=$(echo "scale=1;${warns} / 10" | bc -l)
         performance=$(echo "${performance} + ${perf}" | bc -l | awk '{printf "%.2f\n", $0}')
      fi
      eval $(minikube -p minikube docker-env)
      docker build -f ${temp_path}/Dockerfile -t ${id}:latest

      cd ${temp_path}
      terraform init
      terraform plan
      terraform apply --auto-approve
      sleep 3
    done
}

main "$@"
