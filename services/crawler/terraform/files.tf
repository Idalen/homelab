resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/crawler.yaml"

  content = yamlencode({
    all = {
      children = {
        crawler = {
          hosts = {
            crawler-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
