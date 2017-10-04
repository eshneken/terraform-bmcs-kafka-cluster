
variable "VPC-CIDR" {
  default = "10.0.0.0/16"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}


resource "oci_core_virtual_network" "EdS_TF_Network" {
  cidr_block = "${var.VPC-CIDR}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "Kafka_Zookeeper_Terraformed_Network"
}

resource "oci_core_internet_gateway" "EdS_TF_Internet_Gateway" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "KafkaZookeeper Internet Gateway"
    vcn_id = "${oci_core_virtual_network.EdS_TF_Network.id}"
}

resource "oci_core_route_table" "RouteForComplete" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.EdS_TF_Network.id}"
    display_name = "KafkaZookeeper Route Table"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${oci_core_internet_gateway.EdS_TF_Internet_Gateway.id}"
    }
}

resource "oci_core_security_list" "PublicSubnet" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "KafkaZookeeper Security List"
    vcn_id = "${oci_core_virtual_network.EdS_TF_Network.id}"
    egress_security_rules = [{
        destination = "0.0.0.0/0"
        protocol = "6"
    }]
    ingress_security_rules = [
    {
        tcp_options {
            "max" = 80
            "min" = 80
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
    {
        tcp_options {
            "max" = 22
            "min" = 22
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
    {
        tcp_options {
            "max" = 9092
            "min" = 9092
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
    {
        tcp_options {
            "max" = 2181
            "min" = 2181
        }
        protocol = "6"
        source = "10.0.0.0/24"
    },
    {
        tcp_options {
            "max" = 2181
            "min" = 2181
        }
        protocol = "6"
        source = "10.0.1.0/24"
    },
    {
        tcp_options {
            "max" = 2181
            "min" = 2181
        }
        protocol = "6"
        source = "10.0.2.0/24"
    },
    {
        tcp_options {
            "max" = 2888
            "min" = 2888
        }
        protocol = "6"
        source = "10.0.0.0/24"
    },
    {
        tcp_options {
            "max" = 2888
            "min" = 2888
        }
        protocol = "6"
        source = "10.0.1.0/24"
    },
    {
        tcp_options {
            "max" = 2888
            "min" = 2888
        }
        protocol = "6"
        source = "10.0.2.0/24"
    },
    {
        tcp_options {
            "max" = 3888
            "min" = 3888
        }
        protocol = "6"
        source = "10.0.0.0/24"
    },
    {
        tcp_options {
            "max" = 3888
            "min" = 3888
        }
        protocol = "6"
        source = "10.0.1.0/24"
    },
    {
        tcp_options {
            "max" = 3888
            "min" = 3888
        }
        protocol = "6"
        source = "10.0.2.0/24"
    },
    {
        tcp_options {
            "max" = 9092
            "min" = 9092
        }
        protocol = "6"
        source = "10.0.0.0/24"
    },
    {
        tcp_options {
            "max" = 9092
            "min" = 9092
        }
        protocol = "6"
        source = "10.0.1.0/24"
    },
    {
        tcp_options {
            "max" = 9092
            "min" = 9092
        }
        protocol = "6"
        source = "10.0.2.0/24"
    },
	{
	protocol = "6"
	source = "${var.VPC-CIDR}"
    }]
}

resource "oci_core_subnet" "PublicSubnetAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block = "10.0.0.0/24"
  display_name = "KafkaZooker Subnet AD1"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.EdS_TF_Network.id}"
  route_table_id = "${oci_core_route_table.RouteForComplete.id}"
  security_list_ids = ["${oci_core_security_list.PublicSubnet.id}"]
  dhcp_options_id = "${oci_core_virtual_network.EdS_TF_Network.default_dhcp_options_id}"
}

resource "oci_core_subnet" "PublicSubnetAD2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block = "10.0.1.0/24"
  display_name = "KafkaZooker Subnet AD2"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.EdS_TF_Network.id}"
  route_table_id = "${oci_core_route_table.RouteForComplete.id}"
  security_list_ids = ["${oci_core_security_list.PublicSubnet.id}"]
  dhcp_options_id = "${oci_core_virtual_network.EdS_TF_Network.default_dhcp_options_id}"
}

resource "oci_core_subnet" "PublicSubnetAD3" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  cidr_block = "10.0.2.0/24"
  display_name = "KafkaZooker Subnet AD3"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.EdS_TF_Network.id}"
  route_table_id = "${oci_core_route_table.RouteForComplete.id}"
  security_list_ids = ["${oci_core_security_list.PublicSubnet.id}"]
  dhcp_options_id = "${oci_core_virtual_network.EdS_TF_Network.default_dhcp_options_id}"
}

