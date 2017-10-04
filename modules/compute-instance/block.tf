/*
resource "oci_core_volume" "TFBlock0" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "block-volume-${var.instance_name}"
  size_in_mbs = "${var.256GB}"
}

resource "oci_core_volume_attachment" "TFBlock0Attach" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${oci_core_instance.compute_instance.id}"
    volume_id = "${oci_core_volume.TFBlock0.id}"
}
*/
