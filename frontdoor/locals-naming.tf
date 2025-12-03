locals {
  # Base naming inputs
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  # 1) PROFILE name
  name = coalesce(
    var.custom_name,
    format(
      "%s-%s-cfdp",
      var.client_name,
      var.environment,
    )
  )

  # 2) ENDPOINT names
  endpoint_names = {
    for ep in var.endpoints :
    ep.name => coalesce(
      try(ep.custom_resource_name, null),
      format(
        "%s-%s-%s-cfde",
        var.client_name,
        var.environment,
        ep.name,
      )
    )
  }

  # 3) ORIGIN GROUP names
  origin_group_names = {
    for og in var.origin_groups :
    og.name => coalesce(
      try(og.custom_resource_name, null),
      format(
        "%s-%s-%s-cfdog",
        var.client_name,
        var.environment,
        og.name,
      )
    )
  }

  # 4) ORIGIN names
  origin_names = {
    for o in var.origins :
    o.name => coalesce(
      try(o.custom_resource_name, null),
      format(
        "%s-%s-%s-cfdo",
        var.client_name,
        var.environment,
        o.name,
      )
    )
  }

  # 5) CUSTOM DOMAIN names
  custom_domain_names = {
    for cd in var.custom_domains :
    cd.name => coalesce(
      try(cd.custom_resource_name, null),
      format(
        "%s-%s-%s-cfdcd",
        var.client_name,
        var.environment,
        cd.name,
      )
    )
  }

  # 6) ROUTE names
  route_names = {
    for r in var.routes :
    r.name => coalesce(
      try(r.custom_resource_name, null),
      format(
        "%s-%s-%s-cfdr",
        var.client_name,
        var.environment,
        r.name,
      )
    )
  }

  # 7) RULE SET names
  rule_set_names = {
    for rs in var.rule_sets :
    rs.name => coalesce(
      try(rs.custom_resource_name, null),

      # Rule sets: 1-60 chars, letters/numbers only
      substr(
        format(
          "%s%s%scfdrs",
          var.client_name,
          var.environment,
          rs.name,
        ),
        0,
        60
      )
    )
  }

  # 8) RULE names
  # NOTE: must use the SAME key that data "cdn_frontdoor_rule" uses: format("%s.%s", rule_set_name, rule_name)
  rule_names = {
    for r in local.rules_per_rule_set :
    format("%s.%s", r.rule_set_name, r.name) => coalesce(
      try(r.custom_resource_name, null),
      format(
        "%s-%s-%s-%s-cfdr",
        var.client_name,
        var.environment,
        r.rule_set_name,
        r.name,
      )
    )
  }

  # 9) FIREWALL POLICY names
  firewall_policy_names = {
    for fp in var.firewall_policies :
    fp.name => coalesce(
      try(fp.custom_resource_name, null),
      substr(
        format(
          "%s%s%scfdfp",
          var.client_name,
          var.environment,
          fp.name,
        ),
        0,
        128
      )
    )
  }

  # 10) SECURITY POLICY names
  security_policy_names = {
    for sp in var.security_policies :
    sp.name => coalesce(
      try(sp.custom_resource_name, null),
      format(
        "%s-%s-%s-cfdsp",
        var.client_name,
        var.environment,
        sp.name,
      )
    )
  }
}
