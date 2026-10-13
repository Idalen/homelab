resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/jellyfin.yml"

  content = yamlencode({
    all = {
      children = {
        jellyfin = {
          hosts = {
            jellyfin-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
