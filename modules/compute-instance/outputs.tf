output "public_ip" {
value = "${data.baremetal_core_vnic.InstanceVnic.public_ip_address}"
}

output "private_ip" {
value = "${data.baremetal_core_vnic.InstanceVnic.private_ip_address}"
}
