resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/bookorbit.yaml"

  content = yamlencode({
    all = {
      children = {
        bookorbit = {
          hosts = {
            bookorbit-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
