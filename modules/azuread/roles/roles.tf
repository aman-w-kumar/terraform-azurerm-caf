resource "null_resource" "set_azure_ad_roles" {

  triggers = {
    object_id = var.object_id
  }

  for_each = {
    for key in var.azuread_app_roles : key => key
  }

  provisioner "local-exec" {
    command     = "/tf/caf/modules/azuread/roles/scripts/set_ad_role.sh"
    interpreter = ["/bin/sh"]
    on_failure  = fail

    environment = {
      METHOD                      = "POST"
      AD_ROLE_NAME                = each.key
      SERVICE_PRINCIPAL_OBJECT_ID = var.object_id
    }
  }

  provisioner "local-exec" {
    command     = "/tf/caf/modules/azuread/roles/scripts/set_ad_role.sh"
    when    = destroy
    interpreter = ["/bin/sh"]
    on_failure  = fail

    environment = {
      METHOD                      = "DELETE"
      AD_ROLE_NAME                = each.key
      SERVICE_PRINCIPAL_OBJECT_ID = self.triggers.object_id
    }
  }
}
