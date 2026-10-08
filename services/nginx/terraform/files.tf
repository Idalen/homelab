resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/matrix.yaml"

  content = yamlencode({
    all = {
      children = {
        matrix = {
          hosts = {
            matrix-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
