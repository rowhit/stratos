#!/bin/bash

iaas=$1
host_ip="localhost"
host_port=9443

prgdir=`dirname "$0"`
script_path=`cd "$prgdir"; pwd`

artifacts_path=`cd "${script_path}/../../artifacts"; pwd`
iaas_artifacts_path=`cd "${script_path}/../../artifacts/${iaas}"; pwd`
cartridges_path=`cd "${script_path}/../../../../../cartridges/${iaas}"; pwd`
cartridges_groups_path=`cd "${script_path}/../../../../../cartridges-groups"; pwd`
autoscaling_policies_path=`cd "${script_path}/../../../../../autoscaling-policies"; pwd`
network_partitions_path=`cd "${script_path}/../../../../../network-partitions/${iaas}"; pwd`
deployment_policies_path=`cd "${script_path}/../../../../../deployment-policies"; pwd`
application_policies_path=`cd "${script_path}/../../../../../application-policies"; pwd`

set -e

if [[ -z "${iaas}" ]]; then
    echo "Usage: deploy.sh [iaas]"
    exit
fi

echo ${autoscaling_policies_path}/autoscaling-policy-1.json
echo "Adding autoscale policy..."
curl -X POST -H "Content-Type: application/json" -d "@${autoscaling_policies_path}/autoscaling-policy-1.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/autoscalingPolicies

echo "Adding network partitions..."
curl -X POST -H "Content-Type: application/json" -d "@${network_partitions_path}/network-partition-1.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/networkPartitions
curl -X POST -H "Content-Type: application/json" -d "@${network_partitions_path}/network-partition-2.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/networkPartitions

echo "Adding deployment policies..."
curl -X POST -H "Content-Type: application/json" -d "@${deployment_policies_path}/deployment-policy-2.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/deploymentPolicies

echo "Adding tomcat cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${cartridges_path}/tomcat.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding tomcat1 cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${cartridges_path}/tomcat1.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding tomcat2 cartridge..."
curl -X POST -H "Content-Type: application/json" -d "@${cartridges_path}/tomcat2.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridges

echo "Adding group6c group..."
curl -X POST -H "Content-Type: application/json" -d "@${cartridges_groups_path}/group6c.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/cartridgeGroups

sleep 1

echo "Adding application policy..."
curl -X POST -H "Content-Type: application/json" -d "@${application_policies_path}/application-policy-1.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/applicationPolicies

sleep 1

echo "Creating application..."
curl -X POST -H "Content-Type: application/json" -d "@${artifacts_path}/application.json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/applications

sleep 1

echo "Deploying application..."
curl -X POST -H "Content-Type: application/json" -k -v -u admin:admin https://${host_ip}:${host_port}/api/applications/nested-group-app/deploy/application-policy-1
