variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {default="ocid1.compartment.oc1..aaaaaaaavj6u2nnfwypi6v7vyk66ohmhkvauw5mrhr77zgutlo7rn2d5edgq"}

provider "baremetal" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
}

module "vcn" {
  source = "./modules/vcn"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
}

module "kafka-node-1" {
  source = "./modules/compute-instance"
  AD = "1"
  tenancy_ocid = "${var.tenancy_ocid}"
  subnet_ocid = "${module.vcn.subnet1_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_private_key = "${file(var.ssh_private_key_path)}"
  ssh_public_key = "${file(var.ssh_public_key_path)}"
  instance_name = "eds-apptier-1"
}

module "kafka-node-2" {
  source = "./modules/compute-instance"
  AD = "2"
  tenancy_ocid = "${var.tenancy_ocid}"
  subnet_ocid = "${module.vcn.subnet2_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_private_key = "${file(var.ssh_private_key_path)}"
  ssh_public_key = "${file(var.ssh_public_key_path)}"
  instance_name = "eds-apptier-2"
}

module "kafka-node-3" {
  source = "./modules/compute-instance"
  AD = "3"
  tenancy_ocid = "${var.tenancy_ocid}"
  subnet_ocid = "${module.vcn.subnet3_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_private_key = "${file(var.ssh_private_key_path)}"
  ssh_public_key = "${file(var.ssh_public_key_path)}"
  instance_name = "eds-apptier-3"
}

module "kafka-provision" {
    source = "./modules/kafka-config"
    tenancy_ocid = "${var.tenancy_ocid}"
    compartment_ocid = "${var.compartment_ocid}"
    ssh_private_key_path = "${var.ssh_private_key_path}"
    node-1-private-ip = "${module.kafka-node-1.private_ip}"
    node-1-public-ip = "${module.kafka-node-1.public_ip}"
    node-2-private-ip = "${module.kafka-node-2.private_ip}"
    node-2-public-ip = "${module.kafka-node-2.public_ip}"
    node-3-private-ip = "${module.kafka-node-3.private_ip}"
    node-3-public-ip = "${module.kafka-node-3.public_ip}"
}

output "kafka_start_command" {
  value = "./startKafkaRemote.sh ${module.kafka-node-1.public_ip} ${module.kafka-node-2.public_ip} ${module.kafka-node-3.public_ip}"
}

output "kafka_cluster_address" {
  value = "${module.kafka-node-1.public_ip}:9092,${module.kafka-node-2.public_ip}:9092;${module.kafka-node-3.public_ip}:9092"
}