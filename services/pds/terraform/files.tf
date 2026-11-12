resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/pds.yml"

  content = yamlencode({
    all = {
      children = {
        pds = {
          hosts = {
            pds-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
