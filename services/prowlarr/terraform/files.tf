resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/prowlarr.yml"

  content = yamlencode({
    all = {
      children = {
        prowlarr = {
          hosts = {
            prowlarr-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
