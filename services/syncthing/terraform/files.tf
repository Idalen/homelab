resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/syncthing.yml"

  content = yamlencode({
    all = {
      children = {
        syncthing = {
          hosts = {
            syncthing-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
