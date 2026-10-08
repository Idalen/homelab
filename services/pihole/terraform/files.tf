resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/pihole.yaml"

  content = yamlencode({
    all = {
      children = {
        pihole = {
          hosts = {
            pihole-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
