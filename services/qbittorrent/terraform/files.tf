resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/qbittorrent.yml"

  content = yamlencode({
    all = {
      children = {
        qbittorrent = {
          hosts = {
            qbittorrent-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
