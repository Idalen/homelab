resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/flaresolverr.yml"

  content = yamlencode({
    all = {
      children = {
        flaresolverr = {
          hosts = {
            flaresolverr-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
