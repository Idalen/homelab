resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory.yaml"

  content = yamlencode({
    all = {
      children = {
        ladder = {
          hosts = {
            ladder-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
