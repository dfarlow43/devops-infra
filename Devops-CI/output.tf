output "public_ip_jenkins_node"{
    value = aws_instance.jenkins_server.public_ip
}
output "public_ip_ansible_controller"{
    value = aws_instance.ansibile_controller.public_ip
}
output "public_ip_ansible_managed"{
    value = aws_instance.ansibile_managed_node.public_ip
}
output "public_ip_docker_node"{
    value = aws_instance.docker_host.public_ip
}

output "public_ip_nexus_node"{
    value = aws_instance.nexus.public_ip
}