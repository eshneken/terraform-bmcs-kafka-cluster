resource "null_resource" "config_node_1" {

    provisioner "file" {
        connection {
            host="${var.node-1-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/kafka-bootstrap.sh"
        destination = "/tmp/kafka-bootstrap.sh"
      }
    
    provisioner "file" {
        connection {
            host="${var.node-1-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/startZookeeperKafka.sh"
        destination = "~opc/startZookeeperKafka.sh"
      }
      
    provisioner "file" {
        connection {
            host="${var.node-1-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/stopZookeeperKafka.sh"
        destination = "~opc/stopZookeeperKafka.sh"
      }  
      
    provisioner "remote-exec" {
        connection {
            host="${var.node-1-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
        }
    
        inline = [
            "sed -i 's/\r$//' /tmp/kafka-bootstrap.sh",
            "sed -i 's/\r$//' ~opc/startZookeeperKafka.sh",
            "sed -i 's/\r$//' ~opc/stopZookeeperKafka.sh",
            "chmod 700 ~opc/startZookeeperKafka.sh",
            "chmod 700 ~opc/stopZookeeperKafka.sh",
            
            "bash /tmp/kafka-bootstrap.sh",
            
            "echo initLimit=5                                                 >> ~opc/kafka-install/config/zookeeper.properties",
            "echo syncLimit=2                                                 >> ~opc/kafka-install/config/zookeeper.properties",
            "echo server.1=0.0.0.0:2888:3888                                  >> ~opc/kafka-install/config/zookeeper.properties",
            "echo server.2=${var.node-2-private-ip}:2888:3888                 >> ~opc/kafka-install/config/zookeeper.properties",
            "echo server.3=${var.node-3-private-ip}:2888:3888                 >> ~opc/kafka-install/config/zookeeper.properties",
            "mkdir -p /tmp/zookeeper",
            "echo 1 >> /tmp/zookeeper/myid",
            
            "sed -i 's/broker.id=0/broker.id=0/' ~opc/kafka-install/config/server.properties",
            "sed -i 's/zookeeper.connect=localhost:2181/#zookeeper.connect=localhost:2181/' ~opc/kafka-install/config/server.properties",
            "echo host.name=${var.node-1-public-ip}                             >> ~opc/kafka-install/config/server.properties",
            "echo listeners=PLAINTEXT://${var.node-1-private-ip}:9092           >> ~opc/kafka-install/config/server.properties",
            "echo advertised.listeners=PLAINTEXT://${var.node-1-public-ip}:9092 >> ~opc/kafka-install/config/server.properties",
            "echo zookeeper.connect=${var.node-1-private-ip}:2181,${var.node-2-private-ip}:2181,${var.node-3-private-ip}:2181 >> ~opc/kafka-install/config/server.properties",
            "echo port=9092 >> ~opc/kafka-install/config/server.properties",
            "echo num.partitions=4 >> ~opc/kafka-install/config/server.properties"
            ]
    }
 }
 
resource "null_resource" "config_node_2" {

    provisioner "file" {
        connection {
            host="${var.node-2-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/kafka-bootstrap.sh"
        destination = "/tmp/kafka-bootstrap.sh"
      }
    
    provisioner "file" {
        connection {
            host="${var.node-2-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/startZookeeperKafka.sh"
        destination = "~opc/startZookeeperKafka.sh"
      }
      
     provisioner "file" {
        connection {
            host="${var.node-2-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/stopZookeeperKafka.sh"
        destination = "~opc/stopZookeeperKafka.sh"
      }
      
    provisioner "remote-exec" {
        connection {
            host="${var.node-2-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
        }
    
        inline = [
            "sed -i 's/\r$//' /tmp/kafka-bootstrap.sh",
            "sed -i 's/\r$//' ~opc/startZookeeperKafka.sh",
            "sed -i 's/\r$//' ~opc/stopZookeeperKafka.sh",
            "chmod 700 ~opc/startZookeeperKafka.sh",
            "chmod 700 ~opc/stopZookeeperKafka.sh",
            
            "bash /tmp/kafka-bootstrap.sh",
            
            "echo initLimit=5                                   >> ~opc/kafka-install/config/zookeeper.properties",
            "echo syncLimit=2                                   >> ~opc/kafka-install/config/zookeeper.properties",
            "echo server.1=${var.node-1-private-ip}:2888:3888  >> ~opc/kafka-install/config/zookeeper.properties",
            "echo server.2=0.0.0.0:2888:3888                    >> ~opc/kafka-install/config/zookeeper.properties",
            "echo server.3=${var.node-3-private-ip}:2888:3888  >> ~opc/kafka-install/config/zookeeper.properties",
            "mkdir -p /tmp/zookeeper",
            "echo 2 >> /tmp/zookeeper/myid",
            
            "sed -i 's/broker.id=0/broker.id=1/' ~opc/kafka-install/config/server.properties",
            "sed -i 's/zookeeper.connect=localhost:2181/#zookeeper.connect=localhost:2181/' ~opc/kafka-install/config/server.properties",
            "echo host.name=${var.node-2-public-ip}                             >> ~opc/kafka-install/config/server.properties",
            "echo listeners=PLAINTEXT://${var.node-2-private-ip}:9092           >> ~opc/kafka-install/config/server.properties",
            "echo advertised.listeners=PLAINTEXT://${var.node-2-public-ip}:9092 >> ~opc/kafka-install/config/server.properties",
            "echo zookeeper.connect=${var.node-1-private-ip}:2181,${var.node-2-private-ip}:2181,${var.node-3-private-ip}:2181 >> ~opc/kafka-install/config/server.properties",
            "echo port=9092 >> ~opc/kafka-install/config/server.properties",
            "echo num.partitions=4 >> ~opc/kafka-install/config/server.properties"
        ]
    }
}

resource "null_resource" "config_node_3" {
    
    provisioner "file" {
        connection {
            host="${var.node-3-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/kafka-bootstrap.sh"
        destination = "/tmp/kafka-bootstrap.sh"
      }
    
    provisioner "file" {
        connection {
            host="${var.node-3-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/startZookeeperKafka.sh"
        destination = "~opc/startZookeeperKafka.sh"
      }
      
    provisioner "file" {
        connection {
            host="${var.node-3-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
            }
        source      = "./userdata/stopZookeeperKafka.sh"
        destination = "~opc/stopZookeeperKafka.sh"
      }
      
    provisioner "remote-exec" {
        connection {
            host="${var.node-3-public-ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key_path)}"
        }
    
        inline = [
            "sed -i 's/\r$//' /tmp/kafka-bootstrap.sh",
            "sed -i 's/\r$//' ~opc/startZookeeperKafka.sh",
            "sed -i 's/\r$//' ~opc/stopZookeeperKafka.sh",
            "chmod 700 ~opc/startZookeeperKafka.sh",
            "chmod 700 ~opc/stopZookeeperKafka.sh",
            
            "bash /tmp/kafka-bootstrap.sh",
            
            "echo initLimit=5                                   >> ~opc/kafka-install/config/zookeeper.properties",
            "echo syncLimit=2                                   >> ~opc/kafka-install/config/zookeeper.properties",
            "echo server.1=${var.node-1-private-ip}:2888:3888   >> ~opc/kafka-install/config/zookeeper.properties",
            "echo server.2=${var.node-2-private-ip}:2888:3888   >> ~opc/kafka-install/config/zookeeper.properties",   
            "echo server.3=0.0.0.0:2888:3888                    >> ~opc/kafka-install/config/zookeeper.properties",
            "mkdir -p /tmp/zookeeper",
            "echo 3 >> /tmp/zookeeper/myid",
            
            "sed -i 's/broker.id=0/broker.id=2/' ~opc/kafka-install/config/server.properties",
            "sed -i 's/zookeeper.connect=localhost:2181/#zookeeper.connect=localhost:2181/' ~opc/kafka-install/config/server.properties",
            "echo host.name=${var.node-3-public-ip}                             >> ~opc/kafka-install/config/server.properties",
            "echo listeners=PLAINTEXT://${var.node-3-private-ip}:9092           >> ~opc/kafka-install/config/server.properties",
            "echo advertised.listeners=PLAINTEXT://${var.node-3-public-ip}:9092 >> ~opc/kafka-install/config/server.properties",
            "echo zookeeper.connect=${var.node-1-private-ip}:2181,${var.node-2-private-ip}:2181,${var.node-3-private-ip}:2181 >> ~opc/kafka-install/config/server.properties",
            "echo port=9092 >> ~opc/kafka-install/config/server.properties",
            "echo num.partitions=4 >> ~opc/kafka-install/config/server.properties"
        ]
    }
  }
  
