resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/navidrome.yml"

  content = yamlencode({
    all = {
      children = {
        navidrome = {
          hosts = {
            navidrome-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
