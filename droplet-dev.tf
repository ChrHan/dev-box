data "local_file" "provisioning_script" {
  filename = "${path.module}/cloud-init.sh"
}


resource "digitalocean_droplet" "droplet-dev" {
  image              = "ubuntu-20-10-x64"
  name               = "droplet-dev"
  region             = "sgp1"
  size               = "s-2vcpu-2gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  user_data = data.local_file.provisioning_script.content
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }
}

resource "digitalocean_firewall" "droplet-dev_firewall" {
  name = "only-ssh"

  droplet_ids = [digitalocean_droplet.droplet-dev.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

