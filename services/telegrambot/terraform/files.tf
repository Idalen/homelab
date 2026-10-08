resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../shared/inventory/telegrambot.yml"

  content = yamlencode({
    all = {
      children = {
        telegrambot = {
          hosts = {
            telegrambot-lxc = {
              ansible_host = module.lxc.ip_address
              ansible_user = "root"
            }
          }
        }
      }
    }
  })
}
