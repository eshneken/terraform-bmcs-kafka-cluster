output "subnet1_ocid" {
  value = "${oci_core_subnet.PublicSubnetAD1.id}"
}
output "subnet2_ocid" {
  value = "${oci_core_subnet.PublicSubnetAD2.id}"
}
output "subnet3_ocid" {
  value = "${oci_core_subnet.PublicSubnetAD3.id}"
}
