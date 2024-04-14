[jenkins_server]
master ansible_host=${jenkins_server_ip}

[jenkins_server:vars]
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file=${jenkins_pem}

[jenkins_slave]
slave ansible_host=${jenkins_slave_ip}


[jenkins_slave:vars]
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file=${jenkins_pem}
