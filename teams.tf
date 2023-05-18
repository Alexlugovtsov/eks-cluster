module "team_resources" {
  source = "./team"
  for_each = toset(var.teams)

  team_name  = each.value
}
