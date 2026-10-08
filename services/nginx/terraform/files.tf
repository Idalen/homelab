resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/nginx.yml"

  content = yamlencode({
    all = {
      children = {
        nginx = {
          hosts = {
            nginx-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
